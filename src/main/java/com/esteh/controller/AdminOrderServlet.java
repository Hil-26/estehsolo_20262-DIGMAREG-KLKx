package com.esteh.controller;

import com.esteh.dao.OrderDAO;
import com.esteh.model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminOrderServlet", urlPatterns = {"/admin/orders", "/admin/orders/detail", "/admin/orders/update-status", "/admin/orders/update-payment-status"})
public class AdminOrderServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/admin/orders/detail".equals(path)) {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.trim().isEmpty()) {
                try {
                    Long orderId = Long.parseLong(idParam.trim());
                    Order order = orderDAO.getOrderById(orderId);
                    if (order != null) {
                        req.setAttribute("order", order);
                        req.getRequestDispatcher("/WEB-INF/views/admin/order_detail.jsp").forward(req, resp);
                        return;
                    }
                } catch (NumberFormatException ignore) {}
            }
            resp.sendRedirect(req.getContextPath() + "/admin/orders?error=Pesanan tidak ditemukan.");
            return;
        }

        String statusFilter = req.getParameter("status");
        if (statusFilter == null || statusFilter.trim().isEmpty()) {
            statusFilter = "Semua";
        }

        String searchQuery = req.getParameter("q");
        if (searchQuery != null) {
            searchQuery = searchQuery.trim();
        }

        List<Order> orders = orderDAO.getAllOrders(statusFilter, searchQuery);
        req.setAttribute("orders", orders);
        req.setAttribute("selectedStatus", statusFilter);
        req.setAttribute("searchQuery", searchQuery);

        req.getRequestDispatcher("/WEB-INF/views/admin/orders.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        String orderIdParam = req.getParameter("orderId");
        String redirect = req.getParameter("redirect");

        if ("/admin/orders/update-payment-status".equals(path)) {
            String paymentStatus = req.getParameter("paymentStatus");
            if (orderIdParam != null && paymentStatus != null) {
                try {
                    Long orderId = Long.parseLong(orderIdParam.trim());
                    boolean updated = orderDAO.updatePaymentStatus(orderId, paymentStatus.trim());
                    if (updated) {
                        String target = (redirect != null && !redirect.trim().isEmpty()) ? redirect : "/admin/orders";
                        resp.sendRedirect(req.getContextPath() + target + "?success=Status pembayaran berhasil diperbarui menjadi: " + paymentStatus);
                        return;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            resp.sendRedirect(req.getContextPath() + "/admin/orders?error=Gagal memperbarui status pembayaran.");
            return;
        }

        String newStatus = req.getParameter("newStatus");
        if (orderIdParam != null && newStatus != null) {
            try {
                Long orderId = Long.parseLong(orderIdParam);
                boolean updated = orderDAO.updateOrderStatus(orderId, newStatus);
                if (updated) {
                    if (redirect != null && !redirect.trim().isEmpty()) {
                        resp.sendRedirect(req.getContextPath() + redirect + "?success=Status pesanan berhasil diubah menjadi " + newStatus);
                    } else {
                        resp.sendRedirect(req.getContextPath() + "/admin/orders?success=Status pesanan berhasil diubah menjadi " + newStatus);
                    }
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/orders?error=Gagal memperbarui status pesanan.");
    }
}
