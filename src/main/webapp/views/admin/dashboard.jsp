<%-- 
    Document   : dashboard
    Created on : May 24, 2026, 4:26:11 PM
    Author     : lehan
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.model.User" %>
<%-- Import sẵn các model sẽ dùng sau này --%>
<%-- <%@ page import="java.util.List" %> --%>
<%-- <%@ page import="com.model.Order" %> --%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Presenta</title>
        <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/assets/images/favicon/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-16x16.png">
        <link rel="manifest" href="${pageContext.request.contextPath}/assets/images/favicon/site.webmanifest">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon/favicon.ico">
        
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css"> 
    </head>
    <body>

        <%
            User loginUser = (User) session.getAttribute("LOGIN_USER");
            if (loginUser == null || loginUser.getRoleId() != 1) {
                response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
                return;
            }

            // ==========================================
            // TODO: GỌI DAO ĐỂ LẤY DỮ LIỆU Ở ĐÂY
            // Ví dụ:
            // int totalUsers = dashboardDAO.getTotalUsers();
            // List<Order> recentOrders = orderDAO.getRecentOrders();
            // ==========================================
%>

        <nav class="navbar" style="background: var(--surface); border-bottom: 1px solid var(--border-glass);">
            <a href="${pageContext.request.contextPath}/MainController" class="nav-brand" style="font-family: 'Pacifico', cursive; font-size: 28px;">Presenta</a>
            <div class="nav-links">
                <a href="#" style="color: white; border-bottom: 2px solid var(--primary);">Dashboard</a>
                <a href="#">Pending Approvals</a>
                <a href="#">User List</a>
            </div>
            <div class="nav-actions">
                <span style="font-size: 14px; margin-right: 10px;">Welcome <b><%= loginUser.getUsername()%></b></span>
                <form action="${pageContext.request.contextPath}/MainController" method="POST" style="margin:0; display: inline-block;">
                    <input type="hidden" name="action" value="Logout">
                    <button type="submit" class="btn-outline" style="padding: 6px 16px; font-size: 12px; border-radius: 999px;">Logout</button>
                </form>
            </div>
        </nav>

        <div class="main-container">
            <div class="admin-header">
                <h1>Admin Overview</h1>
                <p>Welcome back. Here's what's happening with the creative engine today.</p>
            </div>

            <div class="admin-stats-grid">
                <div class="glass-panel admin-stat-card">
                    <div class="stat-icon">👥</div>
                    <div class="stat-title">TOTAL USERS</div>
                    <div class="stat-value">0</div>
                </div>
                <div class="glass-panel admin-stat-card">
                    <div class="stat-icon">💳</div>
                    <div class="stat-title">TOTAL SALES</div>
                    <div class="stat-value">$0</div>
                </div>
                <div class="glass-panel admin-stat-card">
                    <div class="stat-icon">📄</div>
                    <div class="stat-title">NEW TEMPLATES</div>
                    <div class="stat-value">0</div>
                </div>
            </div>

            <div class="admin-layout">
                <div class="left-col">
                    <div class="glass-panel" style="padding: 24px;">
                        <div class="section-title">
                            <span>Pending Template Approvals</span>
                        </div>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Template ID</th><th>Designer</th><th>Title</th><th>Price</th><th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%-- TODO: Loop through templates where is_approved = 0 --%>
                                <tr>
                                    <td colspan="5" style="text-align: center; color: var(--text-muted); padding: 32px;">
                                        No templates currently pending approval.
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="right-col">
                    <div class="approval-header">
                        <span class="section-title" style="margin: 0;">Designer Approvals</span>
                        <span class="badge-danger">0 Pending</span>
                    </div>
                    <div class="glass-panel" style="padding: 16px; min-height: 200px;">
                        <div style="text-align: center; color: var(--text-muted); padding: 64px 0;">
                            No designer applications to review.
                        </div>
                        <button class="btn-outline" style="width: 100%; margin-top: 16px;" disabled>See All Applications</button>
                    </div>
                </div>
            </div>
        </div>

    </body>
</html>
