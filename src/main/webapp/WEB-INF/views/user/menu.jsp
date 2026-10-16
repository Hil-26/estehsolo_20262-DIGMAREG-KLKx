<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daftar Menu - Es Teh Solo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

    <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

    <section class="section" style="padding-top: 40px;">
        <div class="container">
            <div class="section-header" style="margin-bottom: 32px;">
                <span class="section-tag">Pilihan Minuman Segar</span>
                <h1 class="section-title">Daftar Menu Es Teh Solo</h1>
                <p class="section-subtitle">Pilih varian rasa favorit Anda dan pesan secara online dengan mudah.</p>
            </div>

            <!-- SEARCH AND CATEGORY FILTER -->
            <div class="filter-bar">
                <div class="search-input-wrapper">
                    <span class="search-icon">🔍</span>
                    <input type="text" id="menuSearchInput" class="search-input"
                           placeholder="Cari minuman favorit (contoh: kampul, susu, lemon)..."
                           value="${searchQuery}">
                </div>

                <div class="category-pills" style="margin-bottom: 0;">
                    <a href="${pageContext.request.contextPath}/menu"
                       class="cat-pill ${empty selectedCategory ? 'active' : ''}">
                        Semua Kategori
                    </a>
                    <c:forEach var="cat" items="${categories}">
                        <a href="${pageContext.request.contextPath}/menu?category=${cat.id}"
                           class="cat-pill ${selectedCategory == cat.id ? 'active' : ''}">
                            ${cat.namaKategori}
                        </a>
                    </c:forEach>
                </div>
            </div>

            <!-- PRODUCTS GRID -->
            <c:choose>
                <c:when test="${empty products}">
                    <div style="text-align: center; padding: 60px 20px; background: white; border-radius: var(--radius-lg); border: 1px solid var(--border);">
                        <div style="font-size: 3rem; margin-bottom: 12px;">🍃</div>
                        <h3 style="font-size: 1.3rem; color: var(--primary-dark); margin-bottom: 8px;">Tidak Ada Minuman yang Ditemukan</h3>
                        <p style="color: var(--text-secondary); margin-bottom: 20px;">Coba gunakan kata kunci pencarian yang lain atau pilih kategori Semua.</p>
                        <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary">Lihat Semua Menu</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="products-grid">
                        <c:forEach var="p" items="${products}">
                            <div class="product-card" data-name="${p.namaProduk}" data-desc="${p.deskripsi}">
                                <div class="product-img-wrapper">
                                    <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}" title="Lihat Detail ${p.namaProduk}">
                                        <img src="${pageContext.request.contextPath}/assets/images/${p.foto}" alt="${p.namaProduk}" onerror="this.src='${pageContext.request.contextPath}/assets/images/esteh_original.jpg'">
                                    </a>
                                    <div class="product-status-tag">
                                        <c:choose>
                                            <c:when test="${p.available}">
                                                <span class="badge badge-success">Tersedia (Stok: ${p.stok})</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-danger">Habis</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="product-body">
                                    <span class="product-category-name">${p.categoryName}</span>
                                    <h3 class="product-title">
                                        <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}" style="color: inherit;">
                                            ${p.namaProduk}
                                        </a>
                                    </h3>
                                    <p class="product-desc">${p.deskripsi}</p>

                                    <div class="product-rating">
                                        <span>⭐ <fmt:formatNumber value="${p.averageRating}" maxFractionDigits="1" minFractionDigits="1"/></span>
                                        <span style="color: var(--text-secondary); font-weight: normal; font-size: 0.8rem;">(${p.reviewCount} ulasan)</span>

                                        <c:if test="${not empty sessionScope.user}">
                                            <button type="button"
                                                    onclick="openReviewModal('${p.id}', '${p.namaProduk}')"
                                                    style="background:none; border:none; color: var(--primary-dark); font-size: 0.78rem; text-decoration: underline; cursor: pointer; margin-left: auto;">
                                                + Beri Nilai
                                            </button>
                                        </c:if>
                                    </div>

                                    <div class="product-footer">
                                        <div class="product-price">
                                            Rp <fmt:formatNumber value="${p.harga}" type="number" groupingUsed="true"/>
                                        </div>
                                        <div style="display: flex; gap: 6px; align-items: center;">
                                            <c:choose>
                                                <c:when test="${p.available}">
                                                    <button class="btn btn-primary btn-sm btn-add-cart-ajax"
                                                            data-product-id="${p.id}"
                                                            data-product-name="${p.namaProduk}"
                                                            title="Masukkan ke keranjang belanja">
                                                        + Keranjang
                                                    </button>
                                                    <a href="https://wa.me/6289515256232?text=Halo%20Admin%20Es%20Teh%20Solo,%20saya%20ingin%20memesan%20minuman%20*${p.namaProduk}*%20(Rp%20<fmt:formatNumber value="${p.harga}" groupingUsed="true"/>).%20Apakah%20bisa%20dipesan%20sekarang?"
                                                       target="_blank"
                                                       class="btn-wa-icon"
                                                       title="Pesan via WhatsApp (0895-1525-6232)">
                                                        <span>💬</span> WA
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn btn-secondary btn-sm" disabled style="opacity: 0.6; cursor: not-allowed;">
                                                        Habis
                                                    </button>
                                                    <a href="https://wa.me/6289515256232?text=Halo%20Admin%20Es%20Teh%20Solo,%20apakah%20menu%20*${p.namaProduk}*%20akan%20segera%20tersedia%20kembali?"
                                                       target="_blank"
                                                       class="btn-wa-icon"
                                                       title="Tanya ketersediaan via WhatsApp (0895-1525-6232)">
                                                        <span>💬</span> Tanya
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <!-- REVIEW MODAL -->
    <div id="reviewModal" class="modal-overlay">
        <div class="modal-content">
            <button class="modal-close" onclick="closeReviewModal()">✕</button>
            <h3 style="font-size: 1.3rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 6px;">
                Beri Ulasan Minuman
            </h3>
            <p id="modalProductName" style="color: var(--primary); font-weight: 700; margin-bottom: 20px;">
                Nama Minuman
            </p>

            <form action="${pageContext.request.contextPath}/review/submit" method="POST">
                <input type="hidden" name="productId" id="modalProductId">
                <input type="hidden" name="rating" id="modalRatingInput" value="5">
                <input type="hidden" name="redirect" value="/menu">

                <div class="form-group text-center">
                    <label class="form-label">Rating Kepuasan</label>
                    <div style="font-size: 2rem; display: flex; justify-content: center; gap: 8px; cursor: pointer;">
                        <span class="star-btn" data-value="1" style="color: #F59E0B;">⭐</span>
                        <span class="star-btn" data-value="2" style="color: #F59E0B;">⭐</span>
                        <span class="star-btn" data-value="3" style="color: #F59E0B;">⭐</span>
                        <span class="star-btn" data-value="4" style="color: #F59E0B;">⭐</span>
                        <span class="star-btn" data-value="5" style="color: #F59E0B;">⭐</span>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Komentar / Pengalaman Rasa</label>
                    <textarea name="komentar" class="form-control" rows="4" placeholder="Ceritakan bagaimana kesegaran dan cita rasa minuman ini..." required></textarea>
                </div>

                <div style="display: flex; justify-content: flex-end; gap: 12px; margin-top: 24px;">
                    <button type="button" class="btn btn-secondary" onclick="closeReviewModal()">Batal</button>
                    <button type="submit" class="btn btn-primary">Kirim Ulasan</button>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
