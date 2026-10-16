<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laporan Penjualan - Es Teh Solo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        @media print {
            .admin-sidebar, .admin-topbar button, .filter-form { display: none !important; }
            .admin-layout { grid-template-columns: 1fr !important; }
            .admin-main { padding: 0 !important; }
        }
    </style>
</head>
<body>

    <div class="admin-layout">
        <jsp:include page="/WEB-INF/views/admin/sidebar.jsp" />

        <main class="admin-main">
            <div class="admin-topbar">
                <div>
                    <h1 style="font-size: 1.8rem; font-weight: 800; color: var(--primary-dark);">Laporan Penjualan</h1>
                    <p style="color: var(--text-secondary); font-size: 0.9rem;">Rekapitulasi transaksi sukses dan analisis produk terlaris.</p>
                </div>

                <div style="display: flex; gap: 10px;">
                    <a href="${pageContext.request.contextPath}/admin/reports/export-csv${not empty startDate ? '?startDate='.concat(startDate).concat('&endDate=').concat(endDate) : ''}" class="btn btn-secondary btn-sm">
                        📥 Unduh CSV Excel
                    </a>
                    <button onclick="window.print()" class="btn btn-primary btn-sm">
                        🖨️ Cetak Laporan
                    </button>
                </div>
            </div>

            <!-- Date Filter Form -->
            <div class="filter-form" style="background: white; border-radius: var(--radius-md); padding: 20px 24px; border: 1px solid var(--border); box-shadow: var(--shadow-sm); margin-bottom: 28px;">
                <form action="${pageContext.request.contextPath}/admin/reports" method="GET" style="display: flex; gap: 16px; align-items: flex-end; flex-wrap: wrap;">
                    <div>
                        <label class="form-label" style="font-size: 0.82rem;">Dari Tanggal</label>
                        <input type="date" name="startDate" class="form-control" value="${startDate}" style="padding: 8px 12px;">
                    </div>
                    <div>
                        <label class="form-label" style="font-size: 0.82rem;">Sampai Tanggal</label>
                        <input type="date" name="endDate" class="form-control" value="${endDate}" style="padding: 8px 12px;">
                    </div>
                    <button type="submit" class="btn btn-secondary btn-sm" style="padding: 10px 18px;">
                        🔍 Filter Laporan
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-outline btn-sm" style="padding: 10px 18px;">
                        Reset
                    </a>
                </form>
            </div>

            <!-- Summary KPI -->
            <div class="stats-grid" style="margin-bottom: 28px;">
                <div class="stat-card">
                    <div class="stat-icon green">💰</div>
                    <div class="stat-info">
                        <h4>Rp <fmt:formatNumber value="${report.totalRevenue}" type="number" groupingUsed="true"/></h4>
                        <p>Total Pendapatan Bersih</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon orange">🥤</div>
                    <div class="stat-info">
                        <h4>${report.totalOrders}</h4>
                        <p>Transaksi Berhasil (Selesai)</p>
                    </div>
                </div>
            </div>

            <!-- BEST SELLING PRODUCTS (Fitur 9) -->
            <div class="table-card" style="margin-bottom: 32px;">
                <div style="padding: 18px 24px; border-bottom: 1px solid var(--border);">
                    <h3 style="font-size: 1.15rem; font-weight: 800; color: var(--primary-dark);">
                        🏆 Produk Terlaris (Top Best Sellers)
                    </h3>
                </div>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Peringkat</th>
                                <th>Nama Minuman</th>
                                <th>Harga Satuan</th>
                                <th style="text-align: center;">Total Porsi Terjual</th>
                                <th style="text-align: right;">Total Omzet</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${bestSellers}" varStatus="status">
                                <tr>
                                    <td style="font-weight: 800; color: var(--primary);">#${status.index + 1}</td>
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 12px;">
                                            <img src="${pageContext.request.contextPath}/assets/images/${item.foto}"
                                                 alt="${item.namaProduk}"
                                                 style="width: 40px; height: 40px; border-radius: 8px; object-fit: cover;"
                                                 onerror="this.src='${pageContext.request.contextPath}/assets/images/esteh_original.jpg'">
                                            <strong style="color: var(--dark);">${item.namaProduk}</strong>
                                        </div>
                                    </td>
                                    <td>
                                        Rp <fmt:formatNumber value="${item.harga}" type="number" groupingUsed="true"/>
                                    </td>
                                    <td style="text-align: center; font-weight: 800; color: var(--primary-dark);">
                                        ${item.totalTerjual} gelas
                                    </td>
                                    <td style="text-align: right; font-weight: 800; color: var(--primary);">
                                        Rp <fmt:formatNumber value="${item.totalPendapatan}" type="number" groupingUsed="true"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- ORDERS IN PERIOD -->
            <div class="table-card">
                <div style="padding: 18px 24px; border-bottom: 1px solid var(--border);">
                    <h3 style="font-size: 1.15rem; font-weight: 800; color: var(--primary-dark);">
                        Rincian Transaksi Selesai
                    </h3>
                </div>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>No. Pesanan</th>
                                <th>Tanggal & Waktu</th>
                                <th>Pelanggan</th>
                                <th>Item Minuman</th>
                                <th>Metode</th>
                                <th style="text-align: right;">Total Bayar</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${report.orders}">
                                <tr>
                                    <td><strong>${order.nomorPesanan}</strong></td>
                                    <td style="font-size: 0.85rem; color: var(--text-secondary);">
                                        <fmt:formatDate value="${order.tanggalPesanan}" pattern="dd/MM/yyyy HH:mm" />
                                    </td>
                                    <td>${order.userName}</td>
                                    <td>
                                        <c:forEach var="det" items="${order.details}" varStatus="dStat">
                                            <span>${det.jumlah}x ${det.productName}</span><c:if test="${!dStat.last}">, </c:if>
                                        </c:forEach>
                                    </td>
                                    <td><span class="badge badge-default">${order.metodePengambilan}</span></td>
                                    <td style="text-align: right; font-weight: 800; color: var(--primary-dark);">
                                        Rp <fmt:formatNumber value="${order.totalHarga}" type="number" groupingUsed="true"/>
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
