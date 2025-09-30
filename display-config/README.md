# Headless STB Based on Debian 12 (No GUI/Desktop Environment)

Proyek ini membuat **Set-Top Box (STB) headless** berbasis **Debian 12** yang menjalankan **Google Chrome** dalam mode **kiosk fullscreen** tanpa Desktop Environment (DE) atau GUI penuh.  
Cocok untuk kebutuhan **digital signage**, **dashboard monitoring**, atau **NVR viewer** ringan.

---

## 📦 Paket yang Dibutuhkan

Update sistem dan install driver GPU + paket dasar:

```bash
apt update
apt install -y firmware-linux firmware-linux-nonfree xserver-xorg-video-radeon mesa-va-drivers vainfo
```

Install Xorg + Openbox (minimal window manager):

```bash
apt install -y wget gnupg apt-transport-https xorg openbox
```

Tambahkan repository resmi Google Chrome:

```bash
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google.gpg] http://dl.google.com/linux/chrome/deb/ stable main"   | tee /etc/apt/sources.list.d/google-chrome.list
```

Install Chrome:

```bash
apt update
apt install -y google-chrome-stable
```

Tambahan multimedia (opsional, untuk video/audio streaming):

```bash
apt install -y ffmpeg gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav
```

---

## 🖥️ Konfigurasi Monitor (Opsional)

Jika ingin memastikan resolusi/monitor terdeteksi dengan benar, buat file konfigurasi:

```bash
nano /etc/X11/xorg.conf.d/10-monitors.conf
```

Isi dengan:

```conf
Section "Monitor"
    Identifier "DisplayPort-0"
    Option "PreferredMode" "1920x1080"
    Option "Primary" "true"
EndSection

Section "Monitor"
    Identifier "DVI-0"
    Option "PreferredMode" "1920x1080"
    Option "Clone" "DisplayPort-0"
EndSection

Section "Screen"
    Identifier "Screen0"
    Device "RadeonCard0"
    Monitor "DisplayPort-0"
    SubSection "Display"
        Modes "1920x1080"
    EndSubSection
EndSection
```

---

## 🚀 Cara Menjalankan Chrome (Pilih Salah Satu)

### 1. Metode `.xinitrc` → `startx`

Buat file `.xinitrc` di home directory:

```bash
nano ~/.xinitrc
```

Isi dengan:

```bash
/usr/bin/google-chrome   --kiosk   --app=http://192.168.60.6:8090   --no-first-run   --disable-translate   --no-sandbox   --start-fullscreen   --window-position=0,0   --window-size=1920,1080   --force-device-scale-factor=1   --alsa-output-device=default   --autoplay-policy=no-user-gesture-required
```

Jalankan dengan:

```bash
startx
```

---

### 2. Metode `stb.sh` (xinit langsung)

Buat script:

```bash
nano stb.sh
chmod +x stb.sh
```

Isi file `stb.sh`:

```bash
#!/bin/bash

xinit /usr/bin/google-chrome   --kiosk   --app=http://192.168.60.6:8090   --no-first-run   --disable-translate   --no-sandbox   --start-fullscreen   --window-position=0,0   --window-size=1920x1080   --force-device-scale-factor=1   --alsa-output-device=default   --autoplay-policy=no-user-gesture-required
```

Jalankan dengan:

```bash
./stb.sh
```

---

## 🛑 Kill Chrome/Xorg jika macet

Gunakan perintah berikut jika Chrome/Xorg hang:

```bash
pkill Xorg
pkill chrome
pkill google-chrome
pkill -f stb.sh
```

Atau gunakan script `killstb.sh` yang sudah disediakan.

---

## 🖥️ Monitor & Display Management (Opsional)

Cek monitor yang terdeteksi:

```bash
DISPLAY=:0 xrandr --listmonitors
DISPLAY=:0 xrandr --query
DISPLAY=:0 xrandr | grep '*'
DISPLAY=:0 xrandr --prop
```

Atur resolusi dan clone output:

```bash
DISPLAY=:0 xrandr --output DisplayPort-0 --primary --mode 1920x1080
DISPLAY=:0 xrandr --output DVI-0 --mode 1920x1080 --same-as DisplayPort-0
```

---

## 📖 Catatan

- **Pilih salah satu metode**: `.xinitrc` → `startx` **atau** `stb.sh`.  
- Project ini **headless**, artinya **tanpa GUI/Desktop Environment penuh**.  
- Bisa dipakai untuk **digital signage**, **CCTV/NVR grid viewer**, atau **web dashboard**.

---
