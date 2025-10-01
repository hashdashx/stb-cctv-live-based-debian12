# Headless STB Based on Debian 12 (No GUI/Desktop Environment)

This project creates a **headless Set-Top Box (STB)** based on **Debian 12** that runs **Google Chrome** in **kiosk fullscreen** mode without a Desktop Environment (DE). This makes it very lightweight and suitable for older PCs, turning them into **digital signage**, **monitoring dashboards**, or a lightweight **NVR viewer**.

---

## 📦 Required Packages

Update the system and install GPU drivers (adjust according to your hardware) + basic packages:

```bash
apt update
apt install -y firmware-linux firmware-linux-nonfree xserver-xorg-video-radeon mesa-va-drivers vainfo
```

Install Xorg + Openbox (minimal window manager):

```bash
apt install -y wget gnupg apt-transport-https xorg openbox
```

Add the official Google Chrome repository:

```bash
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list
```

Install Chrome:

```bash
apt update
apt install -y google-chrome-stable
```

Optional multimedia packages (for video/audio streaming):

```bash
apt install -y ffmpeg gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav
```

---

## 🖥️ Monitor Configuration (Optional)

If you want to make sure resolution/monitor detection is correct, create the config file:

```bash
nano /etc/X11/xorg.conf.d/10-monitors.conf
```

Content:

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

## 🚀 How to Run Chrome (Choose One)

### 1. `.xinitrc` → `startx`

Create `.xinitrc` in your home directory:

```bash
nano ~/.xinitrc
```

Content:

```bash
/usr/bin/google-chrome --kiosk --app=http://192.168.60.6:8090 --no-first-run --disable-translate --no-sandbox --start-fullscreen --window-position=0,0 --window-size=1920,1080 --force-device-scale-factor=1 --alsa-output-device=default --autoplay-policy=no-user-gesture-required
```

Run with:

```bash
startx
```

---

### 2. `stb.sh` Method (direct xinit)

Create script:

```bash
nano stb.sh
chmod +x stb.sh
```

Content of `stb.sh`:

```bash
#!/bin/bash

xinit /usr/bin/google-chrome --kiosk --app=http://192.168.60.6:8090 --no-first-run --disable-translate --no-sandbox --start-fullscreen --window-position=0,0 --window-size=1920x1080 --force-device-scale-factor=1 --alsa-output-device=default --autoplay-policy=no-user-gesture-required
```

Run with:

```bash
./stb.sh
```

---

## 🛑 Kill Chrome/Xorg if Frozen

If Chrome/Xorg hangs, use:

```bash
pkill Xorg
pkill chrome
pkill google-chrome
pkill -f stb.sh
```

Or use the provided `killstb.sh` script.

---

## 🖥️ Monitor & Display Management (Optional)

Check detected monitors:

```bash
DISPLAY=:0 xrandr --listmonitors
DISPLAY=:0 xrandr --query
DISPLAY=:0 xrandr | grep '*'
DISPLAY=:0 xrandr --prop
```

Set resolution and clone output:

```bash
DISPLAY=:0 xrandr --output DisplayPort-0 --primary --mode 1920x1080
DISPLAY=:0 xrandr --output DVI-0 --mode 1920x1080 --same-as DisplayPort-0
```

---

## 📖 Notes

- **Choose only one method**: `.xinitrc` → `startx` **or** `stb.sh`.  
- This project is **headless**, meaning **without a full GUI/Desktop Environment**.  
- Can be used for **digital signage**, **CCTV/NVR grid viewer**, or **web dashboards**.  
