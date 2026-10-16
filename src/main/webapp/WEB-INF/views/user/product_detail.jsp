<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.namaProduk} - Es Teh Solo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

    <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

    <section class="section" style="padding-top: 32px;">
        <div class="container">
            <div style="margin-bottom: 24px;">
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-secondary btn-sm">
                    ← Kembali ke Daftar Menu
                </a>
            </div>

            <c:if test="${not empty param.success}">
                <div style="background: #f0fdf4; border: 1.5px solid #86efac; border-radius: var(--radius-md); padding: 18px 24px; margin-bottom: 24px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 14px; box-shadow: var(--shadow-sm);">
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <span style="font-size: 1.6rem;">🎉</span>
                        <div>
                            <strong style="color: #166534; font-size: 1rem; display: block;">Berhasil Masuk Keranjang!</strong>
                            <span style="color: #15803d; font-size: 0.88rem;"><c:out value="${param.success}" /></span>
                        </div>
                    </div>
                    <div style="display: flex; gap: 10px;">
                        <a href="${pageContext.request.contextPath}/cart" class="btn btn-primary btn-sm">
                            🛒 Buka Keranjang Belanja →
                        </a>
                        <a href="${pageContext.request.contextPath}/menu" class="btn btn-secondary btn-sm">
                            Lihat Menu Lain
                        </a>
                    </div>
                </div>
            </c:if>

            <!-- Product Detail Card Grid -->
            <div style="display: grid; grid-template-columns: 1fr 1.2fr; gap: 40px; background: white; border-radius: var(--radius-lg); padding: 40px; border: 1px solid var(--border); box-shadow: var(--shadow-sm); margin-bottom: 48px; align-items: start;">
                <!-- Product Image -->
                <div style="border-radius: var(--radius-md); overflow: hidden; border: 1px solid var(--border-light); box-shadow: var(--shadow-md);">
                    <img src="${pageContext.request.contextPath}/assets/images/${product.foto}"
                         alt="${product.namaProduk}"
                         style="width: 100%; height: 420px; object-fit: cover;"
                         onerror="this.src='${pageContext.request.contextPath}/assets/images/esteh_original.jpg'">
                </div>

                <!-- Product Info & Purchase Form -->
                <div>
                    <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 8px;">
                        <span class="badge badge-default" style="font-size: 0.85rem;">${product.categoryName}</span>
                        <c:choose>
                            <c:when test="${product.available}">
                                <span class="badge badge-success">Tersedia (Sisa ${product.stok} porsi)</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-danger">Stok Habis</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <h1 style="font-size: 2.2rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 12px; line-height: 1.2;">
                        ${product.namaProduk}
                    </h1>

                    <!-- Rating summary -->
                    <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 20px; font-size: 0.95rem;">
                        <span style="color: #F59E0B; font-weight: 800;">⭐ <fmt:formatNumber value="${product.averageRating}" maxFractionDigits="1" minFractionDigits="1"/></span>
                        <span style="color: var(--text-secondary);">&bull;</span>
                        <span style="color: var(--text-secondary);">${product.reviewCount} ulasan pelanggan</span>
                    </div>

                    <div style="font-size: 1.8rem; font-weight: 800; color: var(--primary); margin-bottom: 24px; padding-bottom: 16px; border-bottom: 1px solid var(--border-light);">
                        Rp <fmt:formatNumber value="${product.harga}" type="number" groupingUsed="true"/>
                    </div>

                    <div style="margin-bottom: 28px;">
                        <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--primary-dark); margin-bottom: 8px; text-transform: uppercase; letter-spacing: 0.05em;">
                            Deskripsi Minuman:
                        </h4>
                        <p style="font-size: 1rem; color: var(--text-secondary); line-height: 1.7;">
                            ${product.deskripsi}
                        </p>
                    </div>

                    <c:choose>
                        <c:when test="${product.available}">
                            <form action="${pageContext.request.contextPath}/cart" method="POST">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="productId" value="${product.id}">
                                <input type="hidden" name="redirect" value="/product-detail?id=${product.id}">

                                <!-- Customization Options -->
                                <div style="background: #f8fafc; border: 1px solid var(--border-light); border-radius: var(--radius-md); padding: 18px; margin-bottom: 20px;">
                                    <h4 style="font-size: 0.9rem; font-weight: 700; color: var(--primary-dark); margin-bottom: 12px;">
                                        ✨ Kustomisasi Racikan Minuman:
                                    </h4>
                                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-bottom: 12px;">
                                        <div>
                                            <label style="font-size: 0.82rem; font-weight: 700; color: var(--dark); margin-bottom: 4px; display: block;">Level Gula (Sugar):</label>
                                            <select name="sugarLevel" class="form-control" style="font-size: 0.88rem; padding: 8px 12px;">
                                                <option value="Normal">Normal (Manis Solo 100%)</option>
                                                <option value="Less Sugar">Less Sugar (Manis Sedang 50%)</option>
                                                <option value="Slight Sugar">Slight Sugar (Sedikit 25%)</option>
                                                <option value="No Sugar">Tanpa Gula / Tawar (0%)</option>
                                            </select>
                                        </div>
                                        <div>
                                            <label style="font-size: 0.82rem; font-weight: 700; color: var(--dark); margin-bottom: 4px; display: block;">Level Es (Ice):</label>
                                            <select name="iceLevel" class="form-control" style="font-size: 0.88rem; padding: 8px 12px;">
                                                <option value="Normal">Normal Ice (Segar Dingin)</option>
                                                <option value="Less Ice">Less Ice (Sedikit Es)</option>
                                                <option value="No Ice">No Ice (Tanpa Es)</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div>
                                        <label style="font-size: 0.82rem; font-weight: 700; color: var(--dark); margin-bottom: 4px; display: block;">Catatan Tambahan:</label>
                                        <input type="text" name="notes" class="form-control" placeholder="Contoh: minta sedotan ekstra, jangan terlalu manis..." style="font-size: 0.85rem; padding: 8px 12px;">
                                    </div>
                                </div>

                                <div style="display: flex; gap: 14px; align-items: center; flex-wrap: wrap;">
                                    <div style="display: flex; align-items: center; gap: 8px;">
                                        <label style="font-weight: 700; font-size: 0.9rem; color: var(--dark);">Jumlah:</label>
                                        <input type="number" name="quantity" value="1" min="1" max="${product.stok}" class="form-control" style="width: 80px; text-align: center; font-weight: 800; padding: 10px;">
                                    </div>

                                    <button type="submit" class="btn btn-primary btn-lg" style="flex: 1; min-width: 180px;">
                                        🛒 Tambah ke Keranjang
                                    </button>

                                    <a href="https://wa.me/6289515256232?text=Halo%20Admin%20Es%20Teh%20Solo,%20saya%20tertarik%20memesan%20*${product.namaProduk}*%20(Rp%20<fmt:formatNumber value="${product.harga}" groupingUsed="true"/>).%20Bisa%20bantu%20proses%20pemesanan%20lewat%20WhatsApp?"
                                       target="_blank"
                                       class="btn btn-whatsapp btn-lg"
                                       style="flex: 1; min-width: 180px; text-decoration: none;"
                                       title="Pesan langsung lewat WhatsApp ke 0895-1525-6232">
                                        <span>💬</span> Pesan via WhatsApp
                                    </a>
                                </div>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-danger" style="margin-bottom: 16px;">
                                Maaf, minuman ini saat ini sedang habis atau tidak tersedia untuk dipesan.
                            </div>
                            <a href="https://wa.me/6289515256232?text=Halo%20Admin%20Es%20Teh%20Solo,%20apakah%20menu%20*${product.namaProduk}*%20akan%20segera%20tersedia%20kembali?"
                               target="_blank"
                               class="btn btn-whatsapp btn-lg"
                               style="width: 100%; text-decoration: none;"
                               title="Tanyakan ke Admin via WhatsApp">
                                <span>💬</span> Tanyakan Ketersediaan via WhatsApp
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- CUSTOMER REVIEWS SECTION -->
            <div style="background: white; border-radius: var(--radius-lg); padding: 40px; border: 1px solid var(--border); box-shadow: var(--shadow-sm); margin-bottom: 48px;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 28px; padding-bottom: 16px; border-bottom: 1px solid var(--border-light); flex-wrap: wrap; gap: 16px;">
                    <div>
                        <h2 style="font-size: 1.4rem; font-weight: 800; color: var(--primary-dark);">
                            ⭐ Ulasan & Penilaian Pelanggan (${fn:length(reviews)})
                        </h2>
                        <p style="color: var(--text-secondary); font-size: 0.9rem;">Testimoni jujur pecinta teh terhadap cita rasa ${product.namaProduk}</p>
                    </div>

                    <c:if test="${not empty sessionScope.user}">
                        <button type="button" class="btn btn-secondary btn-sm" onclick="openReviewModal('${product.id}', '${product.namaProduk}')">
                            + Tulis Ulasan Anda
                        </button>
                    </c:if>
                </div>

                <c:choose>
                    <c:when test="${empty reviews}">
                        <div style="text-align: center; padding: 40px 20px;">
                            <div style="font-size: 2.5rem; margin-bottom: 10px;">🍵</div>
                            <h4 style="font-size: 1.1rem; color: var(--primary-dark); margin-bottom: 6px;">Belum Ada Ulasan</h4>
                            <p style="color: var(--text-secondary); font-size: 0.9rem;">Jadilah yang pertama mencoba dan memberikan ulasan untuk minuman segar ini!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="display: flex; flex-direction: column; gap: 16px;">
                            <c:forEach var="rev" items="${reviews}">
                                <div style="background: var(--cream-light); padding: 20px 24px; border-radius: var(--radius-md); border: 1px solid var(--border-light);">
                                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                                        <div style="display: flex; align-items: center; gap: 10px;">
                                            <div style="width: 36px; height: 36px; border-radius: 50%; background: var(--primary); color: white; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 0.9rem;">
                                                ${rev.userName.substring(0, 1)}
                                            </div>
                                            <strong style="color: var(--dark); font-size: 0.95rem;">${rev.userName}</strong>
                                        </div>
                                        <div style="color: #F59E0B; font-size: 0.9rem;">
                                            <c:forEach begin="1" end="${rev.rating}">⭐</c:forEach>
                                        </div>
                                    </div>
                                    <p style="font-size: 0.92rem; color: var(--text-primary); line-height: 1.5; margin-bottom: 6px;">
                                        "${rev.komentar}"
                                    </p>
                                    <div style="font-size: 0.78rem; color: var(--text-secondary);">
                                        <fmt:formatDate value="${rev.createdAt}" pattern="dd MMMM yyyy, HH:mm" /> WIB
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- RELATED DRINKS -->
            <c:if test="${not empty relatedProducts}">
                <div style="margin-bottom: 40px;">
                    <h3 style="font-size: 1.3rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 24px;">
                        Minuman Terkait Lainnya
                    </h3>
                    <div class="products-grid">
                        <c:forEach var="rp" items="${relatedProducts}" begin="0" end="2">
                            <c:if test="${rp.id != product.id}">
                                <div class="product-card">
                                    <div class="product-img-wrapper">
                                        <img src="${pageContext.request.contextPath}/assets/images/${rp.foto}"
                                             alt="${rp.namaProduk}"
                                             onerror="this.src='${pageContext.request.contextPath}/assets/images/esteh_original.jpg'">
                                    </div>
                                    <div class="product-body">
                                        <h4 class="product-title">${rp.namaProduk}</h4>
                                        <div class="product-price" style="margin-bottom: 12px;">
                                            Rp <fmt:formatNumber value="${rp.harga}" type="number" groupingUsed="true"/>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/product-detail?id=${rp.id}" class="btn btn-secondary btn-sm" style="width: 100%;">
                                            Lihat Detail
                                        </a>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
        </div>
    </section>

    <!-- Review Modal -->
    <div id="reviewModal" class="modal-overlay">
        <div class="modal-content">
            <button class="modal-close" onclick="closeReviewModal()">✕</button>
            <h3 style="font-size: 1.3rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 6px;">
                Beri Ulasan Minuman
            </h3>
            <p id="modalProductName" style="color: var(--primary); font-weight: 700; margin-bottom: 20px;">
                ${product.namaProduk}
            </p>

            <form action="${pageContext.request.contextPath}/review/submit" method="POST">
                <input type="hidden" name="productId" id="modalProductId" value="${product.id}">
                <input type="hidden" name="rating" id="modalRatingInput" value="5">
                <input type="hidden" name="redirect" value="/product-detail?id=${product.id}">

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
