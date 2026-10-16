package com.esteh.controller;

import com.esteh.dao.ReviewDAO;
import com.esteh.model.Review;
import com.esteh.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ReviewServlet", urlPatterns = {"/review/submit"})
public class ReviewServlet extends HttpServlet {
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            Long productId = Long.parseLong(req.getParameter("productId"));
            int rating = Integer.parseInt(req.getParameter("rating"));
            String komentar = req.getParameter("komentar");

            if (rating < 1) rating = 1;
            if (rating > 5) rating = 5;

            // Cek duplikat: satu user hanya boleh satu ulasan per produk
            if (reviewDAO.hasUserReviewed(user.getId(), productId)) {
                String redirect = req.getParameter("redirect");
                String redirectUrl = (redirect != null && !redirect.trim().isEmpty())
                    ? req.getContextPath() + redirect
                    : req.getContextPath() + "/menu";
                resp.sendRedirect(redirectUrl + (redirectUrl.contains("?") ? "&" : "?") + "error=Anda sudah pernah memberikan ulasan untuk produk ini.");
                return;
            }

            Review review = new Review();
            review.setProductId(productId);
            review.setUserId(user.getId());
            review.setRating(rating);
            review.setKomentar(komentar);

            reviewDAO.createReview(review);

            String redirect = req.getParameter("redirect");
            if (redirect != null && !redirect.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + redirect + "?success=Terima kasih atas ulasan dan rating yang Anda berikan!");
            } else {
                resp.sendRedirect(req.getContextPath() + "/menu?success=Ulasan berhasil dikirim!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/menu?error=Gagal mengirim ulasan.");
        }
    }
}
