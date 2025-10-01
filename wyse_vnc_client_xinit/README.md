# Wyse ZX0 sebagai VNC Client tanpa Desktop (Debian 12)

Proyek ini menunjukkan cara menjadikan **Wyse ZX0 (Debian 12)** sebagai **VNC client murni** menggunakan `xinit` + `tigervnc-viewer`, **tanpa desktop environment**. Sangat cocok untuk signage atau menampilkan tampilan dari server Armbian.

---

## 🚀 Fitur
- Tanpa desktop environment (ringan dan cepat)
- Menggunakan `xinit` langsung memanggil `tigervnc-viewer`
- Fullscreen otomatis ke server VNC
- Bisa diatur autostart saat boot (opsional)

---

## 📂 Struktur
```
.
├── start-vnc.sh         # Skrip untuk menjalankan vncviewer via xinit
└── README.md            # Dokumentasi (file ini)
```

---

## ⚙️ Instalasi

### 1. Install paket minimal
```bash
sudo apt update
sudo apt install -y xorg tigervnc-viewer openbox x11-utils
```

> `xorg` = X server minimal untuk `xinit`  
> `tigervnc-viewer` = aplikasi VNC client (`vncviewer`)

### 2. Buat skrip `start-vnc.sh`
```bash
#!/bin/bash
# Jalankan vncviewer fullscreen ke server Armbian
xinit /usr/bin/vncviewer -FullScreen -Shared 192.168.60.20:5900 -- :0
```

Kasih izin eksekusi:
```bash
chmod +x start-vnc.sh
```

> Ganti `192.168.60.20` dengan IP server Armbian kamu.

---

## ▶️ Menjalankan

Cukup jalankan:
```bash
./start-vnc.sh
```

➡️ Hasil: Wyse ZX0 langsung membuka `vncviewer` fullscreen ke Armbian.

---

## 🔗 Penggunaan
- Wyse ZX0 akan otomatis menjadi klien VNC fullscreen
- Server Armbian harus sudah jalan dengan `x11vnc` atau server VNC lain di port 5900

---

# 🌍 English Version

## Wyse ZX0 as VNC Client without Desktop (Debian 12)

This project demonstrates how to turn **Wyse ZX0 (Debian 12)** into a **pure VNC client** using `xinit` + `tigervnc-viewer`, **without any desktop environment**. Perfect for digital signage or displaying output from an Armbian server.

---

## 🚀 Features
- No desktop environment (lightweight and fast)
- Uses `xinit` to directly launch `tigervnc-viewer`
- Auto fullscreen to VNC server
- Can be set to autostart on boot (optional)

---

## 📂 Structure
```
.
├── start-vnc.sh         # Script to run vncviewer via xinit
└── README.md            # Documentation (this file)
```

---

## ⚙️ Installation

### 1. Install minimal packages
```bash
sudo apt update
sudo apt install -y xorg tigervnc-viewer
```

> `xorg` = minimal X server for `xinit`  
> `tigervnc-viewer` = VNC client application (`vncviewer`)

### 2. Create script `start-vnc.sh`
```bash
#!/bin/bash
# Run vncviewer fullscreen to Armbian server
xinit /usr/bin/vncviewer -FullScreen -Shared 192.168.60.20:5900 -- :0
```

Make it executable:
```bash
chmod +x start-vnc.sh
```

> Replace `192.168.60.20` with your Armbian server IP.

---

## ▶️ Run

Simply run:
```bash
./start-vnc.sh
```

➡️ Result: Wyse ZX0 directly opens `vncviewer` fullscreen to Armbian.

---

## 🔗 Usage
- Wyse ZX0 becomes a fullscreen VNC client automatically
- Armbian server must already run `x11vnc` or another VNC server on port 5900

