-- ========================================================
-- DATABASE SCHEMA: ES TEH SOLO (Sistem Pemesanan Minuman Online)
-- Target Database: PostgreSQL
-- ========================================================

-- Drop tables if exists in correct foreign key order
DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS order_details CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- 1. TABEL USERS
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    no_hp VARCHAR(20),
    role VARCHAR(20) NOT NULL DEFAULT 'user', -- 'admin' atau 'user'
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. TABEL CATEGORIES
CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,
    nama_kategori VARCHAR(100) NOT NULL,
    deskripsi TEXT
);

-- 3. TABEL PRODUCTS
CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    category_id BIGINT REFERENCES categories(id) ON DELETE SET NULL,
    nama_produk VARCHAR(150) NOT NULL,
    deskripsi TEXT,
    harga NUMERIC(12,2) NOT NULL,
    foto VARCHAR(255),
    stok INTEGER NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'Tersedia' -- 'Tersedia' atau 'Habis'
);

-- 4. TABEL ORDERS
CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    nomor_pesanan VARCHAR(50) UNIQUE NOT NULL,
    tanggal_pesanan TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_harga NUMERIC(12,2) NOT NULL,
    status_pesanan VARCHAR(30) NOT NULL DEFAULT 'Menunggu', -- 'Menunggu', 'Diproses', 'Siap Diambil', 'Selesai', 'Dibatalkan'
    metode_pengambilan VARCHAR(30) NOT NULL DEFAULT 'Takeaway', -- 'Takeaway' atau 'Dine-in'
    metode_pembayaran VARCHAR(50) NOT NULL DEFAULT 'Tunai di Kasir', -- 'QRIS', 'Transfer Bank', 'Tunai di Kasir'
    status_pembayaran VARCHAR(30) NOT NULL DEFAULT 'Belum Bayar', -- 'Belum Bayar', 'Lunas'
    catatan TEXT
);

-- 5. TABEL ORDER_DETAILS
CREATE TABLE order_details (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id BIGINT NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
    jumlah INTEGER NOT NULL CHECK (jumlah > 0),
    harga_satuan NUMERIC(12,2) NOT NULL,
    subtotal NUMERIC(12,2) NOT NULL,
    sugar_level VARCHAR(30) NOT NULL DEFAULT 'Normal',
    ice_level VARCHAR(30) NOT NULL DEFAULT 'Normal',
    catatan_item VARCHAR(255)
);

-- 6. TABEL REVIEWS (Fitur Tambahan: Ulasan dan Rating Produk)
CREATE TABLE reviews (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    komentar TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 7. TABEL CONTACTS (Pesan Masuk Layanan Pelanggan & Saran)
CREATE TABLE contacts (
    id BIGSERIAL PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    kontak VARCHAR(100) NOT NULL,
    pesan TEXT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Baru', -- 'Baru', 'Dibaca', 'Dibalas'
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- INDEXES FOR OPTIMAL QUERY PERFORMANCE
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status_pesanan);
CREATE INDEX idx_order_details_order ON order_details(order_id);
CREATE INDEX idx_reviews_product ON reviews(product_id);

-- ========================================================
-- DATA AWAL / SEED DATA
-- Catatan Password:
-- Hash SHA-256 untuk 'admin123': 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9
-- Hash SHA-256 untuk 'user123':  e606e38b0d8c19b24cf0ee3808183162ea7cd63ff7912dbb22b5e803286b4446
-- ========================================================

-- Insert Users
INSERT INTO users (nama, email, password, no_hp, role) VALUES
('Administrator Es Teh Solo', 'admin@estehsolo.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', '081234567890', 'admin'),
('Budi Santoso', 'budi@gmail.com', 'e606e38b0d8c19b24cf0ee3808183162ea7cd63ff7912dbb22b5e803286b4446', '081398765432', 'user'),
('Siti Rahmawati', 'siti@gmail.com', 'e606e38b0d8c19b24cf0ee3808183162ea7cd63ff7912dbb22b5e803286b4446', '085712345678', 'user');

-- Insert Categories
INSERT INTO categories (nama_kategori, deskripsi) VALUES
('Es Teh Original', 'Racikan daun teh asli Solo dengan cita rasa wasgitel (wangi, sepet, legi, lan kenthel).'),
('Es Teh Varian Rasa', 'Perpaduan cita rasa teh tradisional Solo dengan susu dan varian rasa kekinian.'),
('Es Teh Buah Segar', 'Kombinasi kesegaran teh Solo dengan sari dan irisan buah-buahan alami pilihan.'),
('Paket Hemat Solo', 'Paket spesial kombinasi minuman dingin segar dengan cemilan khas Solo.');

-- Insert Products
INSERT INTO products (category_id, nama_produk, deskripsi, harga, foto, stok, status) VALUES
(1, 'Es Teh Solo Jumbo', 'Es teh racikan khas Solo ukuran jumbo dengan cita rasa wasgitel yang menyegarkan dahaga di segala suasana.', 5000.00, 'esteh_original.jpg', 150, 'Tersedia'),
(1, 'Es Teh Kampul Khas Solo', 'Minuman legendaris Solo! Teh seduh kental berpadu irisan jeruk wedang segar, rasa manis sepet berpadu aroma citrus.', 8000.00, 'esteh_kampul.jpg', 80, 'Tersedia'),
(1, 'Es Teh Melati Istimewa', 'Dibuat dari daun teh pilihan beraroma melati asli yang harum semerbak, manis legit dan dingin menyejukkan.', 6000.00, 'esteh_melati.jpg', 100, 'Tersedia'),
(2, 'Es Teh Susu Cendana', 'Paduan teh kental Solo berpadu lembutnya susu segar pilihan. Creamy, gurih, dan manisnya pas di lidah.', 10000.00, 'esteh_susu.jpg', 60, 'Tersedia'),
(2, 'Es Teh Cincau Hitam Manis', 'Es teh manis segar berpadu potongan cincau hitam kenyal alami yang berkhasiat meredakan panas dalam.', 8000.00, 'esteh_cincau.jpg', 90, 'Tersedia'),
(3, 'Es Teh Lemon Segar', 'Kombinasi perasan lemon murni dan teh Solo dingin. Perpaduan asam manis segar yang membangkitkan semangat.', 9000.00, 'esteh_lemon.jpg', 75, 'Tersedia'),
(3, 'Es Teh Leci Tropis', 'Es teh wangi dengan buah leci asli dan sirup leci premium. Manis segar dengan aroma buah eksotis.', 12000.00, 'esteh_leci.jpg', 50, 'Tersedia'),
(4, 'Paket Mantap (Es Teh Jumbo + Pisang Aroma)', '1 Gelas Es Teh Solo Jumbo + 2 pcs Pisang Aroma cokelat keju renyah gurih manis.', 14000.00, 'paket_mantap.jpg', 40, 'Tersedia'),
(4, 'Paket Guyub (2 Es Teh Kampul + Mendoan Solo)', '2 Gelas Es Teh Kampul Segar + 3 pcs Tempe Mendoan hangat lengkap dengan sambal kecap pedas.', 24000.00, 'paket_guyub.jpg', 30, 'Tersedia');

-- Insert Initial Orders
INSERT INTO orders (user_id, nomor_pesanan, tanggal_pesanan, total_harga, status_pesanan, metode_pengambilan, catatan) VALUES
(2, 'ETS-20261016-0001', CURRENT_TIMESTAMP - INTERVAL '2 hour', 21000.00, 'Selesai', 'Takeaway', 'Es batunya banyakin ya'),
(2, 'ETS-20261016-0002', CURRENT_TIMESTAMP - INTERVAL '45 minute', 18000.00, 'Diproses', 'Dine-in', 'Meja nomor 4'),
(3, 'ETS-20261016-0003', CURRENT_TIMESTAMP - INTERVAL '10 minute', 14000.00, 'Menunggu', 'Takeaway', 'Jangan terlalu manis');

-- Insert Order Details
-- Order 1: Budi (Es Teh Solo Jumbo x 1 @ 5000 + Es Teh Kampul x 2 @ 8000 = 21000)
INSERT INTO order_details (order_id, product_id, jumlah, harga_satuan, subtotal) VALUES
(1, 1, 1, 5000.00, 5000.00),
(1, 2, 2, 8000.00, 16000.00);

-- Order 2: Budi (Es Teh Susu x 1 @ 10000 + Es Teh Cincau x 1 @ 8000 = 18000)
INSERT INTO order_details (order_id, product_id, jumlah, harga_satuan, subtotal) VALUES
(2, 4, 1, 10000.00, 10000.00),
(2, 5, 1, 8000.00, 8000.00);

-- Order 3: Siti (Paket Mantap x 1 @ 14000 = 14000)
INSERT INTO order_details (order_id, product_id, jumlah, harga_satuan, subtotal) VALUES
(3, 8, 1, 14000.00, 14000.00);

-- Insert Reviews
INSERT INTO reviews (product_id, user_id, rating, komentar) VALUES
(1, 2, 5, 'Rasa tehnya beneran khas Solo! Sepet, legit, dan wanginya dapet banget. Porsinya jumbo puas!'),
(2, 2, 5, 'Es Teh Kampul terenak di Solo! Jeruk wedangnya bikin seger banget apalagi diminum siang hari.'),
(4, 3, 4, 'Es teh susunya creamy, gak bikin eneg. Cocok buat nemenin nugas atau nongkrong.'),
(6, 3, 5, 'Lemonnya berasa asli bukan perisa buatan. Bener-bener nyegerin tenggorokan!');
