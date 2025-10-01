#!/bin/bash
# Jalankan vncviewer fullscreen ke server Armbian
xinit /usr/bin/vncviewer -FullScreen -Shared 192.168.60.20:5900 -- :0
