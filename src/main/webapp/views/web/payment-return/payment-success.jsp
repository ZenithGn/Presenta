<%-- 
    Document   : payment_success
    Created on : May 28, 2026, 8:47:35 PM
    Author     : lehan
--%>

<%@page import="com.model.CartItem"%>
<%@page import="java.util.Map"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.model.User" %>
<%@ page import="com.model.Template" %>
<%@ page import="java.util.List" %>

<%
    // BẢO MẬT & PHÂN QUYỀN: Chỉ cho phép người dùng đăng nhập có quyền Customer (roleId = 2) vào xem
    User loginUser = (User) session.getAttribute("LOGIN_USER");
    if (loginUser == null || loginUser.getRoleId() != 2) {
        response.sendRedirect(request.getContextPath() + "/MainController");
        return;
    }
    String message = (String) request.getAttribute("message");
    if (message == null) {
        message = "Giao dịch đã được hoàn tất thành công!";
    }

    // Nhận lại danh sách sản phẩm truyền từ VNPayReturnController sang
    List<Template> purchasedTemplates = (List<Template>) request.getAttribute("purchasedTemplates");
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Payment Success - Presenta</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&family=Pacifico&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
        <style>
            .result-container {
                min-height: 80vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 40px 20px;
            }
            .result-card {
                background: #ffffff;
                border-radius: 20px;
                padding: 45px 40px;
                text-align: center;
                max-width: 550px;
                width: 100%;
                box-shadow: 0 10px 30px rgba(0,0,0,0.2);
                border-top: 6px solid #28a745;
            }
            .icon-circle.success {
                width: 70px;
                height: 70px;
                background: rgba(40, 167, 69, 0.1);
                color: #28a745;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 36px;
                margin: 0 auto 15px;
            }
            .result-title {
                color: #0b1c4a;
                font-size: 26px;
                font-weight: 800;
                margin-bottom: 12px;
            }
            .result-desc {
                color: #64748b;
                font-size: 15px;
                margin-bottom: 25px;
                line-height: 1.5;
            }

            /* CẤU TRÚC KHU VỰC DỮ LIỆU TẢI FILE */
            .download-box-panel {
                background: #f8fafc;
                border: 1px solid #e2e8f0;
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 30px;
                text-align: left;
            }
            .download-box-title {
                font-size: 14px;
                font-weight: 800;
                color: #0b1c4a;
                margin-top: 0;
                margin-bottom: 15px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                border-bottom: 1px solid #e2e8f0;
                padding-bottom: 8px;
            }
            .download-items-list {
                display: flex;
                flex-direction: column;
                gap: 12px;
            }
            .download-row-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                background: #ffffff;
                padding: 12px 16px;
                border-radius: 8px;
                border: 1px solid #e2e8f0;
            }
            .purchased-item-name {
                color: #334155;
                font-weight: 700;
                font-size: 14px;
                max-width: 60%;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
            .btn-download-zip {
                background: #28a745;
                color: #ffffff;
                text-decoration: none;
                font-size: 12px;
                font-weight: 700;
                padding: 8px 16px;
                border-radius: 6px;
                transition: background 0.2s, transform 0.1s;
                display: inline-flex;
                align-items: center;
                gap: 4px;
            }
            .btn-download-zip:hover {
                background: #218838;
                transform: translateY(-1px);
            }

            .btn-continue-shop {
                display: inline-block;
                background: #050a24;
                color: #fff;
                padding: 12px 35px;
                border-radius: 999px;
                text-decoration: none;
                font-weight: 700;
                transition: background 0.3s;
                width: 100%;
                box-sizing: border-box;
            }
            .btn-continue-shop:hover {
                background: #2b3b75;
            }
        </style>
    </head>

    <body class="landing-body">
        <%-- NAVBAR (Đồng bộ) --%>
        <% if (loginUser.getRoleId() == 0 || loginUser.getRoleId() == 2) { %>
        <nav class="navbar" style="border-bottom: none; background: transparent;">
            <a href="${pageContext.request.contextPath}/MainController" class="nav-brand" style="font-family: 'Pacifico', cursive; font-size: 28px;">Presenta</a>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/MainController">HOME</a>
                <a href="${pageContext.request.contextPath}/MainController?action=Shop">SHOP</a>
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerHub">DESIGNER HUB</a>
                <% if (loginUser.getRoleId() == 2) { %>
                <a href="${pageContext.request.contextPath}/MainController?action=ViewCart">CART</a>
                <a href="${pageContext.request.contextPath}/MainController?action=Profile">PROFILE</a>
                <% } %>
            </div>
            <div class="nav-actions">
<button onclick="toggleLanguage()" class="lang-toggle-btn no-translate" style="background: transparent; border: 1px solid currentColor; color: inherit; padding: 4px 10px; border-radius: 20px; cursor: pointer; margin-right: 15px; font-weight: bold; white-space: nowrap;">EN/VI</button>

                <% if (loginUser.getRoleId() == 2) {%>
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

        <main class="result-container">
            <div class="result-card">
                <div class="icon-circle success">✓</div>
                <h1 class="result-title">Payment Successful!</h1>
                <p class="result-desc"><%= message%><br>Cảm ơn bạn đã mua hàng. File của bạn đã sẵn sàng để tải về bên dưới.</p>

                <div class="download-box-panel">
                    <h2 class="download-box-title">Sản phẩm của bạn</h2>
                    <div class="download-items-list">
                        <%
                            if (purchasedTemplates != null && !purchasedTemplates.isEmpty()) {
                                for (Template t : purchasedTemplates) {
                        %>
                        <div class="download-row-item">
                            <span class="purchased-item-name" title="<%= t.getTitle()%>"><%= t.getTitle()%></span>
                            <a href="<%= t.getFileURL()%>" target="_blank" class="btn-download-zip">
                                📥 Download (.zip)
                            </a>
                        </div>
                        <%
                            }
                        } else {
                        %>
                        <p style="font-size: 13px; color: #64748b; margin: 0; text-align: center;">Không tìm thấy tệp tin đi kèm cho đơn hàng này.</p>
                        <% }%>
                    </div>
                </div>

                <a href="${pageContext.request.contextPath}/MainController?action=Shop" class="btn-continue-shop">Continue Shopping</a>
            </div>
        </main>
    
<script src="${pageContext.request.contextPath}/assets/js/lang.js" charset="UTF-8"></script>
</body>
</html>