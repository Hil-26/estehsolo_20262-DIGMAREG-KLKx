<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<footer class="footer">
    <div class="container">
        <div class="footer-grid">
            <div>
                <div class="footer-brand">
                    <span>🍃</span> Es Teh Solo
                </div>
                <p style="font-size: 0.92rem; line-height: 1.6; color: rgba(255,255,255,0.75); margin-bottom: 20px;">
                    Menyajikan kesegaran teh khas Solo dengan racikan tradisional wasgitel (wangi, sepet, legi, lan kenthel). Dibuat sepenuh hati dari daun teh pilihan nusantara.
                </p>
                <div style="display: flex; flex-direction: column; gap: 8px; font-size: 0.92rem; margin-top: 14px;">
                    <span>📍 Bandar Lampung, Lampung</span>
                    <a href="https://wa.me/6289515256232" target="_blank" style="color: #4CAF50; font-weight: 700; display: inline-flex; align-items: center; gap: 6px;">
                        <span>💬</span> WA Admin: 0895-1525-6232
                    </a>
                </div>
            </div>

            <div class="footer-col">
                <h4>Menu Favorit</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/menu">Es Teh Jumbo Solo</a></li>
                    <li><a href="${pageContext.request.contextPath}/menu">Es Teh Kampul</a></li>
                    <li><a href="${pageContext.request.contextPath}/menu">Es Teh Susu Cendana</a></li>
                    <li><a href="${pageContext.request.contextPath}/menu">Es Teh Lemon Segar</a></li>
                </ul>
            </div>

            <div class="footer-col">
                <h4>Navigasi Cepat</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/">Beranda</a></li>
                    <li><a href="${pageContext.request.contextPath}/menu">Daftar Menu</a></li>
                    <li><a href="${pageContext.request.contextPath}/about">Tentang Kami</a></li>
                    <li><a href="${pageContext.request.contextPath}/contact">Kontak Kami</a></li>
                    <li><a href="${pageContext.request.contextPath}/cart">Keranjang Belanja</a></li>
                    <li><a href="${pageContext.request.contextPath}/orders">Riwayat Pesanan</a></li>
                </ul>
            </div>

            <div class="footer-col">
                <h4>Jam Operasional</h4>
                <p style="font-size: 0.92rem; color: rgba(255,255,255,0.75); margin-bottom: 10px;">
                    Setiap Hari: 09:00 - 21:00 WIB
                </p>
                <p style="font-size: 0.92rem; color: rgba(255,255,255,0.75);">
                    Layanan pemesanan online aktif untuk Takeaway dan Dine-in di outlet.
                </p>
            </div>
        </div>

        <div class="footer-bottom">
            &copy; 2026 Es Teh Solo - Sistem Pemesanan Minuman Online Berbasis Java & PostgreSQL. All rights reserved.
        </div>
    </div>
</footer>

<!-- Floating WhatsApp Chat Button -->
<a href="https://wa.me/6289515256232?text=Halo%20Admin%20Es%20Teh%20Solo,%20saya%20ingin%20bertanya%20seputar%20menu%20dan%20pemesanan%20minuman."
   target="_blank"
   class="floating-wa"
   title="Hubungi Admin Es Teh Solo via WhatsApp (0895-1525-6232)">
    <span class="floating-wa-icon">💬</span>
    <span class="floating-wa-text">Chat WhatsApp Admin</span>
</a>

<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
