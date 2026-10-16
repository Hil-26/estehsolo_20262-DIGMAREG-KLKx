package com.esteh.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Order {
    private Long id;
    private Long userId;
    private String userName;
    private String userPhone;
    private String userEmail;
    private String nomorPesanan;
    private Timestamp tanggalPesanan;
    private BigDecimal totalHarga;
    private String statusPesanan; // 'Menunggu', 'Diproses', 'Siap Diambil', 'Selesai', 'Dibatalkan'
    private String metodePengambilan; // 'Takeaway', 'Dine-in'
    private String metodePembayaran; // 'QRIS', 'Transfer Bank', 'Tunai di Kasir'
    private String statusPembayaran; // 'Belum Bayar', 'Lunas'
    private String catatan;
    private List<OrderDetail> details = new ArrayList<>();

    public Order() {
        this.statusPesanan = "Menunggu";
        this.metodePengambilan = "Takeaway";
        this.metodePembayaran = "Tunai di Kasir";
        this.statusPembayaran = "Belum Bayar";
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserPhone() {
        return userPhone;
    }

    public void setUserPhone(String userPhone) {
        this.userPhone = userPhone;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getNomorPesanan() {
        return nomorPesanan;
    }

    public void setNomorPesanan(String nomorPesanan) {
        this.nomorPesanan = nomorPesanan;
    }

    public Timestamp getTanggalPesanan() {
        return tanggalPesanan;
    }

    public Timestamp getCreatedAt() {
        return tanggalPesanan;
    }

    public void setTanggalPesanan(Timestamp tanggalPesanan) {
        this.tanggalPesanan = tanggalPesanan;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.tanggalPesanan = createdAt;
    }

    public BigDecimal getTotalHarga() {
        return totalHarga;
    }

    public void setTotalHarga(BigDecimal totalHarga) {
        this.totalHarga = totalHarga;
    }

    public String getStatusPesanan() {
        return statusPesanan;
    }

    public void setStatusPesanan(String statusPesanan) {
        this.statusPesanan = statusPesanan;
    }

    public String getMetodePengambilan() {
        return metodePengambilan;
    }

    public void setMetodePengambilan(String metodePengambilan) {
        this.metodePengambilan = metodePengambilan;
    }

    public String getMetodePembayaran() {
        return metodePembayaran;
    }

    public void setMetodePembayaran(String metodePembayaran) {
        this.metodePembayaran = metodePembayaran;
    }

    public String getStatusPembayaran() {
        return statusPembayaran;
    }

    public void setStatusPembayaran(String statusPembayaran) {
        this.statusPembayaran = statusPembayaran;
    }

    public String getCatatan() {
        return catatan;
    }

    public void setCatatan(String catatan) {
        this.catatan = catatan;
    }

    public List<OrderDetail> getDetails() {
        return details;
    }

    public void setDetails(List<OrderDetail> details) {
        this.details = details;
    }

    public boolean canBeCancelled() {
        return "Menunggu".equalsIgnoreCase(this.statusPesanan);
    }

    public boolean isCanBeCancelled() {
        return canBeCancelled();
    }
}
