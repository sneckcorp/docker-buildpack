#!/bin/bash
: ${ZK_STANDALONE_DISABLED:=true}

ZOO_LOG_DIR=$ZK_HOME/logs
ZOO_LOG4J_PROP='INFO,CONSOLE,ROLLINGFILE'

if [ $ZK_STANDALONE_DISABLED = false ]
then
  $ZK_HOME/bin/zkServer.sh `[ -n "$1" ] && echo "$1" || echo "start-foreground"`
else
  : ${ZK_SERVERS:=$1}
  : ${ZK_MYID:=1}
  IPADDRESS=`ip -4 addr show scope global dev eth0 | grep inet | awk '{print \$2}' | cut -d / -f 1`

  echo "standaloneEnabled=false" >> $ZK_HOME/conf/zoo.cfg
  echo "dynamicConfigFile=$ZK_HOME/conf/zoo.cfg.dynamic" >> $ZK_HOME/conf/zoo.cfg

  # 이미 시작중인 프로세스 종료
  ZOOPIDFILE="$ZK_HOME/data/zookeeper_server.pid"
  if [ -f "$ZOOPIDFILE" ] 
  then
    pid=`cat "$ZOOPIDFILE"`
    [ -n "`ps | grep "$pid"`" ] && kill -0 "$pid" > /dev/null
    rm -rf "$ZOOPIDFILE" > /dev/null
  fi

  if [ -n "$ZK_SERVERS" ] # 기존 서버에 참가
  then
    while :
    do
      SERVERS=`$ZK_HOME/bin/zkCli.sh -server $ZK_SERVERS get /zookeeper/config | grep ^server`
      if [ -n "$SERVERS" ]
      then
        break
      else
        echo "Wait server connecting...."
        sleep 1
      fi
    done

    SERVER=`echo "${SERVERS}" | grep "$IPADDRESS:2888"`

    if [ -n "${CURRENT_SERVER}" ] # 기존에 이미 참가 중일 경우
    then 
      ZK_MYID=`echo "${SERVER}" | cut -d "=" -f1 | cut -d "." -f2 | sort -r | cut -d $'\n' -f1 | head`

      echo "$SERVERS" | sed "s/${SERVER}//" > $ZK_HOME/conf/zoo.cfg.dynamic
      echo "server.$ZK_MYID=$IPADDRESS:2888:3888:observer;2181" >> $ZK_HOME/conf/zoo.cfg.dynamic
      $ZK_HOME/bin/zkServer-initialize.sh --force --myid=$ZK_MYID

      $ZK_HOME/bin/zkServer.sh start-foreground
    else # 새로운 participant 추가
      LAST_MYID=`echo "${SERVERS}" | cut -d "=" -f1 | cut -d "." -f2 | sort -r | cut -d $'\n' -f1 | head`
      ZK_MYID=$((${LAST_MYID}+1))

      echo "$SERVERS" > $ZK_HOME/conf/zoo.cfg.dynamic
      echo "server.$ZK_MYID=$IPADDRESS:2888:3888:observer;2181" >> $ZK_HOME/conf/zoo.cfg.dynamic
      $ZK_HOME/bin/zkServer-initialize.sh --force --myid=$ZK_MYID

      $ZK_HOME/bin/zkServer.sh start > /dev/null
      $ZK_HOME/bin/zkCli.sh -server $ZK_SERVERS reconfig -add "server.$ZK_MYID=$IPADDRESS:2888:3888:participant;2181"
      tail -n +0 -f `find "${ZOO_LOG_DIR}" -name "*.out" | sort -r | head`
    fi
  else
    echo "server.$ZK_MYID=$IPADDRESS:2888:3888;2181" >> $ZK_HOME/conf/zoo.cfg.dynamic
    $ZK_HOME/bin/zkServer-initialize.sh --force --myid=$ZK_MYID
    $ZK_HOME/bin/zkServer.sh start-foreground
  fi

fi