<%-- 
    Document   : designer-hub
    Created on : May 27, 2026, 9:51:09 PM
    Author     : lehan
--%>
<%@page import="com.model.Designer"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.model.User" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Designer Hub - Presenta</title>
        <link href="https://fonts.googleapis.com/css2?family=Pacifico&family=Be+Vietnam+Pro:wght@400;500;700;800&display=swap" rel="stylesheet">
        <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/assets/images/favicon/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-16x16.png">
        <link rel="manifest" href="${pageContext.request.contextPath}/assets/images/favicon/site.webmanifest">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon/favicon.ico">
        
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer-hub.css">
    </head>

    <%
        User loginUser = (User) session.getAttribute("LOGIN_USER");
        int roleId = (loginUser != null) ? loginUser.getRoleId() : 0;
    %>

    <body class="landing-body">

        <%-- ======================================================= --%>
        <%-- NAVBAR (Giữ nguyên gốc từ home.jsp)                     --%>
        <%-- ======================================================= --%>
        <% if (roleId == 0 || roleId == 2) { %>
        <nav class="navbar" style="border-bottom: none; background: transparent;">
            <a href="${pageContext.request.contextPath}/MainController" class="nav-brand" style="font-family: 'Pacifico', cursive; font-size: 28px;">Presenta</a>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/MainController">HOME</a>
                <a href="${pageContext.request.contextPath}/MainController?action=Shop">SHOP</a>
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerHub" style="border-bottom: 2px solid white; font-weight: 700;">DESIGNER HUB</a>
                <% if (roleId == 2) { %>
                <a href="${pageContext.request.contextPath}/MainController?action=ViewCart">CART</a>
                <a href="${pageContext.request.contextPath}/MainController?action=Profile">PROFILE</a>
                <% } %>
            </div>
            <div class="nav-actions">
                <% if (roleId == 2) {%>
                <span style="color: #dae2fd; font-size: 14px; margin-right: 10px;">Welcome, <b><%= loginUser.getUsername()%></b></span>
                <form action="${pageContext.request.contextPath}/MainController" method="POST" style="margin:0; display: inline-block;">
                    <input type="hidden" name="action" value="Logout">
                    <button type="submit" class="btn-outline" style="padding: 6px 16px; font-size: 12px; border-radius: 999px;">Logout</button>
                </form>
                <% } else { %>
                <a href="${pageContext.request.contextPath}/MainController?action=Login" class="btn-outline" style="border-radius: 999px;">Login</a>
                <a href="${pageContext.request.contextPath}/MainController?action=Register" class="btn-primary" style="border-radius: 999px; background: white; color: black;">Sign Up</a>
                <% } %>
            </div>
        </nav>
        <% }%>


        <%-- ======================================================= --%>
        <%-- NỘI DUNG CHÍNH DESIGNER HUB                             --%>
        <%-- ======================================================= --%>
        <div class="hub-body-wrapper">

            <section class="hub-hero hub-container">
                <h1 class="hub-title-script" style="margin-bottom: 40px;">Designer Hub</h1>
            </section>

            <section class="hub-container">
                <h2 class="hub-section-title">Design Categories</h2>
                <p class="hub-section-subtitle">Find Your Niche, Build Your Reputation.</p>

                <div class="category-list">
                    <div class="category-item">
                        <h3>Branding Design</h3>
                        <p>Logo Systems, Brand Guideline Templates, Identity Packs.</p>
                    </div>
                    <div class="category-item">
                        <h3>Presentation Design</h3>
                        <p>Academic Slides, Pitch Decks, Structured Course Templates.</p>
                    </div>
                    <div class="category-item">
                        <h3>Marketing Assets</h3>
                        <p>Social Posts, Proposal Decks, Campaign Visuals.</p>
                    </div>
                    <div class="category-item">
                        <h3>Motion & Interactive</h3>
                        <p>Animated Slides, Dynamic Transitions, Micro-interactions.</p>
                    </div>
                    <div class="category-item">
                        <h3>CV & Portfolio Design</h3>
                        <p>Personal Branding Kits, Resumes, Portfolios.</p>
                    </div>
                </div>
            </section>

            <section class="hub-container">
                <h2 class="hub-title-script" style="font-size: 48px; text-align: center; margin-bottom: 40px;">Why Join Presenta</h2>
                <div class="why-join-grid">
                    <div class="why-card">
                        <h3>Access To Targeted Clients</h3>
                        <p>High-Intent Students And Young Professionals Looking For Academic-Grade Designs.</p>
                    </div>
                    <div class="why-card">
                        <h3>Monetize Your Templates</h3>
                        <p>Earn Passive Income From Every Template Sold.</p>
                    </div>
                    <div class="why-card">
                        <h3>Secure Payment System</h3>
                        <p>Transparent Transactions, Fast Payouts.</p>
                    </div>
                    <div class="why-card">
                        <h3>Build Your Personal Brand</h3>
                        <p>Get Recognized For Your Expertise In The Presenta Network.</p>
                    </div>
                </div>
            </section>

            <section class="hub-container">
                <h2 class="hub-section-title">How It Works</h2>
                <p class="hub-section-subtitle">Simple. Structured. Professional.</p>

                <div class="how-it-works-list">
                    <div class="step-item">
                        <span class="step-number">1</span>
                        <span class="step-text">Create Your Designer Profile</span>
                    </div>
                    <div class="step-item" style="justify-content: flex-end; border-left: none; border-right: 4px solid #7C3AED; background: linear-gradient(-90deg, #1D153B 0%, transparent 100%);">
                        <span class="step-text">Upload Templates to Our Custom System</span>
                        <span class="step-number" style="margin-left: 24px; margin-right: 0;">2</span>
                    </div>
                    <div class="step-item">
                        <span class="step-number">3</span>
                        <span class="step-text">Receive Hires & Reviews</span>
                    </div>
                    <div class="step-item" style="justify-content: flex-end; border-left: none; border-right: 4px solid #7C3AED; background: linear-gradient(-90deg, #1D153B 0%, transparent 100%);">
                        <span class="step-text">Cash Out Your Earnings</span>
                        <span class="step-number" style="margin-left: 24px; margin-right: 0;">4</span>
                    </div>
                </div>
            </section>

            <section class="hub-container" style="text-align: center;">
                <h2 class="hub-section-title">Featured Designer</h2>
                <p class="hub-section-subtitle">Meet Top-Rated Creators Building High-Quality Templates.</p>

                <div class="designer-grid">
                    <%
                        // 1. Lấy danh sách 3 Designer từ Controller truyền sang
                        List<Designer> topDesigners = (List<Designer>) request.getAttribute("topDesigners");

                        // 2. Kiểm tra danh sách có dữ liệu không
                        if (topDesigners != null && !topDesigners.isEmpty()) {

                            // 3. Vòng lặp for thay thế cho <c:forEach>
                            for (Designer d : topDesigners) {

                                // Xử lý ảnh Avatar: Nếu trong DB null thì lấy ảnh avatar theo tên
                                String avatar = (d.getAvatarURL() != null && !d.getAvatarURL().trim().isEmpty())
                                        ? d.getAvatarURL()
                                        : "https://ui-avatars.com/api/?name=" + d.getUserName() + "&background=7C3AED&color=fff";
                    %>

                    <div class="scalloped-designer-card">
                        <div class="scalloped-avatar-wrap">
                            <img src="<%= avatar%>" alt="<%= d.getUserName()%>">
                        </div>
                        <div class="scalloped-info">
                            <span class="scalloped-name"><%= d.getUserName()%></span>
                            <span class="scalloped-spec"><%= d.getSpecialty()%></span>
                        </div>
                        <div class="scalloped-actions">
                            <a href="MainController?action=DesignerDetail&id=<%= d.getUserID()%>" class="btn-grid-book">View Designer</a>
                        </div>
                    </div>
                    <%
                        } // Kết thúc vòng lặp
                    } else {
                    %>
                    <p style="grid-column: span 3; text-align: center; color: #ccc;">Chưa có Designer nổi bật nào để hiển thị.</p>
                    <%
                        }
                    %>
                </div>

                <div style="margin-bottom: 80px; margin-top: 40px;">
                    <a href="MainController?action=DesignerList" class="btn-primary" style="padding: 16px 40px; border-radius: 999px; font-size: 16px;">
                        View All Designers &rarr;
                    </a>
                </div>
            </section>

            <section class="cta-bottom">
                <div class="cta-card">
                    <h2>Ready To Turn Your Design Skills<br>Into Recurring Income?</h2>
                    <p>Join Presenta Designer Hub Today And Grow<br>With A Focused, Academic-First Marketplace.</p>

                    <a href="MainController?action=Register" class="btn-cta-highlight">Join Now</a>
                </div>
            </section>

        </div>

        <%-- ======================================================= --%>
        <%-- FOOTER (Giữ nguyên gốc từ home.jsp)                     --%>
        <%-- ======================================================= --%>
        <footer class="main-footer">
            <div class="footer-container">
                <div class="footer-col brand-col">
                    <div class="brand-logo-desc-wrapper">
                        <img src="${pageContext.request.contextPath}/assets/images/logo.jpg" alt="Presenta Logo" class="footer-image-logo">
                        <div class="brand-text-content">
                            <a href="#" class="footer-logo" style="margin-bottom: 4px;">Presenta</a>
                            <p class="footer-desc" style="margin-bottom: 0;">The next generation template marketplace for academic visionaries and creative professionals. Empowering students and designers worldwide.</p>
                        </div>
                    </div>
                    <div class="footer-socials">
                        <a href="https://www.facebook.com/profile.php?id=61590550761077" target="_blank" class="social-icon">🌐</a>
                        <a href="#" class="social-icon">💬</a>
                        <a href="mailto:presentaproject05@gmail.com" target="_blank" class="social-icon">📧</a>
                    </div>
                </div>

                <div class="footer-col contact-col">
                    <h4>GET IN TOUCH</h4>
                    <ul class="contact-info-list">
                        <li><span class="contact-icon">📍</span><span>FPT University, District 9, Ho Chi Minh City</span></li>
                        <li><span class="contact-icon">📧</span><span>presentaproject05@gmail.com</span></li>
                        <li><span class="contact-icon">📞</span><span>+84 (28) 7300 5588</span></li>
                        <li><span class="contact-icon">⏱</span><span>Mon - Fri: 8:00 AM - 5:00 PM</span></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <div class="footer-bottom-container">
                    <p>&copy; 2026 Presenta. All rights reserved.</p>
                </div>
            </div>
        </footer>
    </body>
</html>