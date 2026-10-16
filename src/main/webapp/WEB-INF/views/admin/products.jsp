<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Produk Minuman - Es Teh Solo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

    <div class="admin-layout">
        <jsp:include page="/WEB-INF/views/admin/sidebar.jsp" />

        <main class="admin-main">
            <div class="admin-topbar">
                <div>
                    <h1 style="font-size: 1.8rem; font-weight: 800; color: var(--primary-dark);">Daftar Produk Minuman</h1>
                    <p style="color: var(--text-secondary); font-size: 0.9rem;">Kelola varian rasa, harga, stok, dan status ketersediaan.</p>
                </div>

                <a href="${pageContext.request.contextPath}/admin/products/add" class="btn btn-primary">
                    + Tambah Produk Baru
                </a>
            </div>

            <!-- Global Alerts -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible">
                    <span>✅</span> <span><c:out value="${param.success}" /></span>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible">
                    <span>⚠️</span> <span><c:out value="${param.error}" /></span>
                </div>
            </c:if>

            <!-- Search & Filter Bar for Admin -->
            <div style="background: white; border-radius: var(--radius-md); padding: 18px 24px; border: 1px solid var(--border); box-shadow: var(--shadow-sm); margin-bottom: 24px;">
                <form action="${pageContext.request.contextPath}/admin/products" method="GET" style="display: flex; gap: 16px; align-items: center; flex-wrap: wrap;">
                    <div style="flex-grow: 1; min-width: 240px;">
                        <input type="text" name="q" class="form-control" placeholder="Cari nama atau deskripsi minuman..." value="${searchQuery}" style="padding: 10px 16px;">
                    </div>
                    <div>
                        <select name="category" class="form-control" style="padding: 10px 16px;">
                            <option value="">Semua Kategori</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.id}" ${selectedCategory == cat.id ? 'selected' : ''}>
                                    ${cat.namaKategori}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-secondary btn-sm" style="padding: 10px 18px;">
                        🔍 Filter
                    </button>
                    <c:if test="${not empty searchQuery || not empty selectedCategory}">
                        <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline btn-sm" style="padding: 10px 18px;">
                            Reset
                        </a>
                    </c:if>
                </form>
            </div>

            <!-- Table Card -->
            <div class="table-card">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Foto</th>
                                <th>Nama Minuman</th>
                                <th>Kategori</th>
                                <th>Harga</th>
                                <th>Stok</th>
                                <th>Status</th>
                                <th style="text-align: right;">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${products}">
                                <tr>
                                    <td style="width: 70px;">
                                        <img src="${pageContext.request.contextPath}/assets/images/${p.foto}"
                                             alt="${p.namaProduk}"
                                             style="width: 52px; height: 52px; object-fit: cover; border-radius: 8px;"
                                             onerror="this.src='${pageContext.request.contextPath}/assets/images/esteh_original.jpg'">
                                    </td>
                                    <td>
                                        <strong style="color: var(--dark); font-size: 0.95rem;">${p.namaProduk}</strong>
                                        <div style="font-size: 0.8rem; color: var(--text-secondary); max-width: 320px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                                            ${p.deskripsi}
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge badge-default">${p.categoryName}</span>
                                    </td>
                                    <td style="font-weight: 700; color: var(--primary-dark);">
                                        Rp <fmt:formatNumber value="${p.harga}" type="number" groupingUsed="true"/>
                                    </td>
                                    <td>
                                        <span style="font-weight: 700; ${p.stok <= 5 ? 'color: var(--danger);' : ''}">${p.stok} porsi</span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.status == 'Tersedia'}">
                                                <span class="badge badge-success">Tersedia</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-danger">Habis</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align: right;">
                                        <div style="display: inline-flex; gap: 8px;">
                                            <a href="${pageContext.request.contextPath}/admin/products/edit?id=${p.id}" class="btn btn-secondary btn-sm">
                                                ✏️ Edit
                                            </a>
                                            <form action="${pageContext.request.contextPath}/admin/products/delete" method="POST" onsubmit="return confirm('Apakah Anda yakin ingin menghapus produk ini?');" style="display:inline;">
                                                <input type="hidden" name="id" value="${p.id}">
                                                <button type="submit" class="btn btn-danger btn-sm" style="padding: 4px 8px;">
                                                    🗑️
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
