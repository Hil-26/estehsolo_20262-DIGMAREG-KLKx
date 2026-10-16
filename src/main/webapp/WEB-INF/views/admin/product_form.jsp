<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty product ? 'Tambah Produk Baru' : 'Edit Produk'} - Es Teh Solo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

    <div class="admin-layout">
        <jsp:include page="/WEB-INF/views/admin/sidebar.jsp" />

        <main class="admin-main">
            <div class="admin-topbar">
                <div>
                    <h1 style="font-size: 1.8rem; font-weight: 800; color: var(--primary-dark);">
                        ${empty product ? 'Tambah Produk Minuman' : 'Edit Produk Minuman'}
                    </h1>
                    <p style="color: var(--text-secondary); font-size: 0.9rem;">Lengkapi informasi detail produk minuman.</p>
                </div>

                <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary btn-sm">
                    ← Kembali ke Daftar Produk
                </a>
            </div>

            <div style="background: white; border-radius: var(--radius-lg); padding: 36px; border: 1px solid var(--border); box-shadow: var(--shadow-sm); max-width: 800px;">
                <form action="${pageContext.request.contextPath}/admin/products" method="POST">
                    <input type="hidden" name="id" value="${product.id}">

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div class="form-group">
                            <label class="form-label">Nama Minuman *</label>
                            <input type="text" name="namaProduk" class="form-control" placeholder="Contoh: Es Teh Kampul Solo" value="${product.namaProduk}" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Kategori Minuman *</label>
                            <select name="categoryId" class="form-control" required>
                                <option value="" disabled ${empty product.categoryId ? 'selected' : ''}>Pilih Kategori...</option>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.id}" ${product.categoryId == cat.id ? 'selected' : ''}>
                                        ${cat.namaKategori}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 20px;">
                        <div class="form-group">
                            <label class="form-label">Harga Jual (Rp) *</label>
                            <input type="number" name="harga" class="form-control" placeholder="Contoh: 8000" value="${product.harga}" step="500" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Jumlah Stok (Porsi) *</label>
                            <input type="number" name="stok" class="form-control" placeholder="Contoh: 100" value="${empty product ? 50 : product.stok}" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Status Ketersediaan *</label>
                            <select name="status" class="form-control" required>
                                <option value="Tersedia" ${product.status == 'Tersedia' || empty product ? 'selected' : ''}>Tersedia</option>
                                <option value="Habis" ${product.status == 'Habis' ? 'selected' : ''}>Habis</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Foto Produk Minuman</label>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                            <div>
                                <label style="font-size: 0.78rem; color: var(--text-secondary); margin-bottom: 4px; display: block;">Pilih Foto Bawaan:</label>
                                <select id="presetFoto" class="form-control" onchange="if(this.value) document.getElementById('fotoInput').value = this.value;">
                                    <option value="">-- Pilih dari Preset --</option>
                                    <option value="esteh_original.jpg">Es Teh Original</option>
                                    <option value="esteh_kampul.jpg">Es Teh Kampul Wedang</option>
                                    <option value="esteh_melati.jpg">Es Teh Melati Harum</option>
                                    <option value="esteh_susu.jpg">Es Teh Susu Creamy</option>
                                    <option value="esteh_lemon.jpg">Es Teh Lemon Segar</option>
                                    <option value="esteh_leci.jpg">Es Teh Leci Tropis</option>
                                    <option value="esteh_cincau.jpg">Es Teh Cincau Manis</option>
                                    <option value="paket_mantap.jpg">Paket Mantap</option>
                                    <option value="paket_guyub.jpg">Paket Guyub Mendoan</option>
                                </select>
                            </div>
                            <div>
                                <label style="font-size: 0.78rem; color: var(--text-secondary); margin-bottom: 4px; display: block;">Nama File / URL Foto *:</label>
                                <input type="text" id="fotoInput" name="foto" class="form-control" value="${empty product ? 'esteh_original.jpg' : product.foto}" required>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Deskripsi Minuman</label>
                        <textarea name="deskripsi" class="form-control" rows="4" placeholder="Jelaskan aroma, perpaduan rasa, dan sensasi kesegaran minuman ini...">${product.deskripsi}</textarea>
                    </div>

                    <div style="display: flex; justify-content: flex-end; gap: 12px; margin-top: 30px;">
                        <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary">Batal</a>
                        <button type="submit" class="btn btn-primary">
                            ${empty product ? 'Simpan Produk Baru' : 'Simpan Perubahan'}
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
