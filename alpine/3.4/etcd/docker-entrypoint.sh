#!/bin/sh

ETCD_PORT_2379=${ETCD_PORT_2379:-2379}
ETCD_PORT_2380=${ETCD_PORT_2380:-2380}
ETCD_PORT_4001=${ETCD_PORT_2379:-4001}

if [ "$ETCD_INFRA" = "AWS" ]; then
  ETCD_IP_V4=$(curl http://169.254.169.254/latest/meta-data/local-ipv4);
  ETCD_INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id);
elif [ "$ETCD_INFRA" = "DOCKERCLOUD" ] then
  if [ -z $DOCKERCLOUD_USERNAME -o -z $DOCKERCLOUD_PASSWORD ]; then
    echo "DOCKERCLOUD_USERNAME: <your docker cloud id>"
    echo "DOCKERCLOUD_PASSWORD: <your docker cloud password>"
    exit 1
  else
    CONTAINER_FILE="container.json"
    curl -u "$DOCKERCLOUD_USERNAME:$DOCKERCLOUD_PASSWORD" $DOCKERCLOUD_CONTAINER_API_URL > $CONTAINER_FILE
    ETCD_IP_V4=$(jq -r '.private_ip' $CONTAINER_FILE)
    ETCD_INSTANCE_ID=$(jq -r '.hostname' $CONTAINER_FILE)
    ETCD_PORT_2379=$(jq -r '.link_variables as $env | .link_variables | keys | .[] | select(endswith("2379_TCP_PORT")) as $name | $env[$name]' $CONTAINER_FILE)
    ETCD_PORT_2380=$(jq -r '.link_variables as $env | .link_variables | keys | .[] | select(endswith("2380_TCP_PORT")) as $name | $env[$name]' $CONTAINER_FILE)
    ETCD_PORT_4001=$(jq -r '.link_variables as $env | .link_variables | keys | .[] | select(endswith("4001_TCP_PORT")) as $name | $env[$name]' $CONTAINER_FILE)
    rm -rf $CONTAINER_FILE
  fi
else
  ETCD_IP_V4=$(hostname -i)
  ETCD_INSTANCE_ID=$(hostname)
fi

if [ -z $ETCD_TOKEN ]
 then
  echo "you need to define variable ETCD_TOKEN"
  echo ""
  echo "    docker run -d -e ETCD_TOKEN=<your token> <docker image name>"
  echo ""
  echo "you can find manual at"
  echo "https://coreos.com/os/docs/latest/cluster-discovery.html"
  exit 1
else
  etcd \
    -name $ETCD_INSTANCE_ID \
    -advertise-client-urls http://$ETCD_IP_V4:$ETCD_PORT_2379,http://$ETCD_IP_V4:$ETCD_PORT_4001 \
    -listen-client-urls http://0.0.0.0:$ETCD_PORT_2379,http://0.0.0.0:$ETCD_PORT_4001 \
    -initial-advertise-peer-urls http://$ETCD_IP_V4:$ETCD_PORT_2380 \
    -listen-peer-urls http://0.0.0.0:$ETCD_PORT_2380 \
    -discovery https://discovery.etcd.io/$ETCD_TOKEN
fi