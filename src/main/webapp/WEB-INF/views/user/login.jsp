<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Masuk Akun - Es Teh Solo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

    <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

    <div class="auth-wrapper">
        <div class="auth-card">
            <div class="auth-header">
                <div class="brand-icon" style="margin: 0 auto; width: 56px; height: 56px; font-size: 1.8rem;">🍃</div>
                <h2>Selamat Datang Kembali</h2>
                <p style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 6px;">
                    Masuk untuk memesan es teh Solo favorit Anda
                </p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger" style="margin-bottom: 20px;">
                    <span>⚠️</span> <span><c:out value="${error}" /></span>
                </div>
            </c:if>

            <!-- Quick Demo Credentials Fill -->
            <div style="background: var(--cream-light); padding: 12px 16px; border-radius: var(--radius-sm); border: 1px dashed var(--primary); margin-bottom: 20px;">
                <span style="font-size: 0.78rem; font-weight: 700; color: var(--primary-dark); display: block; margin-bottom: 6px;">⚡ Akun Cepat untuk Pengujian (Demo):</span>
                <div style="display: flex; gap: 8px;">
                    <button type="button" class="btn btn-secondary btn-sm" style="font-size: 0.75rem; padding: 4px 10px;" onclick="fillDemo('admin@estehsolo.com', 'admin123')">
                        👑 Admin
                    </button>
                    <button type="button" class="btn btn-secondary btn-sm" style="font-size: 0.75rem; padding: 4px 10px;" onclick="fillDemo('budi@gmail.com', 'user123')">
                        👤 User (Budi)
                    </button>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/login" method="POST">
                <input type="hidden" name="redirect" value="<c:out value='${param.redirect}' />">
                <div class="form-group">
                    <label class="form-label">Alamat Email *</label>
                    <input type="email" name="email" id="loginEmail" class="form-control" placeholder="nama@email.com" value="${email}" required autofocus>
                </div>

                <div class="form-group">
                    <label class="form-label">Password *</label>
                    <input type="password" name="password" id="loginPassword" class="form-control" placeholder="Masukkan password" required>
                </div>

                <button type="submit" class="btn btn-primary btn-lg" style="width: 100%; margin-top: 10px;">
                    Masuk Sekarang 🍃
                </button>
            </form>

            <div class="auth-footer">
                Belum punya akun? <a href="${pageContext.request.contextPath}/register">Daftar sekarang</a>
            </div>
        </div>
    </div>

    <script>
        function fillDemo(email, pass) {
            document.getElementById('loginEmail').value = email;
            document.getElementById('loginPassword').value = pass;
        }
    </script>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
