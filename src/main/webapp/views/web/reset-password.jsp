<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt lại mật khẩu - Presenta</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">
</head>
<body>
    <div class="login-container">
        <div class="glass-panel login-card">
            <h2 class="brand-title">Presenta</h2>
            <p class="subtitle">Tạo mật khẩu mới</p>

            <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="error-msg">
                <%= request.getAttribute("errorMessage") %>
            </div>
            <% } %>
            
            <% if (request.getAttribute("successMessage") != null) { %>
            <div style="background: rgba(34, 197, 94, 0.2); border: 1px solid #22c55e; color: #4ade80; padding: 12px 20px; border-radius: 8px; margin-bottom: 24px; text-align: center; font-weight: 600; font-size: 14px;">
                <%= request.getAttribute("successMessage") %>
            </div>
            <a href="${pageContext.request.contextPath}/MainController?action=Login" class="btn-primary login-btn-submit" style="text-align: center; text-decoration: none;">Đến trang Đăng nhập</a>
            <% } else { %>
            <form action="${pageContext.request.contextPath}/MainController" method="POST">
                <input type="hidden" name="action" value="ResetPassword">
                <input type="hidden" name="token" value="<%= request.getParameter("token") != null ? request.getParameter("token") : "" %>">

                <div class="form-group">
                    <label for="newPassword">Mật khẩu mới</label>
                    <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">Nhập lại mật khẩu mới</label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                </div>

                <button type="submit" class="btn-primary login-btn-submit">Lưu mật khẩu mới</button>
            </form>
            <% } %>
        </div>
    </div>
</body>
</html>
