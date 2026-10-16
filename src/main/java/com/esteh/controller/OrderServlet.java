package com.esteh.controller;

import com.esteh.dao.OrderDAO;
import com.esteh.dao.ProductDAO;
import com.esteh.model.Cart;
import com.esteh.model.CartItem;
import com.esteh.model.Order;
import com.esteh.model.OrderDetail;
import com.esteh.model.Product;
import com.esteh.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Random;

@WebServlet(name = "OrderServlet", urlPatterns = {"/checkout", "/orders", "/order-detail", "/order-cancel"})
public class OrderServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login?error=Silakan login terlebih dahulu.");
            return;
        }

        if ("/checkout".equals(path)) {
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null || cart.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/cart?error=Keranjang belanja Anda masih kosong.");
                return;
            }
            req.setAttribute("cart", cart);
            req.getRequestDispatcher("/WEB-INF/views/user/checkout.jsp").forward(req, resp);
        } else if ("/orders".equals(path)) {
            List<Order> orders = orderDAO.getOrdersByUser(user.getId());
            req.setAttribute("orders", orders);
            req.getRequestDispatcher("/WEB-INF/views/user/orders.jsp").forward(req, resp);
        } else if ("/order-detail".equals(path)) {
            String idParam = req.getParameter("id");
            if (idParam != null) {
                try {
                    Long orderId = Long.parseLong(idParam);
                    Order order = orderDAO.getOrderById(orderId);
                    if (order != null && (order.getUserId().equals(user.getId()) || user.isAdmin())) {
                        req.setAttribute("order", order);
                        req.getRequestDispatcher("/WEB-INF/views/user/order_detail.jsp").forward(req, resp);
                        return;
                    }
                } catch (NumberFormatException ignore) {}
            }
            resp.sendRedirect(req.getContextPath() + "/orders?error=Pesanan tidak ditemukan.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if ("/checkout".equals(path)) {
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null || cart.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/cart?error=Keranjang Anda kosong.");
                return;
            }

            String metode = req.getParameter("metodePengambilan");
            if (metode == null || (!metode.equalsIgnoreCase("Takeaway") && !metode.equalsIgnoreCase("Dine-in"))) {
                metode = "Takeaway";
            }
            String metodePembayaran = req.getParameter("metodePembayaran");
            if (metodePembayaran == null || metodePembayaran.trim().isEmpty()) {
                metodePembayaran = "Tunai di Kasir";
            }
            String catatan = req.getParameter("catatan");

            // Backend validation: Recalculate price from latest database records
            Order order = new Order();
            order.setUserId(user.getId());
            order.setMetodePengambilan(metode);
            order.setMetodePembayaran(metodePembayaran);
            order.setStatusPembayaran("Belum Bayar");
            order.setCatatan(catatan);
            order.setStatusPesanan("Menunggu");

            // Generate unique order number (e.g., ETS-20261016-8921)
            String dateStr = new SimpleDateFormat("yyyyMMdd").format(new Date());
            int rand = 1000 + new Random().nextInt(9000);
            order.setNomorPesanan("ETS-" + dateStr + "-" + rand);

            BigDecimal calculatedTotal = BigDecimal.ZERO;
            for (CartItem item : cart.getItems()) {
                Product dbProduct = productDAO.getProductById(item.getProduct().getId());
                if (dbProduct == null || !dbProduct.isAvailable()) {
                    resp.sendRedirect(req.getContextPath() + "/cart?error=Salah satu produk dalam keranjang sudah tidak tersedia.");
                    return;
                }
                if (dbProduct.getStok() != null && dbProduct.getStok() < item.getQuantity()) {
                    resp.sendRedirect(req.getContextPath() + "/cart?error=Stok produk " + dbProduct.getNamaProduk() + " tidak mencukupi (tersisa " + dbProduct.getStok() + ").");
                    return;
                }

                BigDecimal subtotal = dbProduct.getHarga().multiply(BigDecimal.valueOf(item.getQuantity()));
                calculatedTotal = calculatedTotal.add(subtotal);

                OrderDetail detail = new OrderDetail();
                detail.setProductId(dbProduct.getId());
                detail.setJumlah(item.getQuantity());
                detail.setHargaSatuan(dbProduct.getHarga());
                detail.setSubtotal(subtotal);
                detail.setSugarLevel(item.getSugarLevel());
                detail.setIceLevel(item.getIceLevel());
                detail.setCatatanItem(item.getNotes());
                order.getDetails().add(detail);
            }

            order.setTotalHarga(calculatedTotal);

            boolean success = orderDAO.createOrder(order);
            if (success) {
                cart.clear(); // Clear cart on success
                resp.sendRedirect(req.getContextPath() + "/orders?success=Pesanan berhasil dibuat dengan nomor " + order.getNomorPesanan() + "!");
            } else {
                resp.sendRedirect(req.getContextPath() + "/checkout?error=Gagal memproses pesanan. Silakan coba lagi.");
            }
        } else if ("/order-cancel".equals(path)) {
            String orderIdParam = req.getParameter("orderId");
            if (orderIdParam != null) {
                try {
                    Long orderId = Long.parseLong(orderIdParam);
                    boolean cancelled = orderDAO.cancelOrder(orderId, user.getId());
                    if (cancelled) {
                        resp.sendRedirect(req.getContextPath() + "/orders?success=Pesanan berhasil dibatalkan.");
                        return;
                    } else {
                        resp.sendRedirect(req.getContextPath() + "/orders?error=Pesanan tidak dapat dibatalkan karena sudah diproses atau bukan pesanan Anda.");
                        return;
                    }
                } catch (NumberFormatException ignore) {}
            }
            resp.sendRedirect(req.getContextPath() + "/orders?error=ID pesanan tidak valid.");
        }
    }
}
