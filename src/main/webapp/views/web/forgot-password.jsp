<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quên mật khẩu - Presenta</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">
</head>
<body>
    <div class="login-container">
        <div class="glass-panel login-card">
            <h2 class="brand-title">Presenta</h2>
            <p class="subtitle">Khôi phục mật khẩu của bạn</p>

            <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="error-msg">
                <%= request.getAttribute("errorMessage") %>
            </div>
            <% } %>

            <% if (request.getAttribute("successMessage") != null) { %>
            <div style="background: rgba(34, 197, 94, 0.2); border: 1px solid #22c55e; color: #4ade80; padding: 12px 20px; border-radius: 8px; margin-bottom: 24px; text-align: center; font-weight: 600; font-size: 14px;">
                <%= request.getAttribute("successMessage") %>
            </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/MainController" method="POST">
                <input type="hidden" name="action" value="ForgotPassword">

                <div class="form-group">
                    <label for="email">Email đã đăng ký</label>
                    <input type="email" class="form-control" id="email" name="email" placeholder="example@email.com" required>
                </div>

                <button type="submit" class="btn-primary login-btn-submit">Gửi link khôi phục</button>
            </form>
            
            <a href="${pageContext.request.contextPath}/MainController?action=Login" class="btn-outline login-btn-back" style="margin-top: 16px;">Quay lại Đăng nhập</a>
        </div>
    </div>
</body>
</html>
