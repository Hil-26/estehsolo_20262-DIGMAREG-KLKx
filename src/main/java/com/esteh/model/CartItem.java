package com.esteh.model;

import java.math.BigDecimal;

public class CartItem {
    private Product product;
    private int quantity;
    private String sugarLevel = "Normal";
    private String iceLevel = "Normal";
    private String itemNotes = "";

    public CartItem(Product product, int quantity) {
        this.product = product;
        this.quantity = quantity;
        this.sugarLevel = "Normal";
        this.iceLevel = "Normal";
        this.itemNotes = "";
    }

    public CartItem(Product product, int quantity, String sugarLevel, String iceLevel, String itemNotes) {
        this.product = product;
        this.quantity = quantity;
        this.sugarLevel = (sugarLevel != null && !sugarLevel.trim().isEmpty()) ? sugarLevel.trim() : "Normal";
        this.iceLevel = (iceLevel != null && !iceLevel.trim().isEmpty()) ? iceLevel.trim() : "Normal";
        this.itemNotes = (itemNotes != null) ? itemNotes.trim() : "";
    }

    public String getItemKey() {
        if (product == null) return "";
        String s = (sugarLevel != null) ? sugarLevel.replaceAll("[^a-zA-Z0-9]", "") : "Normal";
        String i = (iceLevel != null) ? iceLevel.replaceAll("[^a-zA-Z0-9]", "") : "Normal";
        int noteHash = (itemNotes != null && !itemNotes.trim().isEmpty()) ? Math.abs(itemNotes.trim().hashCode()) : 0;
        return product.getId() + "_" + s + "_" + i + "_" + noteHash;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
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

    public String getItemNotes() {
        return itemNotes;
    }

    public String getNotes() {
        return itemNotes;
    }

    public void setItemNotes(String itemNotes) {
        this.itemNotes = itemNotes;
    }

    public BigDecimal getSubtotal() {
        if (product == null || product.getHarga() == null) {
            return BigDecimal.ZERO;
        }
        return product.getHarga().multiply(BigDecimal.valueOf(quantity));
    }
}
