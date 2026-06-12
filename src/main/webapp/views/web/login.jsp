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
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Đăng nhập vào Presenta — nền tảng thiết kế sáng tạo hàng đầu.">
        <title>Đăng nhập - Presenta</title>
        <link href="https://fonts.googleapis.com/css2?family=Pacifico&family=Be+Vietnam+Pro:wght@400;500;700;800&display=swap" rel="stylesheet">
        <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/assets/images/favicon/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-16x16.png">
        <link rel="manifest" href="${pageContext.request.contextPath}/assets/images/favicon/site.webmanifest">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon/favicon.ico">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css?v=1.2">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css?v=1.2">
        <!-- Google Identity Services -->
        <script src="https://accounts.google.com/gsi/client" async defer></script>
    </head>
    <body>

        <div class="auth-wrapper">
            <!-- ===== LEFT — Brand Panel ===== -->
            <div class="auth-brand-panel">
                <div class="floating-shapes">
                    <div class="shape"></div>
                    <div class="shape"></div>
                    <div class="shape"></div>
                </div>

                <div class="brand-logo-area">
                    <h2 class="brand-name" style="font-family: 'Pacifico', cursive;">Presenta</h2>
                    <p class="brand-tagline">Nền tảng thiết kế sáng tạo giúp bạn biến ý tưởng thành hiện thực</p>
                </div>

                <ul class="brand-features">
                    <li>
                        <div class="feature-icon">
                            <svg viewBox="0 0 24 24"><path d="M12 2L2 7l10 5 10-5-10-5z"/><path d="M2 17l10 5 10-5"/><path d="M2 12l10 5 10-5"/></svg>
                        </div>
                        <span>Hàng ngàn mẫu thiết kế chuyên nghiệp</span>
                    </li>
                    <li>
                        <div class="feature-icon">
                            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>
                        </div>
                        <span>Công cụ tùy biến mạnh mẽ & linh hoạt</span>
                    </li>
                    <li>
                        <div class="feature-icon">
                            <svg viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                        </div>
                        <span>Cộng đồng nhà thiết kế tài năng</span>
                    </li>
                </ul>
            </div>

            <!-- ===== RIGHT — Form Panel ===== -->
            <div class="auth-form-panel">
                <div class="auth-card">
                    <div class="card-header">
                        <h1>Chào mừng trở lại</h1>
                        <p>Đăng nhập để tiếp tục sáng tạo với Presenta</p>
                    </div>

                    <% if (request.getAttribute("errorMessage") != null) {%>
                    <div class="error-msg">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                        <%= request.getAttribute("errorMessage")%>
                    </div>
                    <% }%>

                    <form action="${pageContext.request.contextPath}/MainController" method="POST" class="auth-form" id="loginForm">
                        <input type="hidden" name="action" value="Login">

                        <div class="form-group">
                            <label for="email">Email</label>
                            <div class="input-wrapper">
                                <input type="email" class="form-control" id="email" name="email" placeholder="example@email.com" required>
                                <span class="input-icon">
                                    <svg viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
                                </span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="password">Mật khẩu</label>
                            <div class="input-wrapper">
                                <input type="password" class="form-control" id="password" name="password" placeholder="Nhập mật khẩu" required>
                                <span class="input-icon">
                                    <svg viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                                </span>
                                <button type="button" class="toggle-password" id="togglePassword" onclick="togglePasswordVisibility()">
                                    <svg id="eyeIcon" viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                </button>
                            </div>
                        </div>

                        <div class="form-extras">
                            <label class="remember-me">
                                <input type="checkbox" id="rememberMe" name="rememberMe">
                                <span>Ghi nhớ đăng nhập</span>
                            </label>
                            <a href="${pageContext.request.contextPath}/MainController?action=ForgotPassword" class="link-forgot">Quên mật khẩu?</a>
                        </div>

                        <button type="submit" class="btn-auth-submit" id="loginSubmitBtn">
                            Đăng Nhập
                        </button>

                        <!-- Google Sign-In Button -->
                        <div id="g-login-btn-container" style="width: 92%; margin: 12px auto 0 auto; min-height: 40px; display: flex; justify-content: center;"></div>
                    </form>

                    <div class="auth-divider">hoặc</div>

                    <a href="${pageContext.request.contextPath}/MainController" class="btn-back-home" id="backHomeBtn" style="margin-top: 20px;">
                        <svg viewBox="0 0 24 24"><path d="M19 12H5"/><polyline points="12 19 5 12 12 5"/></svg>
                        Quay lại Trang chủ
                    </a>

                    <div class="auth-footer" style="margin-top: 24px;">
                        <span>Bạn chưa có tài khoản?</span>
                        <a href="${pageContext.request.contextPath}/MainController?action=Register" id="goRegisterLink">Đăng ký ngay</a>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function togglePasswordVisibility() {
                const passwordInput = document.getElementById('password');
                const eyeIcon = document.getElementById('eyeIcon');
                if (passwordInput.type === 'password') {
                    passwordInput.type = 'text';
                    eyeIcon.innerHTML = '<path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/>';
                } else {
                    passwordInput.type = 'password';
                    eyeIcon.innerHTML = '<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>';
                }
            }
        </script>
        <script>
            function handleCredentialResponse(response) {
                // Send ID Token from Google to backend Servlet
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/GoogleLoginController';
                
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'credential';
                input.value = response.credential;
                
                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            }

            function renderGoogleButton() {
                const container = document.getElementById("g-login-btn-container");
                if (!container) return;
                
                container.innerHTML = "";
                const parentWidth = container.offsetWidth || 360;
                
                google.accounts.id.renderButton(
                    container,
                    { 
                        theme: "filled_blue", 
                        size: "large", 
                        width: parentWidth, 
                        shape: "rectangular",
                        text: "signin_with",
                        logo_alignment: "left"
                    }
                );
            }

            window.addEventListener('load', function() {
                google.accounts.id.initialize({
                    client_id: "${googleClientId}",
                    callback: handleCredentialResponse
                });
                
                renderGoogleButton();
                
                let resizeTimeout;
                window.addEventListener('resize', function() {
                    clearTimeout(resizeTimeout);
                    resizeTimeout = setTimeout(renderGoogleButton, 100);
                });
            });
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/lang.js?v=4.0" charset="UTF-8"></script>
    </body>
</html>