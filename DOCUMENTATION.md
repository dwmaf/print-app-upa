# Tech Stack

# Dokumentasi Controller Printation UPA

Dokumen ini berisi penjelasan untuk masing-masing controller dan function-function di dalamnya yang digunakan dalam aplikasi ini. Semua controller ini berbasis Inertia.js untuk merender tampilan ke sisi frontend (Vue.js).

---

## 1. `InertiaAuthController`
Lokasi: `app/Http/Controllers/InertiaControllers/InertiaAuthController.php`
Controller ini menangani proses autentikasi pengguna (login, logout) serta menampilkan halaman dashboard.

### Metode:
*   **`showLoginForm()`**
    *   **Fungsi**: Menampilkan halaman login untuk pengguna.
    *   **Return**: Merender ke view Inertia `Login`.

*   **`login(Request $request)`**
    *   **Fungsi**: Memproses percobaan login dari user, memvalidasi email dan password, serta mengarahkan (redirect) user ke rute yang sesuai dengan perannya (`super-admin`, `station-upa-pkk`).
    *   **Parameter/Payload**: `email`, `password`.
    *   **Return**: Redirect ke dashboard sesuai tipe peran/role, atau `back()` dengan error jika gagal.

*   **`logout(Request $request)`**
    *   **Fungsi**: Keluar / mencabut sesi autentikasi pengguna dan mengembalikan user ke halaman login.
    *   **Return**: Redirect ke `login`.

*   **`dashboard()`**
    *   **Fungsi**: Menghitung dan menyediakan statistik untuk halaman dashboard admin (total lembar bulan ini, sepanjang masa, persentase tren, ringkasan status, dan data chart untuk 6 bulan terakhir).
    *   **Return**: Merender view Inertia `DashboardAdmin` beserta data statistik.

---

## 2. `InertiaPrintStationController`
Lokasi: `app/Http/Controllers/InertiaControllers/InertiaPrintStationController.php`
Controller ini mengelola layanan Station Print (tempat print berlangsung). Meliputi list file, menghapus, submit print request, hingga perintah print secara lokal dengan SumatraPDF.

### Metode:
*   **`index(Request $request)`**
    *   **Fungsi**: Menampilkan halaman utama untuk station print, berisi daftar dokumen yang diunggah ke *station* tersebut dan QR Code untuk link unggah dokumen.
    *   **Return**: Merender view Inertia `PrintStation/index`.

*   **`submitRequest(Request $request)`**
    *   **Fungsi**: Menerima request konfigurasi pencetakan dari pengguna / admin stasiun (mengatur halaman, mode warna, copy, ukuran kertas). Mengkalkulasi total halaman berdasarkan range. Membuat record `PrintRequest`. Event `NewTransactionCreated` dipanggil.
    *   **Parameter/Payload**: `file_id`, `station_id`, array `print_config[]`.
    *   **Return**: Redirect `back()`.

*   **`print(Request $request)`**
    *   **Fungsi**: Menjalankan perintah eksekusi print secara fisik menggunakan tools *SumatraPDF*. Controller akan membaca dari setting (copy, color/bw, tipe kertas, jumlah halaman) lalu memerintahkan OS untuk mencetak file PDF terkait. Mengubah status PrintRequest menjadi `completed`. Event `TransactionUpdated` dipanggil.
    *   **Parameter/Payload**: `request_id`.
    *   **Return**: JSON response memuat keterangan status (success/error).

*   **`destroy(Filetoprint $filetoprint)`**
    *   **Fungsi**: Menghapus satu file cetak (PDF/gambar) dari *storage* (disk `public`) dan dari database.
    *   **Return**: Redirect `back()`.

*   **`destroyMultiple(Request $request)`**
    *   **Fungsi**: Menghapus beberapa (batch) file cetak sekaligus dari sistem.
    *   **Parameter/Payload**: Array `file_ids[]`.
    *   **Return**: Redirect `back()` dengan pesan sukses.

*   **`proxyPdf($id)`**
    *   **Fungsi**: Membaca file PDF lokal dan menyajikannya ulang (*serve*) ke browser dengan melempar *header* yang sesuai (menghindari CORS/Cross-origin issues jika dijalankan dalam iframe / viewer Vue).
    *   **Return**: `response()->file()` tipe `application/pdf`.

---

## 3. `InertiaUploadController`
Lokasi: `app/Http/Controllers/InertiaControllers/InertiaUploadController.php`
Controller yang digunakan oleh user (pengguna awam/mahasiswa) untuk mengunggah file yang akan di-*print* dari HP / Device mereka dengan memindai (scan) QR Code dari Station tertentu.

### Metode:
*   **`index($id)`**
    *   **Fungsi**: Menampilkan halaman tempat pengguna mengunggah file. Parameter ID Station diteruskan ke front-end.
    *   **Return**: Merender view Inertia `UploadFile`.

*   **`store(Request $request, $id)`**
    *   **Fungsi**: Menerima satu atau banyak file dari form yang dikirim oleh pengguna. Mengunggahnya ke dalam sistem (folder `uploads` disk `public`), serta menyimpan data rekaman file pada *database* model `Filetoprint`. Modul event `FileUploaded` dijalankan.
    *   **Parameter/Payload**: `station_id`, `files` (array File).
    *   **Return**: Redirect ke `upa.upload.index` dengan membawa info flash message (success).

---

## 4. `InertiaVerifyPrintController`
Lokasi: `app/Http/Controllers/InertiaControllers/InertiaVerifyPrintController.php`
Controller ini dikhususkan untuk menampilkan riwayat request print di level Admin dan melakukan persetujuan (verifikasi file/status print).

### Metode:
*   **`index(Request $request)`**
    *   **Fungsi**: Menampilkan halaman daftar perintah cetak yang dikirimkan. Terdapat fitur filter *Search* melalui `Request` untuk mencari ID Order atau Nama File.
    *   **Return**: Merender view Inertia `VerifyPrint` beserta data-data `printrequests` dalam bentuk *Paginate*.

*   **`updateStatus(Request $request, $id)`**
    *   **Fungsi**: Fungsi aksi untuk memverifikasi atau menolak (`reject`) print request. Mengubah rekaman di kolom `status`. Memicu event real-time `TransactionUpdated`.
    *   **Parameter/Payload**: di dalam *body request* berisi tipe `string` (`verify` atau `reject`), ID order ada pada parameter route.
    *   **Return**: Redirect `back()`.


---

# Dokumentasi File Vue (Frontend) Printation UPA

Dokumen ini berisi penjelasan komponen-komponen Vue.js yang merender antarmuka pengguna (UI) melalui framework Inertia.js. Semua komponen menggunakan *Composition API* (`<script setup>`).

## 1. `Login.vue`
**Lokasi:** `resources/js/Pages/Login.vue`
*   **Fungsi:** Halaman pintu masuk (autentikasi) untuk Admin dan stasiun operator.
*   **Fitur Utama:**
    *   Menggunakan `useForm` dari `@inertiajs/vue3` untuk mengirimkan kredensial (email dan password).
    *   Dilengkapi dengan fungsi toggle (Lihat/Sembunyikan) password menggunakan ikon dari `lucide-vue-next`.
    *   Terdapat penanganan status loading (`form.processing`) agar pengguna tidak melakukan aksi klik berlebihan atau dua kali.

## 2. `DashboardAdmin.vue`
**Lokasi:** `resources/js/Pages/DashboardAdmin.vue`
*   **Fungsi:** Menampilkan metrik dan grafik ringkasan pemakaian kertas pada halaman Dashboard Admin Utama.
*   **Fitur Utama:**
    *   Penyajian total halaman bulan ini dan secara keseluruhan (sejak aplikasi dibangun).
    *   Mengkalkulasi persentase *trend* kenaikan atau penurunan hasil pencetakan dibandingkan dengan bulan lalu (hijau untuk naik, merah untuk turun).
    *   Menerapkan library pihak ketiga **`vue3-apexcharts`** untuk menampilkan diagram batang interaktif selama 6 bulan terakhir.

## 3. `VerifyPrint.vue`
**Lokasi:** `resources/js/Pages/VerifyPrint.vue`
*   **Fungsi:** Papan verifikasi Admin untuk memeriksa permintaan file dari pengguna untuk selanjutnya ditolak (`reject`) atau disetujui (`verify`).
*   **Fitur Utama:**
    *   Fungsi pencarian waktu nyata yang mengimplementasikan metode bawaan Inertia.js untuk me-*refresh* tabel `printrequests` tanpa berpindah halaman (*debounce* ditekankan dengan *watcher* atau manual submit).
    *   Mendengarkan event secara live dari sisi *backend* menggunakan **Laravel Echo** (`.transaction.created` dan `.transaction.updated`). Halaman akan melakukan *reload* parsial saat terdeteksi *order* terbaru.
    *   Mendukung *responsive table view* (tabel biasa di desktop, baris *card* untuk mode *mobile*).

## 4. `UploadFile.vue`
**Lokasi:** `resources/js/Pages/UploadFile.vue`
*   **Fungsi:** Halaman unggah yang dibuka pengguna (lewat scan QR Code di stasiun print). Antarmuka *Drag and Drop* yang *user friendly*.
*   **Fitur Utama:**
    *   Mengadopsi manipulasi aksi DOM *drag event* (`@dragover.prevent`, `@dragleave.prevent`, `@drop.prevent`) untuk menangani berkas jatuhan (*dropped files*). Area pinggir batas akan berubah secara visual jika pengguna mulai menarik (*drag*) berkas masuk.
    *   Menyokong format dokumen (PDF, Word) dan gambar (JPG, PNG) dengan batasan total ukuran maksimal 10MB per unggahan.
    *   Sistem validasi mandiri dan laporan sukses/gagal di *front-end* menggunakan elemen pesan beranimasi berdasarkan masukan *props* `flash` dan `errors`.

## 5. `PrintStation/index.vue`
**Lokasi:** `resources/js/Pages/PrintStation/index.vue`
*   **Fungsi:** Dashboard stasiun cetak yang akan dieksekusi secara lokal (ditampilkan di layar monitor/PC kios print).
*   **Fitur Utama:**
    *   Kunci utama untuk fungsi cetak lokal: Komponen ini membaca parameter struktur file PDF yang baru dimasukkan melalui library klien **`pdf-lib`**. Hal ini mencegah pembebanan server di mana halaman dideteksi (`getPageCount()`) secara internal *browser*.
    *   Koneksi konstan soket pribadi **Laravel Echo** (`printing-channel.{stationId}`). Layar stasiun lekas memperbarui antrean seketika saat mahasiswa berhasil mengunggah file baru lewat ponsel mereka/QR.
    *   Memanggil *Endpoint API* murni melingkupi dependensi Ajax (`axios`) secara internal guna mengeksekusi *hardware printer* sesungguhnya (*SumatraPDF* cli dijalankan via API OS) di dalam fungsi eksekutor `executePrint`.
    *   Pusat penanganan status modifikasi State global (Modal Buka/Tutup, dan Pilih banyak opsi baris File untuk ditindak bersamaan).

## 6. `PrintStation/FileTable.vue`
**Lokasi:** `resources/js/Pages/PrintStation/FileTable.vue`
*   **Fungsi:** Menampilkan daftar file yang tersedia di pergerakan stasiun tersebut.
*   **Fitur Utama:**
    *   Format cerdas tanggal yang merender waktu sepadan jeda (`diff`) dengan detil format API bawaan (contoh: "1 minutes ago" atau "1 days ago") menggunakan fungsi JavaScript cerdas inter-regional (`Intl.RelativeTimeFormat`).
    *   Tersedia seleksi massal (*Select All*) dan pemosisian kotak per file yang akan menyuntik ulang peubah ID target dan melontar `emit` pembaruan parameter ke *komponen parant*.
    *   Opsi tombol "Tampilkan QR" jika stasiun ingin memantul visualisasi ke klien lokal (khusus yang tak terlihat lagi karena tabel panjang).

## 7. `PrintStation/PrintConfig.vue`
**Lokasi:** `resources/js/Pages/PrintStation/PrintConfig.vue`
*   **Fungsi:** Komponen *Modal/Pop-up* untuk simulasi pengaturan preferensi alat cetak (halaman/kopi/warna).
*   **Fitur Utama:**
    *   Sajian IFrame dinamis menyandang *URI Fragment* (`#toolbar=0&navpanes=0`) agar antarmuka PDF Viewer sistem operasi/browser tersamarkan agar nampak selaras layaknya satu kesatuan apik sistem.
    *   Parser rentang halaman yang kompleks; Mengizinkan sistem memilah spesifikasi khusus (contoh: input konfigurasi `1-3, 5`), komponen ini secara sigap dan logis menjumlah parameter lembaran yang dipilah memadukan perulangan rentang dan kondisi ganda murni dalam ranah komputasi klien (*frontend calculation*).

## 8. `PrintStation/EmptyQR.vue`
**Lokasi:** `resources/js/Pages/PrintStation/EmptyQR.vue`
*   **Fungsi:** Layar pangkalan / diam untuk *Station monitor*.
*   **Fitur Utama:**
    *   Muncul begitu baris PDF kosong untuk langsung mengarahkan visual pengguna supaya mereka bisa memindai Kode batang QR statis.
    *   Mengimplementasikan transisi (*zoom-in animate*) ringan berserta opsi Toggle pemantik *view*.

## 9. `PrintStation/Modals/DeleteModal.vue`
**Lokasi:** `resources/js/Pages/PrintStation/Modals/DeleteModal.vue`
*   **Fungsi:** Jendela Konfirmasi generik.
*   **Fitur Utama:**
    *   Komponen reusabel seutuhnya: Semua kata pancingan (ikon, kalimat utama, sifat *bulk* atau tidaknya, penutup pesan, maupun aksi yang dikirim) disalurkan memanfaatkan parameter *props* komponen induknya. Berguna untuk dialog hapus satu berkas dan banyak berkas secara serempak. 