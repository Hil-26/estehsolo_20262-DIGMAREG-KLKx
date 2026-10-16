<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pesan Masuk &amp; Kontak Pelanggan - Es Teh Solo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .filter-pill {
            padding: 8px 16px;
            border-radius: 9999px;
            font-size: 0.88rem;
            font-weight: 600;
            text-decoration: none;
            color: var(--text-secondary);
            background: white;
            border: 1px solid var(--border);
            transition: var(--transition);
        }
        .filter-pill:hover, .filter-pill.active {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
        }
        .status-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 9999px;
            font-size: 0.78rem;
            font-weight: 700;
        }
        .status-baru { background: #fee2e2; color: #b91c1c; }
        .status-dibaca { background: #fef3c7; color: #b45309; }
        .status-dibalas { background: #dcfce7; color: #15803d; }
    </style>
</head>
<body>
    <div class="admin-layout">
        <jsp:include page="/WEB-INF/views/admin/sidebar.jsp" />
        <main class="admin-main">
            <div class="admin-topbar">
                <div>
                    <h1 style="font-size: 1.8rem; font-weight: 800; color: var(--primary-dark);">📬 Pesan Masuk &amp; Kontak</h1>
                    <p style="color: var(--text-secondary); font-size: 0.9rem;">Kelola pesan, pertanyaan, dan kritik/saran dari pelanggan Es Teh Solo.</p>
                </div>
                <div style="font-size: 0.9rem; color: var(--text-secondary); font-weight: 600;">
                    Pesan Belum Dibaca: <strong style="color: #ef4444;">${unreadCount} pesan</strong>
                </div>
            </div>

            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible">
                    <span>✅</span> <span><c:out value="${param.success}" /></span>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible">
                    <span>⚠</span> <span><c:out value="${param.error}" /></span>
                </div>
            </c:if>

            <!-- Filter Status -->
            <div style="display: flex; gap: 8px; margin-bottom: 20px; flex-wrap: wrap;">
                <a href="${pageContext.request.contextPath}/admin/contacts?status=Semua" class="filter-pill ${selectedStatus == 'Semua' ? 'active' : ''}">Semua Pesan</a>
                <a href="${pageContext.request.contextPath}/admin/contacts?status=Baru" class="filter-pill ${selectedStatus == 'Baru' ? 'active' : ''}">🔴 Baru</a>
                <a href="${pageContext.request.contextPath}/admin/contacts?status=Dibaca" class="filter-pill ${selectedStatus == 'Dibaca' ? 'active' : ''}">🟡 Dibaca</a>
                <a href="${pageContext.request.contextPath}/admin/contacts?status=Dibalas" class="filter-pill ${selectedStatus == 'Dibalas' ? 'active' : ''}">🟢 Dibalas</a>
            </div>

            <c:choose>
                <c:when test="${empty contacts}">
                    <div style="background: white; border-radius: var(--radius-lg); padding: 60px 20px; text-align: center; border: 1px solid var(--border); box-shadow: var(--shadow-sm);">
                        <div style="font-size: 3.5rem; margin-bottom: 16px;">📭</div>
                        <h3 style="font-size: 1.3rem; color: var(--primary-dark); margin-bottom: 8px;">Tidak Ada Pesan</h3>
                        <p style="color: var(--text-secondary); max-width: 400px; margin: 0 auto;">Tidak ada pesan pelanggan dengan kategori status yang dipilih.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-card">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Waktu</th>
                                        <th>Pengirim</th>
                                        <th>Kontak (WA/Email)</th>
                                        <th>Isi Pesan</th>
                                        <th>Status</th>
                                        <th style="text-align: right;">Aksi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="c" items="${contacts}">
                                        <tr>
                                            <td style="font-size: 0.85rem; color: var(--text-secondary); width: 140px;">
                                                <fmt:formatDate value="${c.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                            </td>
                                            <td>
                                                <strong style="color: var(--dark);"><c:out value="${c.nama}" /></strong>
                                            </td>
                                            <td>
                                                <code style="background: #f1f5f9; padding: 2px 6px; border-radius: 4px; font-size: 0.85rem;"><c:out value="${c.kontak}" /></code>
                                            </td>
                                            <td style="max-width: 320px; font-size: 0.92rem; color: var(--text-secondary);">
                                                <p style="white-space: pre-wrap; margin: 0;"><c:out value="${c.pesan}" /></p>
                                            </td>
                                            <td style="width: 140px;">
                                                <form action="${pageContext.request.contextPath}/admin/contacts/status" method="POST" style="margin: 0;">
                                                    <input type="hidden" name="id" value="${c.id}">
                                                    <select name="status" onchange="this.form.submit()" class="form-control" style="padding: 4px 8px; font-size: 0.8rem; border-radius: 6px; height: auto;">
                                                        <option value="Baru" ${c.status == 'Baru' ? 'selected' : ''}>🔴 Baru</option>
                                                        <option value="Dibaca" ${c.status == 'Dibaca' ? 'selected' : ''}>🟡 Dibaca</option>
                                                        <option value="Dibalas" ${c.status == 'Dibalas' ? 'selected' : ''}>🟢 Dibalas</option>
                                                    </select>
                                                </form>
                                            </td>
                                            <td style="text-align: right; width: 160px;">
                                                <div style="display: flex; gap: 6px; justify-content: flex-end; align-items: center;">
                                                    <c:choose>
                                                        <c:when test="${c.kontak.matches('^[0-9+]+$')}">
                                                            <a href="https://wa.me/${c.kontak.replaceAll('[^0-9]', '')}" target="_blank" class="btn btn-secondary btn-sm" style="padding: 4px 8px; font-size: 0.78rem;" title="Balas via WhatsApp">
                                                                💬 WA
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="mailto:${c.kontak}" class="btn btn-secondary btn-sm" style="padding: 4px 8px; font-size: 0.78rem;" title="Balas via Email">
                                                                ✉ Email
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <form action="${pageContext.request.contextPath}/admin/contacts/delete" method="POST" onsubmit="return confirm('Hapus pesan kontak ini?');" style="margin: 0;">
                                                        <input type="hidden" name="id" value="${c.id}">
                                                        <button type="submit" class="btn btn-danger btn-sm" style="padding: 4px 8px; font-size: 0.78rem;">
                                                            Hapus
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
