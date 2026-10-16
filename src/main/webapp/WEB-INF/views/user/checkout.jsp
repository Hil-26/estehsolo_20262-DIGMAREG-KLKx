<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Konfirmasi Pemesanan - Es Teh Solo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

    <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

    <section class="section">
        <div class="container">
            <div style="margin-bottom: 32px;">
                <span class="section-tag">Langkah Terakhir</span>
                <h1 class="section-title">Konfirmasi Pemesanan</h1>
            </div>

            <form action="${pageContext.request.contextPath}/checkout" method="POST">
                <div style="display: grid; grid-template-columns: 1.4fr 1fr; gap: 32px; align-items: start;">
                    <!-- Order Options & Information -->
                    <div style="background: white; border-radius: var(--radius-lg); padding: 32px; border: 1px solid var(--border); box-shadow: var(--shadow-sm);">
                        <h3 style="font-size: 1.25rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 24px;">
                            📋 Data Pemesan & Metode Pengambilan
                        </h3>

                        <div class="form-group">
                            <label class="form-label">Nama Pelanggan</label>
                            <input type="text" class="form-control" value="${sessionScope.user.nama}" readonly style="background: #F8FAFC;">
                        </div>

                        <div class="form-group">
                            <label class="form-label">Nomor WhatsApp / HP</label>
                            <input type="text" class="form-control" value="${sessionScope.user.noHp}" readonly style="background: #F8FAFC;">
                            <small style="color: var(--text-secondary); font-size: 0.8rem; margin-top: 4px; display: block;">
                                Anda dapat memperbarui nomor telepon di menu Profil Saya.
                            </small>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Metode Pengambilan *</label>
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                                <label style="display: flex; align-items: center; gap: 12px; padding: 16px; border: 2px solid var(--primary); border-radius: var(--radius-md); background: var(--primary-subtle); cursor: pointer;">
                                    <input type="radio" name="metodePengambilan" value="Takeaway" checked>
                                    <div>
                                        <strong style="color: var(--primary-dark); display: block;">🥡 Takeaway</strong>
                                        <span style="font-size: 0.8rem; color: var(--text-secondary);">Bawa pulang / ambil di outlet</span>
                                    </div>
                                </label>

                                <label style="display: flex; align-items: center; gap: 12px; padding: 16px; border: 2px solid var(--border); border-radius: var(--radius-md); background: white; cursor: pointer;">
                                    <input type="radio" name="metodePengambilan" value="Dine-in">
                                    <div>
                                        <strong style="color: var(--primary-dark); display: block;">🪑 Dine-in</strong>
                                        <span style="font-size: 0.8rem; color: var(--text-secondary);">Minum di tempat (outlet Solo)</span>
                                    </div>
                                </label>
                            </div>
                        </div>

                        <!-- Metode Pembayaran -->
                        <div class="form-group">
                            <label class="form-label">Metode Pembayaran *</label>
                            <div style="display: flex; flex-direction: column; gap: 12px;">
                                <label style="display: flex; align-items: center; gap: 12px; padding: 14px 16px; border: 1.5px solid var(--border); border-radius: var(--radius-md); background: white; cursor: pointer;" onclick="document.getElementById('qrisInfo').style.display='block'; document.getElementById('transferInfo').style.display='none';">
                                    <input type="radio" name="metodePembayaran" value="QRIS" checked>
                                    <div style="flex: 1;">
                                        <div style="display: flex; justify-content: space-between; align-items: center;">
                                            <strong style="color: var(--dark);">📱 QRIS (Instant)</strong>
                                            <span style="font-size: 0.75rem; background: #dcfce7; color: #166534; padding: 2px 8px; border-radius: 9999px; font-weight: 700;">Rekomendasi</span>
                                        </div>
                                        <span style="font-size: 0.8rem; color: var(--text-secondary);">BCA, Mandiri, GoPay, OVO, DANA, ShopeePay</span>
                                    </div>
                                </label>

                                <div id="qrisInfo" style="background: #f8fafc; border: 1px dashed #cbd5e1; border-radius: var(--radius-md); padding: 14px 18px; font-size: 0.85rem; color: var(--dark);">
                                    <div style="display: flex; gap: 14px; align-items: center;">
                                        <div style="font-size: 2rem;">📲</div>
                                        <div>
                                            <strong>Instruksi QRIS:</strong>
                                            <p style="margin: 4px 0 0; color: var(--text-secondary); font-size: 0.8rem;">
                                                QRIS barcode akan tersedia di invoice / kasir saat pengambilan pesanan. Cukup scan & bayar sesuai total tagihan.
                                            </p>
                                        </div>
                                    </div>
                                </div>

                                <label style="display: flex; align-items: center; gap: 12px; padding: 14px 16px; border: 1.5px solid var(--border); border-radius: var(--radius-md); background: white; cursor: pointer;" onclick="document.getElementById('transferInfo').style.display='block'; document.getElementById('qrisInfo').style.display='none';">
                                    <input type="radio" name="metodePembayaran" value="Transfer Bank">
                                    <div style="flex: 1;">
                                        <strong style="color: var(--dark); display: block;">🏦 Transfer Bank (BCA / Mandiri)</strong>
                                        <span style="font-size: 0.8rem; color: var(--text-secondary);">Transfer manual ke rekening resmi outlet</span>
                                    </div>
                                </label>

                                <div id="transferInfo" style="display: none; background: #f8fafc; border: 1px dashed #cbd5e1; border-radius: var(--radius-md); padding: 14px 18px; font-size: 0.85rem; color: var(--dark);">
                                    <strong>Rekening Pembayaran:</strong>
                                    <ul style="margin: 6px 0 0 16px; padding: 0; font-size: 0.82rem; color: var(--text-secondary);">
                                        <li>BCA: <strong>015-8899-231</strong> a.n. Es Teh Solo Asli</li>
                                        <li>Mandiri: <strong>138-00-9988-1122</strong> a.n. Es Teh Solo Asli</li>
                                    </ul>
                                </div>

                                <label style="display: flex; align-items: center; gap: 12px; padding: 14px 16px; border: 1.5px solid var(--border); border-radius: var(--radius-md); background: white; cursor: pointer;" onclick="document.getElementById('qrisInfo').style.display='none'; document.getElementById('transferInfo').style.display='none';">
                                    <input type="radio" name="metodePembayaran" value="Tunai di Kasir">
                                    <div style="flex: 1;">
                                        <strong style="color: var(--dark); display: block;">💵 Bayar Tunai di Kasir</strong>
                                        <span style="font-size: 0.8rem; color: var(--text-secondary);">Bayar langsung saat mengambil pesanan</span>
                                    </div>
                                </label>
                            </div>
                        </div>

                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label">Catatan Pesanan (Opsional)</label>
                            <textarea name="catatan" class="form-control" rows="3" placeholder="Contoh: Nomor meja jika dine-in, minta sedotan ekstra, atau catatan lainnya..."></textarea>
                        </div>
                    </div>

                    <!-- Items Summary -->
                    <div style="background: white; border-radius: var(--radius-lg); padding: 28px; border: 1px solid var(--border); box-shadow: var(--shadow-sm);">
                        <h3 style="font-size: 1.25rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 20px; padding-bottom: 14px; border-bottom: 1px solid var(--border-light);">
                            Rincian Minuman
                        </h3>

                        <div style="display: flex; flex-direction: column; gap: 14px; margin-bottom: 24px;">
                            <c:forEach var="item" items="${cart.items}">
                                <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                                    <div>
                                        <div style="font-weight: 700; color: var(--dark); font-size: 0.95rem;">
                                            ${item.product.namaProduk}
                                        </div>
                                        <div style="font-size: 0.8rem; color: var(--text-secondary); margin-top: 2px;">
                                            ${item.quantity} x Rp <fmt:formatNumber value="${item.product.harga}" type="number" groupingUsed="true"/>
                                        </div>
                                        <c:if test="${not empty item.sugarLevel || not empty item.iceLevel}">
                                            <div style="font-size: 0.76rem; background: #e0f2fe; color: #0369a1; padding: 2px 6px; border-radius: 4px; display: inline-block; margin-top: 4px; font-weight: 600;">
                                                Gula: ${item.sugarLevel} &bull; Es: ${item.iceLevel}
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty item.notes}">
                                            <div style="font-size: 0.76rem; color: #64748b; font-style: italic; margin-top: 2px;">
                                                Catatan: ${item.notes}
                                            </div>
                                        </c:if>
                                    </div>
                                    <div style="font-weight: 800; color: var(--primary-dark);">
                                        Rp <fmt:formatNumber value="${item.subtotal}" type="number" groupingUsed="true"/>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <div style="padding-top: 16px; border-top: 2px dashed var(--border); margin-bottom: 24px;">
                            <div style="display: flex; justify-content: space-between; margin-bottom: 10px;">
                                <span style="color: var(--text-secondary);">Total Item:</span>
                                <span style="font-weight: 700;">${cart.totalCount} porsi</span>
                            </div>
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <span style="font-size: 1.15rem; font-weight: 800; color: var(--primary-dark);">Total Bayar:</span>
                                <span style="font-size: 1.4rem; font-weight: 800; color: var(--primary);">
                                    Rp <fmt:formatNumber value="${cart.totalPrice}" type="number" groupingUsed="true"/>
                                </span>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary btn-lg" style="width: 100%;">
                            Konfirmasi & Buat Pesanan 🍃
                        </button>

                        <a href="${pageContext.request.contextPath}/cart" class="btn btn-secondary btn-sm" style="width: 100%; margin-top: 12px;">
                            ← Kembali ke Keranjang
                        </a>
                    </div>
                </div>
            </form>
        </div>
    </section>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
