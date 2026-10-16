<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daftar Akun Baru - Es Teh Solo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

    <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

    <div class="auth-wrapper">
        <div class="auth-card" style="max-width: 500px;">
            <div class="auth-header">
                <div class="brand-icon" style="margin: 0 auto; width: 56px; height: 56px; font-size: 1.8rem;">🍃</div>
                <h2>Buat Akun Baru</h2>
                <p style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 6px;">
                    Daftar untuk menikmati kemudahan pemesanan online
                </p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger" style="margin-bottom: 20px;">
                    <span>⚠️</span> <span><c:out value="${error}" /></span>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="POST">
                <div class="form-group">
                    <label class="form-label">Nama Lengkap *</label>
                    <input type="text" name="nama" class="form-control" placeholder="Contoh: Siti Rahmawati" value="${nama}" required autofocus>
                </div>

                <div class="form-group">
                    <label class="form-label">Alamat Email *</label>
                    <input type="email" name="email" class="form-control" placeholder="nama@email.com" value="${email}" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Nomor WhatsApp / HP *</label>
                    <input type="tel" name="noHp" class="form-control" placeholder="Contoh: 081234567890" value="${noHp}" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Password * (Minimal 6 karakter)</label>
                    <input type="password" name="password" class="form-control" placeholder="Buat password aman" minlength="6" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Konfirmasi Password *</label>
                    <input type="password" name="confirmPassword" class="form-control" placeholder="Ulangi password" minlength="6" required>
                </div>

                <button type="submit" class="btn btn-primary btn-lg" style="width: 100%; margin-top: 10px;">
                    Daftar Akun Sekarang 🍃
                </button>
            </form>

            <div class="auth-footer">
                Sudah memiliki akun? <a href="${pageContext.request.contextPath}/login">Masuk di sini</a>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
