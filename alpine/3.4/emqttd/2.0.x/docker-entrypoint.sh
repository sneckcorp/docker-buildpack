#!/bin/sh
## EMQ docker image start script
# Huang Rui <vowstar@gmail.com>

## EMQ Base settings
# Base settings in $EMQ_HOME/etc/emq.conf

if [ x"${EMQ_NAME}" = x ]
then
EMQ_NAME=$(hostname)
echo "EMQ_NAME=${EMQ_NAME}"
fi

if [ x"${EMQ_HOST}" = x ]
then
EMQ_HOST=$(cat /etc/hosts | grep $(hostname) | awk '{print $1}')
echo "EMQ_HOST=${EMQ_HOST}"
fi

if [ x"${EMQ_NODE_NAME}" = x ]
then
EMQ_NODE_NAME="${EMQ_NAME}@${EMQ_HOST}"
echo "EMQ_NODE_NAME=${EMQ_NODE_NAME}"
fi
sed -i -e "s/^#*\s*node.name\s*=\s*.*@.*/node.name = ${EMQ_NODE_NAME}/g" $EMQ_HOME/etc/emq.conf

if [ x"${EMQ_NODE_COOKIE}" = x ]
then
EMQ_NODE_COOKIE="emq_dist_cookie"
echo "EMQ_NODE_COOKIE=${EMQ_NODE_COOKIE}"
fi
sed -i -e "s/^#*\s*node.cookie\s*=\s*.*/node.cookie = ${EMQ_NODE_COOKIE}/g" $EMQ_HOME/etc/emq.conf

if [ x"${EMQ_PROCESS_LIMIT}" = x ]
then
EMQ_PROCESS_LIMIT=2097152
echo "EMQ_PROCESS_LIMIT=${EMQ_PROCESS_LIMIT}"
fi
sed -i -e "s/^#*\s*node.process_limit\s*=\s*.*/node.process_limit = ${EMQ_PROCESS_LIMIT}/g" $EMQ_HOME/etc/emq.conf

if [ x"${EMQ_MAX_PORTS}" = x ]
then
EMQ_MAX_PORTS=1048576
echo "EMQ_MAX_PORTS=${EMQ_MAX_PORTS}"
fi
sed -i -e "s/^#*\s*node.max_ports\s*=\s*.*/node.max_ports = ${EMQ_MAX_PORTS}/g" $EMQ_HOME/etc/emq.conf

if [ x"${EMQ_LOG_CONSOLE}" = x ]
then
EMQ_LOG_CONSOLE="file"
echo "EMQ_LOG_CONSOLE=${EMQ_LOG_CONSOLE}"
fi
sed -i -e "s/^#*\s*log.console\s*=\s*.*/log.console = ${EMQ_LOG_CONSOLE}/g" $EMQ_HOME/etc/emq.conf

if [ x"${EMQ_LOG_LEVEL}" = x ]
then
EMQ_LOG_LEVEL="error"
echo "EMQ_LOG_LEVEL=${EMQ_LOG_LEVEL}"
fi
sed -i -e "s/^#*\s*log.console.level\s*=\s*.*/log.console.level = ${EMQ_LOG_LEVEL}/g" $EMQ_HOME/etc/emq.conf

if [ x"${EMQ_ALLOW_ANONYMOUS}" = x ]
then
EMQ_ALLOW_ANONYMOUS="true"
echo "EMQ_ALLOW_ANONYMOUS=${EMQ_ALLOW_ANONYMOUS}"
fi
sed -i -e "s/^#*\s*mqtt.allow_anonymous\s*=\s*.*/mqtt.allow_anonymous = ${EMQ_ALLOW_ANONYMOUS}/g" $EMQ_HOME/etc/emq.conf

if [ x"${EMQ_TCP_PORT}" = x ]
then
EMQ_TCP_PORT=1883
echo "EMQ_TCP_PORT=${EMQ_TCP_PORT}"
fi
sed -i -e "s/^#*\s*mqtt.listener.tcp\s*=\s*.*/mqtt.listener.tcp = ${EMQ_TCP_PORT}/g" $EMQ_HOME/etc/emq.conf

if [ x"${EMQ_TCP_ACCEPTORS}" = x ]
then
EMQ_TCP_ACCEPTORS=64
echo "EMQ_TCP_ACCEPTORS=${EMQ_TCP_ACCEPTORS}"
fi
sed -i -e "s/^#*\s*mqtt.listener.tcp.acceptors\s*=\s*.*/mqtt.listener.tcp.acceptors = ${EMQ_TCP_ACCEPTORS}/g" $EMQ_HOME/etc/emq.conf

if [ x"${EMQ_TCP_MAX_CLIENTS}" = x ]
then
EMQ_TCP_MAX_CLIENTS=1000000
echo "EMQ_TCP_MAX_CLIENTS=${EMQ_TCP_MAX_CLIENTS}"
fi
sed -i -e "s/^#*\s*mqtt.listener.tcp.max_clients\s*=\s*.*/mqtt.listener.tcp.max_clients = ${EMQ_TCP_MAX_CLIENTS}/g" $EMQ_HOME/etc/emq.conf

if [ x"${EMQ_SSL_PORT}" = x ]
then
EMQ_SSL_PORT=8883
echo "EMQ_SSL_PORT=${EMQ_SSL_PORT}"
fi
sed -i -e "s/^#*\s*mqtt.listener.ssl\s*=\s*.*/mqtt.listener.ssl = ${EMQ_SSL_PORT}/g" $EMQ_HOME/etc/emq.conf

if [ x"${EMQ_SSL_ACCEPTORS}" = x ]
then
EMQ_SSL_ACCEPTORS=32
echo "EMQ_SSL_ACCEPTORS=${EMQ_SSL_ACCEPTORS}"
fi
sed -i -e "s/^#*\s*mqtt.listener.ssl.acceptors\s*=\s*.*/mqtt.listener.ssl.acceptors = ${EMQ_SSL_ACCEPTORS}/g" $EMQ_HOME/etc/emq.conf

if [ x"${EMQ_SSL_MAX_CLIENTS}" = x ]
then
EMQ_SSL_MAX_CLIENTS=500000
echo "EMQ_SSL_MAX_CLIENTS=${EMQ_SSL_MAX_CLIENTS}"
fi
sed -i -e "s/^#*\s*mqtt.listener.ssl.max_clients\s*=\s*.*/mqtt.listener.ssl.max_clients = ${EMQ_SSL_MAX_CLIENTS}/g" $EMQ_HOME/etc/emq.conf

if [ x"${EMQ_HTTP_PORT}" = x ]
then
EMQ_HTTP_PORT=8083
echo "EMQ_HTTP_PORT=${EMQ_HTTP_PORT}"
fi
sed -i -e "s/^#*\s*mqtt.listener.http\s*=\s*.*/mqtt.listener.http = ${EMQ_HTTP_PORT}/g" $EMQ_HOME/etc/emq.conf

if [ x"${EMQ_HTTP_ACCEPTORS}" = x ]
then
EMQ_HTTP_ACCEPTORS=64
echo "EMQ_HTTP_ACCEPTORS=${EMQ_HTTP_ACCEPTORS}"
fi
sed -i -e "s/^#*\s*mqtt.listener.http.acceptors\s*=\s*.*/mqtt.listener.http.acceptors = ${EMQ_HTTP_ACCEPTORS}/g" $EMQ_HOME/etc/emq.conf

if [ x"${EMQ_HTTP_MAX_CLIENTS}" = x ]
then
EMQ_HTTP_MAX_CLIENTS=1000000
echo "EMQ_HTTP_MAX_CLIENTS=${EMQ_HTTP_MAX_CLIENTS}"
fi
sed -i -e "s/^#*\s*mqtt.listener.http.max_clients\s*=\s*.*/mqtt.listener.http.max_clients = ${EMQ_HTTP_MAX_CLIENTS}/g" $EMQ_HOME/etc/emq.conf

if [ x"${EMQ_HTTPS_PORT}" = x ]
then
EMQ_HTTPS_PORT=8084
echo "EMQ_HTTPS_PORT=${EMQ_HTTPS_PORT}"
fi
sed -i -e "s/^#*\s*mqtt.listener.https\s*=\s*.*/mqtt.listener.https = ${EMQ_HTTPS_PORT}/g" $EMQ_HOME/etc/emq.conf

if [ x"${EMQ_HTTPS_ACCEPTORS}" = x ]
then
EMQ_HTTPS_ACCEPTORS=32
echo "EMQ_HTTPS_ACCEPTORS=${EMQ_HTTPS_ACCEPTORS}"
fi
sed -i -e "s/^#*\s*mqtt.listener.https.acceptors\s*=\s*.*/mqtt.listener.https.acceptors = ${EMQ_HTTPS_ACCEPTORS}/g" $EMQ_HOME/etc/emq.conf

if [ x"${EMQ_HTTPS_MAX_CLIENTS}" = x ]
then
EMQ_HTTPS_MAX_CLIENTS=1000000
echo "EMQ_HTTPS_MAX_CLIENTS=${EMQ_HTTPS_MAX_CLIENTS}"
fi
sed -i -e "s/^#*\s*mqtt.listener.https.max_clients\s*=\s*.*/mqtt.listener.https.max_clients = ${EMQ_HTTPS_MAX_CLIENTS}/g" $EMQ_HOME/etc/emq.conf


if [ x"${EMQ_MAX_PACKET_SIZE}" = x ]
then
EMQ_MAX_PACKET_SIZE="64KB"
echo "EMQ_MAX_PACKET_SIZE=${EMQ_MAX_PACKET_SIZE}"
fi
sed -i -e "s/^#*\s*mqtt.max_packet_size\s*=\s*.*/mqtt.max_packet_size = ${EMQ_MAX_PACKET_SIZE}/g" $EMQ_HOME/etc/emq.conf

## EMQ Plugin load settings
# Plugins loaded by default

if [ x"${EMQ_LOADED_PLUGINS}" = x ]
then
EMQ_LOADED_PLUGINS="emq_recon,emq_dashboard,emq_mod_presence,emq_mod_retainer,emq_mod_subscription"
echo "EMQ_LOADED_PLUGINS=${EMQ_LOADED_PLUGINS}"
fi
# First, remove special char at header
# Next, replace special char to ".\n" to fit emq loaded_plugins format
echo $(echo "${EMQ_LOADED_PLUGINS}."|sed -e "s/^[^A-Za-z0-9_]\{1,\}//g"|sed -e "s/[^A-Za-z0-9_]\{1,\}/\.\n/g") > $EMQ_HOME/data/loaded_plugins


## EMQ Main script
$EMQ_HOME/bin/emqttd $@