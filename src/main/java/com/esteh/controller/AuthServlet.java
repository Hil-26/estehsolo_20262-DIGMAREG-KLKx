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

@WebServlet(name = "AuthServlet", urlPatterns = {"/login", "/register", "/logout"})
public class AuthServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/logout".equals(path)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/login?success=Anda berhasil logout.");
            return;
        }

        // Jika sudah login, redirect sesuai role
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if (user.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/");
            }
            return;
        }

        if ("/login".equals(path)) {
            req.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(req, resp);
        } else if ("/register".equals(path)) {
            req.getRequestDispatcher("/WEB-INF/views/user/register.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/login".equals(path)) {
            String email = req.getParameter("email");
            String password = req.getParameter("password");

            if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
                req.setAttribute("error", "Email dan password wajib diisi.");
                req.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(req, resp);
                return;
            }

            User user = userDAO.findByEmail(email.trim());
            if (user != null && PasswordUtil.checkPassword(password, user.getPassword())) {
                HttpSession session = req.getSession();
                session.setAttribute("user", user);

                String redirect = req.getParameter("redirect");
                if (redirect != null && redirect.startsWith("/") && !redirect.startsWith("//")) {
                    resp.sendRedirect(req.getContextPath() + redirect);
                    return;
                }

                if (user.isAdmin()) {
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/");
                }
            } else {
                req.setAttribute("error", "Email atau password yang Anda masukkan salah.");
                req.setAttribute("email", email);
                req.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(req, resp);
            }
        } else if ("/register".equals(path)) {
            String nama = req.getParameter("nama");
            String email = req.getParameter("email");
            String noHp = req.getParameter("noHp");
            String password = req.getParameter("password");
            String confirmPassword = req.getParameter("confirmPassword");

            if (nama == null || email == null || password == null ||
                nama.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
                req.setAttribute("error", "Semua kolom bertanda bintang wajib diisi.");
                req.getRequestDispatcher("/WEB-INF/views/user/register.jsp").forward(req, resp);
                return;
            }

            if (!password.equals(confirmPassword)) {
                req.setAttribute("error", "Konfirmasi password tidak cocok.");
                req.setAttribute("nama", nama);
                req.setAttribute("email", email);
                req.setAttribute("noHp", noHp);
                req.getRequestDispatcher("/WEB-INF/views/user/register.jsp").forward(req, resp);
                return;
            }

            if (userDAO.isEmailExists(email.trim())) {
                req.setAttribute("error", "Email sudah terdaftar. Silakan gunakan email lain atau login.");
                req.setAttribute("nama", nama);
                req.setAttribute("noHp", noHp);
                req.getRequestDispatcher("/WEB-INF/views/user/register.jsp").forward(req, resp);
                return;
            }

            User newUser = new User();
            newUser.setNama(nama.trim());
            newUser.setEmail(email.trim());
            newUser.setNoHp(noHp != null ? noHp.trim() : "");
            newUser.setPassword(PasswordUtil.hashPassword(password));
            newUser.setRole("user");

            boolean created = userDAO.createUser(newUser);
            if (created) {
                // Auto login after registration
                HttpSession session = req.getSession();
                session.setAttribute("user", newUser);
                resp.sendRedirect(req.getContextPath() + "/?success=Registrasi berhasil! Selamat datang di Es Teh Solo.");
            } else {
                req.setAttribute("error", "Gagal mendaftarkan akun. Silakan coba kembali.");
                req.getRequestDispatcher("/WEB-INF/views/user/register.jsp").forward(req, resp);
            }
        }
    }
}
