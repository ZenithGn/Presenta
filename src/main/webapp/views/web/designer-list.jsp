<%-- 
    Document   : designer-list
    Created on : May 28, 2026, 12:25:14 AM
    Author     : lehan
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="com.model.Designer" %>
<%@ page import="com.model.User" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Meet Our Designer - Presenta</title>
        <link href="https://fonts.googleapis.com/css2?family=Pacifico&family=Be+Vietnam+Pro:wght@400;500;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.2/css/all.min.css"/>
        <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/assets/images/favicon/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-16x16.png">
        <link rel="manifest" href="${pageContext.request.contextPath}/assets/images/favicon/site.webmanifest">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon/favicon.ico">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer-hub.css?v=2.0">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer-list.css?v=2.0">
    </head>

    <%
        User loginUser = (User) session.getAttribute("LOGIN_USER");
        int roleId = (loginUser != null) ? loginUser.getRoleId() : 0;

        Map<String, List<Designer>> designerMap = (Map<String, List<Designer>>) request.getAttribute("designerMap");
        String txtSearch = (String) request.getAttribute("txtSearch");
        if (txtSearch == null)
            txtSearch = "";
    %>

    <body class="landing-body">

        <%-- NAVBAR --%>
        <% if (roleId == 0 || roleId == 2) { %>
        <nav class="navbar" style="border-bottom: none; background: transparent;">
            <a href="${pageContext.request.contextPath}/MainController" class="nav-brand" style="font-family: 'Pacifico', cursive; font-size: 28px;">Presenta</a>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/MainController">HOME</a>
                <a href="${pageContext.request.contextPath}/MainController?action=Shop">SHOP</a>
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerHub" class="active">DESIGNER HUB</a>
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
        <% }%>

        <%-- CONTENT --%>
        <div class="hub-body-wrapper">
            <div class="hub-container" style="padding-top: 60px; min-height: 80vh;">

                <h1 class="dl-page-title" id="pageTitle">Meet Our Designer</h1>
                <p class="dl-page-subtitle">Discover talented designers organized by their specialties.</p>

                <form action="MainController" method="GET" class="search-wrapper" id="searchBox">
                    <input type="hidden" name="action" value="DesignerList">
                    <span class="search-icon">&#128269;</span>
                    <input type="text" name="search" value="<%= txtSearch%>" class="search-input" placeholder="Search designers...">
                </form>

                <%
                    if (designerMap != null && !designerMap.isEmpty()) {
                        int sectionIdx = 0;
                        for (Map.Entry<String, List<Designer>> entry : designerMap.entrySet()) {
                            String categoryName = entry.getKey();
                            List<Designer> designers = entry.getValue();
                            // Skip categories with no designers
                            if (designers == null || designers.isEmpty()) continue;
                %>

                <div style="margin-bottom: 80px;" class="dl-category-section">
                    <div class="category-header">
                        <h2><%= categoryName%></h2>
                        <a href="MainController?action=DesignerList&category=<%= categoryName%>">View All &rarr;</a>
                    </div>

                    <div class="designer-grid">
                        <%
                            for (Designer d : designers) {
                                String avatar = (d.getAvatarURL() != null && !d.getAvatarURL().trim().isEmpty())
                                        ? d.getAvatarURL()
                                        : "https://ui-avatars.com/api/?name=" + d.getUserName() + "&background=7C3AED&color=fff";
                                double avgRating = new com.model.ReviewDAO().getAverageRatingForDesigner(d.getUserID());
                        %>
                        <div class="box">
                            <div class="image">
                                <img src="<%= avatar%>" alt="<%= d.getUserName()%>">
                            </div>
                            <div class="name_job"><%= d.getUserName()%></div>
                            <div class="rating" title="<%= String.format("%.1f", avgRating) %> Sao">
                                <% for (int i = 1; i <= 5; i++) {
                                     if (i <= Math.floor(avgRating)) { %>
                                        <i class="fas fa-star"></i>
                                <%   } else if (i == Math.ceil(avgRating) && avgRating % 1 != 0) { %>
                                        <i class="fas fa-star-half-alt"></i>
                                <%   } else { %>
                                        <i class="far fa-star"></i>
                                <%   }
                                   } %>
                            </div>
                            <p style="color: #666; font-size: 14px; text-align: center; margin-bottom: 10px;">
                                <%= categoryName %> expert designer.
                            </p>
                            <div class="btns">
                                <button style="background: #7c3aed; color: #fff;" onclick="window.location.href='MainController?action=DesignerDetail&id=<%= d.getUserID()%>'">View Detail</button>
                            </div>
                        </div>
                        <%  } %>
                    </div>
                </div>

                <%
                            sectionIdx++;
                        }
                    } else {
                %>
                <div style="text-align: center; padding: 100px 0;">
                    <h2 style="color: white; margin-bottom: 12px;">No designers found.</h2>
                    <p style="color: rgba(255,255,255,0.5);">Try adjusting your search keyword.</p>
                </div>
                <%  }%>

            </div>
        </div>

        <%-- FOOTER --%>
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
                        <a href="https://www.facebook.com/profile.php?id=61590550761077" target="_blank" class="social-icon">&#127760;</a>
                        <a href="#" class="social-icon">&#128172;</a>
                        <a href="mailto:presentaproject05@gmail.com" target="_blank" class="social-icon">&#128231;</a>
                    </div>
                </div>
                <div class="footer-col contact-col">
                    <h4>GET IN TOUCH</h4>
                    <ul class="contact-info-list">
                        <li><span class="contact-icon">&#128205;</span><span>FPT University, District 9, Ho Chi Minh City</span></li>
                        <li><span class="contact-icon">&#128231;</span><span>presentaproject05@gmail.com</span></li>
                        <li><span class="contact-icon">&#128222;</span><span>+84 (28) 7300 5588</span></li>
                        <li><span class="contact-icon">&#9201;</span><span>Mon - Fri: 8:00 AM - 5:00 PM</span></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <div class="footer-bottom-container">
                    <p>&copy; 2026 Presenta. All rights reserved.</p>
                </div>
            </div>
        </footer>

        <script src="${pageContext.request.contextPath}/assets/js/lang.js?v=4.0" charset="UTF-8"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/ScrollTrigger.min.js"></script>
        <script>
            gsap.registerPlugin(ScrollTrigger);

            // Page title + search
            gsap.from("#pageTitle", { opacity: 0, y: 30, duration: 0.7, ease: "power3.out" });
            gsap.from("#searchBox", { opacity: 0, y: 20, duration: 0.5, delay: 0.2, ease: "power2.out" });

            // Category sections
            document.querySelectorAll(".dl-category-section").forEach(function(section) {
                gsap.from(section.querySelectorAll(".box"), {
                    scrollTrigger: { trigger: section, start: "top 88%" },
                    opacity: 0, y: 40, scale: 0.95, duration: 0.5, stagger: 0.1, ease: "power2.out",
                    clearProps: "all"
                });
            });
        </script>
    </body>
</html>