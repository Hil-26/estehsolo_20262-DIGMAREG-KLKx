<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Riwayat Pesanan - Es Teh Solo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

    <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

    <section class="section">
        <div class="container">
            <div style="margin-bottom: 32px;">
                <span class="section-tag">Status & Riwayat</span>
                <h1 class="section-title">Pesanan Saya</h1>
                <p class="section-subtitle">Pantau status pembuatan minuman Anda secara realtime.</p>
            </div>

            <c:choose>
                <c:when test="${empty orders}">
                    <div style="background: white; border-radius: var(--radius-lg); padding: 60px 20px; text-align: center; border: 1px solid var(--border);">
                        <div style="font-size: 3.5rem; margin-bottom: 16px;">🍵</div>
                        <h3 style="font-size: 1.4rem; color: var(--primary-dark); margin-bottom: 8px;">Belum Ada Riwayat Pesanan</h3>
                        <p style="color: var(--text-secondary); margin-bottom: 24px; max-width: 450px; margin-left: auto; margin-right: auto;">
                            Anda belum pernah melakukan pemesanan. Segarkan harimu dengan segelas Es Teh Solo sekarang!
                        </p>
                        <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary btn-lg">
                            Pesan Minuman Sekarang
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="display: flex; flex-direction: column; gap: 20px;">
                        <c:forEach var="order" items="${orders}">
                            <div style="background: white; border-radius: var(--radius-lg); border: 1px solid var(--border); box-shadow: var(--shadow-sm); padding: 24px;">
                                <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 16px; margin-bottom: 18px; padding-bottom: 16px; border-bottom: 1px solid var(--border-light);">
                                    <div>
                                        <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 6px; flex-wrap: wrap;">
                                            <span style="font-size: 1.15rem; font-weight: 800; color: var(--primary-dark);">
                                                ${order.nomorPesanan}
                                            </span>
                                            <span class="badge ${order.metodePengambilan == 'Dine-in' ? 'badge-info' : 'badge-default'}">
                                                ${order.metodePengambilan}
                                            </span>
                                            <span class="badge ${order.statusPembayaran == 'Lunas' ? 'badge-success' : 'badge-warning'}">
                                                💳 ${order.metodePembayaran} &bull; ${order.statusPembayaran}
                                            </span>
                                        </div>
                                        <div style="font-size: 0.85rem; color: var(--text-secondary);">
                                            Waktu Pesan: <fmt:formatDate value="${order.tanggalPesanan}" pattern="dd MMMM yyyy, HH:mm" /> WIB
                                        </div>
                                    </div>

                                    <div>
                                        <c:choose>
                                            <c:when test="${order.statusPesanan == 'Menunggu'}">
                                                <span class="badge badge-warning" style="font-size: 0.9rem; padding: 6px 16px;">⏳ Menunggu Konfirmasi</span>
                                            </c:when>
                                            <c:when test="${order.statusPesanan == 'Diproses'}">
                                                <span class="badge badge-info" style="font-size: 0.9rem; padding: 6px 16px;">🔄 Sedang Disiapkan</span>
                                            </c:when>
                                            <c:when test="${order.statusPesanan == 'Siap Diambil'}">
                                                <span class="badge badge-success" style="font-size: 0.9rem; padding: 6px 16px;">🥤 Siap Diambil</span>
                                            </c:when>
                                            <c:when test="${order.statusPesanan == 'Selesai'}">
                                                <span class="badge badge-success" style="font-size: 0.9rem; padding: 6px 16px; background-color: #DCFCE7;">✅ Selesai</span>
                                            </c:when>
                                            <c:when test="${order.statusPesanan == 'Dibatalkan'}">
                                                <span class="badge badge-danger" style="font-size: 0.9rem; padding: 6px 16px;">❌ Dibatalkan</span>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- Item Preview -->
                                <div style="display: flex; flex-direction: column; gap: 10px; margin-bottom: 18px;">
                                    <c:forEach var="item" items="${order.details}">
                                        <div style="display: flex; justify-content: space-between; align-items: center; font-size: 0.92rem;">
                                            <div style="display: flex; align-items: center; gap: 10px; flex-wrap: wrap;">
                                                <span style="font-weight: 700; color: var(--primary);">${item.jumlah}x</span>
                                                <span style="color: var(--dark); font-weight: 600;">${item.productName}</span>
                                                <c:if test="${not empty item.sugarLevel || not empty item.iceLevel}">
                                                    <span style="font-size: 0.75rem; background: #e0f2fe; color: #0369a1; padding: 2px 6px; border-radius: 4px; font-weight: 600;">
                                                        Gula: ${item.sugarLevel} | Es: ${item.iceLevel}
                                                    </span>
                                                </c:if>
                                                <c:if test="${not empty item.catatanItem}">
                                                    <span style="font-size: 0.75rem; color: #64748b; font-style: italic;">(${item.catatanItem})</span>
                                                </c:if>
                                            </div>
                                            <span style="color: var(--text-secondary);">
                                                Rp <fmt:formatNumber value="${item.subtotal}" type="number" groupingUsed="true"/>
                                            </span>
                                        </div>
                                    </c:forEach>
                                </div>

                                <c:if test="${not empty order.catatan}">
                                    <div style="background: var(--cream-light); padding: 10px 14px; border-radius: var(--radius-sm); font-size: 0.85rem; color: var(--text-secondary); margin-bottom: 18px;">
                                        <strong>Catatan:</strong> ${order.catatan}
                                    </div>
                                </c:if>

                                <div style="display: flex; justify-content: space-between; align-items: center; padding-top: 14px; border-top: 1px solid var(--border-light); flex-wrap: wrap; gap: 12px;">
                                    <div>
                                        <span style="font-size: 0.88rem; color: var(--text-secondary);">Total Pembayaran: </span>
                                        <span style="font-size: 1.25rem; font-weight: 800; color: var(--primary-dark);">
                                            Rp <fmt:formatNumber value="${order.totalHarga}" type="number" groupingUsed="true"/>
                                        </span>
                                    </div>

                                    <div style="display: flex; align-items: center; gap: 10px;">
                                        <a href="${pageContext.request.contextPath}/order-detail?id=${order.id}" class="btn btn-secondary btn-sm">
                                            Rincian Lengkap
                                        </a>

                                        <c:if test="${order.statusPesanan == 'Menunggu'}">
                                            <form action="${pageContext.request.contextPath}/order-cancel" method="POST" onsubmit="return confirm('Apakah Anda yakin ingin membatalkan pesanan ${order.nomorPesanan}?');" style="display:inline;">
                                                <input type="hidden" name="orderId" value="${order.id}">
                                                <button type="submit" class="btn btn-danger btn-sm">
                                                    Batalkan Pesanan
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
