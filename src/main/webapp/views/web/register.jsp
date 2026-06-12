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
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Đăng ký tài khoản Presenta - bắt đầu hành trình sáng tạo của bạn.">
        <title>Đăng ký - Presenta</title>
        <link href="https://fonts.googleapis.com/css2?family=Pacifico&family=Be+Vietnam+Pro:wght@400;500;700;800&display=swap" rel="stylesheet">
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
                    <p class="brand-tagline">Tham gia cộng đồng sáng tạo và khám phá những khả năng vô hạn</p>
                </div>

                <ul class="brand-features">
                    <li>
                        <div class="feature-icon">
                            <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                        </div>
                        <span>Miễn phí với tài khoản Khách hàng</span>
                    </li>
                    <li>
                        <div class="feature-icon">
                            <svg viewBox="0 0 24 24"><rect x="2" y="3" width="20" height="14" rx="2" ry="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/></svg>
                        </div>
                        <span>Trở thành Nhà thiết kế và bán sản phẩm</span>
                    </li>
                    <li>
                        <div class="feature-icon">
                            <svg viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                        </div>
                        <span>Bảo mật dữ liệu và thanh toán an toàn</span>
                    </li>
                </ul>
            </div>

            <!-- RIGHT Form Panel -->
            <div class="auth-form-panel">
                <div class="auth-card register-card">
                    <div class="card-header">
                        <h1>Tạo tài khoản mới</h1>
                        <p>Bắt đầu hành trình sáng tạo của bạn với Presenta</p>
                    </div>

                    <% if (request.getAttribute("errorMessage") != null) { %>
                    <div class="error-msg">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                        <%= request.getAttribute("errorMessage") %>
                    </div>
                    <% } %>

                    <form action="${pageContext.request.contextPath}/MainController" method="POST" class="auth-form" id="registerForm">
                        <input type="hidden" name="action" value="Register">
                        <input type="hidden" name="roleID" id="roleID" value="2">

                        <!-- Role Tabs -->
                        <div class="role-tabs">
                            <div class="role-tab active" id="tabCustomer" onclick="switchRole('customer')">
                                Khách hàng
                            </div>
                            <div class="role-tab" id="tabDesigner" onclick="switchRole('designer')">
                                Nhà thiết kế
                            </div>
                        </div>

                        <!-- Username -->
                        <div class="form-group">
                            <label for="username">Tên đăng nhập</label>
                            <div class="input-wrapper">
                                <input type="text" class="form-control" id="username" name="username" placeholder="Nhập tên đăng nhập" required>
                                <span class="input-icon">
                                    <svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                                </span>
                            </div>
                        </div>

                        <!-- Email -->
                        <div class="form-group">
                            <label for="email">Email</label>
                            <div class="input-wrapper">
                                <input type="email" class="form-control" id="email" name="email" placeholder="example@email.com" required>
                                <span class="input-icon">
                                    <svg viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
                                </span>
                            </div>
                        </div>

                        <!-- Password -->
                        <div class="form-group">
                            <label for="password">Mật khẩu</label>
                            <div class="input-wrapper">
                                <input type="password" class="form-control" id="password" name="password" placeholder="Tối thiểu 6 ký tự" required oninput="updateStrength(this.value)">
                                <span class="input-icon">
                                    <svg viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                                </span>
                                <button type="button" class="toggle-password" onclick="togglePwd()">
                                    <svg id="eyeIcon" viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                </button>
                            </div>
                            <div class="password-strength" id="passwordStrength">
                                <div class="strength-bar" id="str1"></div>
                                <div class="strength-bar" id="str2"></div>
                                <div class="strength-bar" id="str3"></div>
                                <div class="strength-bar" id="str4"></div>
                            </div>
                        </div>

                        <!-- Designer Fields -->
                        <div id="designerFields" class="designer-fields">
                            <div class="form-group">
                                <label for="phone">Số điện thoại liên hệ</label>
                                <div class="input-wrapper">
                                    <input type="text" class="form-control" id="phone" name="phone" placeholder="0912 345 678">
                                    <span class="input-icon">
                                        <svg viewBox="0 0 24 24"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
                                    </span>
                                </div>
                            </div>
                        </div>

                        <button type="submit" class="btn-auth-submit" id="registerSubmitBtn" style="margin-top: 8px;">
                            Đăng Ký Tài Khoản
                        </button>
                    </form>

                    <div class="auth-footer">
                        <span>Đã có tài khoản?</span>
                        <a href="${pageContext.request.contextPath}/MainController?action=Login" id="goLoginLink">Đăng nhập ngay</a>
                    </div>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/register.js"></script>
        <script>
            function togglePwd() {
                var p = document.getElementById('password');
                var icon = document.getElementById('eyeIcon');
                if (p.type === 'password') {
                    p.type = 'text';
                    icon.innerHTML = '<path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/>';
                } else {
                    p.type = 'password';
                    icon.innerHTML = '<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>';
                }
            }
            function updateStrength(v) {
                var bars = [document.getElementById('str1'), document.getElementById('str2'), document.getElementById('str3'), document.getElementById('str4')];
                for (var i = 0; i < bars.length; i++) { bars[i].className = 'strength-bar'; }
                if (!v) return;
                var s = 0;
                if (v.length >= 6) s++;
                if (v.length >= 10) s++;
                if (/[A-Z]/.test(v) && /[a-z]/.test(v)) s++;
                if (/[0-9]/.test(v) || /[^A-Za-z0-9]/.test(v)) s++;
                var c = ['active-weak', 'active-weak', 'active-medium', 'active-strong'];
                for (var i = 0; i < s; i++) { bars[i].className = 'strength-bar ' + c[Math.min(s - 1, 3)]; }
            }
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/lang.js?v=4.0" charset="UTF-8"></script>
    </body>
</html>