package com.esteh.controller;

import com.esteh.dao.UserDAO;
import com.esteh.model.User;
import com.esteh.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminUserServlet", urlPatterns = {
    "/admin/users",
    "/admin/users/role",
    "/admin/users/reset-password",
    "/admin/users/delete"
})
public class AdminUserServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String search = req.getParameter("q");
        List<User> users = userDAO.getAllUsers(search);
        req.setAttribute("users", users);
        req.setAttribute("searchQuery", search);
        req.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("user");

        String userIdParam = req.getParameter("userId");
        if (userIdParam == null || userIdParam.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=ID Pengguna tidak valid.");
            return;
        }

        try {
            Long userId = Long.parseLong(userIdParam.trim());

            if ("/admin/users/role".equals(path)) {
                String newRole = req.getParameter("role");
                if ("admin".equalsIgnoreCase(newRole) || "user".equalsIgnoreCase(newRole)) {
                    userDAO.updateRole(userId, newRole.toLowerCase());
                    resp.sendRedirect(req.getContextPath() + "/admin/users?success=Peran akun berhasil diubah menjadi " + newRole + ".");
                    return;
                }
            } else if ("/admin/users/reset-password".equals(path)) {
                // Reset password to default 'user123'
                String defaultHash = PasswordUtil.hashPassword("user123");
                userDAO.updatePassword(userId, defaultHash);
                resp.sendRedirect(req.getContextPath() + "/admin/users?success=Password pengguna berhasil di-reset menjadi: user123");
                return;
            } else if ("/admin/users/delete".equals(path)) {
                if (currentUser != null && currentUser.getId().equals(userId)) {
                    resp.sendRedirect(req.getContextPath() + "/admin/users?error=Anda tidak dapat menghapus akun Anda sendiri.");
                    return;
                }
                userDAO.deleteUser(userId);
                resp.sendRedirect(req.getContextPath() + "/admin/users?success=Akun pengguna berhasil dihapus.");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/admin/users?error=Gagal memproses aksi pengguna.");
    }
}
