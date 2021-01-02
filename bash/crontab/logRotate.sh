#!/bin/bash
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $THIS_DIR/../utils.sh

function main() {
  local logFile="$THIS_DIR/cron.log"

  shiftLogFiles
}

function shiftLogFiles() {
  for index in {5..1}; do
    local indexFile="${logFile}.${index}"
    local newFile="${logFile}.$((index+1))"
    if [ -f "$indexFile" ]; then
      mv "$indexFile" "$newFile"
    fi
  done
  if [ -f "$logFile" ]; then
    cp "$logFile" "${logFile}.1"
    echo "Rolled log file; Previous line count: $(wc -l ${logFile}.1 | cut -d' ' -f1)" > "$logFile"
  fi
}

runMain "$@"
