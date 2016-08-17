#!/bin/bash
ZOO_LOG_DIR=$ZK_HOME/logs
ZOO_DATA_DIR=$ZK_HOME/data
ZOO_LOG4J_PROP=${ZOO_LOG4J_PROP:-INFO,CONSOLE,ROLLINGFILE}
 
ZK_MYID=${ZK_MYID:-1}
ZK_HOSTNAME=${ZK_HOSTNAME:-$(hostname)}
ZK_ENV_MODE=${ZK_ENV_MODE:-false}

ZK_MAX_SERVERS=${ZK_MAX_SERVERS:-1}
ZK_HOSTNAME_PREFIX=${ZK_HOSTNAME_PREFIX:-zookeeper-}

RESET_IFS=$IFS
IFS="." read -ra RELEASE <<< "${ZK_VERSION}"
IFS=$RESET_IFS


if [[ "$ZK_MAX_SERVERS" -gt 1 ]]; then
  echo "Starting up in clustered mode"

  for i in $( eval echo {1..$ZK_MAX_SERVERS});do
    if [ "$ZK_MYID" = "$i" ];then
      echo "server.${i}=0.0.0.0:2888:3888" >> $ZK_HOME/conf/zoo.cfg
    else
      echo "server.${i}=${ZK_HOSTNAME_PREFIX}${i}:2888:3888" >> $ZK_HOME/conf/zoo.cfg
    fi
  done

  cat $ZK_HOME/conf/zoo.cfg

  echo "$ZK_MYID" > $ZOO_DATA_DIR/myid
else
  echo "Starting up in standalone mode"
fi

$ZK_HOME/bin/zkServer.sh start-foreground