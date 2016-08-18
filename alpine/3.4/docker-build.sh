#!/bin/bash

docker build --tag sneck/zookeeper:latest zookeeper/3.4.x/
docker build --tag sneck/zookeeper:3.4 --build-arg ZK_VERSION=3.4.8 zookeeper/3.4.x/
docker build --tag sneck/zookeeper:3.4.8 --build-arg ZK_VERSION=3.4.8 zookeeper/3.4.x/
docker build --tag sneck/zookeeper:3.5.2-alpha --build-arg ZK_VERSION=3.5.2-alpha zookeeper/3.5.x/

docker build --tag sneck/exhibitor:latest exhibitor/
docker build --tag sneck/exhibitor:1.5 --build-arg EXHIBITOR_VERSION=1.5.6 exhibitor/
docker build --tag sneck/exhibitor:1.5.6 --build-arg EXHIBITOR_VERSION=1.5.6 exhibitor/

docker build --tag sneck/kafka:latest kafka/
docker build --tag sneck/kafka:0.9 --build-arg KAFKA_VERSION=0.9.0.1 kafka/
docker build --tag sneck/kafka:0.9.0 --build-arg KAFKA_VERSION=0.9.0.1 kafka/

docker build --tag sneck/emqttd:latest emqttd/
docker build --tag sneck/emqttd:1.1.2 --build-arg EMQTTD_VERSION=1.1.2 emqttd/

docker build --tag sneck/openrc:latest openrc/ 
docker build --tag sneck/nfs:latest nfs/
docker build --tag sneck/goofys:latest goofys/
docker build --tag sneck/goofys-nfs:latest goofys-nfs/

docker build --tag sneck/scala:latest scala/
docker build --tag sneck/scala:2.12 --build-arg SCALA_VERSION=2.12.0-M4 scala/
docker build --tag sneck/scala:2.12.0 --build-arg SCALA_VERSION=2.12.0-M4 scala/
docker build --tag sneck/scala:2.10 --build-arg SCALA_VERSION=2.10.6 scala/
docker build --tag sneck/scala:2.10.6 --build-arg SCALA_VERSION=2.10.6 scala/
docker build --tag sneck/scala:2.11 --build-arg SCALA_VERSION=2.11.8 scala/
docker build --tag sneck/scala:2.11.8 --build-arg SCALA_VERSION=2.11.8 scala/

docker build --tag sneck/sbt:latest sbt/
docker build --tag sneck/sbt:0.13 --build-arg SBT_VERSION=0.13.12 sbt/
docker build --tag sneck/sbt:0.13.11 --build-arg SBT_VERSION=0.13.11 sbt/
docker build --tag sneck/sbt:0.13.12 --build-arg SBT_VERSION=0.13.12 sbt/

docker build --tag sneck/kong:latest kong/0.8.x/
docker build --tag sneck/kong:0.8 --build-arg KONG_VERSION=0.8.3 kong/0.8.x/
docker build --tag sneck/kong:0.8.3 --build-arg KONG_VERSION=0.8.3 kong/0.8.x/

docker build --tag sneck/etcd:latest etcd/
docker build --tag sneck/etcd:3.0.3 --build-arg ETCD_VERSION=3.0.3 etcd/

docker build --tag sneck/mosquitto:latest mosquitto/ 
docker build --tag sneck/mosquitto:1.4.8 --build-arg MOSQUITTO_VERSION=1.4.8 mosquitto/

docker build --tag sneck/mosquitto:auth \
  --build-arg MOSQUITTO_AUTH_BACKEND_CDB=yes \
  --build-arg MOSQUITTO_AUTH_BACKEND_MYSQL=yes \
  --build-arg MOSQUITTO_AUTH_BACKEND_SQLITE=yes \
  --build-arg MOSQUITTO_AUTH_BACKEND_REDIS=yes \
  --build-arg MOSQUITTO_AUTH_BACKEND_POSTGRES=yes \
  --build-arg MOSQUITTO_AUTH_BACKEND_LDAP=yes \
  --build-arg MOSQUITTO_AUTH_BACKEND_HTTP=yes \
  --build-arg MOSQUITTO_AUTH_BACKEND_MONGO=yes \
  mosquitto/auth

docker build --tag sneck/mosquitto:auth-http \
  --build-arg MOSQUITTO_AUTH_BACKEND_HTTP=yes \
  mosquitto/auth

docker build --tag sneck/gosu:latest gosu/
docker build --tag sneck/gosu:1.9 --build-arg GOSU_VERSION=1.9 gosu/ 
docker build --tag sneck/gosu:1.8 --build-arg GOSU_VERSION=1.8 gosu/ 
docker build --tag sneck/gosu:1.7 --build-arg GOSU_VERSION=1.7 gosu/ 