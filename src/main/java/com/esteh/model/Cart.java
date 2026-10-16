package com.esteh.model;

import java.math.BigDecimal;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

public class Cart {
    private final Map<String, CartItem> items = new LinkedHashMap<>();

    public void addItem(Product product, int quantity) {
        addItem(product, quantity, "Normal", "Normal", "");
    }

    public void addItem(Product product, int quantity, String sugarLevel, String iceLevel, String notes) {
        if (product == null || quantity <= 0) return;
        CartItem item = new CartItem(product, quantity, sugarLevel, iceLevel, notes);
        String key = item.getItemKey();
        if (items.containsKey(key)) {
            CartItem existing = items.get(key);
            existing.setQuantity(existing.getQuantity() + quantity);
        } else {
            items.put(key, item);
        }
    }

    public CartItem getItem(String itemKey) {
        if (itemKey == null) return null;
        String key = itemKey.trim();
        CartItem item = items.get(key);
        if (item != null) return item;
        for (Map.Entry<String, CartItem> entry : items.entrySet()) {
            if (entry.getKey().equalsIgnoreCase(key)) {
                return entry.getValue();
            }
        }
        return null;
    }

    public int getQuantityForProduct(Long productId) {
        if (productId == null) return 0;
        int total = 0;
        for (CartItem item : items.values()) {
            if (item.getProduct() != null && productId.equals(item.getProduct().getId())) {
                total += item.getQuantity();
            }
        }
        return total;
    }

    public void updateQuantity(String itemKey, int quantity) {
        if (itemKey == null) return;
        String key = itemKey.trim();
        if (quantity <= 0) {
            removeItem(key);
            return;
        }
        if (items.containsKey(key)) {
            items.get(key).setQuantity(quantity);
            return;
        }
        for (Map.Entry<String, CartItem> entry : items.entrySet()) {
            if (entry.getKey().equalsIgnoreCase(key)) {
                entry.getValue().setQuantity(quantity);
                return;
            }
        }
    }

    public void updateQuantity(Long productId, int quantity) {
        if (productId == null) return;
        for (Map.Entry<String, CartItem> entry : items.entrySet()) {
            if (entry.getValue().getProduct() != null && entry.getValue().getProduct().getId().equals(productId)) {
                updateQuantity(entry.getKey(), quantity);
                return;
            }
        }
    }

    public void removeItem(String itemKey) {
        if (itemKey == null) return;
        String key = itemKey.trim();
        if (items.remove(key) == null) {
            items.entrySet().removeIf(entry -> entry.getKey().equalsIgnoreCase(key));
        }
    }

    public void removeItem(Long productId) {
        if (productId == null) return;
        items.entrySet().removeIf(entry -> entry.getValue().getProduct() != null && productId.equals(entry.getValue().getProduct().getId()));
    }

    public void clear() {
        items.clear();
    }

    public Collection<CartItem> getItems() {
        return items.values();
    }

    public boolean isEmpty() {
        return items.isEmpty();
    }

    public boolean isCartEmpty() {
        return items.isEmpty();
    }

    public int getItemCount() {
        return items.size();
    }

    public int getTotalCount() {
        int count = 0;
        for (CartItem item : items.values()) {
            count += item.getQuantity();
        }
        return count;
    }

    public BigDecimal getTotalPrice() {
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : items.values()) {
            total = total.add(item.getSubtotal());
        }
        return total;
    }
}
