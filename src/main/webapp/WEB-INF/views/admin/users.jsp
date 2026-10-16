<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Pengguna - Es Teh Solo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

    <div class="admin-layout">
        <jsp:include page="/WEB-INF/views/admin/sidebar.jsp" />

        <main class="admin-main">
            <div class="admin-topbar">
                <div>
                    <h1 style="font-size: 1.8rem; font-weight: 800; color: var(--primary-dark);">Daftar Akun Pengguna</h1>
                    <p style="color: var(--text-secondary); font-size: 0.9rem;">Informasi akun pelanggan dan administrator terdaftar.</p>
                </div>
            </div>

            <!-- Global Alerts -->
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

            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 12px;">
                <form action="${pageContext.request.contextPath}/admin/users" method="GET" style="display: flex; gap: 8px;">
                    <input type="text" name="q" value="<c:out value='${searchQuery}' />" class="form-control" placeholder="Cari nama, email, no hp..." style="padding: 6px 12px; font-size: 0.88rem; width: 260px;">
                    <button type="submit" class="btn btn-primary btn-sm" style="white-space: nowrap;">🔍 Cari</button>
                    <c:if test="${not empty searchQuery}">
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary btn-sm" style="white-space: nowrap;">Reset</a>
                    </c:if>
                </form>
                <div style="font-size: 0.88rem; color: var(--text-secondary); font-weight: 600;">
                    Total: <strong style="color: var(--primary-dark);">${users.size()} pengguna terdaftar</strong>
                </div>
            </div>

            <div class="table-card">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nama Lengkap</th>
                                <th>Email</th>
                                <th>Nomor Telepon</th>
                                <th>Peran (Role)</th>
                                <th>Tanggal Bergabung</th>
                                <th style="text-align: right;">Aksi Akun</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${users}">
                                <tr>
                                    <td>#${u.id}</td>
                                    <td>
                                        <strong style="color: var(--dark);">${u.nama}</strong>
                                    </td>
                                    <td>${u.email}</td>
                                    <td>${not empty u.noHp ? u.noHp : '-'}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.role == 'admin'}">
                                                <span class="badge badge-warning">👑 Admin</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-info">👤 User</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="font-size: 0.85rem; color: var(--text-secondary);">
                                        <fmt:formatDate value="${u.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                    </td>
                                    <td style="text-align: right;">
                                        <div style="display: inline-flex; gap: 6px; align-items: center;">
                                            <!-- Switch Role -->
                                            <form action="${pageContext.request.contextPath}/admin/users/role" method="POST" style="display:inline;">
                                                <input type="hidden" name="userId" value="${u.id}">
                                                <input type="hidden" name="role" value="${u.role == 'admin' ? 'user' : 'admin'}">
                                                <button type="submit" class="btn btn-secondary btn-sm" style="padding: 4px 8px; font-size: 0.75rem;" title="Ubah peran akun">
                                                    ${u.role == 'admin' ? 'Jadikan User' : 'Jadikan Admin'}
                                                </button>
                                            </form>

                                            <!-- Reset Password -->
                                            <form action="${pageContext.request.contextPath}/admin/users/reset-password" method="POST" onsubmit="return confirm('Reset password pengguna ${u.nama} menjadi user123?');" style="display:inline;">
                                                <input type="hidden" name="userId" value="${u.id}">
                                                <button type="submit" class="btn btn-outline btn-sm" style="padding: 4px 8px; font-size: 0.75rem;" title="Reset password ke user123">
                                                    🔑 Reset Pass
                                                </button>
                                            </form>

                                            <!-- Delete User (if not self) -->
                                            <c:if test="${sessionScope.user.id != u.id}">
                                                <form action="${pageContext.request.contextPath}/admin/users/delete" method="POST" onsubmit="return confirm('Hapus akun ${u.nama}?');" style="display:inline;">
                                                    <input type="hidden" name="userId" value="${u.id}">
                                                    <button type="submit" class="btn btn-danger btn-sm" style="padding: 4px 8px; font-size: 0.75rem;">
                                                        🗑️
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>
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
