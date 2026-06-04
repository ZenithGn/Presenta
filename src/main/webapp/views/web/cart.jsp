<%-- 
    Document   : cart
    Created on : May 28, 2026, 1:43:31 PM
    Author     : lehan
--%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.model.User" %>
<%@ page import="com.model.Template" %>
<%@ page import="com.model.CartItem" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Cart - Presenta</title>
        <link href="https://fonts.googleapis.com/css2?family=Pacifico&family=Be+Vietnam+Pro:wght@400;500;700;800&display=swap" rel="stylesheet">
        <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/assets/images/favicon/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-16x16.png">
        <link rel="manifest" href="${pageContext.request.contextPath}/assets/images/favicon/site.webmanifest">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon/favicon.ico">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cart.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer-hub.css">
    </head>

    <%
        // Lấy thông tin User và Giỏ hàng từ Session
        User loginUser = (User) session.getAttribute("LOGIN_USER");
        int roleId = (loginUser != null) ? loginUser.getRoleId() : 0;

        // Lấy Hashmap giỏ hàng
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("CART");
    %>

    <body class="landing-body">

        <%-- ======================================================= --%>
        <%-- NAVBAR (Đã copy từ home.jsp)                            --%>
        <%-- ======================================================= --%>
        <% if (roleId == 0 || roleId == 2) { %>
        <nav class="navbar" style="border-bottom: none; background: transparent;">
            <a href="${pageContext.request.contextPath}/MainController" class="nav-brand" style="font-family: 'Pacifico', cursive; font-size: 28px;">Presenta</a>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/MainController">HOME</a>
                <a href="${pageContext.request.contextPath}/MainController?action=Shop">SHOP</a>
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerHub">DESIGNER HUB</a>
                <% if (roleId == 2) { %>
                <a href="${pageContext.request.contextPath}/MainController?action=ViewCart" class="active">CART</a>
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
            </div>
        </nav>
        <% } %>

        <%-- ======================================================= --%>
        <%-- MAIN CART CONTENT                                       --%>
        <%-- ======================================================= --%>
        <main class="cart-page">

            <div class="cart-header-banner">
                <h1 class="cart-title-glow">Cart</h1>
            </div>

            <div class="cart-container">

                <div class="cart-items-section">
                    <div class="cart-items-header">
                        <span class="col-product">Product</span>
                        <span class="col-total">Total</span>
                    </div>

                    <%
                        double subTotal = 0;
                        if (cart != null && !cart.isEmpty()) {
                            for (Map.Entry<Integer, CartItem> entry : cart.entrySet()) {
                                int templateId = entry.getKey();
                                CartItem item = entry.getValue();
                                Template t = item.getTemplate();
                                subTotal += item.getItemTotal();

                                String itemThumb = (t.getThumbnailURL() != null && !t.getThumbnailURL().trim().isEmpty())
                                        ? t.getThumbnailURL()
                                        : "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=400";
                    %>
                    <div class="cart-item-card">
                        <div class="item-image">
                            <img src="<%= itemThumb%>" alt="<%= t.getTitle()%>">
                        </div>
                        <div class="item-details">
                            <h3 class="item-name"><%= t.getTitle()%></h3>
                            <p class="item-base-price"><%= String.format("%,.0f", t.getPrice())%>đ (x<%= item.getQuantity()%>)</p>
                            <a href="${pageContext.request.contextPath}/MainController?action=RemoveCart&id=<%= templateId%>" class="btn-remove-item">Remove</a>
                        </div>
                        <div class="item-total-price">
                            <%= String.format("%,.0f", item.getItemTotal())%>đ
                        </div>
                    </div>
                    <%
                        }
                    } else {
                    %>
                    <div class="empty-cart-message">
                        <h3>Giỏ hàng của bạn đang trống!</h3>
                        <a href="${pageContext.request.contextPath}/MainController?action=Shop">Tiếp tục mua sắm</a>
                    </div>
                    <% } %>
                </div>

                <%
                    // Tại trang giỏ hàng, tổng tiền tạm thời bằng đúng Sub Total vì chưa áp voucher
                    double totalAmount = subTotal;
                %>
                <div class="cart-summary-section">
                    <h3 class="summary-title">Summary</h3>

                    <!--
                    <div class="summary-row">
                        <span class="summary-label">Sub Total</span>
                        <span class="summary-value"><%= String.format("%,.0f", subTotal)%>đ</span>
                    </div>

                    <div class="summary-divider"></div>
                    -->

                    <div class="summary-row total-row">
                        <span class="summary-label">Total</span>
                        <span class="summary-value" style="font-size: 20px;"><%= String.format("%,.0f", totalAmount)%>đ</span>
                    </div>

                    <form action="${pageContext.request.contextPath}/MainController?action=Checkout" method="POST">
                        <% if (cart != null && !cart.isEmpty()) { %>
                        <button type="submit" class="btn-checkout">Check Out</button>
                        <% } else { %>
                        <button type="button" class="btn-checkout" style="background:#555; cursor:not-allowed;" disabled>Check Out</button>
                        <% } %>
                    </form>
                </div>

            </div> 
            <div class="suggestions-container">
                <h2 class="suggestions-title">You May Also Like</h2>
                <div class="suggestions-glass-box">
                    <div class="suggestion-grid">
                        <%
                            List<Template> recommendTemplates = (List<Template>) request.getAttribute("recommendTemplates");
                            if (recommendTemplates != null && !recommendTemplates.isEmpty()) {
                                int count = 0;
                                for (Template t : recommendTemplates) {
                                    if (count >= 3) {
                                        break;
                                    }
                                    count++;

                                    String suggestThumb = (t.getThumbnailURL() != null && !t.getThumbnailURL().trim().isEmpty())
                                            ? t.getThumbnailURL()
                                            : "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=400";
                        %>
                        <div class="suggestion-card">
                            <img src="<%= suggestThumb%>" alt="Thumbnail">
                            <div class="suggestion-info">
                                <div class="s-title-row">
                                    <h3 style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 70%;"><%= t.getTitle()%></h3>
                                    <span><%= (int) (t.getPrice() / 1000)%>k</span>
                                </div>
                                <div class="s-action-btns">
                                    <form action="${pageContext.request.contextPath}/MainController" method="GET" style="flex:1; margin:0;">
                                        <input type="hidden" name="action" value="TemplateDetail">
                                        <input type="hidden" name="templateID" value="<%= t.getTemplateID()%>">
                                        <button type="submit" class="btn-s-outline" style="width:100%;">View Detail</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/MainController" method="POST" style="flex:1; margin:0;">
                                        <input type="hidden" name="action" value="AddCart">
                                        <input type="hidden" name="id" value="<%= t.getTemplateID()%>">
                                        <button type="submit" class="btn-s-outline" style="width:100%;">Add to Cart</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <%
                            }
                        } else {
                        %>
                        <p style="color: white; width: 100%; text-align: center;">Chưa có sản phẩm gợi ý.</p>
                        <% }%>
                    </div>
                </div>
            </div>
        </main>

        <%-- ======================================================= --%>
        <%-- FOOTER (Đã copy từ home.jsp)                            --%>
        <%-- ======================================================= --%>
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
    </body>
</html>