package com.esteh.controller;

import com.esteh.dao.OrderDAO;
import com.esteh.dao.ReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.esteh.model.Order;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminReportServlet", urlPatterns = {"/admin/reports", "/admin/reports/export-csv", "/admin/reviews", "/admin/reviews/delete"})
public class AdminReportServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/admin/reviews".equals(path)) {
            req.setAttribute("reviews", reviewDAO.getAllReviews());
            req.getRequestDispatcher("/WEB-INF/views/admin/reviews.jsp").forward(req, resp);
            return;
        }

        if ("/admin/reports/export-csv".equals(path)) {
            List<Order> orders = orderDAO.getAllOrders("Semua");
            resp.setContentType("text/csv; charset=UTF-8");
            resp.setHeader("Content-Disposition", "attachment; filename=\"laporan-penjualan-esteh-" + System.currentTimeMillis() + ".csv\"");

            PrintWriter writer = resp.getWriter();
            writer.write('\ufeff'); // UTF-8 BOM for Microsoft Excel compatibility
            writer.println("Nomor Pesanan,Waktu Pesan,Pelanggan,Total (Rp),Pengambilan,Metode Bayar,Status Bayar,Status Pesanan");
            for (Order o : orders) {
                String nama = (o.getUserName() != null) ? o.getUserName() : "-";
                String waktu = (o.getTanggalPesanan() != null) ? o.getTanggalPesanan().toString() : "-";
                String total = (o.getTotalHarga() != null) ? o.getTotalHarga().toString() : "0";
                String pengambilan = (o.getMetodePengambilan() != null) ? o.getMetodePengambilan() : "-";
                String bayar = (o.getMetodePembayaran() != null) ? o.getMetodePembayaran() : "-";
                String statusBayar = (o.getStatusPembayaran() != null) ? o.getStatusPembayaran() : "-";
                String statusPesanan = (o.getStatusPesanan() != null) ? o.getStatusPesanan() : "-";

                writer.printf("\"%s\",\"%s\",\"%s\",%s,\"%s\",\"%s\",\"%s\",\"%s\"%n",
                        o.getNomorPesanan(),
                        waktu,
                        nama.replace("\"", "\"\""),
                        total,
                        pengambilan,
                        bayar,
                        statusBayar,
                        statusPesanan
                );
            }
            writer.flush();
            return;
        }

        // Laporan Penjualan
        String startDate = req.getParameter("startDate");
        String endDate = req.getParameter("endDate");

        Map<String, Object> report = orderDAO.getSalesReport(startDate, endDate);
        List<Map<String, Object>> bestSellers = orderDAO.getBestSellingProducts(5);

        req.setAttribute("report", report);
        req.setAttribute("bestSellers", bestSellers);
        req.setAttribute("startDate", startDate);
        req.setAttribute("endDate", endDate);

        req.getRequestDispatcher("/WEB-INF/views/admin/reports.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/admin/reviews/delete".equals(path)) {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.trim().isEmpty()) {
                try {
                    Long reviewId = Long.parseLong(idParam.trim());
                    boolean deleted = reviewDAO.deleteReview(reviewId);
                    if (deleted) {
                        resp.sendRedirect(req.getContextPath() + "/admin/reviews?success=Ulasan berhasil dihapus.");
                        return;
                    }
                } catch (NumberFormatException ignore) {}
            }
            resp.sendRedirect(req.getContextPath() + "/admin/reviews?error=Gagal menghapus ulasan.");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/admin/reports");
    }
}
