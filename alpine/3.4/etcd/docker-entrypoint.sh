#!/bin/sh

if [ "$DOCKER_INFRA" = "AWS" ]; then
  ETCD_IP_V4=$(curl http://169.254.169.254/latest/meta-data/local-ipv4);
  ETCD_INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id);
elif [ "$DOCKER_INFRA" = "DOCKERCLOUD" ]; then
  apk add --no-cache jq
  CONTAINER_FILE="container.json"
  DOCKERCLOUD_PASS=${DOCKERCLOUD_PASS:-$DOCKERCLOUD_APIKEY}

  if [ "$DOCKERCLOUD_AUTH" ]; then
    curl -H "Authorization: $DOCKERCLOUD_AUTH" $DOCKERCLOUD_CONTAINER_API_URL > $CONTAINER_FILE
  elif [ "$DOCKERCLOUD_USER" -o "$DOCKERCLOUD_PASS" ]; then
    curl -u "$DOCKERCLOUD_USER:$DOCKERCLOUD_PASS" $DOCKERCLOUD_CONTAINER_API_URL > $CONTAINER_FILE
  else
    echo "DOCKERCLOUD_USER: <your docker cloud id>"
    echo "DOCKERCLOUD_PASS: <your docker cloud password>"
    exit 1
  fi

  ETCD_IP_V4=$(jq -r '.private_ip' $CONTAINER_FILE)
  ETCD_INSTANCE_ID=$(jq -r '.hostname' $CONTAINER_FILE)
  ETCD_PORT_2379=$(jq -r '.container_ports[]? | select(.inner_port == 2379 and .outer_port != null) | .outer_port' $CONTAINER_FILE)
  ETCD_PORT_2380=$(jq -r '.container_ports[]? | select(.inner_port == 2380 and .outer_port != null) | .outer_port' $CONTAINER_FILE)
  ETCD_PORT_4001=$(jq -r '.container_ports[]? | select(.inner_port == 4001 and .outer_port != null) | .outer_port' $CONTAINER_FILE)

  rm -rf $CONTAINER_FILE

  apk del jq
else
  ETCD_IP_V4=`ip -4 addr show scope global dev eth0 | grep inet | head -1 | awk '{print \$2}' | cut -d / -f 1`
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
  ETCD_PORT_2379=${ETCD_PORT_2379:-2379}
  ETCD_PORT_2380=${ETCD_PORT_2380:-2380}
  ETCD_PORT_4001=${ETCD_PORT_4001:-4001}

  etcd \
    -name $ETCD_INSTANCE_ID \
    -advertise-client-urls http://$ETCD_IP_V4:$ETCD_PORT_2379,http://$ETCD_IP_V4:$ETCD_PORT_4001 \
    -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
    -initial-advertise-peer-urls http://$ETCD_IP_V4:$ETCD_PORT_2380 \
    -listen-peer-urls http://0.0.0.0:2380 \
    -discovery https://discovery.etcd.io/$ETCD_TOKEN
fi