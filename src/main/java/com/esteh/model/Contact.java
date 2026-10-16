package com.esteh.model;

import java.sql.Timestamp;

public class Contact {
    private Long id;
    private String nama;
    private String kontak;
    private String pesan;
    private String status; // 'Baru', 'Dibaca', 'Dibalas'
    private Timestamp createdAt;

    public Contact() {}

    public Contact(Long id, String nama, String kontak, String pesan, String status, Timestamp createdAt) {
        this.id = id;
        this.nama = nama;
        this.kontak = kontak;
        this.pesan = pesan;
        this.status = status;
        this.createdAt = createdAt;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNama() {
        return nama;
    }

    public void setNama(String nama) {
        this.nama = nama;
    }

    public String getKontak() {
        return kontak;
    }

    public void setKontak(String kontak) {
        this.kontak = kontak;
    }

    public String getPesan() {
        return pesan;
    }

    public void setPesan(String pesan) {
        this.pesan = pesan;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
