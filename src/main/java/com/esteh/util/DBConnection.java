package com.esteh.util;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {
    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());
    private static final Properties props = new Properties();
    private static boolean isInitialized = false;
    private static boolean usingFallback = false;

    static {
        loadProperties();
    }

    private static void loadProperties() {
        try (InputStream in = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in != null) {
                props.load(in);
            } else {
                LOGGER.warning("db.properties not found on classpath, using defaults.");
                props.setProperty("db.driver", "org.postgresql.Driver");
                props.setProperty("db.url", "jdbc:postgresql://localhost:5432/esteh_db");
                props.setProperty("db.user", "postgres");
                props.setProperty("db.password", "postgres");
                props.setProperty("db.enableFallback", "true");
                props.setProperty("db.fallback.driver", "org.h2.Driver");
                props.setProperty("db.fallback.url", "jdbc:h2:./esteh_database;MODE=PostgreSQL;DATABASE_TO_LOWER=TRUE;DEFAULT_NULL_ORDERING=HIGH");
                props.setProperty("db.fallback.user", "sa");
                props.setProperty("db.fallback.password", "");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to load db.properties", e);
        }

        // Override with Environment Variables if present (for cloud hosting: Railway, Render, Docker, VPS)
        String envDbUrl = System.getenv("DB_URL");
        if (envDbUrl == null || envDbUrl.trim().isEmpty()) {
            envDbUrl = System.getenv("DATABASE_URL");
        }
        if (envDbUrl != null && !envDbUrl.trim().isEmpty()) {
            if (!envDbUrl.startsWith("jdbc:")) {
                envDbUrl = "jdbc:" + envDbUrl;
            }
            props.setProperty("db.url", envDbUrl);
        }

        String envDbUser = System.getenv("DB_USER");
        if (envDbUser != null && !envDbUser.trim().isEmpty()) {
            props.setProperty("db.user", envDbUser);
        }

        String envDbPass = System.getenv("DB_PASSWORD");
        if (envDbPass != null) {
            props.setProperty("db.password", envDbPass);
        }
    }

    public static synchronized Connection getConnection() throws SQLException {
        if (!usingFallback) {
            try {
                Class.forName(props.getProperty("db.driver", "org.postgresql.Driver"));
                Connection conn = DriverManager.getConnection(
                    props.getProperty("db.url"),
                    props.getProperty("db.user"),
                    props.getProperty("db.password")
                );
                if (!isInitialized) {
                    checkAndInitializeSchema(conn, false);
                    isInitialized = true;
                    LOGGER.info("Connected to PostgreSQL successfully.");
                }
                return conn;
            } catch (Exception ex) {
                boolean enableFallback = Boolean.parseBoolean(props.getProperty("db.enableFallback", "true"));
                if (enableFallback) {
                    LOGGER.warning("PostgreSQL connection failed (" + ex.getMessage() + "). Switching to embedded PostgreSQL-compatible mode.");
                    usingFallback = true;
                } else {
                    throw new SQLException("PostgreSQL connection failed and fallback is disabled.", ex);
                }
            }
        }

        // Fallback embedded mode
        try {
            Class.forName(props.getProperty("db.fallback.driver", "org.h2.Driver"));
            Connection conn = DriverManager.getConnection(
                props.getProperty("db.fallback.url"),
                props.getProperty("db.fallback.user", "sa"),
                props.getProperty("db.fallback.password", "")
            );
            if (!isInitialized) {
                checkAndInitializeSchema(conn, true);
                isInitialized = true;
                LOGGER.info("Connected to embedded database engine.");
            }
            return conn;
        } catch (Exception e) {
            throw new SQLException("Failed to connect to database: " + e.getMessage(), e);
        }
    }

    public static boolean isUsingFallback() {
        return usingFallback;
    }

    private static void checkAndInitializeSchema(Connection conn, boolean isFallback) {
        try (Statement stmt = conn.createStatement()) {
            boolean tablesExist = false;
            try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM users")) {
                if (rs.next()) {
                    tablesExist = true;
                }
            } catch (SQLException ignore) {
                // Table doesn't exist yet
                tablesExist = false;
            }

            if (!tablesExist) {
                LOGGER.info("Initializing database schema and seed data...");
                runInitScript(conn, isFallback);
            } else {
                runMigrations(conn);
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Schema check error (will attempt init script): " + e.getMessage());
            runInitScript(conn, isFallback);
        }
    }

    private static void runMigrations(Connection conn) {
        String[] migrations = {
            "CREATE TABLE IF NOT EXISTS contacts (" +
            "    id BIGSERIAL PRIMARY KEY," +
            "    nama VARCHAR(100) NOT NULL," +
            "    kontak VARCHAR(100) NOT NULL," +
            "    pesan TEXT NOT NULL," +
            "    status VARCHAR(20) NOT NULL DEFAULT 'Baru'," +
            "    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP" +
            ")",
            "ALTER TABLE orders ADD COLUMN IF NOT EXISTS metode_pembayaran VARCHAR(50) DEFAULT 'Tunai di Kasir'",
            "ALTER TABLE orders ADD COLUMN IF NOT EXISTS status_pembayaran VARCHAR(30) DEFAULT 'Belum Bayar'",
            "ALTER TABLE order_details ADD COLUMN IF NOT EXISTS sugar_level VARCHAR(30) DEFAULT 'Normal'",
            "ALTER TABLE order_details ADD COLUMN IF NOT EXISTS ice_level VARCHAR(30) DEFAULT 'Normal'",
            "ALTER TABLE order_details ADD COLUMN IF NOT EXISTS catatan_item VARCHAR(255)",
            "UPDATE users SET password = 'e606e38b0d8c19b24cf0ee3808183162ea7cd63ff7912dbb22b5e803286b4446' WHERE email = 'budi@gmail.com' AND password = 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f'"
        };
        try (Statement stmt = conn.createStatement()) {
            for (String sql : migrations) {
                try {
                    stmt.execute(sql);
                } catch (SQLException e) {
                    LOGGER.fine("Migration notice: " + e.getMessage());
                }
            }
            LOGGER.info("Database migrations applied successfully.");
        } catch (SQLException e) {
            LOGGER.warning("Migration error: " + e.getMessage());
        }
    }

    private static void runInitScript(Connection conn, boolean isFallback) {
        // Read database/esteh_solo.sql or fallback script
        String ddlScript =
            "CREATE TABLE IF NOT EXISTS users (" +
            "    id BIGSERIAL PRIMARY KEY," +
            "    nama VARCHAR(100) NOT NULL," +
            "    email VARCHAR(100) UNIQUE NOT NULL," +
            "    password VARCHAR(255) NOT NULL," +
            "    no_hp VARCHAR(20)," +
            "    role VARCHAR(20) NOT NULL DEFAULT 'user'," +
            "    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP" +
            ");" +
            "CREATE TABLE IF NOT EXISTS categories (" +
            "    id BIGSERIAL PRIMARY KEY," +
            "    nama_kategori VARCHAR(100) NOT NULL," +
            "    deskripsi TEXT" +
            ");" +
            "CREATE TABLE IF NOT EXISTS products (" +
            "    id BIGSERIAL PRIMARY KEY," +
            "    category_id BIGINT REFERENCES categories(id) ON DELETE SET NULL," +
            "    nama_produk VARCHAR(150) NOT NULL," +
            "    deskripsi TEXT," +
            "    harga NUMERIC(12,2) NOT NULL," +
            "    foto VARCHAR(255)," +
            "    stok INTEGER NOT NULL DEFAULT 0," +
            "    status VARCHAR(20) NOT NULL DEFAULT 'Tersedia'" +
            ");" +
            "CREATE TABLE IF NOT EXISTS orders (" +
            "    id BIGSERIAL PRIMARY KEY," +
            "    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE," +
            "    nomor_pesanan VARCHAR(50) UNIQUE NOT NULL," +
            "    tanggal_pesanan TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP," +
            "    total_harga NUMERIC(12,2) NOT NULL," +
            "    status_pesanan VARCHAR(30) NOT NULL DEFAULT 'Menunggu'," +
            "    metode_pengambilan VARCHAR(30) NOT NULL DEFAULT 'Takeaway'," +
            "    catatan TEXT" +
            ");" +
            "CREATE TABLE IF NOT EXISTS order_details (" +
            "    id BIGSERIAL PRIMARY KEY," +
            "    order_id BIGINT NOT NULL REFERENCES orders(id) ON DELETE CASCADE," +
            "    product_id BIGINT NOT NULL REFERENCES products(id) ON DELETE RESTRICT," +
            "    jumlah INTEGER NOT NULL CHECK (jumlah > 0)," +
            "    harga_satuan NUMERIC(12,2) NOT NULL," +
            "    subtotal NUMERIC(12,2) NOT NULL" +
            ");" +
            "CREATE TABLE IF NOT EXISTS reviews (" +
            "    id BIGSERIAL PRIMARY KEY," +
            "    product_id BIGINT NOT NULL REFERENCES products(id) ON DELETE CASCADE," +
            "    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE," +
            "    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5)," +
            "    komentar TEXT," +
            "    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP" +
            ");" +
            "CREATE TABLE IF NOT EXISTS contacts (" +
            "    id BIGSERIAL PRIMARY KEY," +
            "    nama VARCHAR(100) NOT NULL," +
            "    kontak VARCHAR(100) NOT NULL," +
            "    pesan TEXT NOT NULL," +
            "    status VARCHAR(20) NOT NULL DEFAULT 'Baru'," +
            "    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP" +
            ");" +
            "ALTER TABLE orders ADD COLUMN IF NOT EXISTS metode_pembayaran VARCHAR(50) DEFAULT 'Tunai di Kasir';" +
            "ALTER TABLE orders ADD COLUMN IF NOT EXISTS status_pembayaran VARCHAR(30) DEFAULT 'Belum Bayar';" +
            "ALTER TABLE order_details ADD COLUMN IF NOT EXISTS sugar_level VARCHAR(30) DEFAULT 'Normal';" +
            "ALTER TABLE order_details ADD COLUMN IF NOT EXISTS ice_level VARCHAR(30) DEFAULT 'Normal';" +
            "ALTER TABLE order_details ADD COLUMN IF NOT EXISTS catatan_item VARCHAR(255);";

        try (Statement stmt = conn.createStatement()) {
            String[] statements = ddlScript.split(";");
            for (String sql : statements) {
                if (!sql.trim().isEmpty()) {
                    try {
                        stmt.execute(sql.trim());
                    } catch (SQLException e) {
                        LOGGER.warning("DDL execution notice: " + e.getMessage());
                    }
                }
            }

            // Seed Users if empty
            try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM users")) {
                if (rs.next() && rs.getInt(1) == 0) {
                    stmt.execute("INSERT INTO users (nama, email, password, no_hp, role) VALUES " +
                        "('Administrator Es Teh Solo', 'admin@estehsolo.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', '081234567890', 'admin')," +
                        "('Budi Santoso', 'budi@gmail.com', 'e606e38b0d8c19b24cf0ee3808183162ea7cd63ff7912dbb22b5e803286b4446', '081398765432', 'user')," +
                        "('Siti Rahmawati', 'siti@gmail.com', 'e606e38b0d8c19b24cf0ee3808183162ea7cd63ff7912dbb22b5e803286b4446', '085712345678', 'user');");
                } else {
                    // Ensure seeded demo user has matching user123 password
                    stmt.execute("UPDATE users SET password = 'e606e38b0d8c19b24cf0ee3808183162ea7cd63ff7912dbb22b5e803286b4446' WHERE email = 'budi@gmail.com' AND password = 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f'");
                }
            }

            // Seed Categories if empty
            try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM categories")) {
                if (rs.next() && rs.getInt(1) == 0) {
                    stmt.execute("INSERT INTO categories (nama_kategori, deskripsi) VALUES " +
                        "('Es Teh Original', 'Racikan daun teh asli Solo dengan cita rasa wasgitel khas tradisional.')," +
                        "('Es Teh Varian Rasa', 'Perpaduan cita rasa teh tradisional Solo dengan susu dan varian rasa kekinian.')," +
                        "('Es Teh Buah Segar', 'Kombinasi kesegaran teh Solo dengan sari dan irisan buah-buahan alami pilihan.')," +
                        "('Paket Hemat Solo', 'Paket spesial kombinasi minuman dingin segar dengan cemilan khas Solo.');");
                }
            }

            // Seed Products if empty
            try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM products")) {
                if (rs.next() && rs.getInt(1) == 0) {
                    stmt.execute("INSERT INTO products (category_id, nama_produk, deskripsi, harga, foto, stok, status) VALUES " +
                        "(1, 'Es Teh Solo Jumbo', 'Es teh racikan khas Solo ukuran jumbo dengan cita rasa wasgitel yang menyegarkan dahaga di segala suasana.', 5000.00, 'esteh_original.jpg', 150, 'Tersedia')," +
                        "(1, 'Es Teh Kampul Khas Solo', 'Minuman legendaris Solo! Teh seduh kental berpadu irisan jeruk wedang segar, rasa manis sepet berpadu aroma citrus.', 8000.00, 'esteh_kampul.jpg', 80, 'Tersedia')," +
                        "(1, 'Es Teh Melati Istimewa', 'Dibuat dari daun teh pilihan beraroma melati asli yang harum semerbak, manis legit dan dingin menyejukkan.', 6000.00, 'esteh_melati.jpg', 100, 'Tersedia')," +
                        "(2, 'Es Teh Susu Cendana', 'Paduan teh kental Solo berpadu lembutnya susu segar pilihan. Creamy, gurih, dan manisnya pas di lidah.', 10000.00, 'esteh_susu.jpg', 60, 'Tersedia')," +
                        "(2, 'Es Teh Cincau Hitam Manis', 'Es teh manis segar berpadu potongan cincau hitam kenyal alami yang berkhasiat meredakan panas dalam.', 8000.00, 'esteh_cincau.jpg', 90, 'Tersedia')," +
                        "(3, 'Es Teh Lemon Segar', 'Kombinasi perasan lemon murni dan teh Solo dingin. Perpaduan asam manis segar yang membangkitkan semangat.', 9000.00, 'esteh_lemon.jpg', 75, 'Tersedia')," +
                        "(3, 'Es Teh Leci Tropis', 'Es teh wangi dengan buah leci asli dan sirup leci premium. Manis segar dengan aroma buah eksotis.', 12000.00, 'esteh_leci.jpg', 50, 'Tersedia')," +
                        "(4, 'Paket Mantap (Es Teh Jumbo + Pisang Aroma)', '1 Gelas Es Teh Solo Jumbo + 2 pcs Pisang Aroma cokelat keju renyah gurih manis.', 14000.00, 'paket_mantap.jpg', 40, 'Tersedia')," +
                        "(4, 'Paket Guyub (2 Es Teh Kampul + Mendoan Solo)', '2 Gelas Es Teh Kampul Segar + 3 pcs Tempe Mendoan hangat lengkap dengan sambal kecap pedas.', 24000.00, 'paket_guyub.jpg', 30, 'Tersedia');");
                }
            }

            // Seed Orders if empty
            try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM orders")) {
                if (rs.next() && rs.getInt(1) == 0) {
                    stmt.execute("INSERT INTO orders (user_id, nomor_pesanan, total_harga, status_pesanan, metode_pengambilan, catatan) VALUES " +
                        "(2, 'ETS-20261016-0001', 21000.00, 'Selesai', 'Takeaway', 'Es batunya banyakin ya')," +
                        "(2, 'ETS-20261016-0002', 18000.00, 'Diproses', 'Dine-in', 'Meja nomor 4')," +
                        "(3, 'ETS-20261016-0003', 14000.00, 'Menunggu', 'Takeaway', 'Jangan terlalu manis');");

                    stmt.execute("INSERT INTO order_details (order_id, product_id, jumlah, harga_satuan, subtotal) VALUES " +
                        "(1, 1, 1, 5000.00, 5000.00)," +
                        "(1, 2, 2, 8000.00, 16000.00)," +
                        "(2, 4, 1, 10000.00, 10000.00)," +
                        "(2, 5, 1, 8000.00, 8000.00)," +
                        "(3, 8, 1, 14000.00, 14000.00);");
                }
            }

            // Seed Reviews if empty
            try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM reviews")) {
                if (rs.next() && rs.getInt(1) == 0) {
                    stmt.execute("INSERT INTO reviews (product_id, user_id, rating, komentar) VALUES " +
                        "(1, 2, 5, 'Rasa tehnya beneran khas Solo! Sepet, legit, dan wanginya dapet banget. Porsinya jumbo puas!')," +
                        "(2, 2, 5, 'Es Teh Kampul terenak di Solo! Jeruk wedangnya bikin seger banget apalagi diminum siang hari.')," +
                        "(4, 3, 4, 'Es teh susunya creamy, gak bikin eneg. Cocok buat nemenin nugas atau nongkrong.')," +
                        "(6, 3, 5, 'Lemonnya berasa asli bukan perisa buatan. Bener-bener nyegerin tenggorokan!');");
                }
            }

            LOGGER.info("Database schema initialized and seeded successfully.");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed executing initialization script: " + e.getMessage(), e);
        }
    }
}
