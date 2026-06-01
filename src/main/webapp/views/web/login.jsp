<%-- 
    Document   : login
    Created on : May 24, 2026, 4:13:32 PM
    Author     : lehan
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đăng nhập - Presenta</title>
        <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/assets/images/favicon/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-16x16.png">
        <link rel="manifest" href="${pageContext.request.contextPath}/assets/images/favicon/site.webmanifest">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon/favicon.ico">
        
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">
    </head>
    <body>

        <div class="login-container">
            <div class="glass-panel login-card">
                <h2 class="brand-title">Presenta</h2>

                <p class="subtitle">Truy cập hệ thống quản trị & thiết kế</p>

                <% if (request.getAttribute("errorMessage") != null) {%>
                <div class="error-msg">
                    <%= request.getAttribute("errorMessage")%>
                </div>
                <% }%>

                <form action="${pageContext.request.contextPath}/MainController" method="POST">
                    <input type="hidden" name="action" value="Login">

                    <div class="form-group">
                        <label for="username">Tên đăng nhập</label>
                        <input type="text" class="form-control" id="username" name="username" required>
                    </div>

                    <div class="form-group">
                        <div class="password-header">
                            <label for="password">Mật khẩu</label>
                        </div>
                        <input type="password" class="form-control" id="password" name="password" required>
                        <a href="${pageContext.request.contextPath}/MainController?action=ForgotPassword" class="link-forgot">Quên mật khẩu?</a>
                    </div>

                    <button type="submit" class="btn-primary login-btn-submit">Đăng Nhập</button>
                </form>
                <a href="${pageContext.request.contextPath}/MainController" class="btn-outline login-btn-back">Quay lại Trang chủ</a>
                <div class="register-prompt">
                    <span>Chưa có tài khoản?</span> 
                    <a href="${pageContext.request.contextPath}/MainController?action=Register" class="link-register">Đăng ký ngay</a>
                </div>
            </div>
        </div>

    </body>
</html>