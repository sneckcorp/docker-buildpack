#!/bin/bash

docker build --tag sneck/zookeeper:latest zookeeper/
docker build --tag sneck/zookeeper:3.4 --build-arg ZK_VERSION=3.4.8 zookeeper/
docker build --tag sneck/zookeeper:3.4.8 --build-arg ZK_VERSION=3.4.8 zookeeper/
docker build --tag sneck/zookeeper:3.5.1-alpha --build-arg ZK_VERSION=3.5.1-alpha zookeeper/

docker build --tag sneck/exhibitor:latest exhibitor/
docker build --tag sneck/exhibitor:1.5 --build-arg EXHIBITOR_VERSION=1.5.6 exhibitor/
docker build --tag sneck/exhibitor:1.5.6 --build-arg EXHIBITOR_VERSION=1.5.6 exhibitor/

docker build --tag sneck/kafka:latest kafka/
docker build --tag sneck/kafka:0.9 --build-arg KAFKA_VERSION=0.9.0.1 kafka/
docker build --tag sneck/kafka:0.9.0 --build-arg KAFKA_VERSION=0.9.0.1 kafka/

docker build --tag sneck/emqttd:latest emqttd/
docker build --tag sneck/emqttd:1.1.2 --build-arg EMQTTD_VERSION=1.1.2 emqttd/

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

docker build --tag sneck/kong:latest kong/
docker build --tag sneck/kong:0.8.3 --build-arg KONG_VERSION=0.8.3 kong/

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