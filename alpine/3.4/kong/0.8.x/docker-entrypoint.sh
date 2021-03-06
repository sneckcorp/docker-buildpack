#!/bin/bash
set -e

IP=`ip -4 addr show scope global dev eth0 | grep inet | head -1 | awk '{print \$2}' | cut -d / -f 1`

KONG_NGINX_WORKING_DIR=${KONG_NGINX_WORKING_DIR:-"/usr/local/kong/"}
KONG_PROXY_LISTEN=${KONG_PROXY_LISTEN:-"0.0.0.0:8000"}
KONG_PROXY_LISTEN_SSL=${KONG_PROXY_LISTEN_SSL:-"0.0.0.0:8443"}
KONG_ADMIN_API_LISTEN=${KONG_ADMIN_API_LISTEN:-"0.0.0.0:8001"}
KONG_CLUSTER_LISTEN=${KONG_CLUSTER_LISTEN:-"0.0.0.0:7946"}
KONG_CLUSTER_LISTEN_RPC=${KONG_CLUSTER_LISTEN_RPC:-"127.0.0.1:7373"}
KONG_SSL_CERT_PATH=${KONG_SSL_CERT_PATH:-""}
KONG_SSL_KEY_PATH=${KONG_SSL_KEY_PATH:-""}
KONG_DNS_RESOLVERS=${KONG_DNS_RESOLVERS:-"dnsmasq"}
KONG_DNS_RESOLVERS_AVAILABLE_SERVER_ADDRESS=${KONG_DNS_RESOLVERS_AVAILABLE_SERVER_ADDRESS:-"127.0.0.1:8053"}
KONG_DNS_RESOLVERS_AVAILABLE_DNSMASQ_PORT=${KONG_DNS_RESOLVERS_AVAILABLE_DNSMASQ_PORT:-8053}
KONG_CLUSTER_ADVERTISE_IP=${KONG_CLUSTER_ADVERTISE_IP:-""}
KONG_CLUSTER_ADVERTISE_PORT=${KONG_CLUSTER_ADVERTISE_PORT:-7946}
KONG_CLUSTER_ADVERTISE=${KONG_CLUSTER_ADVERTISE:-""}
KONG_CLUSTER_ENCRYPT=${KONG_CLUSTER_ENCRYPT:-""}
KONG_CLUSTER_TTL_ON_FAILURE=${KONG_CLUSTER_TTL_ON_FAILURE:-""}
KONG_DATABASE=${KONG_DATABASE:-""}
KONG_POSTGRES_HOST=${KONG_POSTGRES_HOST:-"127.0.0.1"}
KONG_POSTGRES_PORT=${KONG_POSTGRES_PORT:-5432}
KONG_POSTGRES_DATABASE=${KONG_POSTGRES_DATABASE:-"kong"}
KONG_POSTGRES_USER=${KONG_POSTGRES_USER:-""}
KONG_POSTGRES_PASSWORD=${KONG_POSTGRES_PASSWORD:-""}
KONG_CASSANDRA_CONTACT_POINTS=${KONG_CASSANDRA_CONTACT_POINTS:-"127.0.0.1:9042"}
KONG_CASSANDRA_PORT=${KONG_CASSANDRA_PORT:-9042}
KONG_CASSANDRA_KEYSPACE=${KONG_CASSANDRA_KEYSPACE:-"kong"}
KONG_CASSANDRA_TIMEOUT=${KONG_CASSANDRA_TIMEOUT:-5000}
KONG_CASSANDRA_REPLICATION_STRATEGY=${KONG_CASSANDRA_REPLICATION_STRATEGY:-"SimpleStrategy"}
KONG_CASSANDRA_REPLICATION_FACTOR=${KONG_CASSANDRA_REPLICATION_FACTOR:-1}
KONG_CASSANDRA_CONSISTENCY=${KONG_CASSANDRA_CONSISTENCY:-"ONE"}
KONG_CASSANDRA_SSL_ENABLE=${KONG_CASSANDRA_SSL_ENABLE:-false}
KONG_CASSANDRA_SSL_VERIFY=${KONG_CASSANDRA_SSL_VERIFY:-false}
KONG_CASSANDRA_SSL_CERTIFICATE_AUTHORITY=${KONG_CASSANDRA_SSL_CERTIFICATE_AUTHORITY:-""}
KONG_CASSANDRA_USERNAME=${KONG_CASSANDRA_USERNAME:-""}
KONG_CASSANDRA_PASSWORD=${KONG_CASSANDRA_PASSWORD:-""}
KONG_SEND_ANONYMOUS_REPORTS=${KONG_SEND_ANONYMOUS_REPORTS:-true}
KONG_MEMORY_CACHE_SIZE=${KONG_MEMORY_CACHE_SIZE:-128}
KONG_CONF=${KONG_CONF:-""}

[ -z "$KONG_CLUSTER_ADVERTISE" -a -n "$KONG_CLUSTER_ADVERTISE_IP" ] && KONG_CLUSTER_ADVERTISE="${KONG_CLUSTER_ADVERTISE_IP}:${KONG_CLUSTER_ADVERTISE_PORT}"
unset KONG_CLUSTER_ADVERTISE_IP KONG_CLUSTER_ADVERTISE_PORT

TEMPLATE_PATH="/etc/kong/kong.yml.template"
CONFIG_PATH="/etc/kong/kong.yml"

CONFIG_DATA=`cat $TEMPLATE_PATH`

CLUSTER_CONFIG_COUNT=0
CASSANDRA_DATA_CENTERS_COUNT=0
for KEYVALUE in `declare`; do
  if [[ $KEYVALUE =~ ^KONG_.*= ]]; then
    KEY=`echo "$KEYVALUE" | sed -r 's|(.+)=.*|\1|'`
    VALUE=`echo "$KEYVALUE" | sed -r "s|.+='?([^']*)'?|\1|"`

    if [[ -z "$VALUE" ]]; then
      if [[ $KEY =~ ^KONG_(CLUSTER|SSL)_ ]]; then
        CONFIG_DATA=`echo "$CONFIG_DATA" | sed "/{{$KEY}}/d"`
      fi
    fi

    if [[ -n "$VALUE" ]] && [[ $KEY =~ ^KONG_CLUSTER_ ]] && [[ ! ( $KEY =~ ^KONG_CLUSTER_LISTEN ) ]]; then
      echo $KEY
      CLUSTER_CONFIG_COUNT=$((CLUSTER_CONFIG_COUNT+1))
    fi

    if [[ -n "$VALUE" ]] && [[ $KEY =~ ^KONG_CASSANDRA_DATA_CENTERS_ ]]; then
      echo $KEY;

      CASSANDRA_DATA_CENTERS_COUNT=$((CASSANDRA_DATA_CENTERS_COUNT+1))

      CENTER_ID=`echo "$KEY" | sed -r 's/KONG_CASSANDRA_DATA_CENTERS_//'`
      CONFIG_DATA=`echo "$CONFIG_DATA" | sed "s|data_centers:|&\n    ${CENTER_ID}: ${VALUE}|"`
    fi

    CONFIG_DATA=`echo "$CONFIG_DATA" | sed "s|{{$KEY}}|$VALUE|g"`
  fi
done

if [[ $CASSANDRA_DATA_CENTERS_COUNT -eq 0 ]]; then
  CONFIG_DATA=`echo "$CONFIG_DATA" | sed "s|data_centers:|# &|"`
fi

if [[ $CLUSTER_CONFIG_COUNT -eq 0 ]]; then
  CONFIG_DATA=`echo "$CONFIG_DATA" | sed "s|cluster:|# &|"`
fi

echo "$CONFIG_DATA" > $CONFIG_PATH

exec "$@"