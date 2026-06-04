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
        <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/assets/images/favicon/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-16x16.png">
        <link rel="manifest" href="${pageContext.request.contextPath}/assets/images/favicon/site.webmanifest">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon/favicon.ico">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer-hub.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer-list.css">
    </head>

    <%
        User loginUser = (User) session.getAttribute("LOGIN_USER");
        int roleId = (loginUser != null) ? loginUser.getRoleId() : 0;

        // Nhận dữ liệu từ Controller
        Map<String, List<Designer>> designerMap = (Map<String, List<Designer>>) request.getAttribute("designerMap");
        String txtSearch = (String) request.getAttribute("txtSearch");
        if (txtSearch == null)
            txtSearch = "";
    %>

    <body class="landing-body">

        <%-- ======================================================= --%>
        <%-- NAVBAR (Copy nguyên bản từ home.jsp)                    --%>
        <%-- ======================================================= --%>
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
        <%-- NỘI DUNG CHÍNH: LIST DESIGNER THEO CATEGORY             --%>
        <%-- ======================================================= --%>
        <div class="hub-body-wrapper">
            <div class="hub-container" style="padding-top: 40px; min-height: 80vh;">

                <h1 class="hub-title-script" style="text-align: center; margin-bottom: 40px;">Meet Our Designer</h1>

                <form action="MainController" method="GET" class="search-wrapper">
                    <input type="hidden" name="action" value="DesignerList">
                    <span class="search-icon">🔍</span>
                    <input type="text" name="search" value="<%= txtSearch%>" class="search-input" placeholder="Search designers...">
                </form>

                <%
                    if (designerMap != null && !designerMap.isEmpty()) {
                        // Lặp qua từng Category
                        for (Map.Entry<String, List<Designer>> entry : designerMap.entrySet()) {
                            String categoryName = entry.getKey();
                            List<Designer> designers = entry.getValue();
                %>

                <div style="margin-bottom: 80px;">
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
                        %>
                        <div class="scalloped-designer-card">
                            <div class="scalloped-avatar-wrap">
                                <img src="<%= avatar%>" alt="<%= d.getUserName()%>">
                            </div>
                            <div class="scalloped-info">
                                <span class="scalloped-name"><%= d.getUserName()%></span>
                                <span class="scalloped-spec"><%= categoryName%></span>
                            </div>
                            <div class="scalloped-actions">
                                <a href="MainController?action=DesignerDetail&id=<%= d.getUserID()%>" class="btn-grid-book" style="width: 100%;">View Designer</a>
                            </div>
                        </div>
                        <%  } %>
                    </div>
                </div>

                <%
                    }
                } else {
                %>
                <div style="text-align: center; padding: 100px 0; color: #ccc3d8;">
                    <h2>No designers found.</h2>
                    <p>Try adjusting your search keyword.</p>
                </div>
                <%  }%>

            </div>
        </div>

        <%-- ======================================================= --%>
        <%-- FOOTER (Copy nguyên bản từ home.jsp)                    --%>
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