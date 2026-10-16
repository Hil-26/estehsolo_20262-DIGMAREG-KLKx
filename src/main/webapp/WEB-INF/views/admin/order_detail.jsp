<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detail Pesanan ${order.nomorPesanan} - Admin Es Teh Solo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        @media print {
            .admin-sidebar, .btn-no-print, .status-card { display: none !important; }
            .admin-layout { grid-template-columns: 1fr !important; }
            .admin-main { padding: 0 !important; }
        }
    </style>
</head>
<body>

    <div class="admin-layout">
        <jsp:include page="/WEB-INF/views/admin/sidebar.jsp" />

        <main class="admin-main">
            <div class="admin-topbar btn-no-print">
                <div>
                    <h1 style="font-size: 1.8rem; font-weight: 800; color: var(--primary-dark);">Detail Pesanan ${order.nomorPesanan}</h1>
                    <p style="color: var(--text-secondary); font-size: 0.9rem;">Informasi lengkap pemesan, item minuman, dan pengelolaan status.</p>
                </div>

                <div style="display: flex; gap: 12px;">
                    <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-secondary btn-sm">
                        ← Kembali ke Daftar Pesanan
                    </a>
                    <button onclick="window.print()" class="btn btn-outline btn-sm">
                        🖨️ Cetak Struk Dapur / Kasir
                    </button>
                </div>
            </div>

            <!-- Global Alerts -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible btn-no-print">
                    <span>✅</span> <span><c:out value="${param.success}" /></span>
                </div>
            </c:if>

            <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 32px; align-items: start;">
                <!-- Main Invoice Receipt -->
                <div style="background: white; border-radius: var(--radius-lg); padding: 36px; border: 1px solid var(--border); box-shadow: var(--shadow-sm);">
                    <div style="display: flex; justify-content: space-between; align-items: flex-start; padding-bottom: 20px; border-bottom: 2px dashed var(--border); margin-bottom: 24px;">
                        <div>
                            <div class="brand" style="margin-bottom: 6px;">
                                <div class="brand-icon" style="width:34px; height:34px; font-size:1.1rem;">🍃</div>
                                <span style="font-size: 1.25rem;">Es Teh Solo</span>
                            </div>
                            <p style="font-size: 0.85rem; color: var(--text-secondary);">Struk Transaksi Pesanan Minuman</p>
                        </div>

                        <div style="text-align: right;">
                            <span style="display: block; font-size: 0.75rem; color: var(--text-secondary); font-weight: 700; text-transform: uppercase;">Nomor Pesanan</span>
                            <strong style="font-size: 1.3rem; color: var(--primary-dark);">${order.nomorPesanan}</strong>
                            <div style="margin-top: 6px;">
                                <span class="badge ${order.statusPesanan == 'Selesai' ? 'badge-success' : (order.statusPesanan == 'Menunggu' ? 'badge-warning' : (order.statusPesanan == 'Dibatalkan' ? 'badge-danger' : 'badge-info'))}">
                                    ${order.statusPesanan}
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Meta Grid -->
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; font-size: 0.92rem; margin-bottom: 28px;">
                        <div>
                            <span style="font-size: 0.78rem; font-weight: 700; color: var(--text-secondary); text-transform: uppercase; display: block;">Waktu Transaksi</span>
                            <strong style="color: var(--dark);"><fmt:formatDate value="${order.tanggalPesanan}" pattern="dd MMMM yyyy, HH:mm" /> WIB</strong>
                        </div>
                        <div>
                            <span style="font-size: 0.78rem; font-weight: 700; color: var(--text-secondary); text-transform: uppercase; display: block;">Metode Pengambilan</span>
                            <span class="badge ${order.metodePengambilan == 'Dine-in' ? 'badge-info' : 'badge-default'}">
                                ${order.metodePengambilan}
                            </span>
                        </div>
                        <div>
                            <span style="font-size: 0.78rem; font-weight: 700; color: var(--text-secondary); text-transform: uppercase; display: block;">Nama Pelanggan</span>
                            <strong style="color: var(--dark);">${order.userName}</strong>
                        </div>
                        <div>
                            <span style="font-size: 0.78rem; font-weight: 700; color: var(--text-secondary); text-transform: uppercase; display: block;">Kontak Pelanggan</span>
                            <strong style="color: var(--dark);">${order.userPhone} (${order.userEmail})</strong>
                        </div>
                        <div>
                            <span style="font-size: 0.78rem; font-weight: 700; color: var(--text-secondary); text-transform: uppercase; display: block;">Metode Pembayaran</span>
                            <strong style="color: var(--dark);">${order.metodePembayaran}</strong>
                        </div>
                        <div>
                            <span style="font-size: 0.78rem; font-weight: 700; color: var(--text-secondary); text-transform: uppercase; display: block;">Status Pembayaran</span>
                            <span class="badge ${order.statusPembayaran == 'Lunas' ? 'badge-success' : 'badge-warning'}">
                                ${order.statusPembayaran}
                            </span>
                        </div>
                    </div>

                    <c:if test="${not empty order.catatan}">
                        <div style="background: #FFFBEB; border: 1px solid #FDE68A; padding: 14px 18px; border-radius: var(--radius-sm); font-size: 0.9rem; color: #92400E; margin-bottom: 28px;">
                            <strong>Catatan Khusus Pelanggan:</strong> ${order.catatan}
                        </div>
                    </c:if>

                    <!-- Items Table -->
                    <div class="table-card" style="margin-bottom: 24px;">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Item Minuman</th>
                                    <th style="text-align: right;">Harga Satuan</th>
                                    <th style="text-align: center;">Jumlah</th>
                                    <th style="text-align: right;">Subtotal</th>
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
                                                    <div style="font-size: 0.8rem; margin-top: 2px;">
                                                        <c:if test="${not empty item.sugarLevel || not empty item.iceLevel}">
                                                            <span style="background: #e0f2fe; color: #0369a1; padding: 2px 6px; border-radius: 4px; font-weight: 600;">
                                                                Gula: ${item.sugarLevel} &bull; Es: ${item.iceLevel}
                                                            </span>
                                                        </c:if>
                                                        <c:if test="${not empty item.catatanItem}">
                                                            <span style="font-style: italic; color: #64748b; margin-left: 4px;">(${item.catatanItem})</span>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td style="text-align: right;">
                                            Rp <fmt:formatNumber value="${item.hargaSatuan}" type="number" groupingUsed="true"/>
                                        </td>
                                        <td style="text-align: center; font-weight: 800;">
                                            ${item.jumlah}
                                        </td>
                                        <td style="text-align: right; font-weight: 800; color: var(--primary-dark);">
                                            Rp <fmt:formatNumber value="${item.subtotal}" type="number" groupingUsed="true"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="3" style="text-align: right; font-size: 1.1rem; font-weight: 800; color: var(--primary-dark);">
                                        Total Pembayaran:
                                    </td>
                                    <td style="text-align: right; font-size: 1.35rem; font-weight: 800; color: var(--primary);">
                                        Rp <fmt:formatNumber value="${order.totalHarga}" type="number" groupingUsed="true"/>
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>

                <!-- Admin Action Card -->
                <div class="status-card" style="background: white; border-radius: var(--radius-lg); padding: 28px; border: 1px solid var(--border); box-shadow: var(--shadow-sm);">
                    <h3 style="font-size: 1.15rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 20px; padding-bottom: 12px; border-bottom: 1px solid var(--border-light);">
                        ⚙️ Kelola Status Pesanan
                    </h3>

                    <form action="${pageContext.request.contextPath}/admin/orders/update-status" method="POST">
                        <input type="hidden" name="orderId" value="${order.id}">
                        <input type="hidden" name="redirect" value="/admin/orders/detail?id=${order.id}">

                        <div class="form-group">
                            <label class="form-label">Ubah Status Pembuatan:</label>
                            <select name="newStatus" class="form-control" style="font-weight: 700; padding: 12px;">
                                <option value="Menunggu" ${order.statusPesanan == 'Menunggu' ? 'selected' : ''}>⏳ Menunggu Konfirmasi</option>
                                <option value="Diproses" ${order.statusPesanan == 'Diproses' ? 'selected' : ''}>🔄 Diproses (Sedang Diracik)</option>
                                <option value="Siap Diambil" ${order.statusPesanan == 'Siap Diambil' ? 'selected' : ''}>🥤 Siap Diambil / Diantar</option>
                                <option value="Selesai" ${order.statusPesanan == 'Selesai' ? 'selected' : ''}>✅ Selesai (Sudah Diserahkan)</option>
                                <option value="Dibatalkan" ${order.statusPesanan == 'Dibatalkan' ? 'selected' : ''}>❌ Dibatalkan</option>
                            </select>
                        </div>

                        <button type="submit" class="btn btn-primary" style="width: 100%;">
                            Simpan Perubahan Status
                        </button>
                    </form>

                    <form action="${pageContext.request.contextPath}/admin/orders/update-payment-status" method="POST" style="margin-top: 16px;">
                        <input type="hidden" name="orderId" value="${order.id}">
                        <input type="hidden" name="redirect" value="/admin/orders/detail?id=${order.id}">

                        <div class="form-group">
                            <label class="form-label">Ubah Status Pembayaran:</label>
                            <select name="paymentStatus" class="form-control" style="font-weight: 700; padding: 12px;">
                                <option value="Belum Bayar" ${order.statusPembayaran == 'Belum Bayar' ? 'selected' : ''}>⏳ Belum Bayar</option>
                                <option value="Lunas" ${order.statusPembayaran == 'Lunas' ? 'selected' : ''}>✅ Lunas</option>
                            </select>
                        </div>

                        <button type="submit" class="btn btn-secondary" style="width: 100%;">
                            Simpan Status Pembayaran
                        </button>
                    </form>

                    <div style="margin-top: 28px; padding-top: 20px; border-top: 1px solid var(--border-light);">
                        <h4 style="font-size: 0.9rem; font-weight: 700; color: var(--text-secondary); margin-bottom: 12px; text-transform: uppercase;">
                            Hubungi Pelanggan:
                        </h4>
                        <c:set var="rawPhone" value="${empty order.userPhone ? '81234567890' : order.userPhone}" />
                        <c:set var="cleanPhone" value="${rawPhone.startsWith('0') ? rawPhone.substring(1) : rawPhone}" />
                        <a href="https://wa.me/62${cleanPhone}?text=Halo%20${order.userName},%20pesanan%20Es%20Teh%20Solo%20dengan%20nomor%20${order.nomorPesanan}%20sedang%20kami%20proses."
                           target="_blank"
                           class="btn btn-secondary btn-sm"
                           style="width: 100%; justify-content: center; background: #25D366; color: white; border: none;">
                            💬 Hubungi via WhatsApp
                        </a>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
