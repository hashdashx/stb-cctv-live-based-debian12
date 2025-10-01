#!/bin/bash

# Hentikan dulu proses lama
pkill -9 vncviewer
pkill -9 Xorg

# 1. Jalankan vncviewer fullscreen di :0
xinit /usr/bin/vncviewer \
  -FullScreen \
  -Shared \
  192.168.60.2:5900 \
  -- :0 &

# Tunggu Xorg + vncviewer aktif
sleep 5

# 2. Disable DPMS & screensaver di client (:0)
export DISPLAY=:0
xset -dpms
xset s off
xset s noblank

# 3. (Opsional) loop fake input supaya Xorg tidak pernah idle
# Install dulu: apt install -y xdotool
while true; do
  DISPLAY=:0 xdotool mousemove_relative 1 0
  DISPLAY=:0 xdotool mousemove_relative -- -1 0
  sleep 300   # gerak tiap 5 menit
done &
