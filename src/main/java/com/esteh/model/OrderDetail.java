package com.esteh.model;

import java.math.BigDecimal;

public class OrderDetail {
    private Long id;
    private Long orderId;
    private Long productId;
    private String productName;
    private String productPhoto;
    private Integer jumlah;
    private BigDecimal hargaSatuan;
    private BigDecimal subtotal;
    private String sugarLevel = "Normal"; // 'Normal', 'Less Sugar (50%)', 'Slightly Sugar (25%)', 'Tanpa Gula (0%)'
    private String iceLevel = "Normal";   // 'Normal', 'Sedikit Es', 'Tanpa Es'
    private String catatanItem;

    public OrderDetail() {}

    public OrderDetail(Long id, Long orderId, Long productId, Integer jumlah, BigDecimal hargaSatuan, BigDecimal subtotal) {
        this.id = id;
        this.orderId = orderId;
        this.productId = productId;
        this.jumlah = jumlah;
        this.hargaSatuan = hargaSatuan;
        this.subtotal = subtotal;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getOrderId() {
        return orderId;
    }

    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }

    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductPhoto() {
        return productPhoto;
    }

    public void setProductPhoto(String productPhoto) {
        this.productPhoto = productPhoto;
    }

    public Integer getJumlah() {
        return jumlah;
    }

    public void setJumlah(Integer jumlah) {
        this.jumlah = jumlah;
    }

    public BigDecimal getHargaSatuan() {
        return hargaSatuan;
    }

    public void setHargaSatuan(BigDecimal hargaSatuan) {
        this.hargaSatuan = hargaSatuan;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }

    public String getSugarLevel() {
        return sugarLevel;
    }

    public void setSugarLevel(String sugarLevel) {
        this.sugarLevel = sugarLevel;
    }

    public String getIceLevel() {
        return iceLevel;
    }

    public void setIceLevel(String iceLevel) {
        this.iceLevel = iceLevel;
    }

    public String getCatatanItem() {
        return catatanItem;
    }

    public void setCatatanItem(String catatanItem) {
        this.catatanItem = catatanItem;
    }
}
