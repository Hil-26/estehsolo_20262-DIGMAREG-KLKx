package com.esteh.controller;

import com.esteh.dao.ContactDAO;
import com.esteh.model.Contact;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "AboutContactServlet", urlPatterns = {"/about", "/contact", "/contact/send"})
public class AboutContactServlet extends HttpServlet {
    private final ContactDAO contactDAO = new ContactDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/about".equals(path)) {
            req.getRequestDispatcher("/WEB-INF/views/user/about.jsp").forward(req, resp);
        } else if ("/contact".equals(path)) {
            req.getRequestDispatcher("/WEB-INF/views/user/contact.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String nama = req.getParameter("nama");
        String kontak = req.getParameter("kontak");
        String pesan = req.getParameter("pesan");

        if (nama == null || pesan == null || nama.trim().isEmpty() || pesan.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/contact?error=Nama dan isi pesan wajib diisi.");
            return;
        }

        Contact contact = new Contact();
        contact.setNama(nama.trim());
        contact.setKontak(kontak != null && !kontak.trim().isEmpty() ? kontak.trim() : "-");
        contact.setPesan(pesan.trim());
        contact.setStatus("Baru");

        boolean saved = contactDAO.createContact(contact);
        if (saved) {
            resp.sendRedirect(req.getContextPath() + "/contact?success=Terima kasih " + nama.trim() + "! Pesan dan saran Anda telah tersimpan dan akan segera ditindaklanjuti tim kami.");
        } else {
            resp.sendRedirect(req.getContextPath() + "/contact?error=Terjadi kendala saat mengirim pesan. Silakan coba kembali.");
        }
    }
}
