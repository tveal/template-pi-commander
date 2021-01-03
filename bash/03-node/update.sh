#!/bin/bash
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $THIS_DIR/../utils.sh

function main() {
  if noVersion nvm; then
    echo "installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
    loadNvmIfInstalled
  fi

  if noVersion node; then
    echo "installing node..."
    nvm install --lts
  fi

  if noVersion pm2; then
    echo "installing pm2..."
    npm i -g pm2
  fi
}

function noVersion() {
  local version="$($1 -v 2> /dev/null)"
  echo "running noVersion on $1; version: '$version'"
  test -z "$version"
}

runMain "$@"
