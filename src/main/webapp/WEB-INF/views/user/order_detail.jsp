<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detail Pesanan ${order.nomorPesanan} - Es Teh Solo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        @media print {
            .navbar, .footer, .btn-no-print { display: none !important; }
            body { background: white !important; }
            .section { padding: 0 !important; }
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

    <section class="section">
        <div class="container" style="max-width: 800px;">
            <div style="margin-bottom: 24px;" class="btn-no-print">
                <a href="${pageContext.request.contextPath}/orders" class="btn btn-secondary btn-sm">
                    ← Kembali ke Riwayat Pesanan
                </a>
            </div>

            <div style="background: white; border-radius: var(--radius-lg); border: 1px solid var(--border); box-shadow: var(--shadow-md); padding: 40px;">
                <!-- Header Receipt -->
                <div style="display: flex; justify-content: space-between; align-items: flex-start; padding-bottom: 24px; border-bottom: 2px dashed var(--border); margin-bottom: 24px;">
                    <div>
                        <div class="brand" style="margin-bottom: 8px;">
                            <div class="brand-icon" style="width:36px; height:36px; font-size:1.1rem;">🍃</div>
                            <span style="font-size: 1.25rem;">Es Teh Solo</span>
                        </div>
                        <p style="font-size: 0.85rem; color: var(--text-secondary);">Outlet Resmi Tradisi Teh Wasgitel Kota Solo</p>
                    </div>

                    <div style="text-align: right;">
                        <span style="display: block; font-size: 0.8rem; color: var(--text-secondary); text-transform: uppercase; font-weight: 700;">Nomor Pesanan</span>
                        <span style="font-size: 1.3rem; font-weight: 800; color: var(--primary-dark);">${order.nomorPesanan}</span>
                        <div style="margin-top: 6px;">
                            <span class="badge ${order.statusPesanan == 'Selesai' ? 'badge-success' : (order.statusPesanan == 'Menunggu' ? 'badge-warning' : (order.statusPesanan == 'Dibatalkan' ? 'badge-danger' : 'badge-info'))}">
                                ${order.statusPesanan}
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Info Grid -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 30px; font-size: 0.92rem;">
                    <div>
                        <span style="color: var(--text-secondary); display: block; font-size: 0.8rem; font-weight: 700; text-transform: uppercase;">Waktu Transaksi</span>
                        <strong style="color: var(--dark);"><fmt:formatDate value="${order.tanggalPesanan}" pattern="dd MMMM yyyy, HH:mm" /> WIB</strong>
                    </div>
                    <div>
                        <span style="color: var(--text-secondary); display: block; font-size: 0.8rem; font-weight: 700; text-transform: uppercase;">Metode Pengambilan</span>
                        <strong style="color: var(--primary-dark);">${order.metodePengambilan}</strong>
                    </div>
                    <div>
                        <span style="color: var(--text-secondary); display: block; font-size: 0.8rem; font-weight: 700; text-transform: uppercase;">Pemesan</span>
                        <strong style="color: var(--dark);">${order.userName} (${order.userPhone})</strong>
                    </div>
                    <div>
                        <span style="color: var(--text-secondary); display: block; font-size: 0.8rem; font-weight: 700; text-transform: uppercase;">Pembayaran</span>
                        <strong style="color: var(--dark);">${order.metodePembayaran}</strong> &bull;
                        <span class="badge ${order.statusPembayaran == 'Lunas' ? 'badge-success' : 'badge-warning'}">
                            ${order.statusPembayaran}
                        </span>
                    </div>
                </div>

                <c:if test="${not empty order.catatan}">
                    <div style="background: var(--cream-light); padding: 14px 18px; border-radius: var(--radius-sm); font-size: 0.9rem; margin-bottom: 30px; border: 1px solid var(--primary-light);">
                        <strong>Catatan Pesanan:</strong> ${order.catatan}
                    </div>
                </c:if>

                <!-- Order Details Table -->
                <div class="table-card" style="margin-bottom: 24px;">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Item Minuman</th>
                                <th style="text-align: right;">Harga Satuan</th>
                                <th style="text-align: center;">Jumlah</th>
                                <th style="text-align: right;">Subtotal</th>
                                <c:if test="${order.statusPesanan == 'Selesai'}">
                                    <th style="text-align: center;">Ulasan</th>
                                </c:if>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${order.details}">
                                <tr>
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 12px;">
                                            <img src="${pageContext.request.contextPath}/assets/images/${item.productPhoto}"
                                                 alt="${item.productName}"
                                                 style="width: 44px; height: 44px; border-radius: 8px; object-fit: cover;"
                                                 onerror="this.src='${pageContext.request.contextPath}/assets/images/esteh_original.jpg'">
                                            <div>
                                                <span style="font-weight: 700; color: var(--dark); display: block;">${item.productName}</span>
                                                <div style="font-size: 0.78rem; margin-top: 2px;">
                                                    <c:if test="${not empty item.sugarLevel || not empty item.iceLevel}">
                                                        <span style="background: #e0f2fe; color: #0369a1; padding: 2px 6px; border-radius: 4px; font-weight: 600;">
                                                            Gula: ${item.sugarLevel} &bull; Es: ${item.iceLevel}
                                                        </span>
                                                    </c:if>
                                                    <c:if test="${not empty item.catatanItem}">
                                                        <span style="color: #64748b; font-style: italic; margin-left: 4px;">(${item.catatanItem})</span>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td style="text-align: right;">
                                        Rp <fmt:formatNumber value="${item.hargaSatuan}" type="number" groupingUsed="true"/>
                                    </td>
                                    <td style="text-align: center; font-weight: 700;">
                                        ${item.jumlah}
                                    </td>
                                    <td style="text-align: right; font-weight: 800; color: var(--primary-dark);">
                                        Rp <fmt:formatNumber value="${item.subtotal}" type="number" groupingUsed="true"/>
                                    </td>
                                    <c:if test="${order.statusPesanan == 'Selesai'}">
                                        <td style="text-align: center;">
                                            <button type="button" class="btn btn-secondary btn-sm"
                                                    onclick="openReviewModal('${item.productId}', '${item.productName}')">
                                                ⭐ Beri Nilai
                                            </button>
                                        </td>
                                    </c:if>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="3" style="text-align: right; font-size: 1.1rem; font-weight: 800; color: var(--primary-dark);">
                                    Total Pembayaran:
                                </td>
                                <td style="text-align: right; font-size: 1.3rem; font-weight: 800; color: var(--primary);">
                                    Rp <fmt:formatNumber value="${order.totalHarga}" type="number" groupingUsed="true"/>
                                </td>
                                <c:if test="${order.statusPesanan == 'Selesai'}">
                                    <td></td>
                                </c:if>
                            </tr>
                        </tfoot>
                    </table>
                </div>

                <div style="display: flex; justify-content: center; gap: 12px; margin-top: 32px; flex-wrap: wrap;" class="btn-no-print">
                    <button onclick="window.print()" class="btn btn-secondary btn-sm">
                        🖨️ Cetak Bukti Pesanan
                    </button>
                    <a href="https://wa.me/6289515256232?text=Halo%20Kasir%20Es%20Teh%20Solo,%20saya%20sudah%20membuat%20pesanan%20dengan%20nomor%20${order.nomorPesanan}%20senilai%20Rp%20${order.totalHarga}."
                       target="_blank"
                       class="btn btn-primary btn-sm"
                       style="background: #25D366; border-color: #25D366;">
                        📲 Konfirmasi via WhatsApp
                    </a>
                </div>
            </div>
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
                Nama Minuman
            </p>

            <form action="${pageContext.request.contextPath}/review/submit" method="POST">
                <input type="hidden" name="productId" id="modalProductId">
                <input type="hidden" name="rating" id="modalRatingInput" value="5">
                <input type="hidden" name="redirect" value="/order-detail?id=${order.id}">

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
