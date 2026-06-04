<%--
    Document   : profile
    Author     : lehan
    Admin Profile — email change + password change only
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.model.User" %>
<%
    User loginUser = (User) session.getAttribute("LOGIN_USER");
    if (loginUser == null || loginUser.getRoleId() != 1) {
        response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
        return;
    }

    String toastMsg = (String) session.getAttribute("toastMessage");
    String toastType = (String) session.getAttribute("toastType");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Profile - Presenta</title>
        <link href="https://fonts.googleapis.com/css2?family=Pacifico&family=Be+Vietnam+Pro:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/assets/images/favicon/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-16x16.png">
        <link rel="manifest" href="${pageContext.request.contextPath}/assets/images/favicon/site.webmanifest">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon/favicon.ico">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer/designer-home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/toast.css">

        <style>
            .profile-layout {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 24px;
            }
            @media (max-width: 768px) {
                .profile-layout { grid-template-columns: 1fr; }
            }
            .form-group {
                margin-bottom: 20px;
            }
            .form-group label {
                display: block;
                font-size: 13px;
                font-weight: 600;
                color: #A0AEC0;
                margin-bottom: 6px;
            }
            .form-control {
                width: 100%;
                padding: 12px 16px;
                background: rgba(255,255,255,0.06);
                border: 1px solid rgba(255,255,255,0.15);
                border-radius: 10px;
                color: white;
                font-size: 14px;
                box-sizing: border-box;
                font-family: 'Be Vietnam Pro', sans-serif;
                transition: border-color 0.3s;
            }
            .form-control:focus {
                outline: none;
                border-color: #0075FF;
            }
            .btn-save {
                background: #0075FF;
                color: white;
                border: none;
                padding: 12px 28px;
                border-radius: 10px;
                font-weight: 700;
                font-size: 14px;
                cursor: pointer;
                transition: background 0.3s;
                font-family: 'Be Vietnam Pro', sans-serif;
            }
            .btn-save:hover { background: #0056cc; }
            .profile-info-row {
                display: flex;
                align-items: center;
                gap: 16px;
                padding: 12px 0;
                border-bottom: 1px solid rgba(255,255,255,0.06);
            }
            .profile-info-row .label {
                font-size: 13px;
                color: #A0AEC0;
                min-width: 100px;
                font-weight: 600;
            }
            .profile-info-row .value {
                color: white;
                font-size: 14px;
                font-weight: 500;
            }
        </style>
    </head>
    <body class="designer-body">

        <%-- ============ ADMIN NAVBAR ============ --%>
        <nav class="designer-navbar">
            <a href="${pageContext.request.contextPath}/MainController?action=AdminDashboard" class="designer-brand">
                Presenta <span>ADMIN</span>
            </a>
            <div class="designer-nav-links">
                <a href="${pageContext.request.contextPath}/MainController?action=AdminDashboard">Dashboard</a>
                <a href="${pageContext.request.contextPath}/MainController?action=AdminWithdrawals">Withdrawals</a>
                <a href="${pageContext.request.contextPath}/MainController?action=AdminUsers">User List</a>
                <a href="${pageContext.request.contextPath}/MainController?action=AdminProfile" class="active">Profile</a>
            </div>
            <div style="display: flex; align-items: center; gap: 20px;">
                <span style="font-size: 14px; color: #A0AEC0;">Welcome, <b style="color: white;"><%= loginUser.getUsername()%></b></span>
                <form action="${pageContext.request.contextPath}/MainController" method="POST" style="margin: 0;">
                    <input type="hidden" name="action" value="Logout">
                    <button type="submit" style="background: transparent; border: none; color: #A0AEC0; font-weight: 700; cursor: pointer;">Sign Out</button>
                </form>
            </div>
        </nav>

        <div class="designer-container">

            <div class="vision-card" style="padding: 24px; margin-bottom: 24px;">
                <h2 style="color: white; margin: 0 0 4px 0; font-size: 22px;">👤 Admin Profile</h2>
                <p style="color: #A0AEC0; margin: 0; font-size: 14px;">Manage your account settings</p>
            </div>

            <%-- ============ ACCOUNT INFO CARDS ============ --%>
            <div class="stats-grid" style="margin-bottom: 24px;">
                <div class="vision-card stat-card">
                    <div class="stat-info">
                        <span class="stat-title">Username</span>
                        <div class="stat-value" style="font-size: 18px;"><%= loginUser.getUsername()%></div>
                    </div>
                    <div class="stat-icon">👤</div>
                </div>
                <div class="vision-card stat-card">
                    <div class="stat-info">
                        <span class="stat-title">Email</span>
                        <div class="stat-value" style="font-size: 14px;"><%= loginUser.getEmail() != null ? loginUser.getEmail() : "—"%></div>
                    </div>
                    <div class="stat-icon">📧</div>
                </div>
                <div class="vision-card stat-card">
                    <div class="stat-info">
                        <span class="stat-title">Role</span>
                        <div class="stat-value" style="font-size: 18px; color: #dc3545;">Admin</div>
                    </div>
                    <div class="stat-icon">🔑</div>
                </div>
                <div class="vision-card stat-card">
                    <div class="stat-info">
                        <span class="stat-title">Status</span>
                        <div class="stat-value" style="font-size: 18px; color: <%= loginUser.isStatus() ? "#28a745" : "#dc3545"%>;">
                            <%= loginUser.isStatus() ? "Active" : "Banned"%>
                        </div>
                    </div>
                    <div class="stat-icon">🟢</div>
                </div>
            </div>

            <div class="profile-layout">
                <%-- ============ CHANGE USERNAME ============ --%>
                <div class="vision-card" style="padding: 28px;">
                    <div class="panel-header" style="margin-bottom: 20px;">✏️ Change Username</div>
                    <form action="${pageContext.request.contextPath}/MainController" method="POST">
                        <input type="hidden" name="action" value="AdminProfile">
                        <input type="hidden" name="method" value="changeUsername">

                        <div class="form-group">
                            <label>Current Username</label>
                            <input type="text" class="form-control" value="<%= loginUser.getUsername()%>" disabled>
                        </div>
                        <div class="form-group">
                            <label>New Username <span style="color: #E53E3E;">*</span></label>
                            <input type="text" name="newUsername" class="form-control" placeholder="Enter new username (min 3 chars)" required minlength="3">
                        </div>
                        <button type="submit" class="btn-save" style="width: 100%;">Update Username</button>
                    </form>
                </div>

                <%-- ============ CHANGE EMAIL ============ --%>
                <div class="vision-card" style="padding: 28px;">
                    <div class="panel-header" style="margin-bottom: 20px;">📧 Change Email</div>
                    <form action="${pageContext.request.contextPath}/MainController" method="POST">
                        <input type="hidden" name="action" value="AdminProfile">
                        <input type="hidden" name="method" value="changeEmail">

                        <div class="form-group">
                            <label>Current Email</label>
                            <input type="email" class="form-control" value="<%= loginUser.getEmail() != null ? loginUser.getEmail() : ""%>" disabled>
                        </div>
                        <div class="form-group">
                            <label>New Email <span style="color: #E53E3E;">*</span></label>
                            <input type="email" name="newEmail" class="form-control" placeholder="Enter new email" required>
                        </div>
                        <button type="submit" class="btn-save" style="width: 100%;">Update Email</button>
                    </form>
                </div>
            </div>

            <%-- ============ CHANGE PASSWORD ============ --%>
            <div class="vision-card" style="padding: 28px; margin-top: 24px;">
                <div class="panel-header" style="margin-bottom: 20px;">🔒 Change Password</div>
                <form action="${pageContext.request.contextPath}/MainController" method="POST" style="max-width: 500px;">
                    <input type="hidden" name="action" value="AdminProfile">
                    <input type="hidden" name="method" value="changePassword">

                    <div class="form-group">
                        <label>Current Password <span style="color: #E53E3E;">*</span></label>
                        <input type="password" name="oldPassword" class="form-control" placeholder="Enter current password" required>
                    </div>
                    <div class="form-group">
                        <label>New Password <span style="color: #E53E3E;">*</span></label>
                        <input type="password" name="newPassword" class="form-control" placeholder="At least 6 characters" required minlength="6">
                    </div>
                    <div class="form-group">
                        <label>Confirm New Password <span style="color: #E53E3E;">*</span></label>
                        <input type="password" name="confirmPassword" class="form-control" placeholder="Re-enter new password" required minlength="6">
                    </div>
                    <button type="submit" class="btn-save">Change Password</button>
                </form>
            </div>

        </div>

        <%-- ============ TOAST ============ --%>
        <% if (toastMsg != null) { %>
        <div id="custom-toast" class="show" style="<%= "error".equals(toastType) ? "background: #dc3545;" : ""%>">
            <span class="toast-icon"><%= "error".equals(toastType) ? "❌" : "✔️"%></span>
            <span class="toast-text"><%= toastMsg%></span>
        </div>
        <%
            session.removeAttribute("toastMessage");
            session.removeAttribute("toastType");
        } %>

        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
    </body>
</html>
