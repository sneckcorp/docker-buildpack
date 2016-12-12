#!/bin/bash

# ZOOKEEPER
docker build --tag sneck/zookeeper:latest zookeeper/3.4.x/
docker build --tag sneck/zookeeper:3.4 --build-arg ZK_VERSION=3.4.8 zookeeper/3.4.x/
docker build --tag sneck/zookeeper:3.4.8 --build-arg ZK_VERSION=3.4.8 zookeeper/3.4.x/
docker build --tag sneck/zookeeper:3.5.2-alpha --build-arg ZK_VERSION=3.5.2-alpha zookeeper/3.5.x/

# EXHIBITOR
docker build --tag sneck/exhibitor:latest exhibitor/
docker build --tag sneck/exhibitor:1.5 --build-arg EXHIBITOR_VERSION=1.5.6 exhibitor/
docker build --tag sneck/exhibitor:1.5.6 --build-arg EXHIBITOR_VERSION=1.5.6 exhibitor/

# KAFKA
docker build --tag sneck/kafka:latest kafka/
docker build --tag sneck/kafka:0.9 --build-arg KAFKA_VERSION=0.9.0.1 kafka/
docker build --tag sneck/kafka:0.9.0 --build-arg KAFKA_VERSION=0.9.0.1 kafka/
docker build --tag sneck/kafka:0.9.0.0 --build-arg KAFKA_VERSION=0.9.0.0 kafka/
docker build --tag sneck/kafka:0.9.0.1 --build-arg KAFKA_VERSION=0.9.0.1 kafka/
docker build --tag sneck/kafka:0.10 --build-arg KAFKA_VERSION=0.10.0.1 kafka/
docker build --tag sneck/kafka:0.10.0 --build-arg KAFKA_VERSION=0.10.1.0 kafka/
docker build --tag sneck/kafka:0.10.0.0 --build-arg KAFKA_VERSION=0.10.0.0 kafka/
docker build --tag sneck/kafka:0.10.0.1 --build-arg KAFKA_VERSION=0.10.0.1 kafka/
docker build --tag sneck/kafka:0.10.1 --build-arg KAFKA_VERSION=0.10.1.0 kafka/
docker build --tag sneck/kafka:0.10.1.0 --build-arg KAFKA_VERSION=0.10.1.0 kafka/

docker build --tag sneck/kafka-manager:latest kafka-manager/
docker build --tag sneck/kafka-manager:1.3 --build-arg KAFKA_MANAGER_VERSION=1.3.1.6 kafka-manager/
docker build --tag sneck/kafka-manager:l.3.1 --build-arg KAFKA_MANAGER_VERSION=1.3.1.6 kafka-manager/
docker build --tag sneck/kafka-manager:l.3.1.6 --build-arg KAFKA_MANAGER_VERSION=1.3.1.6 kafka-manager/

# EMQTT
docker build --tag sneck/emqttd:latest --build-arg EMQ_VERSION=v2.0.1 emqttd/2.0.x
docker build --tag sneck/emqttd:1.1.2 --build-arg EMQ_VERSION=1.1.2 emqttd/1.1.x
docker build --tag sneck/emqttd:1.1.3 --build-arg EMQ_VERSION=1.1.3 emqttd/1.1.x
docker build --tag sneck/emqttd:1.1.3 --build-arg EMQ_VERSION=1.1.3 emqttd/1.1.x
docker build --tag sneck/emqttd:2.0 --build-arg EMQ_VERSION=v2.0 emqttd/2.0.x
docker build --tag sneck/emqttd:2.0.0 --build-arg EMQ_VERSION=v2.0 emqttd/2.0.x
docker build --tag sneck/emqttd:2.0.1 --build-arg EMQ_VERSION=v2.0.1 emqttd/2.0.x
docker build --tag sneck/emqttd:2.0.2 --build-arg EMQ_VERSION=v2.0.2 emqttd/2.0.x

# OPEN RC
docker build --tag sneck/openrc:latest openrc/ 

# NFS
docker build --tag sneck/nfs:latest nfs/

# GOOFYS
docker build --tag sneck/goofys:latest goofys/

# GOOFYS + NFS
docker build --tag sneck/goofys-nfs:latest goofys-nfs/

# SCALA
docker build --tag sneck/scala:latest scala/
docker build --tag sneck/scala:2.12 --build-arg SCALA_VERSION=2.12.0-M4 scala/
docker build --tag sneck/scala:2.12.0 --build-arg SCALA_VERSION=2.12.0-M4 scala/
docker build --tag sneck/scala:2.10 --build-arg SCALA_VERSION=2.10.6 scala/
docker build --tag sneck/scala:2.10.6 --build-arg SCALA_VERSION=2.10.6 scala/
docker build --tag sneck/scala:2.11 --build-arg SCALA_VERSION=2.11.8 scala/
docker build --tag sneck/scala:2.11.8 --build-arg SCALA_VERSION=2.11.8 scala/

# SBT
docker build --tag sneck/sbt:latest sbt/
docker build --tag sneck/sbt:0.13 --build-arg SBT_VERSION=0.13.12 sbt/
docker build --tag sneck/sbt:0.13.9 --build-arg SBT_VERSION=0.13.9 sbt/
docker build --tag sneck/sbt:0.13.10 --build-arg SBT_VERSION=0.13.10 sbt/
docker build --tag sneck/sbt:0.13.11 --build-arg SBT_VERSION=0.13.11 sbt/
docker build --tag sneck/sbt:0.13.12 --build-arg SBT_VERSION=0.13.12 sbt/

# KONG
docker build --tag sneck/kong:latest kong/0.9.x/
docker build --tag sneck/kong:0.8 --build-arg KONG_VERSION=0.8.3 kong/0.8.x/
docker build --tag sneck/kong:0.8.3 --build-arg KONG_VERSION=0.8.3 kong/0.8.x/
docker build --tag sneck/kong:0.9 --build-arg KONG_VERSION=0.9.2 kong/0.9.x/
docker build --tag sneck/kong:0.9.0 --build-arg KONG_VERSION=0.9.0 kong/0.9.x/
docker build --tag sneck/kong:0.9.1 --build-arg KONG_VERSION=0.9.1 kong/0.9.x/
docker build --tag sneck/kong:0.9.2 --build-arg KONG_VERSION=0.9.2 kong/0.9.x/
docker build --tag sneck/kong:0.9.3 --build-arg KONG_VERSION=0.9.3 kong/0.9.x/

# ETCD
docker build --tag sneck/etcd:latest etcd/
docker build --tag sneck/etcd:3.0.3 --build-arg ETCD_VERSION=3.0.3 etcd/

# MOSQUITTO
docker build --tag sneck/mosquitto:latest mosquitto/ 
docker build --tag sneck/mosquitto:1.4.8 --build-arg MOSQUITTO_VERSION=1.4.8 mosquitto/

# MOSQUITTO
docker build --tag sneck/mosquitto-auth:latest \
  --build-arg MOSQUITTO_AUTH_BACKEND_CDB=yes \
  --build-arg MOSQUITTO_AUTH_BACKEND_MYSQL=yes \
  --build-arg MOSQUITTO_AUTH_BACKEND_SQLITE=yes \
  --build-arg MOSQUITTO_AUTH_BACKEND_REDIS=yes \
  --build-arg MOSQUITTO_AUTH_BACKEND_POSTGRES=yes \
  --build-arg MOSQUITTO_AUTH_BACKEND_LDAP=yes \
  --build-arg MOSQUITTO_AUTH_BACKEND_HTTP=yes \
  --build-arg MOSQUITTO_AUTH_BACKEND_MONGO=yes \
  mosquitto/auth

docker build --tag sneck/mosquitto-auth:http \
  --build-arg MOSQUITTO_AUTH_BACKEND_HTTP=yes \
  mosquitto/auth

# GOSU
docker build --tag sneck/gosu:latest gosu/
docker build --tag sneck/gosu:1.9 --build-arg GOSU_VERSION=1.9 gosu/ 
docker build --tag sneck/gosu:1.8 --build-arg GOSU_VERSION=1.8 gosu/ 
docker build --tag sneck/gosu:1.7 --build-arg GOSU_VERSION=1.7 gosu/ 

# k8s-peer-finder
docker build --tag sneck/k8s-peer-finder:latest k8s-peer-finder/
docker build --tag sneck/k8s-peer-finder:0.1 k8s-peer-finder/