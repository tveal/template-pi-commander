#!/bin/bash
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $THIS_DIR/../utils.sh

function main() {
  local crontabFile="$THIS_DIR/crontab"
  local logFile="$THIS_DIR/cron.log"
  local updateAll="$THIS_DIR/../../update.sh >> $logFile 2>&1"
  local logRotate="$THIS_DIR/logRotate.sh >> $logFile 2>&1"

  echo "*/5 * * * * $updateAll" > $crontabFile
  echo "9-59/10 * * * * $logRotate" >> $crontabFile

  echo "<crontab>"
  cat $crontabFile
  echo "</crontab>"

  if isRaspberryPi; then
    crontab -u pi "$crontabFile"
  fi
}

runMain "$@"
