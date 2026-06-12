<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Quên mật khẩu - Khôi phục mật khẩu tài khoản Presenta.">
    <title>Quên mật khẩu - Presenta</title>
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
                <h2 class="brand-name">Presenta</h2>
                <p class="brand-tagline">Đừng lo, chúng tôi sẽ giúp bạn lấy lại quyền truy cập</p>
            </div>

            <ul class="brand-features">
                <li>
                    <div class="feature-icon">
                        <svg viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                    </div>
                    <span>Bảo mật tài khoản nhiều lớp</span>
                </li>
                <li>
                    <div class="feature-icon">
                        <svg viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
                    </div>
                    <span>Xác thực qua email an toàn</span>
                </li>
                <li>
                    <div class="feature-icon">
                        <svg viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                    </div>
                    <span>Đặt lại mật khẩu nhanh chóng</span>
                </li>
            </ul>
        </div>

        <!-- RIGHT Form Panel -->
        <div class="auth-form-panel">
            <div class="auth-card">
                <div class="card-header">
                    <h1>Quên mật khẩu?</h1>
                    <p>Nhập email đã đăng ký để nhận mã xác thực OTP</p>
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
                <% } %>

                <form action="${pageContext.request.contextPath}/MainController" method="POST" class="auth-form" id="forgotPasswordForm">
                    <input type="hidden" name="action" value="ForgotPassword">

                    <div class="form-group">
                        <label for="email">Email đã đăng ký</label>
                        <div class="input-wrapper">
                            <input type="email" class="form-control" id="email" name="email" placeholder="example@email.com" required>
                            <span class="input-icon">
                                <svg viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
                            </span>
                        </div>
                    </div>

                    <button type="submit" class="btn-auth-submit" id="forgotSubmitBtn">
                        Gửi mã xác thực
                    </button>
                </form>

                <div class="auth-divider">hoặc</div>

                <a href="${pageContext.request.contextPath}/MainController?action=Login" class="btn-back-home" id="backLoginBtn">
                    <svg viewBox="0 0 24 24"><path d="M19 12H5"/><polyline points="12 19 5 12 12 5"/></svg>
                    Quay lại Đăng nhập
                </a>
            </div>
        </div>
    </div>

<script src="${pageContext.request.contextPath}/assets/js/lang.js?v=4.0" charset="UTF-8"></script>
</body>
</html>
