<%-- 
    Document   : template-manage
    Created on : Jun 2, 2026, 11:49:23 AM
    Author     : lehan
--%>

<%-- 
    Document   : manage-template
    Path       : views/designer/manage-template.jsp
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    User loginUser = (User) session.getAttribute("LOGIN_USER");
    if (loginUser == null || loginUser.getRoleId() != 3) {
        response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
        return;
    }

    // Đọc danh sách và các thông số phân trang từ controller gửi xuống
    List<Map<String, Object>> myTemplates = (List<Map<String, Object>>) request.getAttribute("MY_TEMPLATES");
    Integer currentPageObj = (Integer) request.getAttribute("CURRENT_PAGE");
    Integer endPageObj = (Integer) request.getAttribute("END_PAGE");

    int currentPage = (currentPageObj != null) ? currentPageObj : 1;
    int endPage = (endPageObj != null) ? endPageObj : 1;
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Manage Templates - Presenta Designer</title>
        <link href="https://fonts.googleapis.com/css2?family=Pacifico&family=Be+Vietnam+Pro:wght@400;500;600;700;800&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer/designer-home.css">
    </head>
    <body class="designer-body">

        <nav class="designer-navbar">
            <a href="${pageContext.request.contextPath}/MainController?action=DesignerHome" class="designer-brand">
                Presenta <span>DESIGNER</span>
            </a>

            <div class="designer-nav-links">
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerHome">Dashboard</a>
                <a href="${pageContext.request.contextPath}/MainController?action=ManageTemplate" class="active">Manage Templates</a>
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerWithdrawals">Withdrawals</a>
                <a href="${pageContext.request.contextPath}/MainController?action=CustomerBooking">Customer Booking</a>
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerProfile">Profile</a>
            </div>

            <div style="display: flex; align-items: center; gap: 20px;">
                <span style="color: #A0AEC0; font-size: 14px;">Designer: <b style="color: white;"><%= loginUser.getUsername()%></b></span>
                <form action="${pageContext.request.contextPath}/MainController" method="POST" style="margin: 0;">
                    <input type="hidden" name="action" value="Logout">
                    <button type="submit" style="background: transparent; border: none; color: #A0AEC0; font-weight: 700; cursor: pointer;">Sign Out</button>
                </form>
            
<button onclick="toggleLanguage()" class="lang-toggle-btn no-translate" style="background: transparent; border: 1px solid currentColor; color: inherit; padding: 4px 10px; border-radius: 20px; cursor: pointer; margin-left: 15px; font-weight: bold; white-space: nowrap;">EN/VI</button>
</div>
        
</nav>

        <div class="designer-container">

            <div class="vision-card" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px; padding: 32px;">
                <div>
                    <h2 style="color: white; font-size: 28px; font-weight: 800; margin-bottom: 8px;">Template Portfolio Management</h2>
                    <p style="color: #A0AEC0; font-size: 14px;">Create, modify, view catalog, or manage settings of your uploaded presentation files.</p>
                </div>
                <a href="${pageContext.request.contextPath}/MainController?action=CreateTemplateForm" class="btn-vision">
                    + Upload New Design
                </a>
            </div>

            <div class="vision-card" style="padding: 32px;">
                <div class="panel-header" style="margin-bottom: 24px;">
                    Your Uploaded Catalog
                    <span style="font-size: 14px; color: #0075FF; font-weight: normal;">
                        Total: <%= (myTemplates != null) ? myTemplates.size() : 0%> active designs
                    </span>
                </div>

                <table class="custom-table">
                    <thead>
                        <tr>
                            <th style="width: 45%;">Design Name / Details</th>
                            <th style="width: 15%;">Category</th>
                            <th style="width: 15%;">Market Price</th>
                            <th style="width: 25%; text-align: center;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (myTemplates != null && !myTemplates.isEmpty()) {
                                for (Map<String, Object> template : myTemplates) {
                                    double price = (Double) template.get("price");
                                    String thumbImg = (template.get("thumbnailURL") != null) ? (String) template.get("thumbnailURL") : "https://images.unsplash.com/photo-1505664194779-8beaceb93744?q=80&w=150";
                        %>
                        <tr>
                            <td>
                                <div style="display: flex; align-items: center; gap: 16px;">
                                    <img src="<%= thumbImg%>" alt="Thumbnail" style="width: 70px; height: 45px; object-fit: cover; border-radius: 8px; border: 1px solid rgba(255,255,255,0.1);">
                                    <div>
                                        <div style="font-weight: 700; color: white; font-size: 15px;"><%= template.get("title")%></div>
                                        <div style="font-size: 12px; color: #A0AEC0;">ID: #TMP-<%= template.get("templateID")%> | Uploaded: <%= template.get("createAt")%></div>
                                    </div>
                                </div>
                            </td>
                            <td style="color: #A0AEC0; font-weight: 500;"><%= template.get("categoryName")%></td>
                            <td style="color: white; font-weight: 700;"><%= String.format("%,.0f", price)%>₫</td>
                            <td>
                                <div style="display: flex; gap: 8px; justify-content: center;">
                                    <a href="${pageContext.request.contextPath}/MainController?action=EditTemplate&id=<%= template.get("templateID")%>" 
                                       class="status-badge" style="color: #0075FF; border: 1px solid #0075FF; text-decoration: none; text-align: center; width: 60px;">
                                        Edit
                                    </a>
                                    <a href="${pageContext.request.contextPath}/MainController?action=DeleteTemplate&id=<%= template.get("templateID")%>&page=<%= currentPage%>" 
                                       class="status-badge" style="color: #E53E3E; border: 1px solid #E53E3E; text-decoration: none; text-align: center; width: 60px;"
                                       onclick="return confirm('Are you sure you want to delete this template permanently?');">
                                        Delete
                                    </a>
                                </div>
                            </td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="4" style="text-align: center; padding: 40px; color: #A0AEC0;">
                                You haven't uploaded any templates yet. Click "+ Upload New Design" to start selling.
                            </td>
                        </tr>
                        <% }%>
                    </tbody>
                </table> <% if (endPage > 1) { %>
                <div class="pagination-wrapper">

                    <% if (currentPage > 1) {%>
                    <a href="${pageContext.request.contextPath}/MainController?action=ManageTemplate&page=<%= currentPage - 1%>" class="page-link">&laquo; Prev</a>
                    <% } %>

                    <% for (int i = 1; i <= endPage; i++) {%>
                    <a href="${pageContext.request.contextPath}/MainController?action=ManageTemplate&page=<%= i%>" 
                       class="page-link <%= (i == currentPage) ? "active-page" : ""%>">
                        <%= i%>
                    </a>
                    <% } %>

                    <% if (currentPage < endPage) {%>
                    <a href="${pageContext.request.contextPath}/MainController?action=ManageTemplate&page=<%= currentPage + 1%>" class="page-link">Next &raquo;</a>
                    <% } %>

                </div>
                <% }%>
            </div>

        </div>

        <footer class="main-footer">
            <div class="footer-container">
                <div class="footer-col brand-col">
                    <div class="brand-logo-desc-wrapper">
                        <img src="${pageContext.request.contextPath}/assets/images/logo.jpg" alt="Presenta Logo" class="footer-image-logo">
                        <div class="brand-text-content">
                            <a href="${pageContext.request.contextPath}/MainController" class="footer-logo" style="margin-bottom: 4px;">Presenta</a>
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
    
<script src="${pageContext.request.contextPath}/assets/js/lang.js" charset="UTF-8"></script>
</body>
</html>