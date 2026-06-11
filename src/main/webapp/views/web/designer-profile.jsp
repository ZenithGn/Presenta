<%-- 
    Document   : designer-profile
    Created on : May 28, 2026, 12:34:24 AM
    Author     : lehan
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.model.Designer" %>
<%@ page import="com.model.Template" %>
<%@ page import="com.model.Review" %>
<%@ page import="com.model.User" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Designer Profile - Presenta</title>
        <link href="https://fonts.googleapis.com/css2?family=Pacifico&family=Be+Vietnam+Pro:wght@400;500;700;800&display=swap" rel="stylesheet">
        <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/assets/images/favicon/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-16x16.png">
        <link rel="manifest" href="${pageContext.request.contextPath}/assets/images/favicon/site.webmanifest">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon/favicon.ico">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shop.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer-profile.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/toast.css?v=1.0">
    </head>

    <%
        User loginUser = (User) session.getAttribute("LOGIN_USER");
        int roleId = (loginUser != null) ? loginUser.getRoleId() : 0;

        Designer designer = (Designer) request.getAttribute("designer");
        List<Template> templates = (List<Template>) request.getAttribute("templates");
        List<Review> reviews = (List<Review>) request.getAttribute("reviews");

        // Nhận các thông số đã tính toán từ Controller
        Integer templatesSoldObj = (Integer) request.getAttribute("templatesSold");
        int templatesSold = (templatesSoldObj != null) ? templatesSoldObj : 0;

        Double avgRatingObj = (Double) request.getAttribute("avgRating");
        double avgRating = (avgRatingObj != null) ? avgRatingObj : 0.0;

        Integer totalReviewsObj = (Integer) request.getAttribute("totalReviews");
        int totalReviews = (totalReviewsObj != null) ? totalReviewsObj : 0;

        Integer satisfactionRateObj = (Integer) request.getAttribute("satisfactionRate");
        int satisfactionRate = (satisfactionRateObj != null) ? satisfactionRateObj : 0;

        String designerPhone = (String) request.getAttribute("designerPhone");
        if (designerPhone == null) designerPhone = "";

        if (designer == null) {
            response.sendRedirect("MainController?action=DesignerList");
            return;
        }
    %>

    <body class="landing-body">
        <%-- ======================================================= --%>
        <%-- NAVBAR                                                  --%>
        <%-- ======================================================= --%>
        <% if (roleId == 0 || roleId == 2) { %>
        <nav class="navbar" style="border-bottom: none; background: transparent;">
            <a href="${pageContext.request.contextPath}/MainController" class="nav-brand" style="font-family: 'Pacifico', cursive; font-size: 28px;">Presenta</a>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/MainController">HOME</a>
                <a href="${pageContext.request.contextPath}/MainController?action=Shop">SHOP</a>
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerHub" class="active">DESIGNER HUB</a>
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
        <% } %>

        <%-- ======================================================= --%>
        <%-- NỘI DUNG CHÍNH (PROFILE + TEMPLATE + REVIEW)            --%>
        <%-- ======================================================= --%>
        <div style="max-width: 1200px; margin: 0 auto; padding: 0 24px;">

            <%
                String avatar = (designer.getAvatarURL() != null && !designer.getAvatarURL().trim().isEmpty())
                        ? designer.getAvatarURL()
                        : "https://ui-avatars.com/api/?name=" + designer.getUserName() + "&background=7C3AED&color=fff";
            %>
            <div class="profile-hero-card">
                <div class="profile-avatar-wrap">
                    <img src="<%= avatar%>" alt="<%= designer.getUserName()%>">
                </div>
                <div class="profile-info">
                    <h1><%= designer.getUserName()%></h1>
                    <h3>Motion & Interaction & Academic Presentation Designer</h3>

                    <p style="color: white; font-size: 14px; font-weight: 700; margin-bottom: 24px;">
                        ⭐ <%= totalReviews > 0 ? String.format("%.1f", avgRating) : "0"%> Rating (<%= totalReviews%> Reviews)<br>
                        📦 <%= templatesSold%> Templates Sold<br>
                        🔥 <%= satisfactionRate%>% Client Satisfaction
                    </p>

                    <div style="display: flex; gap: 16px; margin-bottom: 32px;">
                        <% if (roleId == 2) { %>
                        <form action="${pageContext.request.contextPath}/MainController" method="POST" style="margin: 0;">
                            <input type="hidden" name="action" value="BookDesigner">
                            <input type="hidden" name="designerID" value="<%= designer.getUserID()%>">
                            <button type="submit" class="btn-primary" style="padding: 12px 32px; border-radius: 999px;">Book</button>
                        </form>
                        <% } else if (roleId == 0) { %>
                        <a href="${pageContext.request.contextPath}/MainController?action=Login" class="btn-primary" style="padding: 12px 32px; border-radius: 999px;">Book</a>
                        <% } %>
                        <% if (!designerPhone.isEmpty()) { %>
                        <a href="https://zalo.me/<%= designerPhone.replaceAll("[^0-9]", "")%>" target="_blank" class="btn-outline" style="padding: 12px 32px; border-radius: 999px; border-color: white;">Contact</a>
                        <% } else { %>
                        <a href="#" class="btn-outline" style="padding: 12px 32px; border-radius: 999px; border-color: white; opacity: 0.5;">Contact</a>
                        <% } %>
                    </div>

                    <h4 style="color: white; margin-bottom: 8px;">About</h4>
                    <p style="color: #E2D7FF; font-size: 14px; line-height: 1.6;">
                        <%= (designer.getBio() != null && !designer.getBio().trim().isEmpty()) ? designer.getBio() : "Chưa có mô tả"%>
                    </p>
                </div>
            </div>

            <h2 style="font-size: 28px; font-weight: 800; color: white; margin-bottom: 24px;">Template By This Designer</h2>
            <div class="templates-wrapper">
                <div class="product-grid" style="margin-bottom: 0;">
                    <%
                        if (templates != null && !templates.isEmpty()) {
                            for (Template t : templates) {
                                String tThumb = (t.getThumbnailURL() != null) ? t.getThumbnailURL() : "https://images.unsplash.com/photo-1614850523459-c2f4c699c52e?q=80&w=400";
                    %>
                    <div class="product-card">
                        <img src="<%= tThumb%>" class="product-img" alt="<%= t.getTitle()%>">
                        <div class="product-info">
                            <span class="product-title"><%= t.getTitle()%></span>
                            <span class="product-price"><%= (int) (t.getPrice() / 1000)%>k</span>
                        </div>
                        <div class="card-actions" style="margin-top: 16px;">
                            <a href="MainController?action=TemplateDetail&templateID=<%= t.getTemplateID()%>" class="btn-card btn-white" style="text-decoration:none; display:block; width:100%;">View Detail</a>
                            <a href="${pageContext.request.contextPath}/MainController?action=AddCart&id=<%= t.getTemplateID()%>" class="btn-card btn-dark" style="text-decoration:none; display:block; width:100%;">Add To Cart</a>
                        </div>
                    </div>
                    <%      }
                    } else { %>
                    <p style="color: #ccc3d8; grid-column: span 3; text-align: center;">Designer này chưa có template nào được đăng bán.</p>
                    <%  } %>
                </div>
            </div>

            <h2 style="font-size: 28px; font-weight: 800; color: white; margin-bottom: 24px; text-align: center;">Client Reviews</h2>

            <div class="review-grid" id="reviewContainer">
                <%
                    if (reviews != null && !reviews.isEmpty()) {
                        int count = 0;
                        for (Review r : reviews) {
                            // 4 review đầu tiên sẽ hiện, từ review thứ 5 trở đi sẽ bị ẩn (gắn class review-hidden)
                            String hiddenClass = (count >= 4) ? "review-hidden" : "";
                %>
                <div class="review-card js-review-item <%= hiddenClass%>">
                    <div class="review-stars">
                        <% for (int i = 0; i < r.getRating(); i++) {
                                out.print("★ ");
                            }%>
                    </div>
                    <div class="review-user"><%= r.getCustomerName()%></div>
                    <div class="review-text">"<%= r.getComment()%>"</div>
                </div>
                <%
                        count++;
                    }
                } else {
                %>
                <p style="color: #ccc3d8; grid-column: span 2; text-align: center;">Chưa có lượt đánh giá nào.</p>
                <%  } %>
            </div>

            <% if (reviews != null && reviews.size() > 4) { %>
            <div style="text-align: center; margin-bottom: 80px;">
                <button id="btnLoadMore" onclick="loadMoreReviews()" class="btn-outline" style="padding: 12px 40px; border-radius: 999px; color: white; border-color: white;">View More Reviews</button>
            </div>
            <% } else { %>
            <div style="margin-bottom: 80px;"></div>
            <% }%>

        </div>
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

            </div> 
            <div class="footer-bottom">
                <div class="footer-bottom-container">
                    <p>&copy; 2026 Presenta. All rights reserved.</p>
                </div>
            </div>
        </footer>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js?v=1.0"></script>
        <script src="${pageContext.request.contextPath}/assets/js/designer-profile.js"></script>
    
<script src="${pageContext.request.contextPath}/assets/js/lang.js" charset="UTF-8"></script>
</body>
</html>