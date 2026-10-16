package com.esteh.model;

import java.sql.Timestamp;

public class User {
    private Long id;
    private String nama;
    private String email;
    private String password;
    private String noHp;
    private String role;
    private Timestamp createdAt;

    public User() {}

    public User(Long id, String nama, String email, String password, String noHp, String role, Timestamp createdAt) {
        this.id = id;
        this.nama = nama;
        this.email = email;
        this.password = password;
        this.noHp = noHp;
        this.role = role;
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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getNoHp() {
        return noHp;
    }

    public void setNoHp(String noHp) {
        this.noHp = noHp;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isAdmin() {
        return "admin".equalsIgnoreCase(this.role);
    }
}
