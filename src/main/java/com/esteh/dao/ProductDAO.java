package com.esteh.dao;

import com.esteh.model.Product;
import com.esteh.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    public List<Product> getAllProducts() {
        return searchProducts(null, null, null);
    }

    public List<Product> getFeaturedProducts(int limit) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, c.nama_kategori, " +
                     "COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.id) as review_count " +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.id " +
                     "LEFT JOIN reviews r ON p.id = r.product_id " +
                     "WHERE p.status = 'Tersedia' " +
                     "GROUP BY p.id, c.nama_kategori " +
                     "ORDER BY p.id ASC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> searchProducts(Long categoryId, String query, String status) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT p.*, c.nama_kategori, " +
            "COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.id) as review_count " +
            "FROM products p " +
            "LEFT JOIN categories c ON p.category_id = c.id " +
            "LEFT JOIN reviews r ON p.id = r.product_id " +
            "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (categoryId != null && categoryId > 0) {
            sql.append("AND p.category_id = ? ");
            params.add(categoryId);
        }

        if (query != null && !query.trim().isEmpty()) {
            sql.append("AND (LOWER(p.nama_produk) LIKE ? OR LOWER(p.deskripsi) LIKE ?) ");
            String wild = "%" + query.trim().toLowerCase() + "%";
            params.add(wild);
            params.add(wild);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND p.status = ? ");
            params.add(status);
        }

        sql.append("GROUP BY p.id, c.nama_kategori ORDER BY p.id ASC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Product getProductById(Long id) {
        String sql = "SELECT p.*, c.nama_kategori, " +
                     "COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.id) as review_count " +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.id " +
                     "LEFT JOIN reviews r ON p.id = r.product_id " +
                     "WHERE p.id = ? " +
                     "GROUP BY p.id, c.nama_kategori";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean createProduct(Product p) {
        String sql = "INSERT INTO products (category_id, nama_produk, deskripsi, harga, foto, stok, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            if (p.getCategoryId() != null) {
                ps.setLong(1, p.getCategoryId());
            } else {
                ps.setNull(1, java.sql.Types.BIGINT);
            }
            ps.setString(2, p.getNamaProduk());
            ps.setString(3, p.getDeskripsi());
            ps.setBigDecimal(4, p.getHarga());
            ps.setString(5, p.getFoto());
            ps.setInt(6, p.getStok() != null ? p.getStok() : 0);
            ps.setString(7, p.getStatus() != null ? p.getStatus() : "Tersedia");

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        p.setId(rs.getLong(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateProduct(Product p) {
        String sql = "UPDATE products SET category_id = ?, nama_produk = ?, deskripsi = ?, harga = ?, foto = ?, stok = ?, status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (p.getCategoryId() != null) {
                ps.setLong(1, p.getCategoryId());
            } else {
                ps.setNull(1, java.sql.Types.BIGINT);
            }
            ps.setString(2, p.getNamaProduk());
            ps.setString(3, p.getDeskripsi());
            ps.setBigDecimal(4, p.getHarga());
            ps.setString(5, p.getFoto());
            ps.setInt(6, p.getStok() != null ? p.getStok() : 0);
            ps.setString(7, p.getStatus() != null ? p.getStatus() : "Tersedia");
            ps.setLong(8, p.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteProduct(Long id) {
        // Cek keterkaitan dengan order_details
        String checkSql = "SELECT COUNT(*) FROM order_details WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    // Jika pernah dipesan, ubah status menjadi Habis agar riwayat transaksi tetap terjaga
                    String updateSql = "UPDATE products SET status = 'Habis' WHERE id = ?";
                    try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                        psUpdate.setLong(1, id);
                        return psUpdate.executeUpdate() > 0;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Jika belum pernah dipesan, hapus langsung
        String sql = "DELETE FROM products WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countProducts() {
        String sql = "SELECT COUNT(*) FROM products";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Product mapRow(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getLong("id"));
        long catId = rs.getLong("category_id");
        if (!rs.wasNull()) {
            p.setCategoryId(catId);
        }
        p.setNamaProduk(rs.getString("nama_produk"));
        p.setDeskripsi(rs.getString("deskripsi"));
        p.setHarga(rs.getBigDecimal("harga"));
        p.setFoto(rs.getString("foto"));
        p.setStok(rs.getInt("stok"));
        p.setStatus(rs.getString("status"));
        try {
            p.setCategoryName(rs.getString("nama_kategori"));
            p.setAverageRating(rs.getDouble("avg_rating"));
            p.setReviewCount(rs.getInt("review_count"));
        } catch (SQLException ignore) {}
        return p;
    }
}
