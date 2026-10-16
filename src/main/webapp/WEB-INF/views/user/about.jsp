<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tentang Kami - Tradisi Kelezatan Es Teh Solo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

    <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

    <!-- HERO ABOUT -->
    <section class="hero" style="padding: 50px 0 30px;">
        <div class="container text-center" style="max-width: 800px;">
            <div class="hero-badge">
                <span>🍃</span> Sejarah & Filosofi
            </div>
            <h1 class="hero-title">
                Warisan Rasa Teh Wasgitel <br>
                <span>Kebanggaan Kota Solo</span>
            </h1>
            <p class="hero-desc" style="margin: 0 auto 30px;">
                Membawa kenikmatan es teh manis khas Solo ke era digital dengan tetap menjunjung tinggi resep racikan tradisional nusantara.
            </p>
        </div>
    </section>

    <!-- CONTENT SECTION -->
    <section class="section" style="background: white;">
        <div class="container">
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 48px; align-items: center; margin-bottom: 60px;">
                <div>
                    <span class="section-tag">Filosofi Tradisi</span>
                    <h2 class="section-title">Apa itu "WASGITEL"?</h2>
                    <p style="font-size: 1.05rem; color: var(--text-secondary); line-height: 1.8; margin-bottom: 16px;">
                        Bagi masyarakat Solo (Surakarta), teh bukan sekadar minuman penghilang haus, melainkan bagian tak terpisahkan dari budaya guyub dan keramahan.
                    </p>
                    <p style="font-size: 1.05rem; color: var(--text-secondary); line-height: 1.8; margin-bottom: 24px;">
                        <strong>WASGITEL</strong> adalah singkatan bahasa Jawa yang menggambarkan standar racikan teh sempurna:
                    </p>
                    <ul style="list-style: none; display: flex; flex-direction: column; gap: 12px;">
                        <li style="display: flex; gap: 12px; align-items: center;">
                            <span class="badge badge-success">Wangi</span> Harum semerbak alami daun teh berpadu bunga melati segar.
                        </li>
                        <li style="display: flex; gap: 12px; align-items: center;">
                            <span class="badge badge-success">Sepet</span> Rasa sepet khas teh tubruk kental yang mantap di lidah.
                        </li>
                        <li style="display: flex; gap: 12px; align-items: center;">
                            <span class="badge badge-success">Legi</span> Manis pas menggunakan gula tebu murni tanpa pemanis buatan.
                        </li>
                        <li style="display: flex; gap: 12px; align-items: center;">
                            <span class="badge badge-success">Kenthel</span> Seduhan pekat berkualitas dari racikan daun teh pilihan.
                        </li>
                    </ul>
                </div>

                <div>
                    <img src="${pageContext.request.contextPath}/assets/images/esteh_kampul.jpg"
                         alt="Tradisi Es Teh Solo"
                         style="border-radius: var(--radius-lg); width: 100%; height: 420px; object-fit: cover; box-shadow: var(--shadow-lg); border: 6px solid var(--cream-light);">
                </div>
            </div>

            <!-- VALUES -->
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 28px; padding-top: 40px; border-top: 1px solid var(--border-light);">
                <div style="background: var(--cream-light); padding: 32px; border-radius: var(--radius-lg); text-align: center;">
                    <div style="font-size: 2.5rem; margin-bottom: 12px;">🌱</div>
                    <h3 style="font-size: 1.2rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 8px;">100% Alami</h3>
                    <p style="font-size: 0.92rem; color: var(--text-secondary);">Menggunakan daun teh lokal nusantara berkualitas tinggi tanpa bahan pengawet.</p>
                </div>
                <div style="background: var(--cream-light); padding: 32px; border-radius: var(--radius-lg); text-align: center;">
                    <div style="font-size: 2.5rem; margin-bottom: 12px;">🧊</div>
                    <h3 style="font-size: 1.2rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 8px;">Es Higienis</h3>
                    <p style="font-size: 0.92rem; color: var(--text-secondary);">Es batu kristal standar food grade bersertifikat dari air minum matang steril.</p>
                </div>
                <div style="background: var(--cream-light); padding: 32px; border-radius: var(--radius-lg); text-align: center;">
                    <div style="font-size: 2.5rem; margin-bottom: 12px;">📱</div>
                    <h3 style="font-size: 1.2rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 8px;">Pemesanan Digital</h3>
                    <p style="font-size: 0.92rem; color: var(--text-secondary);">Pesan online praktis, cepat, tanpa antre panjang di kasir.</p>
                </div>
            </div>
        </div>
    </section>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
