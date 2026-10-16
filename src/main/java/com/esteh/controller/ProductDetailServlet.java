package com.esteh.controller;

import com.esteh.dao.ProductDAO;
import com.esteh.dao.ReviewDAO;
import com.esteh.model.Product;
import com.esteh.model.Review;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/product-detail"})
public class ProductDetailServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/menu");
            return;
        }

        try {
            Long id = Long.parseLong(idParam.trim());
            Product product = productDAO.getProductById(id);
            if (product == null) {
                resp.sendRedirect(req.getContextPath() + "/menu?error=Produk tidak ditemukan.");
                return;
            }

            List<Review> reviews = reviewDAO.getReviewsByProduct(id);
            List<Product> relatedProducts = productDAO.searchProducts(product.getCategoryId(), null, "Tersedia");

            req.setAttribute("product", product);
            req.setAttribute("reviews", reviews);
            req.setAttribute("relatedProducts", relatedProducts);

            req.getRequestDispatcher("/WEB-INF/views/user/product_detail.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/menu");
        }
    }
}
