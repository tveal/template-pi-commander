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
    pcmanfm -d -w "$THIS_DIR/wallpaper.png" --wallpaper-mode fit --display :0
  fi
}

function installDependencies() {
  if notInstalled qrencode; then
    echo "Installing qrencode..."
    sudo apt-get install -y qrencode
  fi

  if notInstalled imagemagick; then
    echo "Installing imagemagick..."
    sudo apt-get install -y imagemagick
  fi
}

function createWallpaper() {
  local ip="$(ip route get 1 | head -1 | cut -d' ' -f7)"
  echo "ip: $ip"
  qrencode -s 6 -l H -o "$THIS_DIR/qrcode.png" "http://$ip:3000"

  # combine Pi-CMD-logo with qrcode
  montage "$THIS_DIR/Pi-CMD-logo.png" "$THIS_DIR/qrcode.png" -background '#151c23' -geometry +2+2 "$THIS_DIR/wallpaper.png"

  # add ip and timestamp to wallpaper
  convert \
    "$THIS_DIR/wallpaper.png" \
    -gravity SouthEast \
    -pointsize 15 \
    -fill '#fff' \
    -annotate 0 "IP: $ip | $(date '+%Y-%m-%d %T')" \
    "$THIS_DIR/wallpaper.png"

  # resize and fill to 7" touchscreen
  convert \
    "$THIS_DIR/wallpaper.png" \
    -resize 800x480 \
    -background '#151c23' \
    -gravity center \
    -extent 800x480 \
    "$THIS_DIR/wallpaper.png"
}

runMain "$@"
