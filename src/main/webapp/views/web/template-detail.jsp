<%-- 
    Document   : template-detail
    Created on : May 26, 2026, 8:56:46 PM
    Author     : lehan
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.model.Template" %>
<%@ page import="com.model.Review" %>
<%@ page import="com.model.User" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Detail - Presenta</title>
        <link href="https://fonts.googleapis.com/css2?family=Pacifico&family=Be+Vietnam+Pro:wght@400;500;700;800&display=swap" rel="stylesheet">
        <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/assets/images/favicon/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-16x16.png">
        <link rel="manifest" href="${pageContext.request.contextPath}/assets/images/favicon/site.webmanifest">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon/favicon.ico">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css"> 
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shop.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/template-detail.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/toast.css?v=1.0">
    </head>
    <%
        // DI CHUYỂN TOÀN BỘ KHỐI NÀY LÊN TRÊN THẺ BODY
        User loginUser = (User) session.getAttribute("LOGIN_USER");
        int roleId = (loginUser != null) ? loginUser.getRoleId() : 0;

        Template t = (Template) request.getAttribute("templateDetail");
        List<Template> relatedTemplates = (List<Template>) request.getAttribute("relatedTemplates");
        List<Review> reviews = (List<Review>) request.getAttribute("reviews");

        String designerName = (String) request.getAttribute("designerName");
        String designerBio = (String) request.getAttribute("designerBio");

        // Xử lý ảnh
        String thumb = (t != null && t.getThumbnailURL() != null) ? t.getThumbnailURL() : "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=800";
    %>

    <body class="<%= (roleId == 0 || roleId == 2) ? "landing-body" : ""%>">

        <% if (roleId == 0 || roleId == 2) { %>
        <nav class="navbar" style="border-bottom: none; background: transparent;">
            <a href="${pageContext.request.contextPath}/MainController" class="nav-brand" style="font-family: 'Pacifico', cursive; font-size: 28px;">Presenta</a>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/MainController">HOME</a>
                <a href="${pageContext.request.contextPath}/MainController?action=Shop" class="active">SHOP</a>
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerHub">DESIGNER HUB</a>
                <% if (roleId == 2) { %>
                <a href="${pageContext.request.contextPath}/MainController?action=ViewCart">CART</a>
                <a href="${pageContext.request.contextPath}/MainController?action=Profile">PROFILE</a>
                <% } %>
            </div>
            <div class="nav-actions">
                <% if (roleId == 2) {%>
                <span style="color: #dae2fd; font-size: 14px; margin-right: 10px;">Welcome, <b><%= loginUser.getUsername()%></b></span>
                <form action="${pageContext.request.contextPath}/MainController" method="POST" style="margin:0; display: inline-block;">
                    <input type="hidden" name="action" value="Logout">
                    <button type="submit" class="btn-outline" style="padding: 6px 16px; font-size: 12px; border-radius: 999px;">Logout</button>
                </form>
                <% } else { %>
                <a href="${pageContext.request.contextPath}/MainController?action=Login" class="btn-outline" style="border-radius: 999px;">Login</a>
                <a href="${pageContext.request.contextPath}/MainController?action=Register" class="btn-primary" style="border-radius: 999px; background: white; color: black;">Sign Up</a>
                <% } %>
            
<button onclick="toggleLanguage()" class="lang-toggle-btn no-translate" style="background: transparent; border: 1px solid currentColor; color: inherit; padding: 4px 10px; border-radius: 20px; cursor: pointer; margin-left: 15px; font-weight: bold; white-space: nowrap;">EN/VI</button>
</div>
        
</nav>

        <% }
            if (t != null) {%>
        <div class="detail-body-wrapper" style="background: transparent !important; padding-top: 1px;">
            <div class="detail-container">

                <a href="MainController?action=Shop" class="btn-back">
                    <span style="font-size: 18px;">&larr;</span> Back to Shop
                </a>

                <div class="detail-hero">
                    <div class="detail-image-box">
                        <img src="<%= thumb%>" alt="Template Preview">
                    </div>

                    <div class="detail-info">
                        <div class="detail-category">PREMIUM TEMPLATE</div>
                        <h1 class="detail-title"><%= t.getTitle()%></h1>

                        <div class="detail-rating">
                            ★ 4.9 <span style="color: #a3a3a3; font-size: 12px;">(<%= (reviews != null) ? reviews.size() : 0%> reviews)</span>
                        </div>

                        <div class="buy-card">
                            <div class="buy-price">
                                <%= String.format("%,.0f", t.getPrice())%> VND
                            </div>
                            <p class="buy-desc"><%= t.getDescription()%></p>

                            <div class="action-buttons">
                                <form action="${pageContext.request.contextPath}/MainController?action=AddCart&id=<%= t.getTemplateID()%>" method="POST" style="margin:0; grid-column: span 2;">
                                    <input type="hidden" name="action" value="BuyNow">
                                    <input type="hidden" name="templateID" value="<%= t.getTemplateID()%>">
                                    <button type="submit" class="btn-full" style="width:100%;">Buy Now</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="detail-middle">
                    <div>
                        <h2 class="section-heading">What's Inside This Template</h2>

                        <%
                            // Xử lý tách chuỗi thành mảng dựa trên ký tự "|"
                            // Nếu DB bị Null, sẽ hiển thị mảng mặc định báo chưa có thông tin
                            String[] cores = (t.getCoreFeatures() != null && !t.getCoreFeatures().trim().isEmpty())
                                    ? t.getCoreFeatures().split("\\|")
                                    : new String[]{"Chưa có thông tin cấu trúc."};

                            String[] assets = (t.getDesignAssets() != null && !t.getDesignAssets().trim().isEmpty())
                                    ? t.getDesignAssets().split("\\|")
                                    : new String[]{"Chưa có thông tin tài nguyên đính kèm."};
                        %>

                        <div class="feature-grid">
                            <div class="feature-box">
                                <h4 style="margin-bottom: 12px; font-size: 14px;">Core Structure</h4>
                                <ul>
                                    <% for (String core : cores) {%>
                                    <li><%= core.trim()%></li>
                                        <% } %>
                                </ul>
                            </div>

                            <div class="feature-box">
                                <h4 style="margin-bottom: 12px; font-size: 14px;">Design Assets</h4>
                                <ul>
                                    <% for (String asset : assets) {%>
                                    <li><%= asset.trim()%></li>
                                        <% } %>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div>
                        <h2 class="section-heading">Meet The Designer</h2>
                        <div class="designer-card">
                            <%
                                // Xử lý ảnh avatar mặc định nếu Designer chưa cập nhật ảnh
                                String avatar = (t.getDesignerAvatar() != null && !t.getDesignerAvatar().trim().isEmpty())
                                        ? t.getDesignerAvatar()
                                        : "https://ui-avatars.com/api/?name=" + t.getDesignerName() + "&background=7C3AED&color=fff";

                                // Xử lý hiển thị Bio mặc định
                                String bio = (t.getDesignerBio() != null && !t.getDesignerBio().trim().isEmpty())
                                        ? t.getDesignerBio()
                                        : "Designer này chưa cập nhật tiểu sử.";

                                // Xử lý link Portfolio
                                String portfolio = (t.getDesignerPortfolio() != null) ? t.getDesignerPortfolio() : "#";
                            %>
                            <img src="<%= avatar%>" class="designer-avatar" alt="Designer Avatar">

                            <h3><%= t.getDesignerName()%></h3>
                            <p style="color: #ccc3d8; font-size: 12px; text-transform: uppercase; margin-bottom: 16px;">Verified Designer</p>

                            <p style="font-size: 14px; margin-bottom: 24px; color: #a3a3a3;"><%= bio%></p>

                            <a href="<%= portfolio%>" target="_blank" class="btn-outline" style="width: 100%; display: block; text-align: center; text-decoration: none;">View Portfolio</a>
                        </div>
                    </div>
                </div>

                <div style="margin-bottom: 64px;">
                    <h2 class="section-heading">Customer Reviews</h2>
                    <% if (reviews != null && !reviews.isEmpty()) {
                            for (Review r : reviews) {
                    %>
                    <div class="review-item">
                        <div class="review-header">
                            <span class="review-name"><%= r.getCustomerName()%></span>
                            <%
                                StringBuilder stars = new StringBuilder();
                                for (int i = 0; i < r.getRating(); i++) {
                                    stars.append("★");
                                }
                                for (int i = r.getRating(); i < 5; i++)
                                    stars.append("☆");
                            %>
                            <span style="color: #FFD700;"><%= stars.toString()%></span>

                        </div>
                        <p style="color: #ccc3d8; font-size: 14px;"><%= r.getComment()%></p>
                    </div>
                    <%  }
                    } else { %>
                    <p style="color: #a3a3a3;">Chưa có đánh giá nào cho sản phẩm này.</p>
                    <% } %>
                </div>

                <div>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
                        <h2 class="shop-section-title" style="margin: 0;">You May Also Like</h2>
                        <a href="MainController?action=Shop" style="color: white; text-decoration: none; font-size: 14px;">View All &rarr;</a>
                    </div>

                    <div class="product-grid">
                        <% if (relatedTemplates != null) {
                                for (Template rt : relatedTemplates) {
                                    String rThumb = (rt.getThumbnailURL() != null) ? rt.getThumbnailURL() : "https://images.unsplash.com/photo-1614850523459-c2f4c699c52e?q=80&w=400";
                        %>
                        <div class="product-card">
                            <img src="<%= rThumb%>" class="product-img" style="height: 180px;" alt="Related">
                            <div class="product-info" style="margin-bottom: 0;">
                                <span class="product-title" style="font-size: 14px;"><%= rt.getTitle()%></span>
                                <span class="badge" style="background: rgba(255,255,255,0.1); border:none; color: white;"><%= (int) (rt.getPrice() / 1000)%>k</span>
                            </div>
                            <form action="MainController" method="GET" style="margin-top: 12px;">
                                <input type="hidden" name="action" value="TemplateDetail">
                                <input type="hidden" name="templateID" value="<%= rt.getTemplateID()%>">
                                <button type="submit" class="btn-card btn-white" style="width:100%;">View Detail</button>
                            </form>
                        </div>
                        <%  }
                            } %>
                    </div>
                </div>

            </div>
        </div>
        <% }%>
        <%
            String toastMsg = (String) session.getAttribute("toastMessage");
            if (toastMsg != null) {
        %>
        <div id="custom-toast" class="show">
            <span class="toast-icon">✔️</span>
            <span class="toast-text"><%= toastMsg%></span>
        </div>
        <%
                session.removeAttribute("toastMessage");
            }
        %>

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
                        <li>
                            <span class="contact-icon">📍</span>
                            <span>FPT University, District 9, Ho Chi Minh City</span>
                        </li>
                        <li>
                            <span class="contact-icon">📧</span>
                            <span>presentaproject05@gmail.com</span>
                        </li>
                        <li>
                            <span class="contact-icon">📞</span>
                            <span>+84 (28) 7300 5588</span>
                        </li>
                        <li>
                            <span class="contact-icon">⏱</span>
                            <span>Mon - Fri: 8:00 AM - 5:00 PM</span>
                        </li>
                    </ul>
                </div>

            </div> <div class="footer-bottom">
                <div class="footer-bottom-container">
                    <p>&copy; 2026 Presenta. All rights reserved.</p>
                </div>
            </div>
        </footer>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js?v=1.0"></script>
    
<script src="${pageContext.request.contextPath}/assets/js/lang.js"></script>
</body>
</html>
