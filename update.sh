#!/bin/bash
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $THIS_DIR/bash/utils.sh

function main() {
  update git

  for path in $( cd "$THIS_DIR" && getUpdateScripts ); do
    local module="$(echo "$path" | cut -d/ -f2)"
    if [ "$module" != "git" ]; then
      update "$module"
    fi
  done
}

function update() {
  "$THIS_DIR/bash/$1/update.sh"
}

function getUpdateScripts() {
  find bash -mindepth 2 -maxdepth 2 -name 'update.sh' | sort
}

runMain "$@"
