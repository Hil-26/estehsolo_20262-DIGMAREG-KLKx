package com.esteh.controller;

import com.esteh.dao.CategoryDAO;
import com.esteh.dao.ProductDAO;
import com.esteh.dao.ReviewDAO;
import com.esteh.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeServlet", urlPatterns = {"", "/home"})
public class HomeServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Product> featuredProducts = productDAO.getFeaturedProducts(6);
        req.setAttribute("featuredProducts", featuredProducts);
        req.setAttribute("categories", categoryDAO.getAllCategories());
        req.setAttribute("reviews", reviewDAO.getAllReviews());

        req.getRequestDispatcher("/WEB-INF/views/user/index.jsp").forward(req, resp);
    }
}
