<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<aside class="admin-sidebar">
    <div class="admin-sidebar-header">
        <div class="brand-icon">🍃</div>
        <div>
            <h3 style="font-size: 1.15rem; font-weight: 800; color: white;">Es Teh Solo</h3>
            <p style="font-size: 0.75rem; color: rgba(255,255,255,0.7); font-weight: 600;">Panel Administrator</p>
        </div>
    </div>

    <ul class="admin-menu">
        <li>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-menu-link ${pageContext.request.servletPath == '/admin/dashboard' || pageContext.request.servletPath == '/admin' ? 'active' : ''}">
                <span>📊</span> Dashboard
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/products" class="admin-menu-link ${pageContext.request.servletPath.startsWith('/admin/products') ? 'active' : ''}">
                <span>🍹</span> Kelola Produk
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/categories" class="admin-menu-link ${pageContext.request.servletPath.startsWith('/admin/categories') ? 'active' : ''}">
                <span>📑</span> Kelola Kategori
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/orders" class="admin-menu-link ${pageContext.request.servletPath.startsWith('/admin/orders') ? 'active' : ''}">
                <span>📦</span> Kelola Pesanan
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/users" class="admin-menu-link ${pageContext.request.servletPath.startsWith('/admin/users') ? 'active' : ''}">
                <span>👥</span> Kelola User
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/reports" class="admin-menu-link ${pageContext.request.servletPath.startsWith('/admin/reports') ? 'active' : ''}">
                <span>📈</span> Laporan Penjualan
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/reviews" class="admin-menu-link ${pageContext.request.servletPath.startsWith('/admin/reviews') ? 'active' : ''}">
                <span>⭐</span> Ulasan & Rating
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/contacts" class="admin-menu-link ${pageContext.request.servletPath.startsWith('/admin/contacts') ? 'active' : ''}">
                <span>📬</span> Pesan Masuk
                <c:if test="${not empty unreadContacts && unreadContacts > 0}">
                    <span class="badge badge-danger" style="margin-left: auto; font-size: 0.72rem; padding: 2px 7px; background-color: #ef4444; color: white; border-radius: 9999px;">${unreadContacts}</span>
                </c:if>
            </a>
        </li>
    </ul>

    <div style="padding-top: 24px; border-top: 1px solid rgba(255,255,255,0.15); display: flex; flex-direction: column; gap: 10px;">
        <a href="${pageContext.request.contextPath}/" class="btn btn-secondary btn-sm" style="width: 100%; justify-content: flex-start;">
            <span>🌐</span> Ke Website Utama
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger btn-sm" style="width: 100%; justify-content: flex-start;" onclick="return confirm('Keluar dari sesi Admin?')">
            <span>🚪</span> Keluar / Logout
        </a>
    </div>
</aside>

<script>
    window.contextPath = '${pageContext.request.contextPath}';
</script>
