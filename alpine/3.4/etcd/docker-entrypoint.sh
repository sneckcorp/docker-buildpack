#!/bin/sh

if [ "$ETCD_INFRA" = "AWS" ]
then
  ETCD_IP_V4=$(curl http://169.254.169.254/latest/meta-data/local-ipv4);
  ETCD_INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id);
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
    -advertise-client-urls http://$ETCD_IP_V4:2379,http://$ETCD_IP_V4:4001 \
    -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
    -initial-advertise-peer-urls http://$ETCD_IP_V4:2380 \
    -listen-peer-urls http://0.0.0.0:2380 \
    -discovery https://discovery.etcd.io/$ETCD_TOKEN
fi