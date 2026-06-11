<%-- 
    Document   : create-template
    Created on : Jun 2, 2026, 12:52:15 PM
    Author     : lehan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    User loginUser = (User) session.getAttribute("LOGIN_USER");
    if (loginUser == null || loginUser.getRoleId() != 3) {
        response.sendRedirect(request.getContextPath() + "/MainController?action=Login"); return;
    }
    List<Map<String, Object>> categories = (List<Map<String, Object>>) request.getAttribute("CATEGORY_LIST");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Upload New Design - Presenta Designer</title>
        <link href="https://fonts.googleapis.com/css2?family=Pacifico&family=Be+Vietnam+Pro:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer/designer-home.css">
        <style>
            .form-group { margin-bottom: 24px; }
            .form-group label { display: block; font-size: 14px; font-weight: 700; color: #A0AEC0; margin-bottom: 8px; }
            .form-control { width: 100%; padding: 14px 16px; background: rgba(15, 23, 42, 0.6); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; color: white; font-family: var(--font-main); font-size: 14px; transition: all 0.3s; }
            .form-control:focus { outline: none; border-color: #0075FF; background: rgba(15, 23, 42, 0.8); }
            .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }
            textarea.form-control { resize: vertical; min-height: 100px; }
        </style>
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
<button onclick="toggleLanguage()" class="lang-toggle-btn no-translate" style="background: transparent; border: 1px solid currentColor; color: inherit; padding: 4px 10px; border-radius: 20px; cursor: pointer; margin-right: 15px; font-weight: bold; white-space: nowrap;">EN/VI</button>

                <span style="color: #A0AEC0; font-size: 14px;">Designer: <b style="color: white;"><%= loginUser.getUsername() %></b></span>
            
</div>
        
</nav>

        <div class="designer-container">
            <div class="vision-card" style="max-width: 800px; margin: 0 auto; padding: 40px;">
                <h2 style="color: white; font-size: 28px; font-weight: 800; margin-bottom: 8px;">Upload New Template</h2>
                <p style="color: #A0AEC0; font-size: 14px; margin-bottom: 32px;">Fill in the details below to list a new design on the marketplace.</p>

                <form action="${pageContext.request.contextPath}/MainController" method="POST">
                    <input type="hidden" name="action" value="CreateTemplateForm"> <div class="form-group">
                        <label>Template Title <span style="color: #E53E3E;">*</span></label>
                        <input type="text" name="title" class="form-control" placeholder="Enter design name..." required>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Category <span style="color: #E53E3E;">*</span></label>
                            <select name="categoryID" class="form-control" required>
                                <option value="" disabled selected>-- Select a category --</option>
                                <% 
                                    if (categories != null) {
                                        for (Map<String, Object> cat : categories) { 
                                %>
                                    <option value="<%= cat.get("categoryID") %>"><%= cat.get("categoryName") %></option>
                                <% 
                                        } 
                                    }
                                %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Price (VND) <span style="color: #E53E3E;">*</span></label>
                            <input type="number" name="price" class="form-control" placeholder="e.g. 50000" min="0" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Short Description <span style="color: #E53E3E;">*</span></label>
                        <textarea name="description" class="form-control" placeholder="Describe your template..." required></textarea>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Core Features (Comma separated) <span style="color: #E53E3E;">*</span></label>
                            <input type="text" name="coreFeatures" class="form-control" placeholder="e.g. Responsive, ATS Friendly" required>
                        </div>
                        <div class="form-group">
                            <label>Design Assets <span style="color: #E53E3E;">*</span></label>
                            <input type="text" name="designAssets" class="form-control" placeholder="e.g. .fig, .docx" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Thumbnail Image URL <span style="color: #A0AEC0; font-weight: normal;">(Optional)</span></label>
                        <input type="text" name="thumbnailURL" class="form-control" placeholder="Leave blank to use default image">
                    </div>

                    <div class="form-group">
                        <label>Source File URL (Google Drive/Dropbox link) <span style="color: #E53E3E;">*</span></label>
                        <input type="url" name="fileURL" class="form-control" placeholder="https://" required>
                    </div>

                    <div style="display: flex; justify-content: flex-end; gap: 16px; margin-top: 40px;">
                        <a href="${pageContext.request.contextPath}/MainController?action=ManageTemplate" class="btn-vision" style="background: transparent; border: 1px solid rgba(255,255,255,0.2); box-shadow: none;">Cancel</a>
                        <button type="submit" class="btn-vision" style="background: #01B574; box-shadow: 0 4px 15px rgba(1, 181, 116, 0.3);">Upload Design</button>
                    </div>
                </form>
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