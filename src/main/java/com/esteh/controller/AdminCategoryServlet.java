package com.esteh.controller;

import com.esteh.dao.CategoryDAO;
import com.esteh.model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminCategoryServlet", urlPatterns = {
    "/admin/categories",
    "/admin/categories/save",
    "/admin/categories/delete"
})
public class AdminCategoryServlet extends HttpServlet {
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Category> categories = categoryDAO.getAllCategories();
        req.setAttribute("categories", categories);

        String editId = req.getParameter("editId");
        if (editId != null) {
            try {
                Category cat = categoryDAO.getCategoryById(Long.parseLong(editId));
                req.setAttribute("editCategory", cat);
            } catch (NumberFormatException ignore) {}
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/categories.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/admin/categories/delete".equals(path)) {
            String idParam = req.getParameter("id");
            if (idParam != null) {
                try {
                    categoryDAO.deleteCategory(Long.parseLong(idParam));
                    resp.sendRedirect(req.getContextPath() + "/admin/categories?success=Kategori berhasil dihapus.");
                    return;
                } catch (NumberFormatException ignore) {}
            }
            resp.sendRedirect(req.getContextPath() + "/admin/categories?error=Gagal menghapus kategori.");
            return;
        }

        // Save (Insert or Update)
        String idParam = req.getParameter("id");
        String namaKategori = req.getParameter("namaKategori");
        String deskripsi = req.getParameter("deskripsi");

        if (namaKategori == null || namaKategori.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/categories?error=Nama kategori wajib diisi.");
            return;
        }

        if (idParam != null && !idParam.trim().isEmpty()) {
            // Update
            Long id = Long.parseLong(idParam.trim());
            Category c = new Category(id, namaKategori.trim(), deskripsi != null ? deskripsi.trim() : "");
            categoryDAO.updateCategory(c);
            resp.sendRedirect(req.getContextPath() + "/admin/categories?success=Kategori berhasil diperbarui.");
        } else {
            // Insert
            Category c = new Category(null, namaKategori.trim(), deskripsi != null ? deskripsi.trim() : "");
            categoryDAO.createCategory(c);
            resp.sendRedirect(req.getContextPath() + "/admin/categories?success=Kategori baru berhasil ditambahkan.");
        }
    }
}
