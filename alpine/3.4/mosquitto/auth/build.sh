#!/bin/sh

OPENSSLDIR="/usr"
MONGODB_VERSION="1.3.3"

: ${MOSQUITTO_AUTH_BACKEND_CDB:="no"}
: ${MOSQUITTO_AUTH_BACKEND_MYSQL:="no"}
: ${MOSQUITTO_AUTH_BACKEND_SQLITE:="no"}
: ${MOSQUITTO_AUTH_BACKEND_REDIS:="no"}
: ${MOSQUITTO_AUTH_BACKEND_POSTGRES:="no"}
: ${MOSQUITTO_AUTH_BACKEND_LDAP:="no"}
: ${MOSQUITTO_AUTH_BACKEND_HTTP:="no"}
: ${MOSQUITTO_AUTH_BACKEND_MONGO:="no"}

# build mosquitto
apk add --no-cache --virtual=build_dependencies wget tar build-base util-linux-dev c-ares-dev libwebsockets-dev openssl-dev \
&& MOSQUITTO_TEMP_DIR=/tmp/mosquitto \
&& mkdir -p $MOSQUITTO_TEMP_DIR \
&& wget -O - http://mosquitto.org/files/source/mosquitto-${MOSQUITTO_VERSION}.tar.gz | tar xzf - -C $MOSQUITTO_TEMP_DIR --strip-components=1 \
&& make -C $MOSQUITTO_TEMP_DIR \
            PREFIX=/usr \
            WITH_SRV=no \
            WITH_WEBSOCKETS=yes \
            WITH_DOCS=no \
&& apk del build_dependencies

# build mosquitto auth plugin dependencies
BUILD_DEPENDENCIES="wget tar ca-certificates build-base openssl-dev"
DEPENDENCIES=""
[ "$MOSQUITTO_AUTH_BACKEND_CDB" == 'yes' ] && BUILD_DEPENDENCIES="${BUILD_DEPENDENCIES}" && DEPENDENCIES="${DEPENDENCIES}" 
[ "$MOSQUITTO_AUTH_BACKEND_MYSQL" == 'yes' ] && BUILD_DEPENDENCIES="${BUILD_DEPENDENCIES} mysql-dev" && DEPENDENCIES="${DEPENDENCIES} mysql-client"
[ "$MOSQUITTO_AUTH_BACKEND_SQLITE" == 'yes' ] && BUILD_DEPENDENCIES="${BUILD_DEPENDENCIES} sqlite-dev" && DEPENDENCIES="${DEPENDENCIES} sqlite"
[ "$MOSQUITTO_AUTH_BACKEND_REDIS" == 'yes' ] && BUILD_DEPENDENCIES="${BUILD_DEPENDENCIES} hiredis-dev" && DEPENDENCIES="${DEPENDENCIES} hiredis"
[ "$MOSQUITTO_AUTH_BACKEND_POSTGRES" == 'yes' ] && BUILD_DEPENDENCIES="${BUILD_DEPENDENCIES} postgresql-dev" && DEPENDENCIES="${DEPENDENCIES} postgresql-client"
[ "$MOSQUITTO_AUTH_BACKEND_LDAP" == 'yes' ] && BUILD_DEPENDENCIES="${BUILD_DEPENDENCIES} openldap-dev" && DEPENDENCIES="${DEPENDENCIES} openldap"
[ "$MOSQUITTO_AUTH_BACKEND_HTTP" == 'yes' ] && BUILD_DEPENDENCIES="${BUILD_DEPENDENCIES} curl-dev" && DEPENDENCIES="${DEPENDENCIES} curl"

# mongodb dependencies
if [ "$MOSQUITTO_AUTH_BACKEND_MONGO" == 'yes' ]; then
  apk add --no-cache --virtual=build_dependencies wget tar ca-certificates build-base util-linux-dev c-ares-dev openssl-dev perl-dev file-dev \
  && SAVED_DIR=`pwd` \
  && MONGOC_TEMP_DIR=/tmp/mongo-c-driver \
  && mkdir -p $MONGOC_TEMP_DIR \
  && wget -O - "https://github.com/mongodb/mongo-c-driver/releases/download/${MONGODB_VERSION}/mongo-c-driver-${MONGODB_VERSION}.tar.gz" | tar xzf - -C $MONGOC_TEMP_DIR --strip-components=1 \
  && cd $MONGOC_TEMP_DIR \
  && ./configure --prefix=/usr/local \
  && make \
  && make install \
  && cd $SAVED_DIR \
  && apk del build_dependencies
fi

# build mosquitto auth plugin
apk add --no-cache --virtual=build_dependencies $BUILD_DEPENDENCIES \
&& apk add --no-cache $DEPENDENCIES \
&& MOSQUITTO_AUTH_PLUGIN_TEMP_DIR=/tmp/mosquitto-auth-plug \
&& mkdir -p $MOSQUITTO_AUTH_PLUGIN_TEMP_DIR \
&& wget -O - "https://github.com/jpmens/mosquitto-auth-plug/archive/${MOSQUITTO_AUTH_VERSION}.tar.gz" | tar xzf - -C $MOSQUITTO_AUTH_PLUGIN_TEMP_DIR --strip-components=1 \
\
&& echo "BACKEND_CDB ?= ${MOSQUITTO_AUTH_BACKEND_CDB}
BACKEND_MYSQL ?= ${MOSQUITTO_AUTH_BACKEND_MYSQL}
BACKEND_SQLITE ?= ${MOSQUITTO_AUTH_BACKEND_SQLITE}
BACKEND_REDIS ?= ${MOSQUITTO_AUTH_BACKEND_REDIS}
BACKEND_POSTGRES ?= ${MOSQUITTO_AUTH_BACKEND_POSTGRES}
BACKEND_LDAP ?= ${MOSQUITTO_AUTH_BACKEND_LDAP}
BACKEND_HTTP ?= ${MOSQUITTO_AUTH_BACKEND_HTTP}
BACKEND_MONGO ?= ${MOSQUITTO_AUTH_BACKEND_MONGO}

# Specify the path to the Mosquitto sources here
MOSQUITTO_SRC = ${MOSQUITTO_TEMP_DIR}

# Specify the path the OpenSSL here
OPENSSLDIR = ${OPENSSLDIR}" > $MOSQUITTO_AUTH_PLUGIN_TEMP_DIR/config.mk \
\
&& cat $MOSQUITTO_AUTH_PLUGIN_TEMP_DIR/config.mk \
\
&& ln -s /usr/local/include/*/* /usr/local/include \
\
&& make -C $MOSQUITTO_AUTH_PLUGIN_TEMP_DIR \
&& apk del build_dependencies \
&& cp $MOSQUITTO_AUTH_PLUGIN_TEMP_DIR/auth-plug.so /usr/lib/auth-plug.so \
&& rm -rf "/tmp/"* \
&& rm -rf "/usr/local/include"