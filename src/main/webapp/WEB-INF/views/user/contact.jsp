<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hubungi Kami - Es Teh Solo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

    <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

    <section class="section">
        <div class="container">
            <div class="section-header" style="margin-bottom: 36px;">
                <span class="section-tag">Layanan Pelanggan</span>
                <h1 class="section-title">Hubungi Kami</h1>
                <p class="section-subtitle">Punya pertanyaan seputar menu, kemitraan, atau pesanan? Tim Es Teh Solo siap membantu.</p>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1.2fr; gap: 40px; align-items: start;">
                <!-- Contact Info Card -->
                <div style="background: white; border-radius: var(--radius-lg); padding: 36px; border: 1px solid var(--border); box-shadow: var(--shadow-sm);">
                    <h3 style="font-size: 1.25rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 24px;">
                        Es Teh Solo – Bandar Lampung
                    </h3>

                    <div style="display: flex; flex-direction: column; gap: 20px;">
                        <div style="display: flex; gap: 16px; align-items: flex-start;">
                            <div style="font-size: 1.5rem; color: var(--primary);">📍</div>
                            <div>
                                <strong style="color: var(--dark); display: block; font-size: 0.95rem;">Alamat Outlet:</strong>
                                <p style="font-size: 0.9rem; color: var(--text-secondary); line-height: 1.6;">
                                    Jl. Teuku Cik Ditiro, Beringin Raya, Kec. Kemiling,<br>
                                    Kota Bandar Lampung, Lampung 35155
                                </p>
                                <a href="https://maps.app.goo.gl/nfnus35Yn3T3VpHG8"
                                   target="_blank"
                                   class="btn btn-secondary btn-sm"
                                   style="margin-top: 8px; background: #4285F4; color: white; border: none;">
                                    📍 Lihat di Google Maps
                                </a>
                            </div>
                        </div>

                        <div style="display: flex; gap: 16px; align-items: flex-start;">
                            <div style="font-size: 1.5rem; color: var(--primary);">💬</div>
                            <div>
                                <strong style="color: var(--dark); display: block; font-size: 0.95rem;">WhatsApp Layanan Pesanan:</strong>
                                <p style="font-size: 0.9rem; color: var(--text-secondary); line-height: 1.6;">
                                    +62 895-1525-6232 (Aktif Setiap Hari)
                                </p>
                                <a href="https://wa.me/6289515256232?text=Halo%20Admin%20Es%20Teh%20Solo,%20saya%20ingin%20bertanya%20seputar%20pemesanan%20minuman"
                                   target="_blank"
                                   class="btn btn-secondary btn-sm"
                                   style="margin-top: 8px; background: #25D366; color: white; border: none;">
                                    💬 Chat via WhatsApp Langsung
                                </a>
                            </div>
                        </div>

                        <div style="display: flex; gap: 16px; align-items: flex-start;">
                            <div style="font-size: 1.5rem; color: var(--primary);">🕒</div>
                            <div>
                                <strong style="color: var(--dark); display: block; font-size: 0.95rem;">Jam Buka:</strong>
                                <p style="font-size: 0.9rem; color: var(--text-secondary); line-height: 1.6;">
                                    Senin - Minggu: 09:00 - 21:00 WIB
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Message Form -->
                <div style="background: white; border-radius: var(--radius-lg); padding: 36px; border: 1px solid var(--border); box-shadow: var(--shadow-sm);">
                    <h3 style="font-size: 1.25rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 20px;">
                        Kirim Pesan / Saran
                    </h3>

                    <c:if test="${not empty param.success}">
                        <div class="alert alert-success alert-dismissible" style="margin-bottom: 20px;">
                            <span>✅</span> <span><c:out value="${param.success}" /></span>
                        </div>
                    </c:if>
                    <c:if test="${not empty param.error}">
                        <div class="alert alert-danger alert-dismissible" style="margin-bottom: 20px;">
                            <span>⚠️</span> <span><c:out value="${param.error}" /></span>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/contact/send" method="POST">
                        <div class="form-group">
                            <label class="form-label">Nama Anda *</label>
                            <input type="text" name="nama" class="form-control" placeholder="Masukkan nama Anda" value="${sessionScope.user.nama}" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Email / WhatsApp *</label>
                            <input type="text" name="kontak" class="form-control" placeholder="Email atau nomor HP Anda" value="${sessionScope.user.email}" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Pesan / Masukan *</label>
                            <textarea name="pesan" class="form-control" rows="4" placeholder="Tuliskan pesan, pertanyaan, atau saran Anda untuk kami..." required></textarea>
                        </div>

                        <button type="submit" class="btn btn-primary btn-lg" style="width: 100%;">
                            Kirim Pesan 🍃
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
