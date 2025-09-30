# AMD HDMI Audio Fix (Wyse Zx0 / OMV7 / Debian 12)

Konfigurasi **ALSA** siap pakai untuk menstabilkan audio **HDMI via DVI→HDMI** pada **Dell Wyse Zx0 (AMD APU)** di **OpenMediaVault 7 / Debian 12**.

Fokus:
- Menghindari error **`Device or resource busy`** saat aplikasi (mis. Chrome kiosk) memakai `plughw:0,3`.
- Membuat audio HDMI **tidak eksklusif** dengan `dmix`.
- Tetap bisa dipakai **tanpa GUI/Desktop (headless)**.

> Walau pakai AMD APU, driver Linux yang aktif tetap bernama `snd_hda_intel` (generik untuk Intel/AMD/NVIDIA).

---

## 🔍 Cara Cek Sound Card & Device

**List kartu suara:**
```bash
cat /proc/asound/cards
```

Contoh output Wyse Zx0:
```
 0 [Generic        ]: HDA-Intel - HD-Audio Generic
                       HD-Audio Generic at 0x91244000 irq 30
 1 [SB             ]: HDA-Intel - HDA ATI SB
                       HDA ATI SB at 0x91240000 irq 16
```

👉 card 0 adalah HDMI, card 1 adalah analog.

**List device playback (ALSA):**
```bash
aplay -l
```

Contoh output:
```
card 0: Generic [HD-Audio Generic], device 3: HDMI 0 [HDMI 0]
card 1: SB [HDA ATI SB], device 0: ALC269VB Analog [ALC269VB Analog]
```

👉 HDMI audio ada di card 0, device 3.

---

## 🔧 Solusi (Konfigurasi ALSA)

Gunakan konfigurasi `dmix` agar HDMI audio tidak eksklusif (bisa dipakai beberapa aplikasi sekaligus tanpa error busy).

**`/etc/asound.conf`**
```conf
pcm.!default {
    type plug
    slave.pcm "dmix:0,3"
}

ctl.!default {
    type hw
    card 0
}
```

---

## 🚀 Cara Pakai

1. Salin file `asound.conf` ke `/etc/asound.conf`
   ```bash
   sudo cp asound.conf /etc/asound.conf
   ```

2. Tes output audio:
   ```bash
   aplay /usr/share/sounds/alsa/Front_Center.wav
   ```

3. Jalankan aplikasi (contoh Chrome) dengan:
   ```bash
   google-chrome --alsa-output-device=default ...
   ```

👉 Dengan ini, audio HDMI akan stabil tanpa error "Device or resource busy".

---

## 📌 Catatan

- Driver ALSA yang dipakai Linux untuk AMD/NVIDIA/Intel HD Audio tetap bernama `snd_hda_intel`.
- Config ini khusus untuk HDMI (card 0, device 3).
- Jika perangkat berbeda, sesuaikan dengan hasil `aplay -l` atau `cat /proc/asound/cards`.
