package com.esteh.controller;

import com.esteh.dao.CategoryDAO;
import com.esteh.dao.ProductDAO;
import com.esteh.model.Category;
import com.esteh.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "AdminProductServlet", urlPatterns = {
    "/admin/products",
    "/admin/products/add",
    "/admin/products/edit",
    "/admin/products/delete"
})
public class AdminProductServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/admin/products/add".equals(path)) {
            req.setAttribute("categories", categoryDAO.getAllCategories());
            req.getRequestDispatcher("/WEB-INF/views/admin/product_form.jsp").forward(req, resp);
        } else if ("/admin/products/edit".equals(path)) {
            String idParam = req.getParameter("id");
            if (idParam != null) {
                try {
                    Long id = Long.parseLong(idParam);
                    Product product = productDAO.getProductById(id);
                    if (product != null) {
                        req.setAttribute("product", product);
                        req.setAttribute("categories", categoryDAO.getAllCategories());
                        req.getRequestDispatcher("/WEB-INF/views/admin/product_form.jsp").forward(req, resp);
                        return;
                    }
                } catch (NumberFormatException ignore) {}
            }
            resp.sendRedirect(req.getContextPath() + "/admin/products?error=Produk tidak ditemukan.");
        } else {
            // List products
            String catParam = req.getParameter("category");
            String search = req.getParameter("q");
            Long catId = null;
            if (catParam != null && !catParam.trim().isEmpty()) {
                try {
                    catId = Long.parseLong(catParam.trim());
                } catch (NumberFormatException ignore) {}
            }
            List<Product> products = productDAO.searchProducts(catId, search, null);
            req.setAttribute("products", products);
            req.setAttribute("categories", categoryDAO.getAllCategories());
            req.setAttribute("selectedCategory", catId);
            req.setAttribute("searchQuery", search);
            req.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/admin/products/delete".equals(path)) {
            String idParam = req.getParameter("id");
            if (idParam != null) {
                try {
                    Long id = Long.parseLong(idParam);
                    boolean deleted = productDAO.deleteProduct(id);
                    if (deleted) {
                        resp.sendRedirect(req.getContextPath() + "/admin/products?success=Produk berhasil dihapus atau diperbarui.");
                        return;
                    }
                } catch (NumberFormatException ignore) {}
            }
            resp.sendRedirect(req.getContextPath() + "/admin/products?error=Gagal menghapus produk.");
            return;
        }

        // Add or Edit Product
        try {
            String idParam = req.getParameter("id");
            String namaProduk = req.getParameter("namaProduk");
            String categoryParam = req.getParameter("categoryId");
            String hargaParam = req.getParameter("harga");
            String stokParam = req.getParameter("stok");
            String deskripsi = req.getParameter("deskripsi");
            String foto = req.getParameter("foto");
            String status = req.getParameter("status");

            if (namaProduk == null || namaProduk.trim().isEmpty() || hargaParam == null || hargaParam.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/admin/products?error=Nama produk dan harga wajib diisi.");
                return;
            }

            Long catId = null;
            if (categoryParam != null && !categoryParam.trim().isEmpty()) {
                catId = Long.parseLong(categoryParam.trim());
            }

            BigDecimal harga = new BigDecimal(hargaParam.trim());
            int stok = 0;
            if (stokParam != null && !stokParam.trim().isEmpty()) {
                stok = Integer.parseInt(stokParam.trim());
            }

            if (status == null || status.trim().isEmpty()) {
                status = "Tersedia";
            }

            if (foto == null || foto.trim().isEmpty()) {
                foto = "esteh_original.jpg";
            }

            if (idParam != null && !idParam.trim().isEmpty()) {
                // Update
                Long id = Long.parseLong(idParam.trim());
                Product p = new Product(id, catId, namaProduk.trim(), deskripsi, harga, foto.trim(), stok, status);
                productDAO.updateProduct(p);
                resp.sendRedirect(req.getContextPath() + "/admin/products?success=Produk berhasil diperbarui.");
            } else {
                // Insert
                Product p = new Product(null, catId, namaProduk.trim(), deskripsi, harga, foto.trim(), stok, status);
                productDAO.createProduct(p);
                resp.sendRedirect(req.getContextPath() + "/admin/products?success=Produk baru berhasil ditambahkan.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/products?error=Terjadi kesalahan saat menyimpan data produk.");
        }
    }
}
