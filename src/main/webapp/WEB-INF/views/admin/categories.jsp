<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Kategori - Es Teh Solo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

    <div class="admin-layout">
        <jsp:include page="/WEB-INF/views/admin/sidebar.jsp" />

        <main class="admin-main">
            <div class="admin-topbar">
                <div>
                    <h1 style="font-size: 1.8rem; font-weight: 800; color: var(--primary-dark);">Kategori Minuman</h1>
                    <p style="color: var(--text-secondary); font-size: 0.9rem;">Kelola kelompok menu minuman dan paket penjualan.</p>
                </div>
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

            <div style="display: grid; grid-template-columns: 1fr 1.6fr; gap: 32px; align-items: start;">
                <!-- Form Add / Edit Category -->
                <div style="background: white; border-radius: var(--radius-lg); padding: 28px; border: 1px solid var(--border); box-shadow: var(--shadow-sm);">
                    <h3 style="font-size: 1.2rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 20px;">
                        ${empty editCategory ? '+ Tambah Kategori Baru' : '✏️ Edit Kategori'}
                    </h3>

                    <form action="${pageContext.request.contextPath}/admin/categories/save" method="POST">
                        <input type="hidden" name="id" value="${editCategory.id}">

                        <div class="form-group">
                            <label class="form-label">Nama Kategori *</label>
                            <input type="text" name="namaKategori" class="form-control" placeholder="Contoh: Es Teh Buah Segar" value="${editCategory.namaKategori}" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Deskripsi Kategori</label>
                            <textarea name="deskripsi" class="form-control" rows="3" placeholder="Penjelasan singkat mengenai kelompok minuman ini...">${editCategory.deskripsi}</textarea>
                        </div>

                        <div style="display: flex; gap: 10px; margin-top: 20px;">
                            <c:if test="${not empty editCategory}">
                                <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-secondary">Batal</a>
                            </c:if>
                            <button type="submit" class="btn btn-primary" style="flex-grow: 1;">
                                ${empty editCategory ? 'Tambah Kategori' : 'Simpan Perubahan'}
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Categories Table -->
                <div class="table-card">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Nama Kategori</th>
                                    <th>Deskripsi</th>
                                    <th style="text-align: center;">Jumlah Produk</th>
                                    <th style="text-align: right;">Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="cat" items="${categories}">
                                    <tr>
                                        <td>#${cat.id}</td>
                                        <td>
                                            <strong style="color: var(--primary-dark);">${cat.namaKategori}</strong>
                                        </td>
                                        <td style="font-size: 0.85rem; color: var(--text-secondary); max-width: 250px;">
                                            ${cat.deskripsi}
                                        </td>
                                        <td style="text-align: center;">
                                            <span class="badge badge-default">${cat.productCount} produk</span>
                                        </td>
                                        <td style="text-align: right;">
                                            <div style="display: inline-flex; gap: 6px;">
                                                <a href="${pageContext.request.contextPath}/admin/categories?editId=${cat.id}" class="btn btn-secondary btn-sm" style="padding: 4px 8px;">
                                                    ✏️
                                                </a>
                                                <form action="${pageContext.request.contextPath}/admin/categories/delete" method="POST" onsubmit="return confirm('Hapus kategori ${cat.namaKategori}?');" style="display:inline;">
                                                    <input type="hidden" name="id" value="${cat.id}">
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
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
