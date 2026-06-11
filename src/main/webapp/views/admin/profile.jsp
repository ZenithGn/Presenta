<%--
    Document   : profile
    Author     : lehan
    Admin Profile — synchronized layout with Admin Dashboard
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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">

        <style>
            /* Chỉnh sửa style nút bấm cho hợp với tone xanh dương */
            .btn-action-primary {
                background: #0075FF !important;
                color: white !important;
                border: none !important;
                border-radius: 8px !important;
                font-weight: 600;
                transition: 0.2s;
            }
            .btn-action-primary:hover {
                background: #005bb5 !important;
            }

            .btn-action-secondary {
                background: transparent !important;
                color: #0075FF !important;
                border: 1px solid #0075FF !important;
                border-radius: 8px !important;
                font-weight: 600;
                transition: 0.2s;
            }
            .btn-action-secondary:hover {
                background: rgba(0, 117, 255, 0.1) !important;
            }
        </style>
    </head>

    <body>

        <%-- NAVBAR (Đồng bộ từ Dashboard) --%>
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
            
<button onclick="toggleLanguage()" class="lang-toggle-btn no-translate" style="background: transparent; border: 1px solid currentColor; color: inherit; padding: 4px 10px; border-radius: 20px; cursor: pointer; margin-left: 15px; font-weight: bold; white-space: nowrap;">EN/VI</button>
</div>
        
</nav>

        <%-- MAIN LAYOUT --%>
        <main class="profile-container" style="padding-top: 40px;">
            <%-- SIDEBAR --%>
            <aside class="profile-sidebar" style="background: var(--surface); border: 1px solid var(--border-glass); border-radius: 16px;">
                <div style="border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 20px;">

                    <div class="avatar-wrapper" onclick="document.getElementById('avatar-file-input').click()" title="Click to change avatar">
                        <%
                            String userAvatar = loginUser.getAvatarUrl();
                            String avatarSrc = (userAvatar != null && !userAvatar.isEmpty()) ? userAvatar : "";

                            if (!avatarSrc.isEmpty()) {
                        %>
                        <img src="<%= avatarSrc%>" id="main-avatar-img" alt="Avatar" style="width: 100%; height: 100%; object-fit: cover; display: block;">
                        <% } else {%>
                        <div class="user-avatar" id="main-avatar-placeholder"><%= loginUser.getUsername().substring(0, 1).toUpperCase()%></div>
                        <img src="" id="main-avatar-img" alt="Avatar" style="width: 100%; height: 100%; object-fit: cover; display: none;">
                        <% }%>
                        <div class="avatar-hover-overlay">&#x1F4F7;</div>
                    </div>

                    <h3 class="user-name" style="color: white;"><%= loginUser.getUsername()%></h3>
                    <p style="text-align:center; color:#0075FF; font-size:12px; margin-top:4px; font-weight:700;">Administrator</p>
                </div>
                <ul class="sidebar-menu">
                    <li class="menu-item active" id="nav-tab-info" style="color: white;">&#x2699;&#xFE0F; Account Settings</li>
                </ul>
            </aside>

            <%-- CONTENT AREA --%>
            <section class="profile-content-area">

                <div id="tab-info" class="tab-pane active">
                    <h2 class="tab-title" style="color: white;">Account Settings</h2>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 40px;">

                        <div style="display: flex; flex-direction: column; gap: 30px;">

                            <%-- Personal Info --%>
                            <div style="background: var(--surface); padding: 24px; border-radius: 16px; border: 1px solid var(--border-glass);">
                                <h4 style="color: white; font-weight: 700; margin-top: 0; margin-bottom: 15px;">Personal Info</h4>
                                <form action="${pageContext.request.contextPath}/AccountController" method="POST">
                                    <input type="hidden" name="updateType" value="profile">

                                    <label style="display:block; font-size:13px; color:#A0AEC0; font-weight:600; margin-bottom:8px;">Username</label>
                                    <input type="text" value="<%= loginUser.getUsername()%>" disabled
                                           style="width:100%; padding:12px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:15px; background:rgba(255,255,255,0.02); color:rgba(255,255,255,0.4); cursor: not-allowed; box-sizing: border-box; font-weight: 600;">

                                    <label style="display:block; font-size:13px; color:#A0AEC0; font-weight:600; margin-bottom:8px;">Email</label>
                                    <input type="email" name="email" value="<%= loginUser.getEmail() != null ? loginUser.getEmail() : ""%>" required
                                           style="width:100%; padding:12px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:20px; background:rgba(255,255,255,0.05); color:#ffffff; box-sizing: border-box;">

                                    <button type="submit" class="btn-action-primary" style="padding: 10px 20px; width: 100%;">Save</button>
                                </form>
                            </div>

                            <%-- Change Password --%>
                            <div style="background: var(--surface); padding: 24px; border-radius: 16px; border: 1px solid var(--border-glass);">
                                <h4 style="color: white; font-weight: 700; margin-top: 0; margin-bottom: 15px;">Change Password</h4>
                                <form action="${pageContext.request.contextPath}/AccountController" method="POST">
                                    <input type="hidden" name="updateType" value="password">

                                    <label style="display:block; font-size:13px; color:#A0AEC0; font-weight:600; margin-bottom:8px;">Current Password</label>
                                    <input type="password" name="oldPass" required style="width:100%; padding:12px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:15px; background:rgba(255,255,255,0.05); color:#ffffff; box-sizing: border-box;">

                                    <label style="display:block; font-size:13px; color:#A0AEC0; font-weight:600; margin-bottom:8px;">New Password</label>
                                    <input type="password" name="newPass" required style="width:100%; padding:12px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:20px; background:rgba(255,255,255,0.05); color:#ffffff; box-sizing: border-box;">

                                    <button type="submit" class="btn-action-secondary" style="padding: 10px 20px; width: 100%;">Change Password</button>
                                </form>
                            </div>

                        </div>

                        <%-- Change Avatar --%>
                        <div>
                            <div style="background: var(--surface); padding: 24px; border-radius: 16px; border: 1px solid var(--border-glass); height: 100%; box-sizing: border-box; display: flex; flex-direction: column;">
                                <h4 style="color: white; font-weight: 700; margin-top: 0; margin-bottom: 15px;">Change Avatar</h4>
                                <p style="font-size: 13px; color: #A0AEC0; margin-top: 0; line-height: 1.5; flex-grow: 1;">
                                    Click the avatar circle in the sidebar or choose a file below.
                                    <br><br>
                                    <span style="color: #ffc107;">* Max file size: 10MB (JPG, PNG, GIF)</span>
                                </p>

                                <form action="${pageContext.request.contextPath}/AccountController" method="POST" enctype="multipart/form-data" style="margin-top: 20px;">
                                    <input type="hidden" name="updateType" value="avatar">

                                    <label style="display:block; font-size:13px; color:#A0AEC0; font-weight:600; margin-bottom:8px;">Choose Image File</label>
                                    <input type="file" name="avatarFile" id="avatar-file-input" accept="image/png, image/jpeg, image/gif" required
                                           style="width:100%; padding:10px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:20px; background:rgba(255,255,255,0.05); color:#ffffff; box-sizing: border-box; font-size: 12px;">

                                    <button type="submit" class="btn-action-primary" style="padding: 12px 24px; width: 100%;">Upload New Avatar</button>
                                </form>
                            </div>
                        </div>

                    </div>
                </div>

            </section>
        </main>

        <%-- TOAST --%>
        <% if (toastMsg != null) {%>
        <div id="toastAlert" class="toast-msg"><%= toastMsg%></div>
        <% session.removeAttribute("toastMessage");
            }%>

        <footer class="main-footer">
            <div class="footer-container">
                <div class="footer-col brand-col">
                    <div class="brand-logo-desc-wrapper">
                        <img src="${pageContext.request.contextPath}/assets/images/logo.jpg" alt="Presenta Logo" class="footer-image-logo">
                        <div class="brand-text-content">
                            <a href="#" class="footer-logo" style="margin-bottom: 4px;">Presenta</a>
                            <p class="footer-desc" style="margin-bottom: 0;">The next generation template marketplace for academic visionaries and creative professionals.</p>
                        </div>
                    </div>
                    <div class="footer-socials">
                        <a href="https://www.facebook.com/profile.php?id=61590550761077" target="_blank" class="social-icon">🌐</a>
                        <a href="#" class="social-icon">💬</a>
                        <a href="mailto:presentaproject05@gmail.com" target="_blank" class="social-icon">📧</a>
                    </div>
                </div>
                <div class="footer-col contact-col">
                    <h4>GET IN TOUCH</h4>
                    <ul class="contact-info-list">
                        <li><span class="contact-icon">📍</span><span>FPT University, District 9, Ho Chi Minh City</span></li>
                        <li><span class="contact-icon">📧</span><span>presentaproject05@gmail.com</span></li>
                        <li><span class="contact-icon">📞</span><span>+84 (28) 7300 5588</span></li>
                        <li><span class="contact-icon">⏱</span><span>Mon - Fri: 8:00 AM - 5:00 PM</span></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <div class="footer-bottom-container">
                    <p>&copy; 2026 Presenta. All rights reserved.</p>
                </div>
            </div>
        </footer>

        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
    
<script src="${pageContext.request.contextPath}/assets/js/lang.js" charset="UTF-8"></script>
</body>
</html>