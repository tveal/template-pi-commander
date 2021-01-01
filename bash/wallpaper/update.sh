#!/bin/bash
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $THIS_DIR/../utils.sh

function main() {
  installDependencies
  createWallpaper

  if isRaspberryPi; then
    # https://stackoverflow.com/a/46259031
    export XAUTHORITY=/home/pi/.Xauthority
    export XDG_RUNTIME_DIR=/run/user/1000
    pcmanfm -d -w "$THIS_DIR/qrcode.png" --wallpaper-mode fit --display :0
  fi
}

function installDependencies() {
  if notInstalled qrencode; then
    echo "Installing qrencode..."
    sudo apt-get install -y qrencode
  fi
}

function createWallpaper() {
  local ip="$(ip route get 1 | head -1 | cut -d' ' -f7)"
  echo "ip: $ip"
  qrencode -s 6 -l H -o "$THIS_DIR/qrcode.png" "http://$ip:3000"
}

runMain "$@"
