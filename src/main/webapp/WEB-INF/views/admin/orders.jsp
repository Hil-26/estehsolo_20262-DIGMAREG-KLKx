<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Pesanan Pelanggan - Es Teh Solo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

    <div class="admin-layout">
        <jsp:include page="/WEB-INF/views/admin/sidebar.jsp" />

        <main class="admin-main">
            <div class="admin-topbar">
                <div>
                    <h1 style="font-size: 1.8rem; font-weight: 800; color: var(--primary-dark);">Daftar Pesanan Masuk</h1>
                    <p style="color: var(--text-secondary); font-size: 0.9rem;">Kelola antrean dan perbarui status pembuatan pesanan.</p>
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

            <!-- Search Bar & Filters -->
            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px; margin-bottom: 20px;">
                <div class="category-pills" style="justify-content: flex-start; margin-bottom: 0;">
                    <a href="${pageContext.request.contextPath}/admin/orders?status=Semua${not empty searchQuery ? '&q='.concat(searchQuery) : ''}" class="cat-pill ${selectedStatus == 'Semua' ? 'active' : ''}">
                        Semua (${fn:length(orders)})
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/orders?status=Menunggu${not empty searchQuery ? '&q='.concat(searchQuery) : ''}" class="cat-pill ${selectedStatus == 'Menunggu' ? 'active' : ''}">
                        ⏳ Menunggu
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/orders?status=Diproses${not empty searchQuery ? '&q='.concat(searchQuery) : ''}" class="cat-pill ${selectedStatus == 'Diproses' ? 'active' : ''}">
                        🔄 Diproses
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/orders?status=Siap Diambil${not empty searchQuery ? '&q='.concat(searchQuery) : ''}" class="cat-pill ${selectedStatus == 'Siap Diambil' ? 'active' : ''}">
                        🥤 Siap Diambil
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/orders?status=Selesai${not empty searchQuery ? '&q='.concat(searchQuery) : ''}" class="cat-pill ${selectedStatus == 'Selesai' ? 'active' : ''}">
                        ✅ Selesai
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/orders?status=Dibatalkan${not empty searchQuery ? '&q='.concat(searchQuery) : ''}" class="cat-pill ${selectedStatus == 'Dibatalkan' ? 'active' : ''}">
                        ❌ Dibatalkan
                    </a>
                </div>

                <form action="${pageContext.request.contextPath}/admin/orders" method="GET" style="display: flex; gap: 8px; align-items: center;">
                    <input type="hidden" name="status" value="${selectedStatus}">
                    <input type="text" name="q" value="<c:out value='${searchQuery}' />" class="form-control" placeholder="Cari nomor pesanan/nama..." style="padding: 6px 12px; font-size: 0.88rem; width: 220px;">
                    <button type="submit" class="btn btn-primary btn-sm" style="white-space: nowrap;">🔍 Cari</button>
                    <c:if test="${not empty searchQuery}">
                        <a href="${pageContext.request.contextPath}/admin/orders?status=${selectedStatus}" class="btn btn-secondary btn-sm" style="white-space: nowrap;">Reset</a>
                    </c:if>
                </form>
            </div>

            <c:choose>
                <c:when test="${empty orders}">
                    <div style="background: white; border-radius: var(--radius-lg); padding: 50px 20px; text-align: center; border: 1px solid var(--border);">
                        <div style="font-size: 3rem; margin-bottom: 12px;">📦</div>
                        <h3 style="font-size: 1.25rem; color: var(--primary-dark); margin-bottom: 6px;">Tidak Ada Pesanan dengan Status Ini</h3>
                        <p style="color: var(--text-secondary);">Silakan pilih filter status atau kata kunci pencarian yang lain.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="display: flex; flex-direction: column; gap: 20px;">
                        <c:forEach var="order" items="${orders}">
                            <div style="background: white; border-radius: var(--radius-lg); border: 1px solid var(--border); box-shadow: var(--shadow-sm); padding: 24px;">
                                <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 16px; margin-bottom: 16px; padding-bottom: 16px; border-bottom: 1px solid var(--border-light);">
                                    <div>
                                        <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 6px; flex-wrap: wrap;">
                                            <span style="font-size: 1.15rem; font-weight: 800; color: var(--primary-dark);">${order.nomorPesanan}</span>
                                            <span class="badge ${order.metodePengambilan == 'Dine-in' ? 'badge-info' : 'badge-default'}">
                                                ${order.metodePengambilan}
                                            </span>
                                            <span class="badge ${order.statusPembayaran == 'Lunas' ? 'badge-success' : 'badge-warning'}">
                                                💳 ${order.metodePembayaran} &bull; ${order.statusPembayaran}
                                            </span>
                                            <span style="font-size: 0.85rem; color: var(--text-secondary);">
                                                🕒 <fmt:formatDate value="${order.tanggalPesanan}" pattern="dd/MM/yyyy HH:mm" /> WIB
                                            </span>
                                        </div>
                                        <div style="font-size: 0.92rem; color: var(--dark);">
                                            <strong>Pelanggan:</strong> ${order.userName} &bull; 📞 ${order.userPhone} &bull; ✉️ ${order.userEmail}
                                        </div>
                                    </div>

                                    <!-- Status update form & Detail button -->
                                    <div style="display: flex; align-items: center; gap: 10px; flex-wrap: wrap;">
                                        <a href="${pageContext.request.contextPath}/admin/orders/detail?id=${order.id}" class="btn btn-secondary btn-sm">
                                            📄 Rincian Lengkap
                                        </a>

                                        <!-- Quick Payment Toggle -->
                                        <form action="${pageContext.request.contextPath}/admin/orders/update-payment-status" method="POST" style="display: flex; align-items: center; gap: 6px; margin: 0;">
                                            <input type="hidden" name="orderId" value="${order.id}">
                                            <input type="hidden" name="redirect" value="/admin/orders">
                                            <select name="paymentStatus" class="form-control" style="width: auto; padding: 4px 8px; font-size: 0.8rem; font-weight: 700; border-radius: 6px;" onchange="this.form.submit()">
                                                <option value="Belum Bayar" ${order.statusPembayaran == 'Belum Bayar' ? 'selected' : ''}>⏳ Belum Bayar</option>
                                                <option value="Lunas" ${order.statusPembayaran == 'Lunas' ? 'selected' : ''}>✅ Lunas</option>
                                            </select>
                                        </form>

                                        <!-- Order Status Update Form -->
                                        <form action="${pageContext.request.contextPath}/admin/orders/update-status" method="POST" style="display: flex; align-items: center; gap: 8px; margin: 0;">
                                            <input type="hidden" name="orderId" value="${order.id}">
                                            <input type="hidden" name="redirect" value="/admin/orders">
                                            <select name="newStatus" class="form-control" style="width: auto; padding: 5px 10px; font-weight: 700; font-size: 0.82rem;" onchange="this.form.submit()">
                                                <option value="Menunggu" ${order.statusPesanan == 'Menunggu' ? 'selected' : ''}>⏳ Menunggu</option>
                                                <option value="Diproses" ${order.statusPesanan == 'Diproses' ? 'selected' : ''}>🔄 Diproses</option>
                                                <option value="Siap Diambil" ${order.statusPesanan == 'Siap Diambil' ? 'selected' : ''}>🥤 Siap Diambil</option>
                                                <option value="Selesai" ${order.statusPesanan == 'Selesai' ? 'selected' : ''}>✅ Selesai</option>
                                                <option value="Dibatalkan" ${order.statusPesanan == 'Dibatalkan' ? 'selected' : ''}>❌ Dibatalkan</option>
                                            </select>
                                        </form>
                                    </div>
                                </div>

                                <!-- Detail Items Table -->
                                <div style="background: #FAFCF9; border-radius: var(--radius-sm); padding: 14px 18px; margin-bottom: 14px; border: 1px solid var(--border-light);">
                                    <c:forEach var="item" items="${order.details}">
                                        <div style="display: flex; justify-content: space-between; align-items: center; font-size: 0.9rem; margin-bottom: 6px;">
                                            <div>
                                                <span style="font-weight: 700; color: var(--primary);">${item.jumlah}x</span>
                                                <span style="color: var(--dark); font-weight: 600;">${item.productName}</span>
                                                <span style="font-size: 0.8rem; color: var(--text-secondary); margin-left: 6px;">
                                                    (@ Rp <fmt:formatNumber value="${item.hargaSatuan}" type="number" groupingUsed="true"/>)
                                                </span>
                                                <c:if test="${not empty item.sugarLevel || not empty item.iceLevel}">
                                                    <span style="font-size: 0.78rem; background: #e0f2fe; color: #0369a1; padding: 2px 6px; border-radius: 4px; margin-left: 6px; font-weight: 600;">
                                                        Gula: ${item.sugarLevel} | Es: ${item.iceLevel}
                                                    </span>
                                                </c:if>
                                                <c:if test="${not empty item.catatanItem}">
                                                    <span style="font-size: 0.78rem; font-style: italic; color: #64748b; margin-left: 6px;">(${item.catatanItem})</span>
                                                </c:if>
                                            </div>
                                            <div style="font-weight: 700; color: var(--dark);">
                                                Rp <fmt:formatNumber value="${item.subtotal}" type="number" groupingUsed="true"/>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <c:if test="${not empty order.catatan}">
                                    <div style="background: #FFFBEB; padding: 10px 14px; border-radius: var(--radius-sm); font-size: 0.85rem; color: #92400E; margin-bottom: 14px; border: 1px solid #FDE68A;">
                                        <strong>Catatan Khusus Pelanggan:</strong> ${order.catatan}
                                    </div>
                                </c:if>

                                <div style="display: flex; justify-content: space-between; align-items: center; padding-top: 10px;">
                                    <span style="font-size: 0.85rem; color: var(--text-secondary);">Total Keseluruhan</span>
                                    <span style="font-size: 1.25rem; font-weight: 800; color: var(--primary-dark);">
                                        Rp <fmt:formatNumber value="${order.totalHarga}" type="number" groupingUsed="true"/>
                                    </span>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
