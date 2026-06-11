<%-- 
    Document   : profile
    Created on : May 29, 2026, 10:28:01 AM
    Author     : lehan
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.model.User" %>
<%@ page import="com.model.Template" %>
<%@ page import="com.model.Order" %>
<%@ page import="com.model.Template" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%
    User loginUser = (User) session.getAttribute("LOGIN_USER");
    if (loginUser == null) {
        response.sendRedirect(request.getContextPath() + "/MainController");
        return;
    }
    List<Template> purchasedTemplates = (List<Template>) request.getAttribute("purchasedTemplates");
    List<Order> customOrders = (List<Order>) request.getAttribute("customOrders");
    Map<Integer, Template> customOrderTemplates = (Map<Integer, Template>) request.getAttribute("customOrderTemplates");
    if (customOrderTemplates == null) {
        customOrderTemplates = new HashMap<>();
    }

    String toastMsg = (String) session.getAttribute("toastMessage");
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>My Profile - Presenta</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&family=Pacifico&display=swap" rel="stylesheet">

        <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/assets/images/favicon/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-16x16.png">
        <link rel="manifest" href="${pageContext.request.contextPath}/assets/images/favicon/site.webmanifest">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon/favicon.ico">
    </head>

    <%-- LỚP LANDING-BODY SẼ KÍCH HOẠT MÀU NỀN TÍM CHUNG CỦA HỆ THỐNG --%>
    <body class="landing-body">

        <%-- NAVBAR ĐÃ CHUYỂN SANG NỀN TRONG SUỐT --%>
        <nav class="navbar" style="border-bottom: none; background: transparent;">
            <a href="${pageContext.request.contextPath}/MainController" class="nav-brand" style="font-family: 'Pacifico', cursive; font-size: 28px; color:white;">Presenta</a>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/MainController" style="color:white;">HOME</a>
                <a href="${pageContext.request.contextPath}/MainController?action=Shop" style="color:white;">SHOP</a>
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerHub" style="color:white;">DESIGNER HUB</a>
                <a href="${pageContext.request.contextPath}/MainController?action=ViewCart" style="color:white;">CART</a>
                <a href="${pageContext.request.contextPath}/MainController?action=Profile" class="active">PROFILE</a>
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

        <main class="profile-container">
            <aside class="profile-sidebar">
                <div style="border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 20px;">

                    <div class="avatar-wrapper" onclick="triggerFileUpload()" title="Click để đổi ảnh đại diện">
                        <%
                            String userAvatar = loginUser.getAvatarUrl();
                            // Đảm bảo đường dẫn là tuyệt đối từ gốc context
                            String avatarSrc = (userAvatar != null && !userAvatar.isEmpty()) ? userAvatar : "";

                            if (!avatarSrc.isEmpty()) {
                        %>
                        <img src="<%= avatarSrc%>" id="main-avatar-img" alt="Avatar" style="width: 100%; height: 100%; object-fit: cover; display: block;">
                        <% } else {%>
                        <div class="user-avatar" id="main-avatar-placeholder"><%= loginUser.getUsername().substring(0, 1).toUpperCase()%></div>
                        <img src="" id="main-avatar-img" alt="Avatar" style="width: 100%; height: 100%; object-fit: cover; display: none;">
                        <% }%>

                        <div class="avatar-hover-overlay">
                            📷
                        </div>
                    </div>

                    <h3 class="user-name"><%= loginUser.getUsername()%></h3>
                </div>
                <ul class="sidebar-menu">
                    <li class="menu-item active" onclick="switchTab('tab-purchased', this)" id="nav-tab-purchased">🛒 Template đã mua</li>
                    <li class="menu-item" onclick="switchTab('tab-custom', this)" id="nav-tab-custom">🖌️ Đơn Customize</li>
                    <li class="menu-item" onclick="switchTab('tab-info', this)" id="nav-tab-info">⚙️ Cài đặt tài khoản</li>
                </ul>
            </aside>

            <section class="profile-content-area">

                <div id="tab-purchased" class="tab-pane active">
                    <h2 class="tab-title">Template Đã Mua (Download)</h2>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Tên Template</th>
                                <th>Ngày mua</th>
                                <th style="text-align: right;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (purchasedTemplates != null && !purchasedTemplates.isEmpty()) {
                                    for (Template t : purchasedTemplates) {%>
                            <tr>
                                <td><%= t.getTitle()%></td>
                                <td style="color: #cbd5e1; font-weight: 400;"><%= t.getCreateAt() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(t.getCreateAt()) : "N/A"%></td>
                                <td style="text-align: right;">
                                    <a href="<%= t.getFileURL()%>" target="_blank" class="btn-action btn-download">📥 Download</a>
                                    <button class="btn-action btn-review" onclick="openReviewModal(<%= t.getTemplateID()%>, '<%= t.getTitle().replace("'", "\\'")%>')">⭐ Review</button>
                                </td>
                            </tr>
                            <% }
                            } else { %>
                            <tr><td colspan="3" style="text-align: center; padding: 40px; color: #94a3b8;">Bạn chưa mua sản phẩm nào.</td></tr>
                            <% } %>
                        </tbody>
                    </table>

                    <%-- PAGING DÀNH CHO TAB 1 --%>
                    <%
                        Integer tagPage = (Integer) request.getAttribute("tag");
                        Integer endPage = (Integer) request.getAttribute("endPage");
                        if (tagPage != null && endPage != null && endPage > 1) {
                    %>
                    <div style="display: flex; justify-content: center; gap: 8px; margin-top: 25px;">
                        <% for (int i = 1; i <= endPage; i++) {%>
                        <a href="MainController?action=Profile&page=<%= i%>&tab=purchased" 
                           style="padding: 8px 14px; border-radius: 8px; text-decoration: none; color: white; border: 1px solid rgba(255,255,255,0.2);
                           <%= (i == tagPage) ? "background: #D8B4FF; color: #11052C;" : ""%>">
                            <%= i%>
                        </a>
                        <% } %>
                    </div>
                    <% }%>
                </div>

                <div id="tab-custom" class="tab-pane">
                    <h2 class="tab-title">Đơn Thiết Kế Riêng (Customize)</h2>

                    <% if (customOrders != null && !customOrders.isEmpty()) { %>
                    <div style="display: flex; flex-direction: column; gap: 16px;">
                        <%
                            for (Order co : customOrders) {
                                String status = co.getStatus() != null ? co.getStatus() : "Pending";
                                // Determine progress step classes
                                String step1Class = "step-active"; // Pending reached
                                String step2Class = (status.equals("Processing") || status.equals("Completed_Design") || status.equals("Completed")) ? "step-active" : "step-inactive";
                                String step3Class = status.equals("Completed") ? "step-active" : "step-inactive";

                                String statusLabel = "";
                                if (status.equals("Pending"))
                                    statusLabel = "Đang chờ Designer xác nhận...";
                                else if (status.equals("Processing"))
                                    statusLabel = "Designer đang thực hiện...";
                                else if (status.equals("Completed_Design"))
                                    statusLabel = "Đã hoàn thành thiết kế, chờ thanh toán";
                                else if (status.equals("Completed"))
                                    statusLabel = "Đã thanh toán";
                                else if (status.equals("Cancelled"))
                                    statusLabel = "Đã hủy";
                        %>
                        <div style="background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08); border-radius: 12px; padding: 20px;">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                                <div>
                                    <span style="font-weight: 700; color: white; font-size: 15px;">Đơn #<%= co.getOrderId()%></span>
                                    <span style="color: #94a3b8; font-size: 13px; margin-left: 12px;">
                                        <%= co.getCreateAt() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(co.getCreateAt()) : "N/A"%>
                                    </span>
                                </div>
                                <div>
                                    <span style="color: #D8B4FF; font-weight: 600; font-size: 14px;">
                                        <%= co.getTotalPrice() > 0 ? String.format("%,.0f₫", co.getTotalPrice()) : "Chưa định giá"%>
                                    </span>
                                </div>
                            </div>

                            <%-- PROGRESS BAR --%>
                            <div style="display: flex; align-items: center; gap: 0; margin-bottom: 16px;">
                                <%-- Step 1: Pending --%>
                                <div style="display: flex; align-items: center; gap: 8px; flex: 1;">
                                    <div style="width: 28px; height: 28px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 13px;
                                         <%= step1Class.equals("step-active") ? "background: #01B574; color: white;" : "background: rgba(255,255,255,0.1); color: #64748b;"%>">
                                        <%= step1Class.equals("step-active") ? "✓" : "1"%>
                                    </div>
                                    <span style="font-size: 12px; color: #cbd5e1; white-space: nowrap;">Đã đặt</span>
                                </div>
                                <%-- Line 1 --%>
                                <div style="height: 2px; flex: 1; min-width: 20px;
                                     <%= step2Class.equals("step-active") ? "background: #01B574;" : "background: rgba(255,255,255,0.1);"%>"></div>
                                <%-- Step 2: Processing --%>
                                <div style="display: flex; align-items: center; gap: 8px; flex: 1; justify-content: center;">
                                    <div style="width: 28px; height: 28px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 13px;
                                         <%= step2Class.equals("step-active") ? "background: #01B574; color: white;" : "background: rgba(255,255,255,0.1); color: #64748b;"%>">
                                        <%= step2Class.equals("step-active") ? "✓" : "2"%>
                                    </div>
                                    <span style="font-size: 12px; color: #cbd5e1; white-space: nowrap;">Đang thiết kế</span>
                                </div>
                                <%-- Line 2 --%>
                                <div style="height: 2px; flex: 1; min-width: 20px;
                                     <%= step3Class.equals("step-active") ? "background: #01B574;" : "background: rgba(255,255,255,0.1);"%>"></div>
                                <%-- Step 3: Completed --%>
                                <div style="display: flex; align-items: center; gap: 8px; flex: 1; justify-content: flex-end;">
                                    <div style="width: 28px; height: 28px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 13px;
                                         <%= step3Class.equals("step-active") ? "background: #01B574; color: white;" : "background: rgba(255,255,255,0.1); color: #64748b;"%>">
                                        <%= step3Class.equals("step-active") ? "✓" : "3"%>
                                    </div>
                                    <span style="font-size: 12px; color: #cbd5e1; white-space: nowrap;">Hoàn thành</span>
                                </div>
                            </div>

                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <span style="color: <%= status.equals("Cancelled") ? "#ef4444" : "#94a3b8"%>; font-size: 13px;">
                                    📋 <%= statusLabel%>
                                </span>

                                <div style="display: flex; gap: 10px;">
                                    <% if (status.equals("Completed_Design")) {%>
                                    <span style="background: rgba(255,255,255,0.1); color: #64748b; padding: 8px 18px; border-radius: 8px; text-decoration: none; font-weight: 700; font-size: 13px; cursor: not-allowed;" title="VNPay is temporarily disabled">
                                        💳 VNPay (Bảo trì)
                                    </span>
                                    <a href="${pageContext.request.contextPath}/MainController?action=ProcessOrder&paymentMethod=MOMO&orderType=HIRE_DESIGNER&orderId=<%= co.getOrderId()%>"
                                       style="background: #FF5E7A; color: white; padding: 8px 18px; border-radius: 8px; text-decoration: none; font-weight: 700; font-size: 13px;">
                                        💳 MoMo
                                    </a>
                                    <a href="${pageContext.request.contextPath}/MainController?action=ProcessOrder&paymentMethod=PAYOS&orderType=HIRE_DESIGNER&orderId=<%= co.getOrderId()%>"
                                       style="background: #4ade80; color: #11052C; padding: 8px 18px; border-radius: 8px; text-decoration: none; font-weight: 700; font-size: 13px;">
                                        💳 PayOS
                                    </a>
                                    <% } else if (status.equals("Completed")) {
                                        Template ct = customOrderTemplates.get(co.getOrderId());
                                        if (ct != null && ct.getFileURL() != null && !ct.getFileURL().isEmpty()) {
                                    %>
                                    <a href="<%= ct.getFileURL()%>" target="_blank"
                                       style="background: #01B574; color: white; padding: 8px 18px; border-radius: 8px; text-decoration: none; font-weight: 700; font-size: 13px;">
                                        📥 Download File
                                    </a>
                                    <% } %>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                    <% } else { %>
                    <div style="text-align: center; padding: 60px 20px; color: #94a3b8;">
                        <div style="font-size: 48px; margin-bottom: 16px;">🎨</div>
                        <p style="font-size: 16px; margin-bottom: 8px;">Bạn chưa có đơn thiết kế riêng nào.</p>
                        <p style="font-size: 14px;">Khám phá <a href="${pageContext.request.contextPath}/MainController?action=DesignerHub" style="color: #D8B4FF;">Designer Hub</a> để thuê designer thiết kế theo yêu cầu!</p>
                    </div>
                    <% }%>
                </div>

                <div id="tab-info" class="tab-pane">
                    <h2 class="tab-title">Cài đặt tài khoản</h2>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 40px;">

                        <div style="display: flex; flex-direction: column; gap: 30px;">

                            <div style="background: rgba(255,255,255,0.02); padding: 20px; border-radius: 12px; border: 1px solid rgba(255,255,255,0.05);">
                                <h4 style="color: #D8B4FF; margin-top: 0; margin-bottom: 15px;">Thông tin cá nhân</h4>
                                <form action="${pageContext.request.contextPath}/AccountController" method="POST">
                                    <input type="hidden" name="updateType" value="profile">

                                    <label style="display:block; font-size:13px; color:#E2D7FF; font-weight:700; margin-bottom:8px;">Tên đăng nhập (Username)</label>
                                    <input type="text" value="<%= loginUser.getUsername()%>" disabled 
                                           style="width:100%; padding:12px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:15px; background:rgba(255,255,255,0.05); color:rgba(255,255,255,0.4); cursor: not-allowed; box-sizing: border-box; font-weight: bold;">

                                    <label style="display:block; font-size:13px; color:#E2D7FF; font-weight:700; margin-bottom:8px;">Địa chỉ Email</label>
                                    <input type="email" name="email" value="<%= loginUser.getEmail()%>" required 
                                           style="width:100%; padding:12px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:20px; background:rgba(255,255,255,0.05); color:#ffffff; box-sizing: border-box;">

                                    <button type="submit" class="btn-action" style="background:#D8B4FF; color:#11052C; padding: 10px 20px; width: 100%;">Lưu thông tin</button>
                                </form>
                            </div>

                            <div style="background: rgba(255,255,255,0.02); padding: 20px; border-radius: 12px; border: 1px solid rgba(255,255,255,0.05);">
                                <h4 style="color: #D8B4FF; margin-top: 0; margin-bottom: 15px;">Đổi mật khẩu</h4>
                                <form action="${pageContext.request.contextPath}/AccountController" method="POST">
                                    <input type="hidden" name="updateType" value="password">

                                    <label style="display:block; font-size:13px; color:#E2D7FF; font-weight:700; margin-bottom:8px;">Mật khẩu hiện tại</label>
                                    <input type="password" name="oldPass" required style="width:100%; padding:12px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:15px; background:rgba(255,255,255,0.05); color:#ffffff; box-sizing: border-box;">

                                    <label style="display:block; font-size:13px; color:#E2D7FF; font-weight:700; margin-bottom:8px;">Mật khẩu mới</label>
                                    <input type="password" name="newPass" required style="width:100%; padding:12px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:20px; background:rgba(255,255,255,0.05); color:#ffffff; box-sizing: border-box;">

                                    <button type="submit" class="btn-action" style="background: transparent; color:#D8B4FF; border: 1px solid #D8B4FF; padding: 10px 20px; width: 100%;">Thay đổi mật khẩu</button>
                                </form>
                            </div>

                        </div>

                        <div>
                            <div style="background: rgba(255,255,255,0.02); padding: 20px; border-radius: 12px; border: 1px solid rgba(255,255,255,0.05); height: 100%; box-sizing: border-box; display: flex; flex-direction: column;">
                                <h4 style="color: #D8B4FF; margin-top: 0; margin-bottom: 15px;">Đổi ảnh đại diện</h4>
                                <p style="font-size: 13px; color: #cbd5e1; margin-top: 0; line-height: 1.5; flex-grow: 1;">
                                    Bấm trực tiếp vào hình vòng tròn ảnh đại diện ở menu bên trái, hoặc bấm nút bên dưới để chọn một file ảnh (JPG, PNG, GIF) từ máy tính của bạn.
                                    <br><br>
                                    <span style="color: #ffc107;">* Lưu ý: Kích thước file không được vượt quá 10MB.</span>
                                </p>

                                <form action="${pageContext.request.contextPath}/AccountController" method="POST" enctype="multipart/form-data" style="margin-top: 20px;">
                                    <input type="hidden" name="updateType" value="avatar">

                                    <label style="display:block; font-size:13px; color:#E2D7FF; font-weight:700; margin-bottom:8px;">Chọn file ảnh từ máy</label>
                                    <input type="file" name="avatarFile" id="avatar-file-input" accept="image/png, image/jpeg, image/gif" required 
                                           style="width:100%; padding:10px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:20px; background:rgba(255,255,255,0.05); color:#ffffff; box-sizing: border-box; font-size: 12px;">

                                    <button type="submit" class="btn-action" style="background:#D8B4FF; color:#11052C; padding: 12px 24px; width: 100%;">Lưu Ảnh Đại Diện Mới</button>
                                </form>
                            </div>
                        </div>

                    </div>
                </div>

            </section>
        </main>

        <div id="reviewModal" class="modal-overlay">
            <div class="modal-content">
                <h3 style="margin-top: 0; color: #ffffff;">Đánh giá sản phẩm</h3>
                <p id="reviewTemplateName" style="color: #D8B4FF; font-size: 14px; margin-bottom: 5px; font-weight:bold;"></p>

                <form action="${pageContext.request.contextPath}/MainController" method="POST">
                    <input type="hidden" name="action" value="SubmitReview">
                    <input type="hidden" name="templateId" id="reviewTemplateId">

                    <div class="star-rating">
                        <input type="radio" id="star5" name="rating" value="5" required><label for="star5">★</label>
                        <input type="radio" id="star4" name="rating" value="4"><label for="star4">★</label>
                        <input type="radio" id="star3" name="rating" value="3"><label for="star3">★</label>
                        <input type="radio" id="star2" name="rating" value="2"><label for="star2">★</label>
                        <input type="radio" id="star1" name="rating" value="1"><label for="star1">★</label>
                    </div>

                    <textarea name="comment" class="review-textarea" rows="4" placeholder="Chia sẻ cảm nhận của bạn về Template này..." required></textarea>

                    <div style="display: flex; gap: 10px; justify-content: space-between;">
                        <button type="button" class="btn-action" style="background: rgba(255,255,255,0.1); color: #ffffff; flex:1;" onclick="closeReviewModal()">Hủy</button>
                        <button type="submit" class="btn-action" style="background: #D8B4FF; color: #11052C; flex:1;">Gửi Đánh Giá</button>
                    </div>
                </form>
            </div>
        </div>

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
                            <p class="footer-desc" style="margin-bottom: 0;">The next generation template marketplace for academic visionaries and creative professionals. Empowering students and designers worldwide.</p>
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
        <script src="${pageContext.request.contextPath}/assets/js/profile.js"></script>
    
<script src="${pageContext.request.contextPath}/assets/js/lang.js"></script>
</body>
</html>