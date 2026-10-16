<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Keranjang Belanja - Es Teh Solo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

    <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

    <section class="section">
        <div class="container">
            <div style="margin-bottom: 28px;">
                <span class="section-tag">Pesanan Anda</span>
                <h1 class="section-title">Keranjang Belanja</h1>
                <p class="section-subtitle">Periksa varian rasa, tingkat manis, dan jumlah cup pesanan Anda sebelum checkout.</p>
            </div>

            <c:choose>
                <c:when test="${empty cart || empty cart.items || cart.totalCount == 0}">
                    <div style="background: white; border-radius: var(--radius-lg); padding: 60px 20px; text-align: center; border: 1px solid var(--border); box-shadow: var(--shadow-sm);">
                        <div style="font-size: 3.5rem; margin-bottom: 16px;">🛒</div>
                        <h3 style="font-size: 1.4rem; color: var(--primary-dark); margin-bottom: 8px;">Keranjang Belanja Anda Kosong</h3>
                        <p style="color: var(--text-secondary); margin-bottom: 24px; max-width: 450px; margin-left: auto; margin-right: auto;">
                            Belum ada minuman segar yang Anda tambahkan. Yuk pilih varian teh Solo favorit Anda sekarang!
                        </p>
                        <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary btn-lg">
                            🍃 Pilih Menu Minuman Segar
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 32px; align-items: start;">
                        <!-- Cart Items Table -->
                        <div class="table-card">
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Minuman</th>
                                            <th>Harga Satuan</th>
                                            <th style="text-align: center;">Jumlah Cup</th>
                                            <th>Subtotal</th>
                                            <th style="text-align: center;">Aksi</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${cart.items}">
                                            <tr>
                                                <td>
                                                    <div style="display: flex; align-items: center; gap: 14px;">
                                                        <a href="${pageContext.request.contextPath}/product-detail?id=${item.product.id}">
                                                            <img src="${pageContext.request.contextPath}/assets/images/${item.product.foto}"
                                                                 alt="${item.product.namaProduk}"
                                                                 style="width: 58px; height: 58px; object-fit: cover; border-radius: 10px; border: 1px solid var(--border-light);"
                                                                 onerror="this.src='${pageContext.request.contextPath}/assets/images/esteh_original.jpg'">
                                                        </a>
                                                        <div>
                                                            <a href="${pageContext.request.contextPath}/product-detail?id=${item.product.id}" style="color: inherit; text-decoration: none;">
                                                                <strong style="color: var(--primary-dark); font-size: 0.98rem; display: block;">${item.product.namaProduk}</strong>
                                                            </a>
                                                            <div style="font-size: 0.78rem; color: var(--primary); font-weight: 700; margin-top: 1px;">
                                                                ${item.product.categoryName} &bull; 
                                                                <span style="color: var(--text-secondary); font-weight: normal;">Sisa Stok: <strong>${item.product.stok}</strong></span>
                                                            </div>
                                                            <div style="font-size: 0.78rem; margin-top: 5px;">
                                                                <c:if test="${not empty item.sugarLevel || not empty item.iceLevel}">
                                                                    <span style="background: #e0f2fe; color: #0369a1; padding: 2px 8px; border-radius: 4px; font-weight: 600; display: inline-block;">
                                                                        Gula: ${item.sugarLevel} &bull; Es: ${item.iceLevel}
                                                                    </span>
                                                                </c:if>
                                                                <c:if test="${not empty item.notes}">
                                                                    <span style="color: #64748b; font-style: italic; margin-left: 4px;">(${item.notes})</span>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    Rp <fmt:formatNumber value="${item.product.harga}" type="number" groupingUsed="true"/>
                                                </td>
                                                <td style="text-align: center;">
                                                    <div style="display: inline-flex; align-items: center; gap: 8px; border: 1.5px solid var(--border); border-radius: var(--radius-full); padding: 4px 10px; background: white;">
                                                        <!-- Decrement Button -->
                                                        <form action="${pageContext.request.contextPath}/cart" method="POST" style="display:inline;">
                                                            <input type="hidden" name="action" value="update">
                                                            <input type="hidden" name="itemKey" value="${item.itemKey}">
                                                            <input type="hidden" name="productId" value="${item.product.id}">
                                                            <input type="hidden" name="quantity" value="${item.quantity - 1}">
                                                            <button type="submit" style="background:none; border:none; cursor:pointer; font-weight:bold; font-size: 1.1rem; color:var(--primary-dark); padding: 0 4px;" title="Kurangi 1 cup">-</button>
                                                        </form>
                                                        
                                                        <span style="font-weight: 800; min-width: 22px; font-size: 0.95rem;">${item.quantity}</span>
                                                        
                                                        <!-- Increment Button -->
                                                        <c:choose>
                                                            <c:when test="${item.product.stok != null && item.quantity >= item.product.stok}">
                                                                <button type="button" disabled style="background:none; border:none; cursor:not-allowed; opacity: 0.3; font-weight:bold; font-size: 1.1rem; color:var(--text-secondary); padding: 0 4px;" title="Stok maksimal tercapai (${item.product.stok})">+</button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <form action="${pageContext.request.contextPath}/cart" method="POST" style="display:inline;">
                                                                    <input type="hidden" name="action" value="update">
                                                                    <input type="hidden" name="itemKey" value="${item.itemKey}">
                                                                    <input type="hidden" name="productId" value="${item.product.id}">
                                                                    <input type="hidden" name="quantity" value="${item.quantity + 1}">
                                                                    <button type="submit" style="background:none; border:none; cursor:pointer; font-weight:bold; font-size: 1.1rem; color:var(--primary-dark); padding: 0 4px;" title="Tambah 1 cup">+</button>
                                                                </form>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <c:if test="${item.product.stok != null && item.quantity >= item.product.stok}">
                                                        <div style="font-size: 0.72rem; color: #d97706; font-weight: 700; margin-top: 4px;">Maks. Stok</div>
                                                    </c:if>
                                                </td>
                                                <td style="font-weight: 800; color: var(--primary-dark);">
                                                    Rp <fmt:formatNumber value="${item.subtotal}" type="number" groupingUsed="true"/>
                                                </td>
                                                <td style="text-align: center;">
                                                    <form action="${pageContext.request.contextPath}/cart" method="POST" onsubmit="return confirm('Hapus racikan minuman ini dari keranjang?')">
                                                        <input type="hidden" name="action" value="remove">
                                                        <input type="hidden" name="itemKey" value="${item.itemKey}">
                                                        <input type="hidden" name="productId" value="${item.product.id}">
                                                        <button type="submit" class="btn btn-danger btn-sm" style="padding: 5px 12px;" title="Hapus dari keranjang">
                                                            🗑️
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <div style="padding: 16px 20px; background: #F8FAFC; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px;">
                                <a href="${pageContext.request.contextPath}/menu" class="btn btn-secondary btn-sm">
                                    ← Tambah Minuman Lain
                                </a>
                                <form action="${pageContext.request.contextPath}/cart" method="POST" onsubmit="return confirm('Apakah Anda yakin ingin mengosongkan seluruh keranjang belanja?')">
                                    <input type="hidden" name="action" value="clear">
                                    <button type="submit" class="btn btn-outline btn-sm" style="color: var(--danger); border-color: var(--danger);">
                                        Kosongkan Keranjang
                                    </button>
                                </form>
                            </div>
                        </div>

                        <!-- Summary Card -->
                        <div style="background: white; border-radius: var(--radius-lg); padding: 28px; border: 1px solid var(--border); box-shadow: var(--shadow-sm);">
                            <h3 style="font-size: 1.25rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 20px; padding-bottom: 14px; border-bottom: 1px solid var(--border-light);">
                                Ringkasan Belanja
                            </h3>

                            <div style="display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 0.95rem;">
                                <span style="color: var(--text-secondary);">Total Item:</span>
                                <span style="font-weight: 700;">${cart.totalCount} cup</span>
                            </div>

                            <div style="display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 0.95rem;">
                                <span style="color: var(--text-secondary);">Subtotal:</span>
                                <span style="font-weight: 700;">Rp <fmt:formatNumber value="${cart.totalPrice}" type="number" groupingUsed="true"/></span>
                            </div>

                            <div style="display: flex; justify-content: space-between; margin-bottom: 18px; font-size: 0.95rem;">
                                <span style="color: var(--text-secondary);">Biaya Layanan / Cup:</span>
                                <span style="font-weight: 700; color: var(--primary);">GRATIS</span>
                            </div>

                            <div style="background: #f0fdf4; border: 1px dashed #86efac; border-radius: var(--radius-sm); padding: 12px; margin-bottom: 20px; font-size: 0.82rem; color: #166534;">
                                <span>🎉 <strong>Promo Outlet:</strong> Gratis biaya kemasan dan sedotan higienis untuk semua pesanan!</span>
                            </div>

                            <div style="display: flex; justify-content: space-between; padding-top: 16px; border-top: 2px dashed var(--border); margin-bottom: 24px;">
                                <span style="font-size: 1.15rem; font-weight: 800; color: var(--primary-dark);">Total Bayar:</span>
                                <span style="font-size: 1.4rem; font-weight: 800; color: var(--primary);">
                                    Rp <fmt:formatNumber value="${cart.totalPrice}" type="number" groupingUsed="true"/>
                                </span>
                            </div>

                            <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary btn-lg" style="width: 100%; text-align: center; justify-content: center;">
                                Lanjutkan Pemesanan →
                            </a>

                            <div style="text-align: center; margin-top: 14px; font-size: 0.8rem; color: var(--text-secondary);">
                                🔒 Pesanan aman & dapat diambil di outlet / dine-in
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
