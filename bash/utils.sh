#!/bin/bash
# Exit immediately if a command exits with a non-zero status.
set -e

# runMain: in each script, use the pattern:
#
# THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# source $THIS_DIR/../utils.sh
#
# function main() {
#   ...
# }
#
# runMain "$@"
#
function runMain() {
  local component="$( basename $THIS_DIR)"
  local action="$( basename $0 )"
  echo "$(date '+%Y-%m-%d %T') [START] $action {$component}"
  main "$@"
  echo "$(date '+%Y-%m-%d %T') [COMPLETE] $action {$component}"
}

function notInstalled() {
  local status="$(dpkg-query -W -f='${db:Status-Status}' $1 2> /dev/null)"
  echo "running notInstalled on $1; status: $status"
  test -z "$status" || test "$status" != "installed"
}

function isRaspberryPi() {
  test "$(hostname)" = "raspberrypi"
}

function loadNvmIfInstalled() {
  set +e
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
  set -e
}
# Make nvm accessible to scripts, if installed
loadNvmIfInstalled

# IMPORTANT: THIS_DIR is relative to the script that sources this file.
#  Only works in files one-level deeper than this utils.sh file
PREV_COMMIT_FILE="$THIS_DIR/../git/prevCommit"
LAST_COMMIT_FILE="$THIS_DIR/../git/lastCommit"
function hasGitChanges() {
  if [[ -f "$PREV_COMMIT_FILE" && -f "$LAST_COMMIT_FILE" ]]; then
    test "$(cat $PREV_COMMIT_FILE)" != "$(cat $LAST_COMMIT_FILE)"
  else
    test ! -f "$PREV_COMMIT_FILE"
  fi
}
