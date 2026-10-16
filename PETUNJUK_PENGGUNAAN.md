# 🍃 PANDUAN PENGGUNAAN & PENGUJIAN APLIKASI ES TEH SOLO

Dokumen ini merupakan panduan lengkap untuk menjalankan, menguji alur kerja pengguna (User), dan menguji alur kerja administrator (Admin) pada aplikasi **Es Teh Solo (Sistem Pemesanan Minuman Online)**.

---

## 📌 1. Cara Menjalankan Aplikasi

Aplikasi telah dilengkapi server embedded Tomcat 10 sehingga dapat dijalankan langsung dengan satu perintah di PowerShell:

```powershell
mvn compile exec:java
```

Setelah muncul tulisan:
```
=========================================================
  ES TEH SOLO - Sistem Pemesanan Minuman Online
  Server berjalan di: http://localhost:8080
=========================================================
```
Buka browser favorit Anda (Google Chrome, Mozilla Firefox, atau Edge) lalu kunjungi alamat:
👉 **[http://localhost:8080/](http://localhost:8080/)**

---

## 👤 2. Pengujian Alur Role Pelanggan (User)

### A. Melihat Menu & Menambah ke Keranjang
1. Pada halaman beranda, klik tombol **"Pesan Sekarang"** atau pilih menu **"Daftar Menu"** di navigasi atas.
2. Anda akan melihat seluruh produk minuman dalam bentuk kartu (*card*) dengan foto, harga, dan ketersediaan stok.
3. Coba fitur pencarian dengan mengetik kata kunci seperti `kampul` atau `susu` di kotak pencarian.
4. Klik tab kategori (misal: *Es Teh Original*, *Es Teh Varian Rasa*, *Es Teh Buah Segar*, atau *Paket Hemat*) untuk memfilter minuman.
5. Klik tombol **"+ Keranjang"** pada minuman yang diinginkan. Anda akan melihat notifikasi *toast* hijau dan angka pada ikon keranjang 🛒 di pojok kanan atas bertambah secara instan tanpa reload halaman (*AJAX*).

### B. Memeriksa Keranjang & Melakukan Pemesanan (Checkout)
1. Klik ikon keranjang 🛒 di bagian kanan atas navbar.
2. Di halaman keranjang belanja, Anda dapat:
   - Menambah jumlah porsi dengan tombol `+`
   - Mengurangi porsi dengan tombol `-`
   - Menghapus item dengan tombol tempat sampah 🗑️
   - Melihat subtotal dan total harga secara otomatis.
3. Klik tombol **"Lanjutkan Pemesanan →"**.
4. Jika belum login, sistem akan meminta Anda untuk login terlebih dahulu.

### C. Login & Registrasi User
- Klik tombol **"👤 User (Budi)"** pada kotak demo di halaman login untuk mengisi otomatis akun:
  - **Email**: `budi@gmail.com`
  - **Password**: `user123`
- Atau buat akun baru di menu **"Daftar sekarang"** dengan mengisi Nama, Email, Nomor WhatsApp, dan Password.
- Klik **"Masuk Sekarang"**.

### D. Konfirmasi Pemesanan
1. Setelah login dan masuk ke halaman checkout:
   - Pilih metode pengambilan: **Takeaway** (Ambil di outlet) atau **Dine-in** (Minum di tempat).
   - Tulis catatan khusus (misal: *"Es sedikit saja, manis sedang"*).
2. Periksa kembali total harga yang telah divalidasi oleh backend Java.
3. Klik tombol **"Konfirmasi & Buat Pesanan 🍃"**.
4. Pesanan baru akan disimpan ke database dengan status **`Menunggu`** dan nomor unik otomatis (contoh: `ETS-20261016-8921`).

### E. Riwayat Pesanan & Pembatalan
1. Anda akan diarahkan ke halaman **"Riwayat Pesanan"**.
2. Anda dapat melihat detail pesanan, status pembuatan, dan total harga.
3. Selama status pesanan masih **`Menunggu`**, tombol **"Batalkan Pesanan"** aktif. Coba klik tombol tersebut untuk menguji fitur pembatalan pesanan dan pengembalian stok ke sistem.
4. Klik tombol **"Rincian Lengkap"** untuk melihat bukti invoice struk pembayaran yang rapi dan dapat dicetak.

### F. Memberikan Rating & Ulasan (Fitur Tambahan)
1. Pada pesanan yang berstatus **`Selesai`** (atau melalui halaman menu), klik tautan **"+ Beri Nilai"** atau **"⭐ Beri Nilai"**.
2. Pilih rating bintang (1 sampai 5) dan tulis komentar pengalaman rasa.
3. Klik **"Kirim Ulasan"**. Ulasan akan langsung muncul pada kartu minuman dan masuk ke panel admin.

### G. Profil User
1. Klik nama Anda pada navbar atas.
2. Anda dapat memperbarui Nama Lengkap dan Nomor WhatsApp.
3. Anda juga dapat mengganti kata sandi lama dengan kata sandi baru.

---

## 👑 3. Pengujian Alur Role Administrator (Admin)

### A. Login Sebagai Admin
1. Jika sedang login sebagai user, klik **"Logout"**.
2. Masuk ke halaman login (`/login`), lalu klik tombol demo **"👑 Admin"**:
   - **Email**: `admin@estehsolo.com`
   - **Password**: `admin123`
3. Klik **"Masuk Sekarang"**. Anda akan langsung diarahkan ke **Panel Admin** (`/admin/dashboard`).

### B. Dashboard Admin
- Perhatikan 4 kartu metrik utama:
  - **Total Penjualan Selesai** (akumulasi omzet pesanan berstatus Selesai).
  - **Total Pesanan Masuk**.
  - **Varian Minuman Aktif**.
  - **Pelanggan Terdaftar**.
- Terdapat ringkasan jumlah pesanan berdasarkan status (`Menunggu`, `Diproses`, `Siap Diambil`, `Selesai`, `Dibatalkan`).
- Tabel transaksi terbaru memungkinkan admin mengubah status pesanan secara instan melalui dropdown cepat.

### C. Kelola Produk (CRUD Produk)
1. Klik menu **"Kelola Produk"** di sidebar.
2. **Tambah Produk Baru**:
   - Klik tombol **"+ Tambah Produk Baru"**.
   - Masukkan Nama Minuman, pilih Kategori, isi Harga (Rp), Stok Porsi, pilih Foto, dan tulis Deskripsi.
   - Klik **"Simpan Produk Baru"**.
3. **Ubah Informasi Produk**:
   - Klik tombol **"✏️ Edit"** pada salah satu baris produk untuk mengubah harga, stok, atau status.
4. **Hapus Produk**:
   - Klik tombol tempat sampah 🗑️. Jika produk sudah pernah dipesan pada transaksi sebelumnya, sistem secara aman mengubah status produk menjadi *Habis* untuk menjaga keutuhan riwayat transaksi pelanggan.

### D. Kelola Kategori (CRUD Kategori)
1. Klik menu **"Kelola Kategori"** di sidebar.
2. Anda dapat menambahkan kategori baru pada formulir sebelah kiri.
3. Anda dapat mengedit nama dan deskripsi kategori dengan tombol pensil ✏️.
4. Anda dapat menghapus kategori yang sudah tidak digunakan dengan tombol tempat sampah 🗑️.

### E. Kelola Pesanan (Order Management)
1. Klik menu **"Kelola Pesanan"** di sidebar.
2. Gunakan tombol filter status di bagian atas (`Semua`, `Menunggu`, `Diproses`, `Siap Diambil`, `Selesai`, `Dibatalkan`).
3. Pada baris pesanan pelanggan yang masuk:
   - Ubah status dari **`Menunggu`** menjadi **`Diproses`** (sedang disiapkan).
   - Setelah minuman siap di racik, ubah status menjadi **`Siap Diambil`**.
   - Setelah pesanan diserahkan ke pelanggan, ubah status menjadi **`Selesai`**.
4. Perubahan status ini akan langsung tercatat di database dan dapat dipantau oleh pelanggan secara *real-time*.

### F. Kelola User
1. Klik menu **"Kelola User"** di sidebar.
2. Tampilkan daftar seluruh akun pelanggan yang terdaftar lengkap dengan email, nomor telepon, peran (role), dan tanggal bergabung.

### G. Laporan Penjualan (Fitur Tambahan)
1. Klik menu **"Laporan Penjualan"** di sidebar.
2. Anda dapat memfilter laporan berdasarkan rentang tanggal:
   - Pilih **Dari Tanggal** dan **Sampai Tanggal**, lalu klik **Filter Laporan**.
3. Sistem menghitung:
   - Total pendapatan bersih dari pesanan yang sukses (Selesai).
   - Total transaksi selesai.
   - **Tabel Peringkat Produk Terlaris (*Top Best Sellers*)** berdasarkan jumlah gelas terjual dan omzet per varian minuman.
   - Rincian daftar transaksi selesai dalam periode tersebut.
4. Klik tombol **"🖨️ Cetak / Ekspor Laporan"** untuk mencetak laporan resmi atau menyimpannya sebagai file PDF.

### H. Ulasan & Rating (Fitur Tambahan)
1. Klik menu **"Ulasan & Rating"** di sidebar.
2. Admin dapat melihat seluruh testimoni, ulasan rasa, dan rating bintang yang diberikan pelanggan pada setiap minuman.

---

## 🗄️ 4. Penggunaan Basis Data PostgreSQL

File skema dan *seed data* database berada di:
[`database/esteh_solo.sql`](file:///d:/esteh/database/esteh_solo.sql)

Langkah jika ingin menghubungkan ke database server PostgreSQL lokal:
1. Pastikan service PostgreSQL Anda berjalan di port `5432`.
2. Buka `pgAdmin` atau terminal `psql` dan buat database:
   ```sql
   CREATE DATABASE esteh_db;
   ```
3. Eksekusi file `database/esteh_solo.sql` ke dalam database `esteh_db`.
4. Buka file konfigurasi di project:
   [`src/main/resources/db.properties`](file:///d:/esteh/src/main/resources/db.properties)
5. Pastikan username dan password sesuai dengan pengaturan PostgreSQL Anda:
   ```properties
   db.driver=org.postgresql.Driver
   db.url=jdbc:postgresql://localhost:5432/esteh_db
   db.user=postgres
   db.password=password_anda
   ```

Selamat mencoba aplikasi **Es Teh Solo**! Segala proses pemesanan dan pengelolaan pesanan kini menjadi lebih terstruktur, modern, dan menyenangkan.
