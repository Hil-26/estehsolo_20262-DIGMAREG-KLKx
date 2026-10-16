package com.esteh.util;

import com.esteh.model.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*", "/checkout", "/orders", "/profile", "/order-detail", "/review/submit"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = uri.substring(contextPath.length());

        // Check Admin routes
        if (path.startsWith("/admin")) {
            if (currentUser == null) {
                res.sendRedirect(contextPath + "/login?error=Silakan login terlebih dahulu untuk mengakses menu admin.");
                return;
            }
            if (!currentUser.isAdmin()) {
                res.sendRedirect(contextPath + "/?error=Akses ditolak. Anda bukan Administrator.");
                return;
            }
        }

        // Check Customer protected routes
        if (path.startsWith("/checkout") || path.startsWith("/orders") || path.startsWith("/profile") || path.startsWith("/order-detail") || path.startsWith("/review/submit")) {
            if (currentUser == null) {
                String query = req.getQueryString();
                String targetPath = (query != null && !query.trim().isEmpty()) ? path + "?" + query : path;
                String encodedTarget = java.net.URLEncoder.encode(targetPath, java.nio.charset.StandardCharsets.UTF_8);
                res.sendRedirect(contextPath + "/login?redirect=" + encodedTarget + "&error=" + java.net.URLEncoder.encode("Silakan login terlebih dahulu untuk melanjutkan pesanan Anda.", java.nio.charset.StandardCharsets.UTF_8));
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
