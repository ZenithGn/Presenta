<%-- 
    Document   : register
    Created on : May 26, 2026, 2:39:17 PM
    Author     : lehan
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đăng ký - Presenta</title>
        <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/assets/images/favicon/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-16x16.png">
        <link rel="manifest" href="${pageContext.request.contextPath}/assets/images/favicon/site.webmanifest">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon/favicon.ico">
        
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/register.css">
    </head>
    <body>

        <div class="login-container">
            <div class="glass-panel login-card register-card">
                <h2 class="brand-title">Presenta</h2>
                <p class="subtitle">Bắt đầu hành trình sáng tạo của bạn</p>

                <% if (request.getAttribute("errorMessage") != null) {%>
                <div class="error-msg">
                    <%= request.getAttribute("errorMessage")%>
                </div>
                <% }%>

                <form action="${pageContext.request.contextPath}/MainController" method="POST">
                    <input type="hidden" name="action" value="Register">
                    
                    <input type="hidden" name="roleID" id="roleID" value="2">

                    <div class="role-tabs">
                        <div class="role-tab active" id="tabCustomer" onclick="switchRole('customer')">Khách hàng</div>
                        <div class="role-tab" id="tabDesigner" onclick="switchRole('designer')">Nhà thiết kế</div>
                    </div>

                    <div class="form-group">
                        <label for="username">Tên đăng nhập</label>
                        <input type="text" class="form-control" id="username" name="username" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" class="form-control" id="email" name="email" required>
                    </div>

                    <div class="form-group">
                        <label for="password">Mật khẩu</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>

                    <div id="designerFields" class="designer-fields">
                        <div class="form-group">
                            <label for="phone">Số điện thoại liên hệ</label>
                            <input type="text" class="form-control" id="phone" name="phone">
                        </div>                    
                    </div>

                    <button type="submit" class="btn-primary login-btn-submit" style="margin-top: 24px;">Đăng Ký Tài Khoản</button>
                </form>

                <div class="register-prompt">
                    <span>Đã có tài khoản?</span> 
                    <a href="${pageContext.request.contextPath}/MainController?action=Login" class="link-register">Đăng nhập ngay</a>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/register.js"></script>
    </body>
</html>