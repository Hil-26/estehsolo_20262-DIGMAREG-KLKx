<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profil Akun Saya - Es Teh Solo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

    <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

    <section class="section">
        <div class="container" style="max-width: 800px;">
            <div style="margin-bottom: 32px;">
                <span class="section-tag">Pengaturan Akun</span>
                <h1 class="section-title">Profil Saya</h1>
            </div>

            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible" style="margin-bottom: 24px;">
                    <span>✅</span> <span><c:out value="${param.success}" /></span>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible" style="margin-bottom: 24px;">
                    <span>⚠️</span> <span><c:out value="${param.error}" /></span>
                </div>
            </c:if>

            <div style="display: grid; grid-template-columns: 1fr; gap: 32px;">
                <!-- Form 1: Edit Info -->
                <div style="background: white; border-radius: var(--radius-lg); padding: 32px; border: 1px solid var(--border); box-shadow: var(--shadow-sm);">
                    <h3 style="font-size: 1.25rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 20px;">
                        👤 Informasi Kontak
                    </h3>

                    <form action="${pageContext.request.contextPath}/profile/update" method="POST">
                        <div class="form-group">
                            <label class="form-label">Alamat Email</label>
                            <input type="email" class="form-control" value="${userProfile.email}" readonly style="background: #F8FAFC; color: var(--text-secondary);">
                            <small style="color: var(--text-secondary); font-size: 0.8rem; margin-top: 4px; display: block;">Email digunakan sebagai identitas akun utama dan tidak dapat diubah.</small>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Nama Lengkap *</label>
                            <input type="text" name="nama" class="form-control" value="${userProfile.nama}" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Nomor WhatsApp / HP *</label>
                            <input type="text" name="noHp" class="form-control" value="${userProfile.noHp}" required>
                        </div>

                        <button type="submit" class="btn btn-primary">
                            Simpan Perubahan Profil
                        </button>
                    </form>
                </div>

                <!-- Form 2: Change Password -->
                <div style="background: white; border-radius: var(--radius-lg); padding: 32px; border: 1px solid var(--border); box-shadow: var(--shadow-sm);">
                    <h3 style="font-size: 1.25rem; font-weight: 800; color: var(--primary-dark); margin-bottom: 20px;">
                        🔒 Ganti Kata Sandi
                    </h3>

                    <form action="${pageContext.request.contextPath}/profile/password" method="POST">
                        <div class="form-group">
                            <label class="form-label">Password Saat Ini *</label>
                            <input type="password" name="currentPassword" class="form-control" placeholder="Masukkan password saat ini" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Password Baru * (Minimal 6 karakter)</label>
                            <input type="password" name="newPassword" class="form-control" placeholder="Masukkan password baru" minlength="6" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Konfirmasi Password Baru *</label>
                            <input type="password" name="confirmPassword" class="form-control" placeholder="Ulangi password baru" minlength="6" required>
                        </div>

                        <button type="submit" class="btn btn-secondary">
                            Ubah Password
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
