<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ulasan &amp; Rating Produk - Es Teh Solo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="admin-layout">
        <jsp:include page="/WEB-INF/views/admin/sidebar.jsp" />
        <main class="admin-main">
            <div class="admin-topbar">
                <div>
                    <h1 style="font-size: 1.8rem; font-weight: 800; color: var(--primary-dark);">Ulasan &amp; Rating Produk</h1>
                    <p style="color: var(--text-secondary); font-size: 0.9rem;">Umpan balik dan kepuasan pelanggan terhadap varian minuman Es Teh Solo.</p>
                </div>
                <div style="font-size: 0.9rem; color: var(--text-secondary); font-weight: 600;">
                    Total: <strong style="color: var(--primary-dark);">${reviews.size()} ulasan</strong>
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
            <c:choose>
                <c:when test="${empty reviews}">
                    <div style="background: white; border-radius: var(--radius-lg); padding: 60px 20px; text-align: center; border: 1px solid var(--border); box-shadow: var(--shadow-sm);">
                        <div style="font-size: 3.5rem; margin-bottom: 16px;">⭐</div>
                        <h3 style="font-size: 1.3rem; color: var(--primary-dark); margin-bottom: 8px;">Belum Ada Ulasan</h3>
                        <p style="color: var(--text-secondary); max-width: 400px; margin: 0 auto;">Belum ada pelanggan yang memberikan ulasan dan rating terhadap produk.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-card">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Tanggal</th>
                                        <th>Pelanggan</th>
                                        <th>Minuman</th>
                                        <th>Rating</th>
                                        <th>Komentar / Ulasan</th>
                                        <th style="text-align: right;">Aksi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="rev" items="${reviews}">
                                        <tr>
                                            <td style="font-size: 0.85rem; color: var(--text-secondary); width: 140px;">
                                                <fmt:formatDate value="${rev.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                            </td>
                                            <td><strong style="color: var(--dark);"><c:out value="${rev.userName}" /></strong></td>
                                            <td><span class="badge badge-default"><c:out value="${rev.productName}" /></span></td>
                                            <td style="width: 130px;">
                                                <span style="color: #F59E0B;"><c:forEach begin="1" end="${rev.rating}">⭐</c:forEach></span>
                                                <span style="font-weight:700; font-size:0.85rem;"> ${rev.rating}/5</span>
                                            </td>
                                            <td style="font-size: 0.92rem; color: var(--text-secondary); font-style: italic; max-width: 300px;">
                                                &quot;<c:out value="${rev.komentar}" />&quot;
                                            </td>
                                            <td style="text-align: right; width: 110px;">
                                                <form action="${pageContext.request.contextPath}/admin/reviews/delete" method="POST"
                                                      onsubmit="return confirm('Hapus ulasan ini?');" style="display:inline;">
                                                    <input type="hidden" name="id" value="${rev.id}">
                                                    <button type="submit" class="btn btn-danger btn-sm" style="padding:4px 10px;font-size:0.78rem;">
                                                        Hapus
                                                    </button>
                                                </form>
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