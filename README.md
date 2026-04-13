# Print App - Installation Guide

Proyek ini adalah aplikasi berbasis Laravel, InertiaJs, dan VueJs. Ikuti langkah-langkah di bawah ini untuk menjalankan proyek di mesin lokal Anda.

## Prasyarat

Pastikan Anda sudah menginstal:
- PHP >= 8.2
- Composer
- Node.js & PpNPM (sangat disarankan untuk menggunakan ppnpm dibanding pnpm karena lebih cepat dan lebih hemat storage, ppnpm membuat link jika versi dependansi yg sama berada di direktori yang berbeda, sementara pnpm akan membuat duplikasi walaupun versi dependansinya sama sehingga akan memakan ruang lebih banyak)
- MySQL/MariaDB/SQLite

## Langkah Instalasi

### 1. Clone Repository
```sh
git clone https://github.com/dwmaf/print-app-upa.git
cd print-app-upa
```

### 2. Instal Dependensi PHP
```sh
composer install
```

### 3. Setup File Environment
Salin file `.env.example` menjadi `.env` dan sesuaikan konfigurasi database Anda.
```sh
copy .env.example .env
```
*Gunakan `cp` jika menggunakan terminal Git Bash/Linux.*

### 4. Konfigurasi Jaringan & IP Lokal (Wajib jika ingin Testing via HP dan  Menguji fitur Real Time, yes brothers, kita ga pakai ngrok lagi, ngrok suckss, local IP is the best)

Agar fitur scan QR Code berfungsi di HP, laptop dan HP Anda **wajib** berada dalam satu jaringan Wi-Fi yang sama.

1. Cari IP Lokal (IPv4) laptop Anda:
   - Buka CMD/Terminal/PowerShell.
   - Ketik `ipconfig`.
   - Cari baris `IPv4 Address` pada bagian adapter Wi-Fi (Contoh: `10.91.233.144`).
2. Buka file `.env` dan sesuaikan variabel berikut menggunakan IP tersebut:
```dotenv
# Ganti dengan IP laptop Anda
APP_URL="http://10.91.233.144:8000"

# Konfigurasi Reverb (Backend tetap ke Localhost)
REVERB_HOST="127.0.0.1"
REVERB_PORT=8081
REVERB_SCHEME=http

# Konfigurasi Akses HP (Frontend/Client)
VITE_REVERB_HOST="10.91.233.144" # Gunakan IP laptop Anda
VITE_REVERB_PORT="${REVERB_PORT}"
VITE_REVERB_SCHEME="${REVERB_SCHEME}"
```

Jika anda hanya ingin mengubah" ui tanpa menguji fitur real time ubah nilai BROADCAST_CONNECTION menjadi log
```
BROADCAST_CONNECTION=log
```

3. **Izin Firewall (Wajib)**:
   Agar HP bisa memanggil server di laptop, jalankan PowerShell sebagai **Administrator** dan eksekusi perintah berikut satu per satu:
   ```sh
   netsh advfirewall firewall add rule name="Laravel App" dir=in action=allow protocol=TCP localport=8000
   netsh advfirewall firewall add rule name="Laravel Reverb" dir=in action=allow protocol=TCP localport=8081
   ```

### 5. Generate Application Key
```sh
php artisan key:generate
```

### 6. Hubungkan Storage ke Public
Jalankan storage link agar file yang tersimpan di storage bisa diakses:
```sh
php artisan storage:link
```

### 7. Migrasi Database
Pastikan database sudah dibuat di MySQL, lalu jalankan:
```sh
php artisan migrate
```

### 8. Seeding Database
Data dummy sudah tersedia di databaseseeder, jadi anda bisa seeding data untuk lihat datanya:
Copy folder files di folder public ke folder storage/app/public

```sh
php artisan db:seed
```

### 9. Instal Dependensi Frontend
```sh
pnpm install
pnpm run build
```

### 10. Menjalankan Aplikasi

1. Jalankan server Laravel:
   ```sh
   php artisan serve
   ```
2. Jalankan pemantau aset Vite (opsional saat pengembangan):
   ```sh
   pnpm run dev
   ```
3. **Jika ingin menguji fitur real-time sync via HP** (Cek no 4):
   - Jalankan `pnpm run build` terlebih dahulu.
   - Gunakan perintah: `composer run prod`
   - Akses via HP: `http://[IP-LAPTOP-ANDA]:8000`

4. **Khusus Frontend Developer** (Jika hanya koding UI di laptop saja):
   - Gunakan `.env` standar (`APP_URL=http://localhost:8000`).
   - Jalankan `composer run dev`.
   - Buka di browser laptop: `http://localhost:8000`.

# Production

port di anjungannya adalah 8001 untuk server laravelnya, dan 8002 untuk server reverbnya