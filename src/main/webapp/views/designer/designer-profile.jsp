<%--
    Designer Profile Page - Tabbed profile for Designer role
    Similar to customer profile but with designer-specific features
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.model.User" %>
<%@ page import="com.model.Designer" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    User loginUser = (User) session.getAttribute("LOGIN_USER");
    if (loginUser == null || loginUser.getRoleId() != 3) {
        response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
        return;
    }

    Designer designer = (Designer) request.getAttribute("designer");
    List<Map<String, Object>> designerOrders = (List<Map<String, Object>>) request.getAttribute("DESIGNER_ORDERS");

    String toastMsg = (String) session.getAttribute("toastMessage");

    // Determine active tab
    String activeTab = request.getParameter("tab");
    if (activeTab == null) activeTab = "portfolio";
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Designer Profile - Presenta</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&family=Pacifico&display=swap" rel="stylesheet">
        <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/assets/images/favicon/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-16x16.png">
        <link rel="manifest" href="${pageContext.request.contextPath}/assets/images/favicon/site.webmanifest">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon/favicon.ico">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer/designer-profile.css">
    </head>

    <body class="landing-body">

        <%-- NAVBAR --%>
        <nav class="navbar" style="border-bottom: none; background: transparent;">
            <a href="${pageContext.request.contextPath}/MainController?action=DesignerHome" class="nav-brand" style="font-family: 'Pacifico', cursive; font-size: 28px; color:white;">
                Presenta <span style="font-size:12px; color:#D8B4FF; font-family: Inter;">DESIGNER</span>
            </a>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerHome" class="active">Dashboard</a>
                <a href="${pageContext.request.contextPath}/MainController?action=ManageTemplate">Manage Templates</a>
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerWithdrawals">Withdrawals</a>
                <a href="${pageContext.request.contextPath}/MainController?action=CustomerBooking">Customer Booking</a>
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerProfile" style="border-bottom: 2px solid white; font-weight: 700; color:white;">Profile</a>
            </div>
            <div class="nav-actions">
                <span style="color: #dae2fd; font-size: 14px; margin-right: 10px;">Welcome, <b><%= loginUser.getUsername()%></b></span>
                <form action="${pageContext.request.contextPath}/MainController" method="POST" style="margin:0; display: inline-block;">
                    <input type="hidden" name="action" value="Logout">
                    <button type="submit" class="btn-outline" style="padding: 6px 16px; font-size: 12px; border-radius: 999px; color:white; border-color:white;">Logout</button>
                </form>
            
<button onclick="toggleLanguage()" class="lang-toggle-btn no-translate" style="background: transparent; border: 1px solid currentColor; color: inherit; padding: 4px 10px; border-radius: 20px; cursor: pointer; margin-left: 15px; font-weight: bold; white-space: nowrap;">EN/VI</button>
</div>
        
</nav>

        <%-- MAIN LAYOUT --%>
        <main class="profile-container">
            <%-- SIDEBAR --%>
            <aside class="profile-sidebar">
                <div style="border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 20px;">

                    <div class="avatar-wrapper" onclick="triggerFileUpload()" title="Click để đổi ảnh đại diện">
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

                    <h3 class="user-name"><%= loginUser.getUsername()%></h3>
                    <p style="text-align:center; color:#D8B4FF; font-size:12px; margin-top:4px;">Designer</p>
                </div>
                <ul class="sidebar-menu">
                    <li class="menu-item <%= "portfolio".equals(activeTab) ? "active" : ""%>" onclick="switchTab('tab-portfolio', this)" id="nav-tab-portfolio">&#x1F3A8; Portfolio Settings</li>
                    <li class="menu-item <%= "info".equals(activeTab) ? "active" : ""%>" onclick="switchTab('tab-info', this)" id="nav-tab-info">&#x2699;&#xFE0F; Account Settings</li>
                    <li class="menu-item <%= "orders".equals(activeTab) ? "active" : ""%>" onclick="switchTab('tab-orders', this)" id="nav-tab-orders">&#x1F4E6; Custom Orders</li>
                </ul>
            </aside>

            <%-- CONTENT AREA --%>
            <section class="profile-content-area">

                <%-- TAB: Portfolio Settings --%>
                <div id="tab-portfolio" class="tab-pane <%= "portfolio".equals(activeTab) ? "active" : ""%>">
                    <h2 class="tab-title">Portfolio Settings</h2>
                    <p style="color:#cbd5e1; font-size:13px; margin-bottom:24px;">
                        These details appear on your public designer profile. Keep them up to date to attract more clients.
                    </p>

                    <div style="background: rgba(255,255,255,0.02); padding: 24px; border-radius: 12px; border: 1px solid rgba(255,255,255,0.05);">
                        <form action="${pageContext.request.contextPath}/AccountController" method="POST">
                            <input type="hidden" name="updateType" value="designer_profile">

                            <label style="display:block; font-size:13px; color:#E2D7FF; font-weight:700; margin-bottom:8px;">Bio / About</label>
                            <textarea name="bio" rows="4" style="width:100%; padding:12px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:16px; background:rgba(255,255,255,0.05); color:#ffffff; box-sizing:border-box; resize:vertical; font-family:inherit;"><%= (designer != null && designer.getBio() != null) ? designer.getBio() : ""%></textarea>

                            <label style="display:block; font-size:13px; color:#E2D7FF; font-weight:700; margin-bottom:8px;">Phone Number</label>
                            <input type="text" name="phone" value="<%= (designer != null && designer.getPhone() != null) ? designer.getPhone() : ""%>" style="width:100%; padding:12px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:16px; background:rgba(255,255,255,0.05); color:#ffffff; box-sizing:border-box;">

                            <label style="display:block; font-size:13px; color:#E2D7FF; font-weight:700; margin-bottom:8px;">Portfolio URL (Behance, Dribbble, etc.)</label>
                            <input type="url" name="portfolioURL" value="<%= (designer != null && designer.getPortfolioURL() != null) ? designer.getPortfolioURL() : ""%>" placeholder="https://" style="width:100%; padding:12px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:24px; background:rgba(255,255,255,0.05); color:#ffffff; box-sizing:border-box;">

                            <button type="submit" class="btn-action" style="background:#D8B4FF; color:#11052C; padding:12px 28px; width:100%;">Save Portfolio Settings</button>
                        </form>
                    </div>
                </div>

                <%-- TAB: Account Settings (Email, Password, Avatar) --%>
                <div id="tab-info" class="tab-pane <%= "info".equals(activeTab) ? "active" : ""%>">
                    <h2 class="tab-title">Account Settings</h2>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 40px;">

                        <div style="display: flex; flex-direction: column; gap: 30px;">

                            <div style="background: rgba(255,255,255,0.02); padding: 20px; border-radius: 12px; border: 1px solid rgba(255,255,255,0.05);">
                                <h4 style="color: #D8B4FF; margin-top: 0; margin-bottom: 15px;">Personal Info</h4>
                                <form action="${pageContext.request.contextPath}/AccountController" method="POST">
                                    <input type="hidden" name="updateType" value="profile">

                                    <label style="display:block; font-size:13px; color:#E2D7FF; font-weight:700; margin-bottom:8px;">Username</label>
                                    <input type="text" value="<%= loginUser.getUsername()%>" disabled style="width:100%; padding:12px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:15px; background:rgba(255,255,255,0.05); color:rgba(255,255,255,0.4); cursor:not-allowed; box-sizing:border-box; font-weight:bold;">

                                    <label style="display:block; font-size:13px; color:#E2D7FF; font-weight:700; margin-bottom:8px;">Email</label>
                                    <input type="email" name="email" value="<%= loginUser.getEmail()%>" required style="width:100%; padding:12px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:20px; background:rgba(255,255,255,0.05); color:#ffffff; box-sizing:border-box;">

                                    <button type="submit" class="btn-action" style="background:#D8B4FF; color:#11052C; padding:10px 20px; width:100%;">Save</button>
                                </form>
                            </div>

                            <div style="background: rgba(255,255,255,0.02); padding: 20px; border-radius: 12px; border: 1px solid rgba(255,255,255,0.05);">
                                <h4 style="color: #D8B4FF; margin-top: 0; margin-bottom: 15px;">Change Password</h4>
                                <form action="${pageContext.request.contextPath}/AccountController" method="POST">
                                    <input type="hidden" name="updateType" value="password">

                                    <label style="display:block; font-size:13px; color:#E2D7FF; font-weight:700; margin-bottom:8px;">Current Password</label>
                                    <input type="password" name="oldPass" required style="width:100%; padding:12px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:15px; background:rgba(255,255,255,0.05); color:#ffffff; box-sizing:border-box;">

                                    <label style="display:block; font-size:13px; color:#E2D7FF; font-weight:700; margin-bottom:8px;">New Password</label>
                                    <input type="password" name="newPass" required style="width:100%; padding:12px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:20px; background:rgba(255,255,255,0.05); color:#ffffff; box-sizing:border-box;">

                                    <button type="submit" class="btn-action" style="background:transparent; color:#D8B4FF; border:1px solid #D8B4FF; padding:10px 20px; width:100%;">Change Password</button>
                                </form>
                            </div>
                        </div>

                        <div>
                            <div style="background: rgba(255,255,255,0.02); padding: 20px; border-radius: 12px; border: 1px solid rgba(255,255,255,0.05); height:100%; box-sizing:border-box; display:flex; flex-direction:column;">
                                <h4 style="color: #D8B4FF; margin-top: 0; margin-bottom: 15px;">Change Avatar</h4>
                                <p style="font-size:13px; color:#cbd5e1; margin-top:0; line-height:1.5; flex-grow:1;">
                                    Click the avatar circle in the sidebar or choose a file below.
                                    <br><br>
                                    <span style="color:#ffc107;">* Max file size: 10MB (JPG, PNG, GIF)</span>
                                </p>

                                <form action="${pageContext.request.contextPath}/AccountController" method="POST" enctype="multipart/form-data" style="margin-top:20px;">
                                    <input type="hidden" name="updateType" value="designer_avatar">

                                    <label style="display:block; font-size:13px; color:#E2D7FF; font-weight:700; margin-bottom:8px;">Choose Image File</label>
                                    <input type="file" name="avatarFile" id="avatar-file-input" accept="image/png, image/jpeg, image/gif" required style="width:100%; padding:10px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:20px; background:rgba(255,255,255,0.05); color:#ffffff; box-sizing:border-box; font-size:12px;">

                                    <button type="submit" class="btn-action" style="background:#D8B4FF; color:#11052C; padding:12px 24px; width:100%;">Upload New Avatar</button>
                                </form>
                            </div>
                        </div>

                    </div>
                </div>

                <%-- TAB: Custom Orders --%>
                <div id="tab-orders" class="tab-pane <%= "orders".equals(activeTab) ? "active" : ""%>">
                    <h2 class="tab-title">Custom Design Orders</h2>
                    <p style="color:#cbd5e1; font-size:13px; margin-bottom:24px;">
                        Orders from customers who hired you for custom design work.
                    </p>

                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Customer</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (designerOrders != null && !designerOrders.isEmpty()) {
                                for (Map<String, Object> o : designerOrders) {
                                    double price = (Double) o.get("totalPrice");
                                    String status = (String) o.get("status");
                                    java.sql.Timestamp createdAt = (java.sql.Timestamp) o.get("createAt");
                            %>
                            <tr>
                                <td>#<%= o.get("orderID")%></td>
                                <td><%= o.get("customerName")%></td>
                                <td><%= String.format("%,.0f", price)%>&#x20AB;</td>
                                <td>
                                    <span style="padding:4px 10px; border-radius:12px; font-size:12px; font-weight:700;
                                        <%= "Completed".equals(status) ? "background:rgba(40,167,69,0.2); color:#28a745;" : ("Cancelled".equals(status) ? "background:rgba(220,53,69,0.2); color:#dc3545;" : "background:rgba(255,193,7,0.2); color:#ffc107;")%>">
                                        <%= status%>
                                    </span>
                                </td>
                                <td style="color:#cbd5e1; font-weight:400;"><%= createdAt != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(createdAt) : "N/A"%></td>
                            </tr>
                            <% }
                            } else { %>
                            <tr><td colspan="5" style="text-align:center; padding:40px; color:#94a3b8;">No custom orders yet.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
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
                            <a href="#" class="footer-logo" style="margin-bottom:4px;">Presenta</a>
                            <p class="footer-desc" style="margin-bottom:0;">The next generation template marketplace for academic visionaries and creative professionals.</p>
                        </div>
                    </div>
                    <div class="footer-socials">
                        <a href="https://www.facebook.com/profile.php?id=61590550761077" target="_blank" class="social-icon">&#x1F310;</a>
                        <a href="#" class="social-icon">&#x1F4AC;</a>
                        <a href="mailto:presentaproject05@gmail.com" target="_blank" class="social-icon">&#x1F4E7;</a>
                    </div>
                </div>
                <div class="footer-col contact-col">
                    <h4>GET IN TOUCH</h4>
                    <ul class="contact-info-list">
                        <li><span class="contact-icon">&#x1F4CD;</span><span>FPT University, District 9, Ho Chi Minh City</span></li>
                        <li><span class="contact-icon">&#x1F4E7;</span><span>presentaproject05@gmail.com</span></li>
                        <li><span class="contact-icon">&#x1F4DE;</span><span>+84 (28) 7300 5588</span></li>
                        <li><span class="contact-icon">&#x23F1;</span><span>Mon - Fri: 8:00 AM - 5:00 PM</span></li>
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
        <script src="${pageContext.request.contextPath}/assets/js/designer-account.js"></script>
    
<script src="${pageContext.request.contextPath}/assets/js/lang.js" charset="UTF-8"></script>
</body>
</html>
