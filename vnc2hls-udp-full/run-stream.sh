#!/bin/bash
set -u

SERVER_IP="192.168.60.2"
VNC_PORT="5901"
RESOLUTION="1920x1080"
FPS=25
OUTDIR="/var/www/hls"

UDP_ADDR="239.255.1.1"
UDP_PORT="1234"

# stop proses lama
pkill -9 ffmpeg 2>/dev/null || true
pkill -9 vncviewer 2>/dev/null || true
pkill -9 openbox 2>/dev/null || true
pkill -9 Xvfb 2>/dev/null || true
sleep 1

mkdir -p "$OUTDIR"
rm -f "$OUTDIR"/*.ts "$OUTDIR"/*.m3u8

echo "[INFO] Start Xvfb :99 ($RESOLUTION)..."
Xvfb :99 -screen 0 ${RESOLUTION}x24 &
sleep 3
export DISPLAY=":99"

echo "[INFO] Start openbox..."
openbox &
sleep 3

echo "[INFO] Start vncviewer ke $SERVER_IP:$VNC_PORT ..."
vncviewer -ViewOnly -Shared -FullScreen "$SERVER_IP:$VNC_PORT" &
sleep 7

# Step 1: Grab layar → kirim ke UDP
echo "[INFO] Start FFmpeg grab → UDP ..."
ffmpeg -f x11grab -framerate $FPS -draw_mouse 0 -video_size "$RESOLUTION" -i :99   -c:v mpeg2video -q:v 5 -pix_fmt yuv420p   -an -f mpegts "udp://$UDP_ADDR:$UDP_PORT?pkt_size=1316"   > "$OUTDIR/ffmpeg-udp.log" 2>&1 &

sleep 2

# Step 2: Bungkus UDP → HLS
echo "[INFO] Start FFmpeg UDP → HLS ..."
ffmpeg -i udp://$UDP_ADDR:$UDP_PORT   -c:v copy -c:a copy   -f hls -hls_time 6 -hls_list_size 5 -hls_flags delete_segments   "$OUTDIR/stream.m3u8" > "$OUTDIR/ffmpeg-hls.log" 2>&1 &

echo "[OK] Streaming jalan!"
echo "👉 Akses di VLC / Browser / TV:"
echo "   http://$(hostname -I | awk '{print $1}'):8088/hls/stream.m3u8"
