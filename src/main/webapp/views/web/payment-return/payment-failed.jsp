<%-- 
    Document   : payment_failed
    Created on : May 28, 2026, 8:47:50 PM
    Author     : lehan
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.model.User" %>

<%
    // BẢO MẬT & PHÂN QUYỀN: Kiểm tra đăng nhập
    User loginUser = (User) session.getAttribute("LOGIN_USER");
    if (loginUser == null || loginUser.getRoleId() != 2) {
        response.sendRedirect(request.getContextPath() + "/MainController");
        return;
    }
    int roleId = loginUser.getRoleId();
    String message = (String) request.getAttribute("message");
    if (message == null)
        message = "Đã xảy ra lỗi trong quá trình thanh toán.";
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Payment Failed - Presenta</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&family=Pacifico&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
        <style>
            .result-container {
                min-height: 70vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }
            .result-card {
                background: #ffffff;
                border-radius: 20px;
                padding: 50px 40px;
                text-align: center;
                max-width: 500px;
                width: 100%;
                box-shadow: 0 10px 30px rgba(0,0,0,0.2);
                border-top: 6px solid #dc3545;
            }
            .icon-circle.failed {
                width: 80px;
                height: 80px;
                background: rgba(220, 53, 69, 0.1);
                color: #dc3545;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 40px;
                margin: 0 auto 20px;
            }
            .result-title {
                color: #0b1c4a;
                font-size: 28px;
                font-weight: 800;
                margin-bottom: 15px;
            }
            .result-desc {
                color: #64748b;
                font-size: 16px;
                margin-bottom: 30px;
                line-height: 1.5;
            }
            .btn-action {
                display: inline-block;
                background: #dc3545;
                color: #fff;
                padding: 12px 30px;
                border-radius: 999px;
                text-decoration: none;
                font-weight: 700;
                transition: background 0.3s;
            }
            .btn-action:hover {
                background: #c82333;
            }
            .btn-secondary {
                display: inline-block;
                color: #4a8ee6;
                margin-top: 15px;
                text-decoration: none;
                font-weight: 600;
            }
            .btn-secondary:hover {
                text-decoration: underline;
            }
        </style>
    </head>

    <body class="landing-body">
        <%-- NAVBAR ĐÃ PHÂN QUYỀN --%>
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
                <% if (loginUser.getRoleId() == 2) {%>
                <span style="color: #dae2fd; font-size: 14px; margin-right: 10px;">Welcome, <b><%= loginUser.getUsername()%></b></span>
                <form action="${pageContext.request.contextPath}/MainController" method="POST" style="margin:0; display: inline-block;">
                    <input type="hidden" name="action" value="Logout">
                    <button type="submit" class="btn-outline" style="padding: 6px 16px; font-size: 12px; border-radius: 999px;">Logout</button>
                </form>
                <% } else { %>
                <a href="${pageContext.request.contextPath}/MainController?action=Login" class="btn-outline" style="border-radius: 999px;">Login</a>
                <a href="${pageContext.request.contextPath}/MainController?action=Register" class="btn-primary" style="border-radius: 999px; background: white; color: black;">Sign Up</a>
                <% }%>
            
<button onclick="toggleLanguage()" class="lang-toggle-btn no-translate" style="background: transparent; border: 1px solid currentColor; color: inherit; padding: 4px 10px; border-radius: 20px; cursor: pointer; margin-left: 15px; font-weight: bold; white-space: nowrap;">EN/VI</button>
</div>
        
</nav>
        <% }%>
        <main class="result-container">
            <div class="result-card">
                <div class="icon-circle failed">✕</div>
                <h1 class="result-title">Payment Failed!</h1>
                <p class="result-desc"><%= message%><br>Vui lòng kiểm tra lại phương thức thanh toán.</p>
                <a href="${pageContext.request.contextPath}/MainController?action=ViewCart" class="btn-action">Back to Cart</a><br>
                <a href="${pageContext.request.contextPath}/MainController" class="btn-secondary">Return to Homepage</a>
            </div>
        </main>
    
<script src="${pageContext.request.contextPath}/assets/js/lang.js" charset="UTF-8"></script>
</body>
</html>