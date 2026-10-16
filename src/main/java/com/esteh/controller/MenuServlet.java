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
import java.util.List;

@WebServlet(name = "MenuServlet", urlPatterns = {"/menu"})
public class MenuServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String categoryParam = req.getParameter("category");
        String searchParam = req.getParameter("q");

        Long categoryId = null;
        if (categoryParam != null && !categoryParam.trim().isEmpty()) {
            try {
                categoryId = Long.parseLong(categoryParam.trim());
            } catch (NumberFormatException ignore) {}
        }

        List<Product> products = productDAO.searchProducts(categoryId, searchParam, null);
        List<Category> categories = categoryDAO.getAllCategories();

        req.setAttribute("products", products);
        req.setAttribute("categories", categories);
        req.setAttribute("selectedCategory", categoryId);
        req.setAttribute("searchQuery", searchParam);

        req.getRequestDispatcher("/WEB-INF/views/user/menu.jsp").forward(req, resp);
    }
}
