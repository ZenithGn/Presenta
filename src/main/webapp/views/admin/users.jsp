<%--
    Document   : users
    Author     : lehan
--%>

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="com.model.User" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>User Management - Presenta Admin</title>
        <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/assets/images/favicon/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-16x16.png">
        <link rel="manifest" href="${pageContext.request.contextPath}/assets/images/favicon/site.webmanifest">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon/favicon.ico">
        <link href="https://fonts.googleapis.com/css2?family=Pacifico&family=Be+Vietnam+Pro:wght@400;500;600;700;800&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer/designer-home.css">

        <style>
            .filter-bar {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 20px;
                flex-wrap: wrap;
            }
            .filter-bar input, .filter-bar select, .filter-bar button {
                padding: 10px 16px;
                border-radius: 8px;
                border: 1px solid rgba(255,255,255,0.15);
                background: rgba(255,255,255,0.06);
                color: white;
                font-size: 13px;
            }
            .filter-bar input { min-width: 200px; }
            .filter-bar input::placeholder { color: #A0AEC0; }
            .filter-bar select option {
                background-color: #1e1b4b;
                color: white;
            }
            .filter-bar .btn-search {
                background: #0075FF;
                border-color: #0075FF;
                font-weight: 600;
                cursor: pointer;
            }
            .admin-table {
                width: 100%;
                border-collapse: collapse;
            }
            .admin-table th {
                text-align: left;
                padding: 12px 16px;
                color: #A0AEC0;
                font-size: 12px;
                text-transform: uppercase;
                border-bottom: 1px solid rgba(255,255,255,0.1);
            }
            .admin-table td {
                padding: 14px 16px;
                border-bottom: 1px solid rgba(255,255,255,0.05);
                color: #E2E8F0;
                font-size: 14px;
            }
            .admin-table tr:hover td { background: rgba(255,255,255,0.03); }
            .role-badge {
                padding: 4px 10px;
                border-radius: 999px;
                font-size: 12px;
                font-weight: 600;
            }
            .role-admin { background: rgba(220,53,69,0.2); color: #dc3545; }
            .role-customer { background: rgba(0,117,255,0.2); color: #0075FF; }
            .role-designer { background: rgba(168,85,247,0.2); color: #a855f7; }
            .status-active { color: #28a745; font-weight: 600; }
            .status-banned { color: #dc3545; font-weight: 600; }
            .btn-ban {
                background: #dc3545;
                border: none;
                color: white;
                padding: 6px 14px;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 600;
                cursor: pointer;
                text-decoration: none;
            }
            .btn-unban {
                background: #28a745;
                border: none;
                color: white;
                padding: 6px 14px;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 600;
                cursor: pointer;
                text-decoration: none;
            }
            .pagination {
                display: flex;
                gap: 8px;
                justify-content: center;
                margin-top: 24px;
            }
            .pagination a, .pagination span {
                padding: 8px 14px;
                border-radius: 8px;
                border: 1px solid rgba(255,255,255,0.15);
                color: white;
                text-decoration: none;
                font-size: 13px;
            }
            .pagination a:hover { background: rgba(255,255,255,0.1); }
            .pagination .active-page { background: #0075FF; border-color: #0075FF; font-weight: 700; }
            .vision-card { margin-bottom: 24px; }
            .user-avatar {
                width: 36px;
                height: 36px;
                border-radius: 50%;
                object-fit: cover;
                background: rgba(255,255,255,0.1);
            }
            .user-info-cell {
                display: flex;
                align-items: center;
                gap: 12px;
            }
        </style>
    </head>
    <body>

        <%
            User loginUser = (User) session.getAttribute("LOGIN_USER");
            if (loginUser == null || loginUser.getRoleId() != 1) {
                response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
                return;
            }

            List<User> userList = (List<User>) request.getAttribute("USER_LIST");
            Integer currentPage = (Integer) request.getAttribute("CURRENT_PAGE");
            Integer totalPages = (Integer) request.getAttribute("TOTAL_PAGES");
            Integer totalCount = (Integer) request.getAttribute("TOTAL_COUNT");
            String search = (String) request.getAttribute("SEARCH");
            String roleFilter = (String) request.getAttribute("ROLE_FILTER");

            if (currentPage == null) currentPage = 1;
            if (totalPages == null) totalPages = 1;
            if (totalCount == null) totalCount = 0;
            if (search == null) search = "";
            if (roleFilter == null) roleFilter = "All";
        %>

        <%-- ============ ADMIN NAVBAR ============ --%>
        <nav class="designer-navbar">
            <a href="${pageContext.request.contextPath}/MainController?action=AdminDashboard" class="designer-brand">
                Presenta <span>ADMIN</span>
            </a>

            <div class="designer-nav-links">
                <a href="${pageContext.request.contextPath}/MainController?action=AdminDashboard">Dashboard</a>
                <a href="${pageContext.request.contextPath}/MainController?action=AdminWithdrawals">Withdrawals</a>
                <a href="${pageContext.request.contextPath}/MainController?action=AdminUsers" class="active">User List</a>
                <a href="${pageContext.request.contextPath}/MainController?action=AdminVouchers">Vouchers</a>
                <a href="${pageContext.request.contextPath}/MainController?action=AdminProfile">Profile</a>
            </div>

            <div style="display: flex; align-items: center; gap: 20px;">
<div onclick="toggleLanguage()" class="lang-toggle-switch no-translate" style="position: relative; display: flex; align-items: center; width: 64px; height: 28px; border: 1px solid currentColor; border-radius: 20px; cursor: pointer; margin-right: 15px; color: inherit;">
    <div class="lang-slider" style="position: absolute; top: 2px; left: 2px; width: 28px; height: 22px; background: currentColor; opacity: 0.2; border-radius: 14px; transition: transform 0.3s cubic-bezier(0.4, 0.0, 0.2, 1); z-index: 1;"></div>
    <span style="flex: 1; text-align: center; font-size: 11px; font-weight: bold; z-index: 2; pointer-events: none;">EN</span>
    <span style="flex: 1; text-align: center; font-size: 11px; font-weight: bold; z-index: 2; pointer-events: none;">VI</span>
</div>

                <span style="font-size: 14px; color: #A0AEC0;">Welcome, <b style="color: white;"><%= loginUser.getUsername()%></b></span>
                <form action="${pageContext.request.contextPath}/MainController" method="POST" style="margin: 0;">
                    <input type="hidden" name="action" value="Logout">
                    <button type="submit" style="background: transparent; border: none; color: #A0AEC0; font-weight: 700; cursor: pointer;">Sign Out</button>
                </form>
            
</div>
        
</nav>

        <div class="designer-container">
            <div class="vision-card" style="padding: 24px;">
                <h2 style="color: white; margin: 0 0 4px 0; font-size: 22px;"><span class="no-translate">👥</span> User Management</h2>
                <p style="color: #A0AEC0; margin: 0 0 20px 0; font-size: 14px;"><span class="no-translate"><%= totalCount%></span> total user(s)</p>

                <%-- ============ FILTER BAR ============ --%>
                <div class="filter-bar">
                    <form action="${pageContext.request.contextPath}/MainController" method="GET" style="display:flex; align-items:center; gap:12px; margin:0; flex-wrap:wrap;">
                        <input type="hidden" name="action" value="AdminUsers">
                        <input type="text" name="search" placeholder="Search by name or email..." value="<%= search%>">
                        <select name="roleFilter" onchange="this.form.submit()">
                            <option value="All" <%= "All".equals(roleFilter) ? "selected" : ""%>>All Roles</option>
                            <option value="Admin" <%= "Admin".equals(roleFilter) ? "selected" : ""%>>Admin</option>
                            <option value="Customer" <%= "Customer".equals(roleFilter) ? "selected" : ""%>>Customer</option>
                            <option value="Designer" <%= "Designer".equals(roleFilter) ? "selected" : ""%>>Designer</option>
                        </select>
                        <button type="submit" class="btn-search"><span class="no-translate">🔍</span> Search</button>
                    </form>
                </div>

                <%-- ============ TABLE ============ --%>
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>User</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (userList != null && !userList.isEmpty()) {
                                for (User u : userList) {
                                    String roleClass = "role-customer";
                                    String roleName = "Customer";
                                    if (u.getRoleId() == 1) { roleClass = "role-admin"; roleName = "Admin"; }
                                    if (u.getRoleId() == 3) { roleClass = "role-designer"; roleName = "Designer"; }

                                    String avatar = (u.getAvatarUrl() != null && !u.getAvatarUrl().trim().isEmpty())
                                            ? u.getAvatarUrl()
                                            : "https://ui-avatars.com/api/?name=" + u.getUsername() + "&background=7C3AED&color=fff";
                        %>
                        <tr>
                            <td>
                                <div class="user-info-cell">
                                    <img src="<%= avatar%>" class="user-avatar" alt="">
                                    <span style="font-weight:600;"><%= u.getUsername()%></span>
                                </div>
                            </td>
                            <td style="color:#A0AEC0;"><%= u.getEmail() != null ? u.getEmail() : "—"%></td>
                            <td><span class="role-badge <%= roleClass%>"><%= roleName%></span></td>
                            <td>
                                <span class="<%= u.isStatus() ? "status-active" : "status-banned"%>">
                                    <%= u.isStatus() ? "Active" : "Banned"%>
                                </span>
                            </td>
                            <td>
                                <% if (u.getUserId() != loginUser.getUserId()) { %>
                                    <% if (u.isStatus()) { %>
                                    <a href="${pageContext.request.contextPath}/MainController?action=AdminUsers&toggleId=<%= u.getUserId()%>&search=<%= search%>&roleFilter=<%= roleFilter%>&page=<%= currentPage%>"
                                       class="btn-ban" onclick="return confirm('Ban user <%= u.getUsername()%>?')">Ban</a>
                                    <% } else { %>
                                    <a href="${pageContext.request.contextPath}/MainController?action=AdminUsers&toggleId=<%= u.getUserId()%>&search=<%= search%>&roleFilter=<%= roleFilter%>&page=<%= currentPage%>"
                                       class="btn-unban" onclick="return confirm('Unban user <%= u.getUsername()%>?')">Unban</a>
                                    <% } %>
                                <% } else { %>
                                <span style="color:#A0AEC0; font-size:12px;">You</span>
                                <% } %>
                            </td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="5" style="text-align:center; padding:48px; color:#A0AEC0;">
                                No users found.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>

                <%-- ============ PAGINATION ============ --%>
                <% if (totalPages > 1) { %>
                <div class="pagination">
                    <% if (currentPage > 1) { %>
                    <a href="${pageContext.request.contextPath}/MainController?action=AdminUsers&page=<%= currentPage - 1%>&search=<%= search%>&roleFilter=<%= roleFilter%>">&laquo; Prev</a>
                    <% } %>
                    <%
                        for (int i = 1; i <= totalPages; i++) {
                            if (i == currentPage) {
                    %>
                    <span class="active-page"><%= i%></span>
                    <% } else { %>
                    <a href="${pageContext.request.contextPath}/MainController?action=AdminUsers&page=<%= i%>&search=<%= search%>&roleFilter=<%= roleFilter%>"><%= i%></a>
                    <% }
                        } %>
                    <% if (currentPage < totalPages) { %>
                    <a href="${pageContext.request.contextPath}/MainController?action=AdminUsers&page=<%= currentPage + 1%>&search=<%= search%>&roleFilter=<%= roleFilter%>">Next &raquo;</a>
                    <% } %>
                </div>
                <% } %>
            </div>
        </div>
    
<script src="${pageContext.request.contextPath}/assets/js/lang.js" charset="UTF-8"></script>
</body>
</html>
