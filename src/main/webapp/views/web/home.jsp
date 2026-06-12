<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.model.Template" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Presenta - Home</title>
        <link href="https://fonts.googleapis.com/css2?family=Pacifico&family=Be+Vietnam+Pro:wght@400;500;700;800&display=swap" rel="stylesheet">
        <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/assets/images/favicon/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-16x16.png">
        <link rel="manifest" href="${pageContext.request.contextPath}/assets/images/favicon/site.webmanifest">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon/favicon.ico">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    </head>

    <%
        User loginUser = (User) session.getAttribute("LOGIN_USER");
        // Define role variables for cleaner code: 0 = Guest, 1 = Admin, 2 = Customer, 3 = Designer
        int roleId = (loginUser != null) ? loginUser.getRoleId() : 0;
    %>

    <body class="<%= (roleId == 0 || roleId == 2) ? "landing-body" : ""%>">

        <%-- ======================================================= --%>
        <%-- NAVIGATION BARS (DYNAMIC BASED ON ROLE)                 --%>
        <%-- ======================================================= --%>

        <% if (roleId == 0 || roleId == 2) { %>
        <nav class="navbar" style="border-bottom: none; background: transparent;">
            <a href="${pageContext.request.contextPath}/MainController" class="nav-brand" style="font-family: 'Pacifico', cursive; font-size: 28px;">Presenta</a>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/MainController" class="active">HOME</a>
                <a href="${pageContext.request.contextPath}/MainController?action=Shop">SHOP</a>
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerHub">DESIGNER HUB</a>
                <% if (roleId == 2) { %>
                <a href="${pageContext.request.contextPath}/MainController?action=ViewCart">CART</a>
                <a href="${pageContext.request.contextPath}/MainController?action=Profile">PROFILE</a>
                <% } %>
            </div>
            <div class="nav-actions">
<div onclick="toggleLanguage()" class="lang-toggle-switch no-translate" style="position: relative; display: flex; align-items: center; width: 64px; height: 28px; border: 1px solid currentColor; border-radius: 20px; cursor: pointer; margin-right: 15px; color: inherit;">
    <div class="lang-slider" style="position: absolute; top: 2px; left: 2px; width: 28px; height: 22px; background: currentColor; opacity: 0.2; border-radius: 14px; transition: transform 0.3s cubic-bezier(0.4, 0.0, 0.2, 1); z-index: 1;"></div>
    <span style="flex: 1; text-align: center; font-size: 11px; font-weight: bold; z-index: 2; pointer-events: none;">EN</span>
    <span style="flex: 1; text-align: center; font-size: 11px; font-weight: bold; z-index: 2; pointer-events: none;">VI</span>
</div>

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

        <% } else if (roleId == 3) {%>
        <nav class="navbar" style="background: var(--surface); border-bottom: 1px solid var(--border-glass);">
            <a href="${pageContext.request.contextPath}/MainController" class="nav-brand" style="font-family: 'Pacifico', cursive; font-size: 28px;">Presenta</a>
            <div class="nav-links">
                <a href="#" style="color: white; border-bottom: 2px solid var(--primary);">Manage Templates</a>
                <a href="#">Statistics</a>
                <a href="#">Orders</a>
            </div>
            <div class="nav-actions">
<div onclick="toggleLanguage()" class="lang-toggle-switch no-translate" style="position: relative; display: flex; align-items: center; width: 64px; height: 28px; border: 1px solid currentColor; border-radius: 20px; cursor: pointer; margin-right: 15px; color: inherit;">
    <div class="lang-slider" style="position: absolute; top: 2px; left: 2px; width: 28px; height: 22px; background: currentColor; opacity: 0.2; border-radius: 14px; transition: transform 0.3s cubic-bezier(0.4, 0.0, 0.2, 1); z-index: 1;"></div>
    <span style="flex: 1; text-align: center; font-size: 11px; font-weight: bold; z-index: 2; pointer-events: none;">EN</span>
    <span style="flex: 1; text-align: center; font-size: 11px; font-weight: bold; z-index: 2; pointer-events: none;">VI</span>
</div>

                <span style="font-size: 14px; margin-right: 10px;">Designer: <b><%= loginUser.getUsername()%></b></span>
                <form action="${pageContext.request.contextPath}/MainController" method="POST" style="margin:0; display: inline-block;">
                    <input type="hidden" name="action" value="Logout">
                    <button type="submit" class="btn-outline" style="padding: 6px 16px; font-size: 12px; border-radius: 999px;">Logout</button>
                </form>
            
</div>
        </nav>

        <%  } %>

        <%-- ======================================================= --%>
        <%-- MAIN CONTENT AREAS                                      --%>
        <%-- ======================================================= --%>

        <%-- SECTION A: GUEST & CUSTOMER LANDING PAGE --%>
        <% if (roleId == 0 || roleId == 2) { %>

        <section class="hero-section-full" style="width: 100%; margin-bottom: 80px;">
            <img src="${pageContext.request.contextPath}/assets/images/presenta_banner.png" 
                 alt="Presenta Banner" 
                 style="width: 100%; height: auto; display: block; object-fit: cover;">
        </section>

        <div class="landing-container">

            <section class="landing-section text-center">
                <h3 class="section-title-large" style="text-align: center">Academic Slides<br>Made Easy.</h3>
                <p class="hero-desc" style="text-align: center" >Structured Templates And Designer-Backed Customization For Students And Young Professionals.</p>
                <div class="bento-grid text-left">
                    <div class="bento-card large">
                        <h3 style="text-align: right;">Structured</h3>
                    </div>
                    <div class="bento-card">
                        <h3>Customizable</h3>
                        <p style="color: #E2D7FF; font-size: 14px;">Edit Yourself Or Add Sweet (Full Customize).</p>
                    </div>
                    <div class="bento-card">
                        <h3>Designer Support</h3>
                        <p style="color: #E2D7FF; font-size: 14px;">Hire The Designer Directly For Adjustments.</p>
                    </div>
                </div>
            </section>

            <%
                Template bestTemplate = (Template) request.getAttribute("bestTemplate");
                List<Template> loopTemplates = (List<Template>) request.getAttribute("loopTemplates");

                String DEFAULT_THUMBNAIL = "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=400";

                String bestThumb = DEFAULT_THUMBNAIL;
                if (bestTemplate != null && bestTemplate.getThumbnailURL() != null && !bestTemplate.getThumbnailURL().trim().isEmpty()) {
                    bestThumb = bestTemplate.getThumbnailURL();
                }
            %>

            <section class="landing-section" style="text-align: center; width: 100vw; position: relative; left: 50%; right: 50%; margin-left: -50vw; margin-right: -50vw; padding: 40px 0;">

                <h2 class="section-title-large" style="font-size: 36px;">Over 1000 Templates</h2>

                <style>
                    @keyframes scroll-left {
                        0% {
                            transform: translateX(0);
                        }
                        100% {
                            transform: translateX(-50%);
                        } /* Dịch chuyển chính xác 50% độ dài */
                    }
                    .my-marquee-track {
                        display: flex;
                        gap: 16px;
                        width: max-content; /* RẤT QUAN TRỌNG: Ép track dài ra vô hạn chứa đủ thẻ con */
                        animation: scroll-left 30s linear infinite; /* Tăng lên 30s cho tốc độ lướt êm ái hơn */
                    }
                    .my-marquee-track:hover {
                        animation-play-state: paused; /* Dừng lại khi khách hàng di chuột vào xem ảnh */
                    }
                </style>

                <div style="display: flex; overflow: hidden; width: 100%; margin: 32px 0; mask-image: linear-gradient(to right, transparent, black 5%, black 95%, transparent); -webkit-mask-image: linear-gradient(to right, transparent, black 5%, black 95%, transparent);">
                    <div class="my-marquee-track">
                        <%
                            if (loopTemplates != null && !loopTemplates.isEmpty()) {
                                // Tăng vòng lặp lên 4 lần. Vì DB của bạn mới có 3 sản phẩm, lặp 4 lần giúp track đủ dài 
                                // để lấp đầy các màn hình to (như màn hình PC 27 inch) mà không bị đứt đoạn.
                                for (int i = 0; i < 4; i++) {
                                    java.util.Iterator<Template> it = loopTemplates.iterator();
                                    while (it.hasNext()) {
                                        Template t = it.next();
                                        String tThumb = (t.getThumbnailURL() != null && !t.getThumbnailURL().trim().isEmpty())
                                                ? t.getThumbnailURL()
                                                : DEFAULT_THUMBNAIL;
                        %>
                        <div style="width: 320px; height: 200px; flex-shrink: 0; cursor: pointer; border-radius: 16px; overflow: hidden; border: 1px solid rgba(255,255,255,0.1); transition: transform 0.3s ease;" 
                             onclick="window.location.href = 'MainController?action=TemplateDetail&templateID=<%= t.getTemplateID()%>'"
                             onmouseover="this.style.transform = 'translateY(-5px)'"
                             onmouseout="this.style.transform = 'translateY(0)'">

                            <img src="<%= tThumb%>" alt="Template" style="width: 100%; height: 100%; object-fit: cover; display: block;">

                        </div>
                        <%
                                }
                            }
                        } else {
                        %>
                        <p style="color: white; margin: 0 auto;">Chưa có sản phẩm nào để hiển thị.</p>
                        <%  }%>
                    </div>
                </div>
            </section>

            <section class="landing-section">
                <div class="bento-card" style="display: flex; justify-content: space-between; align-items: center; background: #D8B4FF; color: #11052C;">
                    <div style="max-width: 400px;">
                        <h2 class="section-title-large">Best Of<br>The Week</h2>
                        <h3 style="font-size: 20px; font-weight: 700; margin-bottom: 8px;"><%= (bestTemplate != null) ? bestTemplate.getTitle() : ""%></h3>
                        <p style="margin-bottom: 24px; font-weight: 500;">
                            <%= (bestTemplate != null) ? bestTemplate.getDescription() : "Structured Templates And Designer-Backed Customization For Students."%>
                        </p>
                        <a href="MainController?action=TemplateDetail&templateID=<%= (bestTemplate != null) ? bestTemplate.getTemplateID() : ""%>" class="btn-pill" style="background: #11052C; color: white; text-decoration: none; display: inline-block;">Explore Now</a>
                    </div>

                    <div style="width: 400px; height: 250px; background: url('<%= bestThumb%>') center/cover; border-radius: 16px; box-shadow: 0 10px 30px rgba(0,0,0,0.3);"></div>
                </div>
            </section>

            <section class="landing-section" style="text-align: center;">
                <h2 class="section-title-large" style="font-size: 36px; margin-bottom: 40px;">How It Works</h2>

                <div class="step-card" style="text-align: left;">
                    <h4>1. Choose A Template</h4>
                    <p style="color: #E2D7FF; font-size: 14px;">Browse Structured Slides Designed For Academic Excellence.</p>
                </div>
                <div class="step-card" style="text-align: left;">
                    <h4>2. Customize</h4>
                    <p style="color: #E2D7FF; font-size: 14px;">Edit Yourself Or Add Sweet (Full Customize).</p>
                </div>
                <div class="step-card" style="text-align: left;">
                    <h4>3. Download & Present</h4>
                    <p style="color: #E2D7FF; font-size: 14px;">Get Polished Slides Ready To Impress.</p>
                </div>
            </section>

            <section class="landing-section">
                <div class="designer-banner" style="position: relative; overflow: hidden;">

                    <div style="position: relative; z-index: 2;">
                        <h2>Meet Our Designer</h2>
                        <p style="max-width: 300px; margin-bottom: 24px; font-weight: 500;">
                            The Creative Mind Behind Polished, Standout Slides That Help You Present With Confidence.
                        </p>
                        <a href="${pageContext.request.contextPath}/MainController?action=DesignerHub" class="btn-pill">Review</a>
                    </div>

                    <img src="${pageContext.request.contextPath}/assets/images/designer.png" alt="Designer Image" class="designer-banner-img">

                </div>
            </section>

            <section class="landing-section" style="display: flex; justify-content: space-between; align-items: center; padding-bottom: 80px;">
                <div style="max-width: 300px;">
                    <h2 style="font-size: 32px; font-weight: 800; margin-bottom: 16px;">Need More Than A Template?</h2>
                    <p style="color: #E2D7FF; line-height: 1.6;">Our Customize Feature Helps You Refine Content, Improve Layout, And Elevate Visuals.</p>
                </div>
                <div style="text-align: right;">
                    <h1 style="font-size: 80px; font-weight: 800; line-height: 1; margin: 0;">DESIGNER</h1>
                    <h1 style="font-size: 80px; font-weight: 800; line-height: 1; margin: 0;">HUB</h1>
                </div>
            </section>
        </div>

        <%-- SECTION B: DESIGNER WORKSPACE --%>
        <% } else if (roleId == 3) {%>
        <div class="main-container">
            <div class="page-header">
                <div class="greeting">Personal Workspace</div>
                <h1>Hello, Designer <%= loginUser.getUsername()%></h1>
                <p>Manage your templates and track sales performance.</p>
            </div>

            <h3 class="section-title">Sales Analytics</h3>
            <div class="admin-stats-grid">
                <div class="glass-panel admin-stat-card">
                    <div class="stat-icon">💰</div>
                    <div class="stat-title">TOTAL EARNINGS</div>
                    <div class="stat-value">$0</div>
                </div>
                <div class="glass-panel admin-stat-card">
                    <div class="stat-icon">📦</div>
                    <div class="stat-title">TEMPLATES SOLD</div>
                    <div class="stat-value">0</div>
                </div>
                <div class="glass-panel admin-stat-card">
                    <div class="stat-icon">⏳</div>
                    <div class="stat-title">ACTIVE CUSTOM ORDERS</div>
                    <div class="stat-value">0</div>
                </div>
            </div>

            <div class="admin-layout">
                <div class="left-col">
                    <div class="glass-panel" style="padding: 32px;">
                        <h3 class="section-title" style="margin-top: 0;">+ Create New Template</h3>
                        <form action="${pageContext.request.contextPath}/MainController" method="POST">
                            <input type="hidden" name="action" value="CreateTemplate">
                            <div class="form-group">
                                <label style="display:block; margin-bottom:8px; font-size:14px;">Template Title</label>
                                <input type="text" class="form-control" name="templateTitle" required placeholder="e.g., IT Graduate Minimalist CV">
                            </div>
                            <div class="form-group" style="margin-top: 16px;">
                                <label style="display:block; margin-bottom:8px; font-size:14px;">Template Description</label>
                                <textarea class="form-control" name="templateDesc" rows="4" style="resize:none;" placeholder="Notes on pages, color schemes, aspect ratios..."></textarea>
                            </div>
                            <div class="form-group" style="margin-top: 16px;">
                                <label style="display:block; margin-bottom:8px; font-size:14px;">Desired Price (VND)</label>
                                <input type="number" class="form-control" name="templatePrice" required placeholder="50000">
                            </div>
                            <div class="form-group" style="margin-top: 16px;">
                                <label style="display:block; margin-bottom:8px; font-size:14px;">File Download Link (Drive/Cloud Link)</label>
                                <input type="url" class="form-control" name="templateUrl" placeholder="https://drive.google.com/file/...">
                            </div>
                            <button type="submit" class="btn-primary" style="margin-top: 24px; width: 100%; padding: 14px;">Submit for Approval & Publish</button>
                        </form>
                    </div>
                </div>
                <div class="right-col">
                    <div class="glass-panel" style="padding: 24px; min-height: 100%;">
                        <h3 class="section-title" style="margin-top: 0;">Track Orders</h3>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Order ID</th><th>Order Type</th><th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td colspan="3" style="text-align: center; color: var(--text-muted); padding: 64px 0;">
                                        No transactions have occurred yet.
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <% }%>

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
                        <li>
                            <span class="contact-icon">📍</span>
                            <span>FPT University, District 9, Ho Chi Minh City</span>
                        </li>
                        <li>
                            <span class="contact-icon">📧</span>
                            <span>presentaproject05@gmail.com</span>
                        </li>
                        <li>
                            <span class="contact-icon">📞</span>
                            <span>+84 (28) 7300 5588</span>
                        </li>
                        <li>
                            <span class="contact-icon">⏱</span>
                            <span>Mon - Fri: 8:00 AM - 5:00 PM</span>
                        </li>
                    </ul>
                </div>

            </div> <div class="footer-bottom">
                <div class="footer-bottom-container">
                    <p>&copy; 2026 Presenta. All rights reserved.</p>
                </div>
            </div>
        </footer>
    
<script src="${pageContext.request.contextPath}/assets/js/lang.js?v=4.0" charset="UTF-8"></script>
</body>
</html>