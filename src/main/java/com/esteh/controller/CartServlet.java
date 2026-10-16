package com.esteh.controller;

import com.esteh.dao.ProductDAO;
import com.esteh.model.Cart;
import com.esteh.model.CartItem;
import com.esteh.model.Product;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    private final Gson gson = new Gson();

    private Cart getOrCreateCart(HttpSession session) {
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Cart cart = getOrCreateCart(session);
        req.setAttribute("cart", cart);
        req.getRequestDispatcher("/WEB-INF/views/user/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Cart cart = getOrCreateCart(session);

        String action = req.getParameter("action");
        String redirect = req.getParameter("redirect");
        String isAjax = req.getHeader("X-Requested-With");
        boolean ajax = "XMLHttpRequest".equalsIgnoreCase(isAjax) || "true".equalsIgnoreCase(req.getParameter("ajax"));

        try {
            if ("add".equalsIgnoreCase(action)) {
                String productIdParam = req.getParameter("productId");
                if (productIdParam == null || productIdParam.trim().isEmpty()) {
                    if (ajax) {
                        sendJsonResponse(resp, false, "ID Produk tidak valid.", cart);
                    } else {
                        sendRedirectWithMessage(req, resp, redirect, "error", "ID produk tidak valid.");
                    }
                    return;
                }

                Long productId = Long.parseLong(productIdParam.trim());
                int qty = 1;
                if (req.getParameter("quantity") != null && !req.getParameter("quantity").trim().isEmpty()) {
                    qty = Math.max(1, Integer.parseInt(req.getParameter("quantity").trim()));
                }
                String sugarLevel = req.getParameter("sugarLevel");
                if (sugarLevel == null || sugarLevel.trim().isEmpty()) {
                    sugarLevel = "Normal";
                }
                String iceLevel = req.getParameter("iceLevel");
                if (iceLevel == null || iceLevel.trim().isEmpty()) {
                    iceLevel = "Normal";
                }
                String notes = req.getParameter("notes");
                if (notes == null) {
                    notes = "";
                }

                Product p = productDAO.getProductById(productId);
                if (p == null || !p.isAvailable()) {
                    if (ajax) {
                        sendJsonResponse(resp, false, "Minuman ini sedang tidak tersedia atau habis.", cart);
                    } else {
                        sendRedirectWithMessage(req, resp, redirect, "error", "Minuman ini sedang tidak tersedia atau habis.");
                    }
                    return;
                }

                // Check stock limit
                int currentInCart = cart.getQuantityForProduct(productId);
                if (p.getStok() != null && (currentInCart + qty) > p.getStok()) {
                    int remaining = Math.max(0, p.getStok() - currentInCart);
                    String msg = remaining > 0
                        ? "Stok produk tidak mencukupi. Anda sudah memiliki " + currentInCart + " di keranjang, tersisa " + remaining + " porsi."
                        : "Stok produk sudah habis atau sudah berada di batas maksimum keranjang Anda.";
                    if (ajax) {
                        sendJsonResponse(resp, false, msg, cart);
                    } else {
                        sendRedirectWithMessage(req, resp, redirect, "error", msg);
                    }
                    return;
                }

                cart.addItem(p, qty, sugarLevel, iceLevel, notes);

                if (ajax) {
                    sendJsonResponse(resp, true, p.getNamaProduk() + " berhasil ditambahkan ke keranjang!", cart);
                } else {
                    String target = (redirect != null && !redirect.trim().isEmpty()) ? redirect : "/cart";
                    sendRedirectWithMessage(req, resp, target, "success", p.getNamaProduk() + " (" + qty + " porsi) berhasil ditambahkan ke keranjang!");
                }
                return;

            } else if ("update".equalsIgnoreCase(action)) {
                String itemKey = req.getParameter("itemKey");
                int qty = 0;
                try {
                    qty = Integer.parseInt(req.getParameter("quantity"));
                } catch (NumberFormatException ignore) {}

                if (qty <= 0) {
                    if (itemKey != null && !itemKey.trim().isEmpty()) {
                        cart.removeItem(itemKey);
                    } else if (req.getParameter("productId") != null) {
                        cart.removeItem(Long.parseLong(req.getParameter("productId")));
                    }
                    sendRedirectWithMessage(req, resp, "/cart", "success", "Minuman berhasil dihapus dari keranjang.");
                    return;
                }

                // Check stock before updating quantity
                CartItem item = (itemKey != null) ? cart.getItem(itemKey) : null;
                if (item != null && item.getProduct() != null) {
                    Product dbProduct = productDAO.getProductById(item.getProduct().getId());
                    if (dbProduct != null && dbProduct.getStok() != null && qty > dbProduct.getStok()) {
                        sendRedirectWithMessage(req, resp, "/cart", "error", "Jumlah pesanan melebihi stok yang tersedia (tersisa " + dbProduct.getStok() + " porsi).");
                        return;
                    }
                }

                if (itemKey != null && !itemKey.trim().isEmpty()) {
                    cart.updateQuantity(itemKey, qty);
                } else if (req.getParameter("productId") != null) {
                    cart.updateQuantity(Long.parseLong(req.getParameter("productId")), qty);
                }

                sendRedirectWithMessage(req, resp, "/cart", "success", "Jumlah pesanan berhasil diperbarui.");
                return;

            } else if ("remove".equalsIgnoreCase(action)) {
                String itemKey = req.getParameter("itemKey");
                if (itemKey != null && !itemKey.trim().isEmpty()) {
                    cart.removeItem(itemKey);
                } else if (req.getParameter("productId") != null) {
                    cart.removeItem(Long.parseLong(req.getParameter("productId")));
                }
                sendRedirectWithMessage(req, resp, "/cart", "success", "Minuman berhasil dihapus dari keranjang.");
                return;

            } else if ("clear".equalsIgnoreCase(action)) {
                cart.clear();
                sendRedirectWithMessage(req, resp, "/cart", "success", "Keranjang belanja berhasil dikosongkan.");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (ajax) {
                sendJsonResponse(resp, false, "Terjadi kesalahan pada keranjang: " + e.getMessage(), cart);
            } else {
                sendRedirectWithMessage(req, resp, "/cart", "error", "Terjadi kesalahan saat memproses keranjang.");
            }
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/cart");
    }

    private void sendJsonResponse(HttpServletResponse resp, boolean success, String message, Cart cart) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        Map<String, Object> result = new HashMap<>();
        result.put("success", success);
        result.put("message", message);
        if (cart != null) {
            result.put("totalCount", cart.getTotalCount());
            result.put("totalPrice", cart.getTotalPrice());
        }
        resp.getWriter().write(gson.toJson(result));
    }

    private void sendRedirectWithMessage(HttpServletRequest req, HttpServletResponse resp, String path, String paramName, String message) throws IOException {
        if (path == null || path.trim().isEmpty()) {
            path = "/cart";
        }
        String separator = path.contains("?") ? "&" : "?";
        String encodedMessage = URLEncoder.encode(message, StandardCharsets.UTF_8);
        resp.sendRedirect(req.getContextPath() + path + separator + paramName + "=" + encodedMessage);
    }
}
