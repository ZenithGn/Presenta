<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác thực OTP - Presenta</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">
</head>
<body>
    <div class="login-container">
        <div class="glass-panel login-card">
            <h2 class="brand-title">Presenta</h2>
            <p class="subtitle">Nhập mã xác thực OTP</p>
            <p style="text-align: center; font-size: 14px; color: #6b7280; margin-bottom: 24px;">Chúng tôi đã gửi mã 6 số đến email của bạn.</p>

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
                <input type="hidden" name="action" value="VerifyOtp">
                
                <!-- Lưu lại email đang verify để gửi kèm -->
                <input type="hidden" name="email" value="<%= request.getAttribute("verifyEmail") != null ? request.getAttribute("verifyEmail") : request.getParameter("email") %>">

                <div class="form-group">
                    <label for="otp">Mã xác thực (6 số)</label>
                    <input type="text" class="form-control" id="otp" name="otp" placeholder="VD: 123456" pattern="[0-9]{6}" title="Vui lòng nhập đúng 6 chữ số" required style="text-align: center; font-size: 24px; letter-spacing: 8px; font-weight: bold;">
                </div>

                <button type="submit" class="btn-primary login-btn-submit">Xác nhận</button>
            </form>
            
            <a href="${pageContext.request.contextPath}/MainController?action=Login" class="btn-outline login-btn-back" style="margin-top: 16px;">Hủy bỏ & Quay lại</a>
        </div>
    </div>
</body>
</html>
