package com.esteh.controller;

import com.esteh.dao.ContactDAO;
import com.esteh.model.Contact;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminContactServlet", urlPatterns = {
    "/admin/contacts",
    "/admin/contacts/status",
    "/admin/contacts/delete"
})
public class AdminContactServlet extends HttpServlet {
    private final ContactDAO contactDAO = new ContactDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String statusFilter = req.getParameter("status");
        if (statusFilter == null || statusFilter.trim().isEmpty()) {
            statusFilter = "Semua";
        }

        List<Contact> contacts = contactDAO.getAllContacts(statusFilter);
        int unreadCount = contactDAO.countUnreadContacts();

        req.setAttribute("contacts", contacts);
        req.setAttribute("selectedStatus", statusFilter);
        req.setAttribute("unreadCount", unreadCount);

        req.getRequestDispatcher("/WEB-INF/views/admin/contacts.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/admin/contacts/status".equals(path)) {
            String idParam = req.getParameter("id");
            String newStatus = req.getParameter("newStatus");
            if (idParam != null && newStatus != null) {
                try {
                    Long id = Long.parseLong(idParam.trim());
                    contactDAO.updateStatus(id, newStatus.trim());
                    resp.sendRedirect(req.getContextPath() + "/admin/contacts?success=Status pesan berhasil diperbarui menjadi " + newStatus);
                    return;
                } catch (NumberFormatException ignore) {}
            }
            resp.sendRedirect(req.getContextPath() + "/admin/contacts?error=Gagal memperbarui status pesan.");
        } else if ("/admin/contacts/delete".equals(path)) {
            String idParam = req.getParameter("id");
            if (idParam != null) {
                try {
                    Long id = Long.parseLong(idParam.trim());
                    contactDAO.deleteContact(id);
                    resp.sendRedirect(req.getContextPath() + "/admin/contacts?success=Pesan berhasil dihapus.");
                    return;
                } catch (NumberFormatException ignore) {}
            }
            resp.sendRedirect(req.getContextPath() + "/admin/contacts?error=Gagal menghapus pesan.");
        }
    }
}
