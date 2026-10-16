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

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile", "/profile/update", "/profile/password"})
public class ProfileServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User sessionUser = (User) session.getAttribute("user");
        if (sessionUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User freshUser = userDAO.findById(sessionUser.getId());
        req.setAttribute("userProfile", freshUser);
        req.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession();
        User sessionUser = (User) session.getAttribute("user");

        if (sessionUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if ("/profile/update".equals(path)) {
            String nama = req.getParameter("nama");
            String noHp = req.getParameter("noHp");

            if (nama == null || nama.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/profile?error=Nama tidak boleh kosong.");
                return;
            }

            boolean updated = userDAO.updateProfile(sessionUser.getId(), nama.trim(), noHp != null ? noHp.trim() : "");
            if (updated) {
                sessionUser.setNama(nama.trim());
                sessionUser.setNoHp(noHp != null ? noHp.trim() : "");
                session.setAttribute("user", sessionUser);
                resp.sendRedirect(req.getContextPath() + "/profile?success=Profil berhasil diperbarui.");
            } else {
                resp.sendRedirect(req.getContextPath() + "/profile?error=Gagal memperbarui profil.");
            }
        } else if ("/profile/password".equals(path)) {
            String currentPassword = req.getParameter("currentPassword");
            String newPassword = req.getParameter("newPassword");
            String confirmPassword = req.getParameter("confirmPassword");

            User dbUser = userDAO.findById(sessionUser.getId());
            if (!PasswordUtil.checkPassword(currentPassword, dbUser.getPassword())) {
                resp.sendRedirect(req.getContextPath() + "/profile?error=Password saat ini tidak sesuai.");
                return;
            }

            if (newPassword == null || newPassword.length() < 6) {
                resp.sendRedirect(req.getContextPath() + "/profile?error=Password baru minimal 6 karakter.");
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                resp.sendRedirect(req.getContextPath() + "/profile?error=Konfirmasi password baru tidak cocok.");
                return;
            }

            boolean updated = userDAO.updatePassword(sessionUser.getId(), PasswordUtil.hashPassword(newPassword));
            if (updated) {
                resp.sendRedirect(req.getContextPath() + "/profile?success=Password berhasil diganti.");
            } else {
                resp.sendRedirect(req.getContextPath() + "/profile?error=Gagal mengganti password.");
            }
        }
    }
}
