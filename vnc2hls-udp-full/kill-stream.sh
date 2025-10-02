#!/bin/bash

echo "[INFO] Stop semua proses streaming..."
pkill -9 ffmpeg 2>/dev/null || true
pkill -9 vncviewer 2>/dev/null || true
pkill -9 openbox 2>/dev/null || true
pkill -9 Xvfb 2>/dev/null || true
echo "[OK] Semua proses dihentikan."
