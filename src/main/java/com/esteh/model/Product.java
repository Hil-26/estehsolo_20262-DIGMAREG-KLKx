package com.esteh.model;

import java.math.BigDecimal;

public class Product {
    private Long id;
    private Long categoryId;
    private String categoryName;
    private String namaProduk;
    private String deskripsi;
    private BigDecimal harga;
    private String foto;
    private Integer stok;
    private String status; // 'Tersedia', 'Habis'
    private Double averageRating;
    private Integer reviewCount;

    public Product() {
        this.stok = 0;
        this.status = "Tersedia";
        this.averageRating = 0.0;
        this.reviewCount = 0;
    }

    public Product(Long id, Long categoryId, String namaProduk, String deskripsi, BigDecimal harga, String foto, Integer stok, String status) {
        this.id = id;
        this.categoryId = categoryId;
        this.namaProduk = namaProduk;
        this.deskripsi = deskripsi;
        this.harga = harga;
        this.foto = foto;
        this.stok = stok;
        this.status = status;
        this.averageRating = 0.0;
        this.reviewCount = 0;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Long categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getNamaProduk() {
        return namaProduk;
    }

    public void setNamaProduk(String namaProduk) {
        this.namaProduk = namaProduk;
    }

    public String getDeskripsi() {
        return deskripsi;
    }

    public void setDeskripsi(String deskripsi) {
        this.deskripsi = deskripsi;
    }

    public BigDecimal getHarga() {
        return harga;
    }

    public void setHarga(BigDecimal harga) {
        this.harga = harga;
    }

    public String getFoto() {
        return foto;
    }

    public void setFoto(String foto) {
        this.foto = foto;
    }

    public Integer getStok() {
        return stok;
    }

    public void setStok(Integer stok) {
        this.stok = stok;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Double getAverageRating() {
        return averageRating != null ? averageRating : 0.0;
    }

    public void setAverageRating(Double averageRating) {
        this.averageRating = averageRating;
    }

    public Integer getReviewCount() {
        return reviewCount != null ? reviewCount : 0;
    }

    public void setReviewCount(Integer reviewCount) {
        this.reviewCount = reviewCount;
    }

    public boolean isAvailable() {
        return "Tersedia".equalsIgnoreCase(this.status) && (this.stok == null || this.stok > 0);
    }
}
