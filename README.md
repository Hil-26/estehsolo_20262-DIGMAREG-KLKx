# 🍃 Es Teh Solo - Sistem Pemesanan Minuman Online

Aplikasi website pemesanan minuman online **Es Teh Solo** berbasis web yang dirancang dengan tema visual **Fresh Green** (kombinasi nuansa tradisional Solo dan modern). Sistem ini mengintegrasikan seluruh proses transaksi pelanggan mulai dari penelusuran menu, keranjang belanja, checkout pemesanan, hingga pemantauan status pesanan secara *real-time*, serta panel administrasi lengkap untuk manajemen produk, kategori, pesanan, dan laporan penjualan.

---

## 🌟 Fitur Utama

### 1. Role Pelanggan (User)
- **Registrasi & Login**: Keamanan password dengan enkripsi hash SHA-256.
- **Daftar Menu & Katalog**:
  - Filter interaktif berdasarkan kategori (*Es Teh Original*, *Varian Rasa*, *Buah Segar*, *Paket Hemat*).
  - Fitur pencarian *real-time*.
  - Indikator ketersediaan produk dan sisa stok.
- **Keranjang Belanja (Shopping Cart)**:
  - Penambahan produk instan berbasis AJAX tanpa reload halaman.
  - Pengaturan kuantitas pembelian secara dinamis.
  - Perhitungan subtotal dan total otomatis.
- **Konfirmasi Pemesanan & Checkout**:
  - Pemilihan metode pengambilan: **Takeaway** (Ambil di tempat) atau **Dine-in** (Minum di tempat).
  - Kolom catatan pesanan khusus (*less sugar*, es dipisah, dll.).
  - Validasi harga backend Java untuk integritas data transaksi.
- **Riwayat & Status Pesanan**:
  - Pelacakan status: `Menunggu` ➔ `Diproses` ➔ `Siap Diambil` ➔ `Selesai` / `Dibatalkan`.
  - Pembatalan pesanan mandiri selama status masih `Menunggu`.
  - Bukti invoice transaksi yang dapat dicetak.
- **Ulasan & Rating Produk** *(Fitur Tambahan)*:
  - Pemberian rating bintang 1–5 dan ulasan pengalaman rasa.
- **Pengaturan Profil**:
  - Ubah nama dan nomor WhatsApp.
  - Ganti kata sandi.

### 2. Role Administrator (Admin)
- **Dashboard Ringkasan**:
  - Kartu KPI: Total Pendapatan, Total Pesanan Masuk, Total Varian Produk, dan Total Pelanggan.
  - Ringkasan pesanan berdasarkan status.
  - Tabel transaksi terbaru dengan *quick action* pembaruan status.
- **CRUD Produk Minuman**:
  - Tambah, lihat, ubah informasi (nama, kategori, harga, stok, foto, deskripsi, status), dan hapus produk dengan perlindungan integritas relasi pesanan.
- **CRUD Kategori**:
  - Kelola kategori minuman beserta penghitungan jumlah produk aktif.
- **Manajemen Pesanan**:
  - Tinjau seluruh pesanan masuk dengan filter status.
  - Ubah status pesanan secara langsung.
- **Manajemen Pengguna**:
  - Monitoring daftar akun pelanggan terdaftar.
- **Laporan Penjualan** *(Fitur Tambahan)*:
  - Filter rentang tanggal (custom date range).
  - Analisis produk terlaris (*Top Best Sellers*).
  - Ekspor / cetak laporan siap cetak (*print-friendly*).
- **Moderasi Ulasan**:
  - Pantau umpan balik dan rating bintang dari pelanggan.

---

## 🛠️ Arsitektur & Teknologi

| Komponen | Teknologi | Keterangan |
| :--- | :--- | :--- |
| **Backend** | Java 21 / Jakarta Servlet 6.0 | MVC Pattern (Model-View-Controller) |
| **Database** | PostgreSQL 16+ & JDBC | Mendukung auto-fallback embedded mode |
| **Web Server** | Apache Tomcat 10.1 (Embedded & Standalone) | Siap jalan langsung via Maven |
| **Frontend** | HTML5, CSS3 kustom, Vanilla JavaScript | Responsive Fresh Green theme |
| **Keamanan** | SHA-256 Password Hashing & AuthFilter | Role-based Access Control (Admin & User) |

---

## 🚀 Cara Menjalankan Aplikasi

### 1. Prasyarat
- Java JDK 21 (sudah terpasang di sistem: `C:\Program Files\Eclipse Adoptium\jdk-21.0.12.101-hotspot`)
- Apache Maven (sudah terpasang di sistem: `C:\Users\HYPE 7 AMD X8-1\maven`)

### 2. Menjalankan Server (1 Perintah)
Buka terminal PowerShell pada direktori `d:\esteh` lalu jalankan:

```powershell
mvn compile exec:java
```

Setelah server aktif, buka browser dan akses:
👉 **[http://localhost:8080/](http://localhost:8080/)**

### 3. Akun Pengujian (Demo Credentials)
Tersedia tombol auto-fill pada halaman login:
- **Admin**:
  - Email: `admin@estehsolo.com`
  - Password: `admin123`
- **User (Pelanggan)**:
  - Email: `budi@gmail.com`
  - Password: `user123`
- Atau daftar akun baru melalui menu **Daftar**.

---

## 🗄️ Konfigurasi Basis Data PostgreSQL

1. Skrip database lengkap tersedia di: [`database/esteh_solo.sql`](file:///d:/esteh/database/esteh_solo.sql)
2. Buat database baru di PostgreSQL / pgAdmin:
   ```sql
   CREATE DATABASE esteh_db;
   ```
3. Import atau jalankan skrip `database/esteh_solo.sql`.
4. Sesuaikan konfigurasi username dan password database pada file:
   [`src/main/resources/db.properties`](file:///d:/esteh/src/main/resources/db.properties)

> **Catatan Kemudahan Demo:**
> Jika PostgreSQL lokal belum diaktifkan, aplikasi memiliki fitur cerdas **Auto-Fallback Engine** ke database embedded internal yang otomatis membuat tabel dan mengisi *seed data* awal. Hal ini memastikan aplikasi dapat langsung diuji dan didemokan tanpa kendala koneksi database!

---

## 📁 Struktur Direktori Project

```text
d:\esteh\
├── database/
│   └── esteh_solo.sql                 # Skrip skema database & data awal PostgreSQL
├── src/
│   ├── main/
│   │   ├── java/com/esteh/
│   │   │   ├── controller/            # Jakarta Servlet Controllers (Home, Menu, Cart, Order, Auth, Admin...)
│   │   │   ├── dao/                   # Data Access Objects (UserDAO, ProductDAO, OrderDAO, CategoryDAO...)
│   │   │   ├── model/                 # Entity POJO Models (User, Product, Order, Category, Cart...)
│   │   │   ├── server/                # Embedded Tomcat Launcher (App.java)
│   │   │   └── util/                  # Utilities (DBConnection, PasswordUtil, AuthFilter)
│   │   ├── resources/
│   │   │   └── db.properties          # Konfigurasi koneksi database PostgreSQL
│   │   └── webapp/
│   │       ├── assets/
│   │       │   ├── css/style.css      # Desain tema Fresh Green responsif
│   │       │   ├── js/main.js         # Interaksi keranjang AJAX & rating modal
│   │       │   └── images/            # Foto minuman resolusi tinggi
│   │       ├── WEB-INF/
│   │       │   ├── web.xml            # Descriptor Servlet Jakarta EE
│   │       │   └── views/
│   │       │       ├── admin/         # JSP Panel Admin (dashboard, produk, pesanan, laporan...)
│   │       │       ├── user/          # JSP Pelanggan (beranda, menu, keranjang, riwayat...)
│   │       │       └── common/        # Komponen bersama (navbar, footer)
│   │       └── index.jsp
├── pom.xml                            # Konfigurasi Maven dependencies & plugins
└── README.md                          # Dokumentasi resmi project
```
