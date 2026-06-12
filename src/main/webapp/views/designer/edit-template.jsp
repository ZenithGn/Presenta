<%-- 
    Document   : edit-template
    Created on : Jun 2, 2026, 12:37:54 PM
    Author     : lehan
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

    Map<String, Object> templateData = (Map<String, Object>) request.getAttribute("TEMPLATE_DATA");
    List<Map<String, Object>> categories = (List<Map<String, Object>>) request.getAttribute("CATEGORY_LIST");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Edit Template - Presenta Designer</title>
        <link href="https://fonts.googleapis.com/css2?family=Pacifico&family=Be+Vietnam+Pro:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer/designer-home.css">
        <style>
            /* Các class phụ trợ cho Form Vision UI */
            .form-group {
                margin-bottom: 24px;
            }
            .form-group label {
                display: block;
                font-size: 14px;
                font-weight: 700;
                color: #A0AEC0;
                margin-bottom: 8px;
            }
            .form-control {
                width: 100%;
                padding: 14px 16px;
                background: rgba(15, 23, 42, 0.6);
                border: 1px solid rgba(255,255,255,0.1);
                border-radius: 12px;
                color: white;
                font-family: var(--font-main);
                font-size: 14px;
                transition: all 0.3s;
            }
            .form-control:focus {
                outline: none;
                border-color: #0075FF;
                background: rgba(15, 23, 42, 0.8);
            }
            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 24px;
            }
            textarea.form-control {
                resize: vertical;
                min-height: 100px;
            }
            .file-drop-area { position: relative; display: flex; align-items: center; width: 100%; padding: 25px; background: rgba(15, 23, 42, 0.6); border: 2px dashed rgba(255,255,255,0.2); border-radius: 12px; transition: 0.3s; cursor: pointer; box-sizing: border-box; }
            .file-drop-area.is-active { border-color: #0075FF; background: rgba(15, 23, 42, 0.8); }
            .fake-btn { flex-shrink: 0; background-color: rgba(255, 255, 255, 0.1); border: 1px solid rgba(255, 255, 255, 0.2); border-radius: 8px; padding: 8px 15px; margin-right: 10px; font-size: 14px; color: white; }
            .file-msg { font-size: 14px; font-weight: 300; color: #A0AEC0; }
            .file-input { position: absolute; left: 0; top: 0; height: 100%; width: 100%; cursor: pointer; opacity: 0; }
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
<div onclick="toggleLanguage()" class="lang-toggle-switch no-translate" style="position: relative; display: flex; align-items: center; width: 64px; height: 28px; border: 1px solid currentColor; border-radius: 20px; cursor: pointer; margin-right: 15px; color: inherit;">
    <div class="lang-slider" style="position: absolute; top: 2px; left: 2px; width: 28px; height: 22px; background: currentColor; opacity: 0.2; border-radius: 14px; transition: transform 0.3s cubic-bezier(0.4, 0.0, 0.2, 1); z-index: 1;"></div>
    <span style="flex: 1; text-align: center; font-size: 11px; font-weight: bold; z-index: 2; pointer-events: none;">EN</span>
    <span style="flex: 1; text-align: center; font-size: 11px; font-weight: bold; z-index: 2; pointer-events: none;">VI</span>
</div>

                <span style="color: #A0AEC0; font-size: 14px;">Designer: <b style="color: white;"><%= loginUser.getUsername()%></b></span>
                <form action="${pageContext.request.contextPath}/MainController" method="POST" style="margin: 0;">
                    <input type="hidden" name="action" value="Logout">
                    <button type="submit" style="background: transparent; border: none; color: #A0AEC0; font-weight: 700; cursor: pointer;">Sign Out</button>
                </form>
            
</div>
        
</nav>

        <div class="designer-container">
            <div class="vision-card" style="max-width: 800px; margin: 0 auto; padding: 40px;">
                <h2 style="color: white; font-size: 28px; font-weight: 800; margin-bottom: 8px;">Edit Template Details</h2>
                <p style="color: #A0AEC0; font-size: 14px; margin-bottom: 32px;">Update the information for ID: #TMP-<%= templateData.get("templateID")%></p>

                <form action="${pageContext.request.contextPath}/EditTemplateController" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="templateId" value="<%= templateData.get("templateID")%>">

                    <div class="form-group">
                        <label>Template Title <span style="color: #E53E3E;">*</span></label>
                        <input type="text" name="title" class="form-control" value="<%= templateData.get("title")%>" required>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Category <span style="color: #E53E3E;">*</span></label>
                            <select name="categoryID" class="form-control" required>
                                <% for (Map<String, Object> cat : categories) {
                                        int catId = (Integer) cat.get("categoryID");
                                        int currentCat = (Integer) templateData.get("categoryID");
                                %>
                                <option value="<%= catId%>" <%= (catId == currentCat) ? "selected" : ""%>><%= cat.get("categoryName")%></option>
                                <% }%>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Price (VND) <span style="color: #E53E3E;">*</span></label>
                            <input type="number" name="price" class="form-control" value="<%= String.format("%.0f", templateData.get("price"))%>" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Short Description</label>
                        <textarea name="description" class="form-control"><%= (templateData.get("description") != null) ? templateData.get("description") : ""%></textarea>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Core Features (Comma separated)</label>
                            <input type="text" name="coreFeatures" class="form-control" value="<%= (templateData.get("coreFeatures") != null) ? templateData.get("coreFeatures") : ""%>">
                        </div>
                        <div class="form-group">
                            <label>Design Assets (e.g. .fig, .pdf)</label>
                            <input type="text" name="designAssets" class="form-control" value="<%= (templateData.get("designAssets") != null) ? templateData.get("designAssets") : ""%>">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Thumbnail Image <span style="color: #A0AEC0; font-weight: normal;">(Optional)</span></label>
                        <div class="file-drop-area" id="file-drop-area">
                            <span class="fake-btn">Choose File</span>
                            <%
                                String existingThumbnail = (templateData.get("thumbnailURL") != null) ? templateData.get("thumbnailURL").toString() : "";
                                String fileMsgText = "or drag and drop files here";
                                if (!existingThumbnail.isEmpty()) {
                                    int lastSlash = existingThumbnail.lastIndexOf('/');
                                    if (lastSlash != -1 && lastSlash < existingThumbnail.length() - 1) {
                                        fileMsgText = "Current file: " + existingThumbnail.substring(lastSlash + 1);
                                    } else {
                                        fileMsgText = "Current file uploaded";
                                    }
                                }
                            %>
                            <span class="file-msg"><%= fileMsgText %></span>
                            <input class="file-input" type="file" name="thumbnailFile" accept="image/*" id="thumbnailFile">
                        </div>
                        <% if (!existingThumbnail.isEmpty()) { %>
                            <input type="hidden" name="thumbnailURL" value="<%= existingThumbnail %>">
                        <% } %>
                        <div id="preview-container" style="display: <%= existingThumbnail.isEmpty() ? "none" : "block" %>; margin-top: 15px; text-align: center;">
                            <img id="image-preview" src="<%= existingThumbnail %>" alt="Image Preview" style="max-width: 100%; max-height: 200px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.1);">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Source File URL (Google Drive/Dropbox link)</label>
                        <input type="text" name="fileURL" class="form-control" value="<%= (templateData.get("fileURL") != null) ? templateData.get("fileURL") : ""%>">
                    </div>

                    <div style="display: flex; justify-content: flex-end; gap: 16px; margin-top: 40px;">
                        <a href="${pageContext.request.contextPath}/MainController?action=ManageTemplate" class="btn-vision" style="background: transparent; border: 1px solid rgba(255,255,255,0.2); box-shadow: none;">Cancel</a>
                        <button type="submit" class="btn-vision">Save Changes</button>
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
    
<script>
    const fileDropArea = document.querySelector('#file-drop-area');
    const fileInput = document.querySelector('#thumbnailFile');
    const fileMsg = document.querySelector('.file-msg');
    const previewContainer = document.querySelector('#preview-container');
    const imagePreview = document.querySelector('#image-preview');

    if (fileDropArea && fileInput) {
        fileInput.addEventListener('dragenter', () => fileDropArea.classList.add('is-active'));
        fileInput.addEventListener('focus', () => fileDropArea.classList.add('is-active'));
        fileInput.addEventListener('click', () => fileDropArea.classList.add('is-active'));

        fileInput.addEventListener('dragleave', () => fileDropArea.classList.remove('is-active'));
        fileInput.addEventListener('blur', () => fileDropArea.classList.remove('is-active'));
        fileInput.addEventListener('drop', () => fileDropArea.classList.remove('is-active'));

        fileInput.addEventListener('change', function() {
            const file = this.files[0];
            if (file) {
                fileMsg.textContent = "Current file: " + file.name;
                const reader = new FileReader();
                reader.onload = function(e) {
                    imagePreview.src = e.target.result;
                    previewContainer.style.display = 'block';
                }
                reader.readAsDataURL(file);
            } else {
                <%
                    String existingThumbnailJS = (templateData.get("thumbnailURL") != null) ? templateData.get("thumbnailURL").toString() : "";
                    String defaultMsgJS = "or drag and drop files here";
                    if (!existingThumbnailJS.isEmpty()) {
                        int lastSlash = existingThumbnailJS.lastIndexOf('/');
                        if (lastSlash != -1 && lastSlash < existingThumbnailJS.length() - 1) {
                            defaultMsgJS = "Current file: " + existingThumbnailJS.substring(lastSlash + 1);
                        }
                    }
                %>
                fileMsg.textContent = '<%= defaultMsgJS %>';
                imagePreview.src = '<%= existingThumbnailJS %>';
                previewContainer.style.display = '<%= existingThumbnailJS.isEmpty() ? "none" : "block" %>';
            }
        });
    }
</script>
<script src="${pageContext.request.contextPath}/assets/js/lang.js" charset="UTF-8"></script>
</body>
</html>