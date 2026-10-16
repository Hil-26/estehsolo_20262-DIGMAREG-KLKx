<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<header class="navbar">
    <div class="container navbar-container">
        <!-- Brand Logo -->
        <a href="${pageContext.request.contextPath}/" class="brand">
            <div class="brand-icon">🍃</div>
            <div class="brand-text">Es Teh <span>Solo</span></div>
        </a>

        <!-- Main Navigation Links -->
        <nav>
            <ul class="nav-menu">
                <li><a href="${pageContext.request.contextPath}/" class="nav-link ${pageContext.request.servletPath == '' || pageContext.request.servletPath == '/home' ? 'active' : ''}">Beranda</a></li>
                <li><a href="${pageContext.request.contextPath}/menu" class="nav-link ${pageContext.request.servletPath == '/menu' ? 'active' : ''}">Daftar Menu</a></li>
                <li><a href="${pageContext.request.contextPath}/about" class="nav-link ${pageContext.request.servletPath == '/about' ? 'active' : ''}">Tentang Kami</a></li>
                <li><a href="${pageContext.request.contextPath}/contact" class="nav-link ${pageContext.request.servletPath == '/contact' ? 'active' : ''}">Kontak</a></li>
                <c:if test="${not empty sessionScope.user}">
                    <li><a href="${pageContext.request.contextPath}/orders" class="nav-link ${pageContext.request.servletPath == '/orders' ? 'active' : ''}">Riwayat Pesanan</a></li>
                </c:if>
                <c:if test="${not empty sessionScope.user and sessionScope.user.admin}">
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link" style="color: #4CAF50; font-weight: 800;">⚡ Panel Admin</a></li>
                </c:if>
            </ul>
        </nav>

        <!-- Nav Actions: Cart & Auth -->
        <div class="nav-actions">
            <!-- Shopping Cart Button -->
            <a href="${pageContext.request.contextPath}/cart" class="cart-btn" title="Keranjang Belanja">
                🛒
                <span class="cart-count" style="${empty sessionScope.cart || sessionScope.cart.totalCount == 0 ? 'display:none;' : ''}">
                    ${not empty sessionScope.cart ? sessionScope.cart.totalCount : 0}
                </span>
            </a>

            <!-- Authentication State -->
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/profile" class="btn btn-secondary btn-sm" title="Profil Saya">
                        👤 ${sessionScope.user.nama}
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm" onclick="return confirm('Yakin ingin keluar?')">
                        Logout
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary btn-sm">
                        Masuk
                    </a>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-sm">
                        Daftar
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

<!-- Global Toast / Alert Messages -->
<c:if test="${not empty param.success}">
    <div class="container" style="margin-top: 16px;">
        <div class="alert alert-success alert-dismissible">
            <span>✅</span>
            <span><c:out value="${param.success}" /></span>
        </div>
    </div>
</c:if>

<c:if test="${not empty param.error}">
    <div class="container" style="margin-top: 16px;">
        <div class="alert alert-danger alert-dismissible">
            <span>⚠️</span>
            <span><c:out value="${param.error}" /></span>
        </div>
    </div>
</c:if>

<script>
    window.contextPath = '${pageContext.request.contextPath}';
</script>
