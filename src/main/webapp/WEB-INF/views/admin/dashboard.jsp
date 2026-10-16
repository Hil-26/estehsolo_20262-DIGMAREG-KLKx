<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - Es Teh Solo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

    <div class="admin-layout">
        <!-- Sidebar -->
        <jsp:include page="/WEB-INF/views/admin/sidebar.jsp" />

        <!-- Main Content -->
        <main class="admin-main">
            <div class="admin-topbar">
                <div>
                    <h1 style="font-size: 1.8rem; font-weight: 800; color: var(--primary-dark);">Dashboard Ringkasan</h1>
                    <p style="color: var(--text-secondary); font-size: 0.9rem;">Selamat datang kembali, <strong>${sessionScope.user.nama}</strong>!</p>
                </div>

                <div style="display: flex; gap: 12px;">
                    <a href="${pageContext.request.contextPath}/admin/products/add" class="btn btn-primary btn-sm">
                        + Tambah Produk
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-secondary btn-sm">
                        📈 Laporan Penjualan
                    </a>
                </div>
            </div>

            <!-- Global Toast / Alert Messages -->
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

            <!-- STATS CARDS -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon green">💰</div>
                    <div class="stat-info">
                        <h4>Rp <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true"/></h4>
                        <p>Total Penjualan Selesai</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon orange">📦</div>
                    <div class="stat-info">
                        <h4>${totalOrders}</h4>
                        <p>Total Pesanan Masuk</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon blue">🍹</div>
                    <div class="stat-info">
                        <h4>${totalProducts}</h4>
                        <p>Varian Minuman</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon purple">👥</div>
                    <div class="stat-info">
                        <h4>${totalUsers}</h4>
                        <p>Pelanggan Terdaftar</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon" style="background: #FEE2E2; color: #DC2626;">📬</div>
                    <div class="stat-info">
                        <h4>${unreadContacts}</h4>
                        <p>Pesan Kontak Baru</p>
                    </div>
                </div>
            </div>

            <!-- ORDER STATUS SUMMARY ROW -->
            <div style="background: white; border-radius: var(--radius-lg); padding: 24px; border: 1px solid var(--border); box-shadow: var(--shadow-sm); margin-bottom: 32px;">
                <h3 style="font-size: 1.15rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 16px;">
                    Ringkasan Status Pesanan
                </h3>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 14px;">
                    <a href="${pageContext.request.contextPath}/admin/orders?status=Menunggu" style="background: #FEF3C7; padding: 14px 18px; border-radius: var(--radius-md); border: 1px solid #FDE68A; display: block;">
                        <span style="font-size: 0.8rem; font-weight: 700; color: #92400E; display: block;">⏳ Menunggu</span>
                        <strong style="font-size: 1.4rem; color: #B45309;">${statusCounts['Menunggu']} Pesanan</strong>
                    </a>

                    <a href="${pageContext.request.contextPath}/admin/orders?status=Diproses" style="background: #E0F2FE; padding: 14px 18px; border-radius: var(--radius-md); border: 1px solid #BAE6FD; display: block;">
                        <span style="font-size: 0.8rem; font-weight: 700; color: #075985; display: block;">🔄 Sedang Disiapkan</span>
                        <strong style="font-size: 1.4rem; color: #0284C7;">${statusCounts['Diproses']} Pesanan</strong>
                    </a>

                    <a href="${pageContext.request.contextPath}/admin/orders?status=Siap Diambil" style="background: #DCFCE7; padding: 14px 18px; border-radius: var(--radius-md); border: 1px solid #BBF7D0; display: block;">
                        <span style="font-size: 0.8rem; font-weight: 700; color: #166534; display: block;">🥤 Siap Diambil</span>
                        <strong style="font-size: 1.4rem; color: #16A34A;">${statusCounts['Siap Diambil']} Pesanan</strong>
                    </a>

                    <a href="${pageContext.request.contextPath}/admin/orders?status=Selesai" style="background: #F1F5F9; padding: 14px 18px; border-radius: var(--radius-md); border: 1px solid #E2E8F0; display: block;">
                        <span style="font-size: 0.8rem; font-weight: 700; color: #475569; display: block;">✅ Selesai</span>
                        <strong style="font-size: 1.4rem; color: #334155;">${statusCounts['Selesai']} Pesanan</strong>
                    </a>

                    <a href="${pageContext.request.contextPath}/admin/orders?status=Dibatalkan" style="background: #FEE2E2; padding: 14px 18px; border-radius: var(--radius-md); border: 1px solid #FECACA; display: block;">
                        <span style="font-size: 0.8rem; font-weight: 700; color: #991B1B; display: block;">❌ Dibatalkan</span>
                        <strong style="font-size: 1.4rem; color: #DC2626;">${statusCounts['Dibatalkan']} Pesanan</strong>
                    </a>
                </div>
            </div>

            <!-- RECENT ORDERS TABLE -->
            <div class="table-card">
                <div style="padding: 20px 24px; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center;">
                    <h3 style="font-size: 1.2rem; font-weight: 800; color: var(--primary-dark);">
                        Pesanan Masuk Terbaru
                    </h3>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-secondary btn-sm">
                        Lihat Semua Pesanan →
                    </a>
                </div>

                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>No. Pesanan</th>
                                <th>Pelanggan</th>
                                <th>Metode</th>
                                <th>Waktu</th>
                                <th>Total</th>
                                <th>Status</th>
                                <th style="text-align: right;">Aksi Cepat</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${recentOrders}">
                                <tr>
                                    <td>
                                        <strong style="color: var(--primary-dark);">${order.nomorPesanan}</strong>
                                    </td>
                                    <td>
                                        <strong>${order.userName}</strong>
                                        <div style="font-size: 0.8rem; color: var(--text-secondary);">${order.userPhone}</div>
                                    </td>
                                    <td>
                                        <span class="badge ${order.metodePengambilan == 'Dine-in' ? 'badge-info' : 'badge-default'}">
                                            ${order.metodePengambilan}
                                        </span>
                                    </td>
                                    <td style="font-size: 0.85rem; color: var(--text-secondary);">
                                        <fmt:formatDate value="${order.tanggalPesanan}" pattern="dd/MM HH:mm" /> WIB
                                    </td>
                                    <td style="font-weight: 800; color: var(--primary-dark);">
                                        Rp <fmt:formatNumber value="${order.totalHarga}" type="number" groupingUsed="true"/>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.statusPesanan == 'Menunggu'}">
                                                <span class="badge badge-warning">Menunggu</span>
                                            </c:when>
                                            <c:when test="${order.statusPesanan == 'Diproses'}">
                                                <span class="badge badge-info">Diproses</span>
                                            </c:when>
                                            <c:when test="${order.statusPesanan == 'Siap Diambil'}">
                                                <span class="badge badge-success">Siap Diambil</span>
                                            </c:when>
                                            <c:when test="${order.statusPesanan == 'Selesai'}">
                                                <span class="badge badge-success" style="background-color: #DCFCE7;">Selesai</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-danger">Dibatalkan</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align: right;">
                                        <form action="${pageContext.request.contextPath}/admin/orders/update-status" method="POST" style="display: inline-flex; gap: 6px; align-items: center;">
                                            <input type="hidden" name="orderId" value="${order.id}">
                                            <input type="hidden" name="redirect" value="/admin/dashboard">
                                            <select name="newStatus" class="form-control" style="padding: 4px 8px; font-size: 0.82rem; width: auto;" onchange="this.form.submit()">
                                                <option value="" disabled selected>Ubah Status...</option>
                                                <option value="Menunggu">Menunggu</option>
                                                <option value="Diproses">Diproses</option>
                                                <option value="Siap Diambil">Siap Diambil</option>
                                                <option value="Selesai">Selesai</option>
                                                <option value="Dibatalkan">Dibatalkan</option>
                                            </select>
                                        </form>
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
