#!/bin/bash
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $THIS_DIR/bash/utils.sh

function main() {
  echo "Starting the Pi Commander Update!"

  update wallpaper
}

function update() {
  $THIS_DIR/bash/$1/update.sh
}

runMain "$@"
