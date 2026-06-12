<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Đặt lại mật khẩu - Presenta">
    <title>Đặt lại mật khẩu - Presenta</title>
    <link href="https://fonts.googleapis.com/css2?family=Pacifico&family=Be+Vietnam+Pro:wght@400;500;700;800&display=swap" rel="stylesheet">
    <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/assets/images/favicon/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-16x16.png">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon/favicon.ico">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">
</head>
<body>

    <div class="auth-wrapper">
        <!-- LEFT Brand Panel -->
        <div class="auth-brand-panel">
            <div class="floating-shapes">
                <div class="shape"></div>
                <div class="shape"></div>
                <div class="shape"></div>
            </div>

            <div class="brand-logo-area">
                <h2 class="brand-name" style="font-family: 'Pacifico', cursive;">Presenta</h2>
                <p class="brand-tagline">Tạo mật khẩu mới để bảo vệ tài khoản của bạn</p>
            </div>

            <ul class="brand-features">
                <li>
                    <div class="feature-icon">
                        <svg viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                    </div>
                    <span>Sử dụng mật khẩu mạnh, an toàn</span>
                </li>
                <li>
                    <div class="feature-icon">
                        <svg viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                    </div>
                    <span>Kết hợp chữ hoa, thường, số</span>
                </li>
                <li>
                    <div class="feature-icon">
                        <svg viewBox="0 0 24 24"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                    </div>
                    <span>Tối thiểu 6 ký tự trở lên</span>
                </li>
            </ul>
        </div>

        <!-- RIGHT Form Panel -->
        <div class="auth-form-panel">
            <div class="auth-card">
                <div class="card-header">
                    <h1>Đặt lại mật khẩu</h1>
                    <p>Tạo mật khẩu mới cho tài khoản Presenta của bạn</p>
                </div>

                <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="error-msg">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                    <%= request.getAttribute("errorMessage") %>
                </div>
                <% } %>

                <% if (request.getAttribute("successMessage") != null) { %>
                <div style="background: rgba(34, 197, 94, 0.15); border: 1px solid rgba(34, 197, 94, 0.3); color: #4ade80; padding: 12px 16px; border-radius: 10px; margin-bottom: 24px; text-align: center; font-weight: 600; font-size: 14px; display: flex; align-items: center; justify-content: center; gap: 8px;">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                    <%= request.getAttribute("successMessage") %>
                </div>
                <a href="${pageContext.request.contextPath}/MainController?action=Login" class="btn-auth-submit" style="text-align: center; text-decoration: none; display: block;">
                    Đến trang Đăng nhập
                </a>
                <% } else { %>
                <form action="${pageContext.request.contextPath}/MainController" method="POST" class="auth-form" id="resetPasswordForm">
                    <input type="hidden" name="action" value="ResetPassword">
                    <input type="hidden" name="email" value="<%= request.getAttribute("resetEmail") != null ? request.getAttribute("resetEmail") : request.getParameter("email") %>">

                    <div class="form-group">
                        <label for="newPassword">Mật khẩu mới</label>
                        <div class="input-wrapper">
                            <input type="password" class="form-control" id="newPassword" name="newPassword" placeholder="Nhập mật khẩu mới" required>
                            <span class="input-icon">
                                <svg viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                            </span>
                            <button type="button" class="toggle-password" onclick="togglePwd('newPassword', 'eyeNew')">
                                <svg id="eyeNew" viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                            </button>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Nhập lại mật khẩu mới</label>
                        <div class="input-wrapper">
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Xác nhận mật khẩu" required>
                            <span class="input-icon">
                                <svg viewBox="0 0 24 24"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                            </span>
                            <button type="button" class="toggle-password" onclick="togglePwd('confirmPassword', 'eyeConfirm')">
                                <svg id="eyeConfirm" viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                            </button>
                        </div>
                    </div>

                    <button type="submit" class="btn-auth-submit" id="resetSubmitBtn">
                        Lưu mật khẩu mới
                    </button>
                </form>
                <% } %>
            </div>
        </div>
    </div>

    <script>
        function togglePwd(inputId, iconId) {
            var p = document.getElementById(inputId);
            var icon = document.getElementById(iconId);
            if (p.type === 'password') {
                p.type = 'text';
                icon.innerHTML = '<path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/>';
            } else {
                p.type = 'password';
                icon.innerHTML = '<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>';
            }
        }
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/lang.js?v=4.0" charset="UTF-8"></script>
</body>
</html>
