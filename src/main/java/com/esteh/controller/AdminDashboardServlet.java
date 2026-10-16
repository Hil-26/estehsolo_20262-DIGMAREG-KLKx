package com.esteh.controller;

import com.esteh.dao.CategoryDAO;
import com.esteh.dao.ContactDAO;
import com.esteh.dao.OrderDAO;
import com.esteh.dao.ProductDAO;
import com.esteh.dao.UserDAO;
import com.esteh.model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin", "/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    private final UserDAO userDAO = new UserDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ContactDAO contactDAO = new ContactDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int totalProducts = productDAO.countProducts();
        int totalUsers = userDAO.countUsers();
        int totalOrders = orderDAO.countTotalOrders();
        BigDecimal totalRevenue = orderDAO.getTotalRevenue();
        int unreadContacts = contactDAO.countUnreadContacts();

        Map<String, Integer> statusCounts = new HashMap<>();
        statusCounts.put("Menunggu", orderDAO.countOrdersByStatus("Menunggu"));
        statusCounts.put("Diproses", orderDAO.countOrdersByStatus("Diproses"));
        statusCounts.put("Siap Diambil", orderDAO.countOrdersByStatus("Siap Diambil"));
        statusCounts.put("Selesai", orderDAO.countOrdersByStatus("Selesai"));
        statusCounts.put("Dibatalkan", orderDAO.countOrdersByStatus("Dibatalkan"));

        List<Order> recentOrders = orderDAO.getAllOrders("Semua");
        if (recentOrders.size() > 8) {
            recentOrders = recentOrders.subList(0, 8);
        }

        req.setAttribute("totalProducts", totalProducts);
        req.setAttribute("totalUsers", totalUsers);
        req.setAttribute("totalOrders", totalOrders);
        req.setAttribute("totalRevenue", totalRevenue);
        req.setAttribute("unreadContacts", unreadContacts);
        req.setAttribute("statusCounts", statusCounts);
        req.setAttribute("recentOrders", recentOrders);

        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }
}
