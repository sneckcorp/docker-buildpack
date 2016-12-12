#!/bin/sh

auto_cluster_join() {
  if [[ "$EMQTTD_AUTO_CLUSTER_JOIN" == "true" ]]; then
    NODE_NAME=`egrep '^\-\s*name' $EMQTTD_HOME/etc/vm.args | sed -r 's/^-\s*name\s*(.*)/\1/'`
    MASTER_NODE_PATH="$EMQTTD_HOME/cluster/master"

    if [[ -f "$MASTER_NODE_PATH" ]]; then
      MASTER_NAME=`cat $EMQTTD_HOME/cluster/master`
      emqttd_ctl cluster join $MASTER_NAME &> /dev/null

      echo "cluster mode: slave"
      emqttd_ctl cluster status
    else
      mkdir -p $EMQTTD_HOME/cluster
      echo "$NODE_NAME" > $MASTER_NODE_PATH

      echo "cluster mode: master"
    fi
  fi
}

if [[ -z "$EMQTTD_NODE_NAME" -a -n "$EMQTTD_BIND_NODE_NAME" ]]; then
  if [[ "$EMQTTD_BIND_NODE_NAME" == "ip" ]]; then
    EMQTTD_NODE_NAME=`ip -4 addr show scope global dev eth0 | grep inet | head -1 | awk '{print \$2}' | cut -d / -f 1`
  else
    EMQTTD_NODE_NAME=`hostname -f`
  fi
fi

if [[ -n "$EMQTTD_NODE_NAME" ]]; then
  VM_ARGS_DATA=`cat $EMQTTD_HOME/etc/vm.args`
  echo "$VM_ARGS_DATA" | sed "s/^-\s*name.*/-name emqttd@${EMQTTD_NODE_NAME}/" > $EMQTTD_HOME/etc/vm.args
fi

if [[ "$1" == "start-with-log" ]]; then
  emqttd start
  auto_cluster_join

  sleep 1

  EMQTTD_LOG_PATH=$EMQTTD_HOME/log
  for LOG_LEVEL in debug info notice warning error critical alert emergency crash; do
    LOG_FILE_PATH="${EMQTTD_LOG_PATH}/emqttd_${LOG_LEVEL}.log"

    if [[ -f "$LOG_FILE_PATH" ]]; then
      LOG_FILE="$LOG_FILE_PATH"
      break;
    fi
  done


  if [[ -n "$LOG_FILE" ]]; then
    echo "watching the file(${LOG_FILE})"
    tail -f $LOG_FILE
  else
    echo "not found log file."
    tail -f /dev/null
  fi
else
  emqttd $@
  auto_cluster_join
fi