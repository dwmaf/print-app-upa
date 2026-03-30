# Print App - Installation Guide

Proyek ini adalah aplikasi berbasis Laravel. Ikuti langkah-langkah di bawah ini untuk menjalankan proyek di mesin lokal Anda.

## Prasyarat

Pastikan Anda sudah menginstal:
- PHP >= 8.2
- Composer
- Node.js & NPM
- MySQL/MariaDB (atau Laragon)
- **Ngrok CLI** (Download di [ngrok.com](https://ngrok.com/download/windows?tab=install))

## Langkah Instalasi

### 1. Clone Repository
```sh
git clone https://github.com/dwmaf/print-app.git
cd print-app
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
   netsh advfirewall firewall add rule name="Laravel Vite" dir=in action=allow protocol=TCP localport=5173
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
npm install
npm run build
```

### 10. Menjalankan Aplikasi

1. Jalankan server Laravel:
   ```sh
   php artisan serve
   ```
2. Jalankan pemantau aset Vite (opsional saat pengembangan):
   ```sh
   npm run dev
   ```
3. **Jika ingin menguji fitur real-time sync via HP** (Cek no 4):
   - Jalankan `npm run build` terlebih dahulu.
   - Gunakan perintah: `composer run lainprod`
   - Akses via HP: `http://[IP-LAPTOP-ANDA]:8000`

4. **Khusus Frontend Developer** (Jika hanya koding UI di laptop saja):
   - Gunakan `.env` standar (`APP_URL=http://localhost:8000`).
   - Jalankan `composer run laindev`.
   - Buka di browser laptop: `http://localhost:8000`.
   - *Catatan: Jika koding UI tapi ingin melihat tampilannya di HP lewat IP lokal, pastikan port 5173 sudah diizinkan di Firewall agar CSS muncul.*

### 11. Daftar Halaman yang Ada & Lokasi file bladenya

#### A. Fitur Pelanggan (Customer - Mobile/HP)
| Fitur | Lokasi File | Rute | Deskripsi |
|-------|--------|------|-----------|
| **Upload Page** | user-upload.blade.php | `/upload/{station_id}` | Halaman upload file via scan QR di laptop. |

#### B. Fitur Print Station (Mesin Cetak)
| Fitur | Lokasi File | Rute | Deskripsi |
|-------|--------|------|-----------|
| **Dashboard Station**| print-station.blade.php | `/station` | Daftar antrian file yang siap diprint (Auto-refresh via Reverb) perlu login, liat kredensial login station di DatabaseSeeder.php. |

#### C. Fitur Outlet Owner (Semuanya perlu login sebagai outlet-owner, cek DatabaseSeeder.php utk liat kredensial login)
| Fitur | Lokasi File | Rute | Deskripsi |
|-------|--------|------|-----------|
| **Dashboard** | outlet-owner/dashboard.blade.php | `/outlet/dashboard` | Ringkasan pendapatan dan statistik outlet. |
| **Antrian Bayar** | outlet-owner/payments.blade.php | `/outlet/payments` | List bukti pembayaran masuk. |
| **Manajemen File** | outlet-owner/files.blade.php | `/outlet/files` | Monitoring & pembersihan file di semua station milik outlet. |
| **Kelola Station** | outlet-owner/stations.blade.php | `/outlet/stations` | Menambah/menghapus akun station di bawah outlet. |

#### D. Fitur Super Admin (Global)
| Fitur | Lokasi File | Rute | Deskripsi |
|-------|--------|------|-----------|
| **Dashboard Super Admin** | admin/dashboard-admin.blade.php | `/admin/dashboard` | Statistik untuk insight admin. |
| **Kelola Outlet** | admin/outlets/index.blade.php | `/admin/outlets` | Menambah outlet baru & owner-nya ke sistem. |
| **Log Transaksi** | admin/transactions/index.blade.php | `/admin/transactions` | Melihat riwayat seluruh transaksi di semua outlet. |

#### E. Autentikasi
| Fitur | Lokasi File | Rute | Deskripsi |
|-------|--------|------|-----------|
| **Login** | auth/login.blade.php | `/login` | Masuk sesuai role (Admin/Outlet-Owner/Station). |