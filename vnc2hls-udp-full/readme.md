# VNC to HLS via UDP Relay

Proyek ini membuat **relay tampilan VNC** → **MPEG2-TS (UDP multicast/unicast)** → **HLS (m3u8)**.  
Sehingga bisa ditonton di **VLC, browser modern, maupun LG NetCast Smart TV** langsung lewat browser.

## 🔧 Alur

```
[VNC Server] 
     │
     ▼
 [Xvfb + vncviewer]
     │ (grab layar)
     ▼
 [FFmpeg] --encode--> [UDP MPEG2-TS]
     │
     ▼
 [FFmpeg] --remux--> [HLS: stream.m3u8]
     │
     ├──► VLC (modern player)
     ├──► Browser PC
     └──► LG NetCast Smart TV (via browser)
```

##sebelumnya jalankan dulu vnc-sever.sh ya di server
```
file vnc-sever.sh sudah ada disini
```
## 📦 Paket yang Dibutuhkan
Server diuji di **Armbian 11 (Debian Bullseye)**.  
Paket yang perlu di-install:

```bash
sudo apt update
sudo apt install -y ffmpeg xvfb openbox tigervnc-viewer nginx
```

- `ffmpeg` → encode video dan bungkus ulang ke HLS  
- `xvfb` → X server virtual (headless)  
- `openbox` → window manager ringan  
- `tigervnc-viewer` → VNC client untuk menampilkan layar remote  
- `nginx` → webserver untuk menyajikan HLS (`http://IP:8088/hls/stream.m3u8`)

## ▶️ Menjalankan
Edit konfigurasi di `run-stream.sh` sesuai kebutuhan:
- `SERVER_IP` → IP VNC server
- `VNC_PORT` → port VNC server (default `5901`)
- `OUTDIR` → folder HLS (default `/var/www/hls`)
- `UDP_ADDR` → alamat UDP multicast/unicast
- `UDP_PORT` → port UDP (default `1234`)

Jalankan:
```bash
chmod +x run-stream.sh kill-stream.sh
./run-stream.sh
```

Akses stream:
```
http://<IP-SERVER>:8088/hls/stream.m3u8
```

## ⏹️ Menghentikan
```bash
./kill-stream.sh
```

## 🌐 Nginx Config Minimal
Gunakan contoh `nginx.conf.example`:
```nginx
server {
    listen 8088;
    server_name _;

    location /hls {
        types {
            application/vnd.apple.mpegurl m3u8;
            video/mp2t ts;
        }
        root /var/www;
        add_header Cache-Control no-cache;
    }
}
```

Reload nginx:
```bash
sudo nginx -s reload
```

## 📺 Tested On
- Armbian 11 (Debian Bullseye)  
- VLC Media Player (Windows/Linux)  
- LG NetCast Smart TV (browser playback OK)  
