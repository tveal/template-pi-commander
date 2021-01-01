#!/bin/bash
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $THIS_DIR/../utils.sh

function main() {
  echo "Setting wallpaper..."

  if notInstalled qrencode; then
    echo "Installing qrencode..."
    sudo apt-get install -y qrencode
  fi

  local ip="$(ip route get 1 | head -1 | cut -d' ' -f7)"
  echo "ip: $ip"
  qrencode -s 6 -l H -o "$THIS_DIR/qrcode.png" "http://$ip:3000"
}

runMain "$@"
