<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Es Teh Solo - Segarnya Tradisi Teh Nusantara</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

    <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

    <!-- HERO SECTION -->
    <section class="hero">
        <div class="container">
            <div class="hero-grid">
                <div>
                    <div class="hero-badge">
                        <span>🍃</span> Racikan Khas Wasgitel Asli Solo
                    </div>
                    <h1 class="hero-title">
                        Segarnya Tradisi, <br>
                        <span>Cita Rasa Otentik</span> Solo
                    </h1>
                    <p class="hero-desc">
                        Nikmati kelezatan es teh manis racikan tradisional Solo dengan aroma wangi melati, rasa sepet legit, dan dingin menyejukkan dahaga Anda setiap saat.
                    </p>
                    <div class="hero-actions">
                        <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary btn-lg">
                            <span>🛒</span> Pesan Sekarang
                        </a>
                        <a href="#menu-favorit" class="btn btn-secondary btn-lg">
                            Lihat Menu Favorit
                        </a>
                    </div>
                    <div class="hero-stats">
                        <div class="hero-stat">
                            <h3>100%</h3>
                            <p>Daun Teh Pilihan</p>
                        </div>
                        <div class="hero-stat">
                            <h3>5.000+</h3>
                            <p>Gelas Terjual</p>
                        </div>
                        <div class="hero-stat">
                            <h3>4.9 ⭐</h3>
                            <p>Rating Pelanggan</p>
                        </div>
                    </div>
                </div>

                <div class="hero-image-wrapper">
                    <div class="hero-image-card">
                        <img src="${pageContext.request.contextPath}/assets/images/esteh_original.jpg" alt="Es Teh Solo Jumbo">
                    </div>
                    <div class="hero-floating-badge">
                        <span style="font-size: 2rem;">🏆</span>
                        <div>
                            <h4 style="font-size: 0.95rem; font-weight: 800; color: var(--primary-dark);">Paling Diminati</h4>
                            <p style="font-size: 0.8rem; color: var(--text-secondary);">Es Teh Kampul Khas Solo</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- SECTION: KEUNGGULAN -->
    <section class="section" style="background: var(--white);">
        <div class="container">
            <div class="section-header">
                <span class="section-tag">Kenapa Harus Es Teh Solo?</span>
                <h2 class="section-title">Kualitas Rasa yang Selalu Terjaga</h2>
                <p class="section-subtitle">Kami memadukan resep turun temurun dengan standar kebersihan modern.</p>
            </div>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 30px;">
                <div style="background: var(--cream-light); padding: 32px; border-radius: var(--radius-lg); text-align: center; border: 1px solid var(--primary-light);">
                    <div style="font-size: 2.5rem; margin-bottom: 16px;">🌱</div>
                    <h3 style="font-size: 1.25rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 10px;">Wasgitel Otentik</h3>
                    <p style="font-size: 0.92rem; color: var(--text-secondary); line-height: 1.6;">
                        Wangi, Sepet, Legi, lan Kenthel. Racikan pas yang membuat setiap tegukan berkesan.
                    </p>
                </div>

                <div style="background: var(--cream-light); padding: 32px; border-radius: var(--radius-lg); text-align: center; border: 1px solid var(--primary-light);">
                    <div style="font-size: 2.5rem; margin-bottom: 16px;">🧊</div>
                    <h3 style="font-size: 1.25rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 10px;">Es Kristal Higienis</h3>
                    <p style="font-size: 0.92rem; color: var(--text-secondary); line-height: 1.6;">
                        Menggunakan es batu kristal dari air matang terfiltrasi standar pangan nasional.
                    </p>
                </div>

                <div style="background: var(--cream-light); padding: 32px; border-radius: var(--radius-lg); text-align: center; border: 1px solid var(--primary-light);">
                    <div style="font-size: 2.5rem; margin-bottom: 16px;">⚡</div>
                    <h3 style="font-size: 1.25rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 10px;">Pesan Cepat & Praktis</h3>
                    <p style="font-size: 0.92rem; color: var(--text-secondary); line-height: 1.6;">
                        Pesan online tanpa antre lama. Pilih Takeaway atau Dine-in dan pantau status pesanan langsung.
                    </p>
                </div>
            </div>
        </div>
    </section>

    <!-- SECTION: MENU FAVORIT -->
    <section class="section" id="menu-favorit">
        <div class="container">
            <div class="section-header">
                <span class="section-tag">Pilihan Terbaik</span>
                <h2 class="section-title">Menu Favorit Pelanggan</h2>
                <p class="section-subtitle">Varian minuman paling laris dengan racikan segar yang siap memanjakan lidah Anda.</p>
            </div>

            <div class="products-grid">
                <c:forEach var="p" items="${featuredProducts}">
                    <div class="product-card">
                        <div class="product-img-wrapper">
                            <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}" title="Lihat Detail ${p.namaProduk}">
                                <img src="${pageContext.request.contextPath}/assets/images/${p.foto}" alt="${p.namaProduk}" onerror="this.src='${pageContext.request.contextPath}/assets/images/esteh_original.jpg'">
                            </a>
                            <div class="product-status-tag">
                                <c:choose>
                                    <c:when test="${p.available}">
                                        <span class="badge badge-success">Tersedia</span>
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
                            </div>

                            <div class="product-footer">
                                <div class="product-price">
                                    Rp <fmt:formatNumber value="${p.harga}" type="number" groupingUsed="true"/>
                                </div>
                                <div style="display: flex; gap: 6px; align-items: center;">
                                    <c:if test="${p.available}">
                                        <button class="btn btn-primary btn-sm btn-add-cart-ajax"
                                                data-product-id="${p.id}"
                                                data-product-name="${p.namaProduk}"
                                                title="Tambah ke keranjang">
                                            + Keranjang
                                        </button>
                                        <a href="https://wa.me/6289515256232?text=Halo%20Admin%20Es%20Teh%20Solo,%20saya%20ingin%20memesan%20minuman%20*${p.namaProduk}*%20(Rp%20<fmt:formatNumber value="${p.harga}" groupingUsed="true"/>).%20Apakah%20bisa%20dipesan%20sekarang?"
                                           target="_blank"
                                           class="btn-wa-icon"
                                           title="Pesan via WhatsApp (0895-1525-6232)">
                                            <span>💬</span> WA
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div style="text-align: center; margin-top: 48px;">
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary btn-lg">
                    Lihat Semua Menu Lengkap →
                </a>
            </div>
        </div>
    </section>

    <!-- SECTION: ULASAN PELANGGAN -->
    <section class="section" style="background: var(--white);">
        <div class="container">
            <div class="section-header">
                <span class="section-tag">Kata Mereka</span>
                <h2 class="section-title">Apa Kata Pecinta Es Teh Solo?</h2>
                <p class="section-subtitle">Ulasan asli dari para pelanggan setia kami yang telah merasakan kenikmatannya.</p>
            </div>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 24px;">
                <c:forEach var="rev" items="${reviews}" begin="0" end="3">
                    <div style="background: var(--cream-light); padding: 26px; border-radius: var(--radius-md); border: 1px solid var(--border);">
                        <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 12px;">
                            <h4 style="font-weight: 800; color: var(--primary-dark); font-size: 1rem;">${rev.userName}</h4>
                            <div style="color: #F59E0B; font-size: 0.9rem;">
                                <c:forEach begin="1" end="${rev.rating}">⭐</c:forEach>
                            </div>
                        </div>
                        <p style="font-size: 0.82rem; font-weight: 700; color: var(--primary); margin-bottom: 8px;">
                            ${rev.productName}
                        </p>
                        <p style="font-size: 0.9rem; color: var(--text-secondary); line-height: 1.5; font-style: italic;">
                            "${rev.komentar}"
                        </p>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
