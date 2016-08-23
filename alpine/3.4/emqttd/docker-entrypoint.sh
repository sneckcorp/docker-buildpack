#!/bin/sh

if [[ "$1" == "start-with-log" ]]; then
  emqttd start

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
    sleep 1
    tail -f $LOG_FILE
  else
    tail -f /dev/null
  fi
else
  emqttd $@
fi