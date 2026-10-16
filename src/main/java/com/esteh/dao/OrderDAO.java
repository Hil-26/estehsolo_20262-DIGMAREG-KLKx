package com.esteh.dao;

import com.esteh.model.Order;
import com.esteh.model.OrderDetail;
import com.esteh.util.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrderDAO {

    /**
     * Membuat pesanan baru secara transaksional
     */
    public boolean createOrder(Order order) {
        String insertOrderSql = "INSERT INTO orders (user_id, nomor_pesanan, total_harga, status_pesanan, metode_pengambilan, metode_pembayaran, status_pembayaran, catatan) " +
                                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        String insertDetailSql = "INSERT INTO order_details (order_id, product_id, jumlah, harga_satuan, subtotal, sugar_level, ice_level, catatan_item) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        String updateStockSql = "UPDATE products SET stok = GREATEST(0, stok - ?), status = CASE WHEN (stok - ?) <= 0 THEN 'Habis' ELSE status END WHERE id = ?";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Begin transaction

            // 1. Insert order
            try (PreparedStatement psOrder = conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setLong(1, order.getUserId());
                psOrder.setString(2, order.getNomorPesanan());
                psOrder.setBigDecimal(3, order.getTotalHarga());
                psOrder.setString(4, order.getStatusPesanan() != null ? order.getStatusPesanan() : "Menunggu");
                psOrder.setString(5, order.getMetodePengambilan() != null ? order.getMetodePengambilan() : "Takeaway");
                psOrder.setString(6, order.getMetodePembayaran() != null ? order.getMetodePembayaran() : "Tunai di Kasir");
                psOrder.setString(7, order.getStatusPembayaran() != null ? order.getStatusPembayaran() : "Belum Bayar");
                psOrder.setString(8, order.getCatatan());

                int affected = psOrder.executeUpdate();
                if (affected == 0) {
                    conn.rollback();
                    return false;
                }

                try (ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) {
                        order.setId(rs.getLong(1));
                    }
                }
            }

            // 2. Insert order details and update stock
            try (PreparedStatement psDetail = conn.prepareStatement(insertDetailSql);
                 PreparedStatement psStock = conn.prepareStatement(updateStockSql)) {
                for (OrderDetail detail : order.getDetails()) {
                    psDetail.setLong(1, order.getId());
                    psDetail.setLong(2, detail.getProductId());
                    psDetail.setInt(3, detail.getJumlah());
                    psDetail.setBigDecimal(4, detail.getHargaSatuan());
                    psDetail.setBigDecimal(5, detail.getSubtotal());
                    psDetail.setString(6, detail.getSugarLevel() != null ? detail.getSugarLevel() : "Normal");
                    psDetail.setString(7, detail.getIceLevel() != null ? detail.getIceLevel() : "Normal");
                    psDetail.setString(8, detail.getCatatanItem());
                    psDetail.addBatch();

                    // Kurangi stok dan update status jika habis
                    psStock.setInt(1, detail.getJumlah());
                    psStock.setInt(2, detail.getJumlah());
                    psStock.setLong(3, detail.getProductId());
                    psStock.addBatch();
                }
                psDetail.executeBatch();
                psStock.executeBatch();
            }

            conn.commit(); // Commit transaction
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public Order getOrderById(Long id) {
        String sql = "SELECT o.*, u.nama as user_nama, u.no_hp as user_phone, u.email as user_email " +
                     "FROM orders o " +
                     "JOIN users u ON o.user_id = u.id " +
                     "WHERE o.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = mapRow(rs);
                    order.setDetails(getOrderDetails(conn, order.getId()));
                    return order;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Order getOrderByNumber(String orderNumber) {
        String sql = "SELECT o.*, u.nama as user_nama, u.no_hp as user_phone, u.email as user_email " +
                     "FROM orders o " +
                     "JOIN users u ON o.user_id = u.id " +
                     "WHERE o.nomor_pesanan = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = mapRow(rs);
                    order.setDetails(getOrderDetails(conn, order.getId()));
                    return order;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Order> getOrdersByUser(Long userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.nama as user_nama, u.no_hp as user_phone, u.email as user_email " +
                     "FROM orders o " +
                     "JOIN users u ON o.user_id = u.id " +
                     "WHERE o.user_id = ? " +
                     "ORDER BY o.tanggal_pesanan DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = mapRow(rs);
                    order.setDetails(getOrderDetails(conn, order.getId()));
                    list.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getAllOrders(String statusFilter) {
        return getAllOrders(statusFilter, null);
    }

    public List<Order> getAllOrders(String statusFilter, String searchQuery) {
        List<Order> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT o.*, u.nama as user_nama, u.no_hp as user_phone, u.email as user_email " +
            "FROM orders o " +
            "JOIN users u ON o.user_id = u.id " +
            "WHERE 1=1 "
        );
        List<Object> params = new ArrayList<>();

        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"Semua".equalsIgnoreCase(statusFilter)) {
            sql.append("AND o.status_pesanan = ? ");
            params.add(statusFilter.trim());
        }

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append("AND (LOWER(o.nomor_pesanan) LIKE ? OR LOWER(u.nama) LIKE ? OR LOWER(u.no_hp) LIKE ?) ");
            String wild = "%" + searchQuery.trim().toLowerCase() + "%";
            params.add(wild);
            params.add(wild);
            params.add(wild);
        }

        sql.append("ORDER BY o.tanggal_pesanan DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = mapRow(rs);
                    order.setDetails(getOrderDetails(conn, order.getId()));
                    list.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateOrderStatus(Long orderId, String newStatus) {
        String sql = "UPDATE orders SET status_pesanan = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setLong(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePaymentStatus(Long orderId, String newPaymentStatus) {
        String sql = "UPDATE orders SET status_pembayaran = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPaymentStatus);
            ps.setLong(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean cancelOrder(Long orderId, Long userId) {
        String checkSql = "SELECT status_pesanan FROM orders WHERE id = ? AND user_id = ?";
        String cancelSql = "UPDATE orders SET status_pesanan = 'Dibatalkan' WHERE id = ?";
        String restoreStockSql = "UPDATE products p SET stok = stok + od.jumlah FROM order_details od " +
                                 "WHERE p.id = od.product_id AND od.order_id = ?";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
                psCheck.setLong(1, orderId);
                psCheck.setLong(2, userId);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return false;
                    }
                    String currentStatus = rs.getString("status_pesanan");
                    if (!"Menunggu".equalsIgnoreCase(currentStatus)) {
                        conn.rollback();
                        return false; // Hanya boleh dibatalkan jika statusnya Menunggu
                    }
                }
            }

            try (PreparedStatement psCancel = conn.prepareStatement(cancelSql)) {
                psCancel.setLong(1, orderId);
                psCancel.executeUpdate();
            }

            // Kembalikan stok produk yang dibatalkan
            try {
                // Versi standar UPDATE JOIN
                try (PreparedStatement psRestore = conn.prepareStatement(
                    "UPDATE products SET stok = stok + (SELECT COALESCE(SUM(jumlah), 0) FROM order_details WHERE order_details.product_id = products.id AND order_details.order_id = ?), " +
                    "status = 'Tersedia' " +
                    "WHERE id IN (SELECT product_id FROM order_details WHERE order_id = ?)"
                )) {
                    psRestore.setLong(1, orderId);
                    psRestore.setLong(2, orderId);
                    psRestore.executeUpdate();
                }
            } catch (SQLException ignore) {}

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public List<OrderDetail> getOrderDetails(Connection conn, Long orderId) throws SQLException {
        List<OrderDetail> details = new ArrayList<>();
        String sql = "SELECT od.*, p.nama_produk, p.foto as product_photo " +
                     "FROM order_details od " +
                     "LEFT JOIN products p ON od.product_id = p.id " +
                     "WHERE od.order_id = ? ORDER BY od.id ASC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetail d = new OrderDetail();
                    d.setId(rs.getLong("id"));
                    d.setOrderId(rs.getLong("order_id"));
                    d.setProductId(rs.getLong("product_id"));
                    d.setProductName(rs.getString("nama_produk"));
                    d.setProductPhoto(rs.getString("product_photo"));
                    d.setJumlah(rs.getInt("jumlah"));
                    d.setHargaSatuan(rs.getBigDecimal("harga_satuan"));
                    d.setSubtotal(rs.getBigDecimal("subtotal"));
                    try {
                        String sugar = rs.getString("sugar_level");
                        if (sugar != null) d.setSugarLevel(sugar);
                        String ice = rs.getString("ice_level");
                        if (ice != null) d.setIceLevel(ice);
                        d.setCatatanItem(rs.getString("catatan_item"));
                    } catch (SQLException ignore) {}
                    details.add(d);
                }
            }
        }
        return details;
    }

    public int countTotalOrders() {
        String sql = "SELECT COUNT(*) FROM orders";
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

    public int countOrdersByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM orders WHERE status_pesanan = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public BigDecimal getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(total_harga), 0) FROM orders WHERE status_pesanan = 'Selesai'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    /**
     * Laporan Penjualan (Fitur Tambahan 9)
     */
    public Map<String, Object> getSalesReport(String startDate, String endDate) {
        Map<String, Object> report = new HashMap<>();
        StringBuilder sqlOrders = new StringBuilder("SELECT * FROM orders WHERE status_pesanan = 'Selesai' ");
        List<Object> params = new ArrayList<>();

        if (startDate != null && !startDate.trim().isEmpty()) {
            sqlOrders.append("AND tanggal_pesanan >= CAST(? AS TIMESTAMP) ");
            params.add(startDate + " 00:00:00");
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            sqlOrders.append("AND tanggal_pesanan <= CAST(? AS TIMESTAMP) ");
            params.add(endDate + " 23:59:59");
        }
        sqlOrders.append("ORDER BY tanggal_pesanan DESC");

        List<Order> orders = new ArrayList<>();
        BigDecimal totalRevenue = BigDecimal.ZERO;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlOrders.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = mapRow(rs);
                    o.setDetails(getOrderDetails(conn, o.getId()));
                    orders.add(o);
                    if (o.getTotalHarga() != null) {
                        totalRevenue = totalRevenue.add(o.getTotalHarga());
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        report.put("orders", orders);
        report.put("totalOrders", orders.size());
        report.put("totalRevenue", totalRevenue);
        return report;
    }

    public List<Map<String, Object>> getBestSellingProducts(int limit) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT p.id, p.nama_produk, p.harga, p.foto, " +
                     "SUM(od.jumlah) as total_terjual, SUM(od.subtotal) as total_pendapatan " +
                     "FROM order_details od " +
                     "JOIN orders o ON od.order_id = o.id " +
                     "JOIN products p ON od.product_id = p.id " +
                     "WHERE o.status_pesanan = 'Selesai' " +
                     "GROUP BY p.id, p.nama_produk, p.harga, p.foto " +
                     "ORDER BY total_terjual DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("id", rs.getLong("id"));
                    item.put("namaProduk", rs.getString("nama_produk"));
                    item.put("harga", rs.getBigDecimal("harga"));
                    item.put("foto", rs.getString("foto"));
                    item.put("totalTerjual", rs.getInt("total_terjual"));
                    item.put("totalPendapatan", rs.getBigDecimal("total_pendapatan"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Order mapRow(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getLong("id"));
        order.setUserId(rs.getLong("user_id"));
        order.setNomorPesanan(rs.getString("nomor_pesanan"));
        order.setTanggalPesanan(rs.getTimestamp("tanggal_pesanan"));
        order.setTotalHarga(rs.getBigDecimal("total_harga"));
        order.setStatusPesanan(rs.getString("status_pesanan"));
        order.setMetodePengambilan(rs.getString("metode_pengambilan"));
        order.setCatatan(rs.getString("catatan"));
        try {
            String payMethod = rs.getString("metode_pembayaran");
            order.setMetodePembayaran(payMethod != null ? payMethod : "Tunai di Kasir");
            String payStatus = rs.getString("status_pembayaran");
            order.setStatusPembayaran(payStatus != null ? payStatus : "Belum Bayar");
            order.setUserName(rs.getString("user_nama"));
            order.setUserPhone(rs.getString("user_phone"));
            order.setUserEmail(rs.getString("user_email"));
        } catch (SQLException ignore) {}
        return order;
    }
}
