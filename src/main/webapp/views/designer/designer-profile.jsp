<%--
    Designer Profile Page - Tabbed profile for Designer role
    Similar to customer profile but with designer-specific features
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.model.User" %>
<%@ page import="com.model.Designer" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    User loginUser = (User) session.getAttribute("LOGIN_USER");
    if (loginUser == null || loginUser.getRoleId() != 3) {
        response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
        return;
    }

    Designer designer = (Designer) request.getAttribute("designer");
    List<Map<String, Object>> designerOrders = (List<Map<String, Object>>) request.getAttribute("DESIGNER_ORDERS");

    String toastMsg = (String) session.getAttribute("toastMessage");

    // Determine active tab
    String activeTab = request.getParameter("tab");
    if (activeTab == null) activeTab = "portfolio";
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Designer Profile - Presenta</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&family=Pacifico&display=swap" rel="stylesheet">
        <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/assets/images/favicon/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-16x16.png">
        <link rel="manifest" href="${pageContext.request.contextPath}/assets/images/favicon/site.webmanifest">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon/favicon.ico">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer/designer-profile.css">
        <!-- Include pdf.js in head so it is loaded before change handler fires -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.16.105/pdf.min.js"></script>
        <script>
            if (typeof pdfjsLib !== 'undefined') {
                pdfjsLib.GlobalWorkerOptions.workerSrc = 'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.16.105/pdf.worker.min.js';
            }
        </script>
    </head>

    <body class="landing-body">

        <%-- NAVBAR --%>
        <nav class="navbar" style="border-bottom: none; background: transparent;">
            <a href="${pageContext.request.contextPath}/MainController?action=DesignerHome" class="nav-brand" style="font-family: 'Pacifico', cursive; font-size: 28px; color:white;">
                Presenta <span style="font-size:12px; color:#D8B4FF; font-family: Inter;">DESIGNER</span>
            </a>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerHome" class="active">Dashboard</a>
                <a href="${pageContext.request.contextPath}/MainController?action=ManageTemplate">Manage Templates</a>
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerWithdrawals">Withdrawals</a>
                <a href="${pageContext.request.contextPath}/MainController?action=CustomerBooking">Customer Booking</a>
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerProfile" style="border-bottom: 2px solid white; font-weight: 700; color:white;">Profile</a>
            </div>
            <div class="nav-actions">
<div onclick="toggleLanguage()" class="lang-toggle-switch no-translate" style="position: relative; display: flex; align-items: center; width: 64px; height: 28px; border: 1px solid currentColor; border-radius: 20px; cursor: pointer; margin-right: 15px; color: inherit;">
    <div class="lang-slider" style="position: absolute; top: 2px; left: 2px; width: 28px; height: 22px; background: currentColor; opacity: 0.2; border-radius: 14px; transition: transform 0.3s cubic-bezier(0.4, 0.0, 0.2, 1); z-index: 1;"></div>
    <span style="flex: 1; text-align: center; font-size: 11px; font-weight: bold; z-index: 2; pointer-events: none;">EN</span>
    <span style="flex: 1; text-align: center; font-size: 11px; font-weight: bold; z-index: 2; pointer-events: none;">VI</span>
</div>

                <span style="color: #dae2fd; font-size: 14px; margin-right: 10px;">Welcome, <b><%= loginUser.getUsername()%></b></span>
                <form action="${pageContext.request.contextPath}/MainController" method="POST" style="margin:0; display: inline-block;">
                    <input type="hidden" name="action" value="Logout">
                    <button type="submit" class="btn-outline" style="padding: 6px 16px; font-size: 12px; border-radius: 999px; color:white; border-color:white;">Logout</button>
                </form>
            
</div>
        
</nav>

        <%-- MAIN LAYOUT --%>
        <main class="profile-container">
            <%-- SIDEBAR --%>
            <aside class="profile-sidebar">
                <div style="border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 20px;">

                    <div class="avatar-wrapper" onclick="triggerFileUpload()" title="Click để đổi ảnh đại diện">
                        <%
                            String userAvatar = loginUser.getAvatarUrl();
                            String avatarSrc = (userAvatar != null && !userAvatar.isEmpty()) ? userAvatar : "";

                            if (!avatarSrc.isEmpty()) {
                        %>
                        <img src="<%= avatarSrc%>" id="main-avatar-img" alt="Avatar" style="width: 100%; height: 100%; object-fit: cover; display: block;">
                        <% } else {%>
                        <div class="user-avatar" id="main-avatar-placeholder"><%= loginUser.getUsername().substring(0, 1).toUpperCase()%></div>
                        <img src="" id="main-avatar-img" alt="Avatar" style="width: 100%; height: 100%; object-fit: cover; display: none;">
                        <% }%>
                        <div class="avatar-hover-overlay"><span class="no-translate">📷</span></div>
                    </div>

                    <h3 class="user-name"><%= loginUser.getUsername()%></h3>
                    <p style="text-align:center; color:#D8B4FF; font-size:12px; margin-top:4px;">Designer</p>
                </div>
                <ul class="sidebar-menu">
                    <li class="menu-item <%= "portfolio".equals(activeTab) ? "active" : ""%>" onclick="switchTab('tab-portfolio', this)" id="nav-tab-portfolio"><span class="no-translate">&#x1F3A8;</span> Portfolio Settings</li>
                    <li class="menu-item <%= "info".equals(activeTab) ? "active" : ""%>" onclick="switchTab('tab-info', this)" id="nav-tab-info"><span class="no-translate">&#x2699;&#xFE0F;</span> Account Settings</li>
                    <li class="menu-item <%= "orders".equals(activeTab) ? "active" : ""%>" onclick="switchTab('tab-orders', this)" id="nav-tab-orders"><span class="no-translate">&#x1F4E6;</span> Custom Orders</li>
                </ul>
            </aside>

            <%-- CONTENT AREA --%>
            <section class="profile-content-area">

                <%-- TAB: Portfolio Settings --%>
                <div id="tab-portfolio" class="tab-pane <%= "portfolio".equals(activeTab) ? "active" : ""%>">
                    <h2 class="tab-title">Portfolio Settings</h2>
                    <p style="color:#cbd5e1; font-size:13px; margin-bottom:24px;">
                        These details appear on your public designer profile. Keep them up to date to attract more clients.
                    </p>

                    <div style="background: rgba(255,255,255,0.02); padding: 24px; border-radius: 12px; border: 1px solid rgba(255,255,255,0.05);">
                        <form action="${pageContext.request.contextPath}/AccountController" method="POST" enctype="multipart/form-data">
                            <input type="hidden" name="updateType" value="designer_profile">

                            <label style="display:block; font-size:13px; color:#E2D7FF; font-weight:700; margin-bottom:8px;">Bio / About</label>
                            <textarea name="bio" rows="4" style="width:100%; padding:12px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:16px; background:rgba(255,255,255,0.05); color:#ffffff; box-sizing:border-box; resize:vertical; font-family:inherit;"><%= (designer != null && designer.getBio() != null) ? designer.getBio() : ""%></textarea>

                            <label style="display:block; font-size:13px; color:#E2D7FF; font-weight:700; margin-bottom:8px;">Phone Number</label>
                            <input type="text" name="phone" value="<%= (designer != null && designer.getPhone() != null) ? designer.getPhone() : ""%>" style="width:100%; padding:12px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:16px; background:rgba(255,255,255,0.05); color:#ffffff; box-sizing:border-box;">

                            <label style="display:block; font-size:13px; color:#E2D7FF; font-weight:700; margin-bottom:8px;">Portfolio File (Image or PDF)</label>
                            <div style="display: flex; flex-direction: column; gap: 12px; margin-bottom: 24px;">
                                <div class="file-drop-area" id="portfolio-drop-area" style="position: relative; display: flex; align-items: center; width: 100%; padding: 25px; border: 2px dashed rgba(255, 255, 255, 0.2); border-radius: 12px; background: rgba(15, 23, 42, 0.6); transition: all 0.3s; cursor: pointer; box-sizing: border-box;">
                                    <span class="fake-btn" style="flex-shrink: 0; background-color: rgba(255, 255, 255, 0.1); border: 1px solid rgba(255, 255, 255, 0.2); border-radius: 8px; padding: 8px 15px; margin-right: 10px; font-size: 14px; color: white;">Choose File</span>
                                    <%
                                        String fileMsgText = "or drag and drop Image/PDF here";
                                        if (designer != null && designer.getPortfolioURL() != null && !designer.getPortfolioURL().trim().isEmpty()) {
                                            String urlStr = designer.getPortfolioURL();
                                            int lastSlash = urlStr.lastIndexOf('/');
                                            if (lastSlash != -1 && lastSlash < urlStr.length() - 1) {
                                                fileMsgText = "Current file: " + urlStr.substring(lastSlash + 1);
                                            } else {
                                                fileMsgText = "Current file uploaded";
                                            }
                                        }
                                    %>
                                    <span class="file-msg" id="portfolio-file-msg" style="font-size: 13px; font-weight: 300; color: #A0AEC0;"><%= fileMsgText %></span>
                                    <input class="file-input" type="file" name="portfolioFile" accept="image/png, image/jpeg, image/gif, application/pdf" id="portfolioFile" style="position: absolute; left: 0; top: 0; height: 100%; width: 100%; cursor: pointer; opacity: 0;">
                                </div>
                                <div style="color: #ffc107; font-size: 11px; margin-top: 4px; text-align: left;">
                                    * Lưu ý: Đối với file PDF, hệ thống chỉ hỗ trợ hiển thị trang đầu tiên.
                                </div>
                                <div id="portfolio-preview-container" style="margin-top: 15px; text-align: center;">
                                    <% 
                                        String previewUrl = (designer != null) ? designer.getPortfolioURL() : null;
                                        if (previewUrl != null && previewUrl.toLowerCase().endsWith(".pdf") && previewUrl.contains("res.cloudinary.com")) {
                                            int lastDot = previewUrl.lastIndexOf('.');
                                            if (lastDot != -1) {
                                                previewUrl = previewUrl.substring(0, lastDot) + ".jpg";
                                            }
                                        }
                                    %>
                                    <% if (designer != null && designer.getPortfolioURL() != null && !designer.getPortfolioURL().trim().isEmpty()) { %>
                                    <input type="hidden" name="portfolioURL" value="<%= designer.getPortfolioURL() %>">
                                    <img id="portfolio-image-preview" src="<%= previewUrl %>" alt="Portfolio Preview" style="max-width: 100%; max-height: 200px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.1); display: inline-block;">
                                    <% } else { %>
                                    <img id="portfolio-image-preview" src="" alt="Portfolio Preview" style="max-width: 100%; max-height: 200px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.1); display: none;">
                                    <% } %>
                                </div>
                            </div>

                            <button type="submit" class="btn-action" style="background:#D8B4FF; color:#11052C; padding:12px 28px; width:100%;">Save Portfolio Settings</button>
                        </form>
                    </div>
                </div>

                <%-- TAB: Account Settings (Email, Password, Avatar) --%>
                <div id="tab-info" class="tab-pane <%= "info".equals(activeTab) ? "active" : ""%>">
                    <h2 class="tab-title">Account Settings</h2>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 40px;">

                        <div style="display: flex; flex-direction: column; gap: 30px;">

                            <div style="background: rgba(255,255,255,0.02); padding: 20px; border-radius: 12px; border: 1px solid rgba(255,255,255,0.05);">
                                <h4 style="color: #D8B4FF; margin-top: 0; margin-bottom: 15px;">Personal Info</h4>
                                <form action="${pageContext.request.contextPath}/AccountController" method="POST">
                                    <input type="hidden" name="updateType" value="profile">

                                    <label style="display:block; font-size:13px; color:#E2D7FF; font-weight:700; margin-bottom:8px;">Username</label>
                                    <input type="text" name="username" value="<%= loginUser.getUsername()%>" required style="width:100%; padding:12px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:15px; background:rgba(255,255,255,0.05); color:#ffffff; box-sizing:border-box; font-weight:bold;">

                                    <label style="display:block; font-size:13px; color:#E2D7FF; font-weight:700; margin-bottom:8px;">Email</label>
                                    <input type="email" name="email" value="<%= loginUser.getEmail()%>" required style="width:100%; padding:12px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:20px; background:rgba(255,255,255,0.05); color:#ffffff; box-sizing:border-box;">

                                    <button type="submit" class="btn-action" style="background:#D8B4FF; color:#11052C; padding:10px 20px; width:100%;">Save</button>
                                </form>
                            </div>

                            <div style="background: rgba(255,255,255,0.02); padding: 20px; border-radius: 12px; border: 1px solid rgba(255,255,255,0.05);">
                                <h4 style="color: #D8B4FF; margin-top: 0; margin-bottom: 15px;">Change Password</h4>
                                <form action="${pageContext.request.contextPath}/AccountController" method="POST">
                                    <input type="hidden" name="updateType" value="password">

                                    <label style="display:block; font-size:13px; color:#E2D7FF; font-weight:700; margin-bottom:8px;">Current Password</label>
                                    <input type="password" name="oldPass" required style="width:100%; padding:12px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:15px; background:rgba(255,255,255,0.05); color:#ffffff; box-sizing:border-box;">

                                    <label style="display:block; font-size:13px; color:#E2D7FF; font-weight:700; margin-bottom:8px;">New Password</label>
                                    <input type="password" name="newPass" required style="width:100%; padding:12px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:20px; background:rgba(255,255,255,0.05); color:#ffffff; box-sizing:border-box;">

                                    <button type="submit" class="btn-action" style="background:transparent; color:#D8B4FF; border:1px solid #D8B4FF; padding:10px 20px; width:100%;">Change Password</button>
                                </form>
                            </div>
                        </div>

                        <div>
                            <div style="background: rgba(255,255,255,0.02); padding: 20px; border-radius: 12px; border: 1px solid rgba(255,255,255,0.05); height:100%; box-sizing:border-box; display:flex; flex-direction:column;">
                                <h4 style="color: #D8B4FF; margin-top: 0; margin-bottom: 15px;">Change Avatar</h4>
                                <p style="font-size:13px; color:#cbd5e1; margin-top:0; line-height:1.5; flex-grow:1;">
                                    Click the avatar circle in the sidebar or choose a file below.
                                    <br><br>
                                    <span style="color:#ffc107;">* Max file size: 10MB (JPG, PNG, GIF)</span>
                                </p>

                                <form action="${pageContext.request.contextPath}/AccountController" method="POST" enctype="multipart/form-data" style="margin-top:20px;">
                                    <input type="hidden" name="updateType" value="designer_avatar">

                                    <label style="display:block; font-size:13px; color:#E2D7FF; font-weight:700; margin-bottom:8px;">Choose Image File</label>
                                    <input type="file" name="avatarFile" id="avatar-file-input" accept="image/png, image/jpeg, image/gif" required style="width:100%; padding:10px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:20px; background:rgba(255,255,255,0.05); color:#ffffff; box-sizing:border-box; font-size:12px;">

                                    <button type="submit" class="btn-action" style="background:#D8B4FF; color:#11052C; padding:12px 24px; width:100%;">Upload New Avatar</button>
                                </form>
                            </div>
                        </div>

                    </div>
                </div>

                <%-- TAB: Custom Orders --%>
                <div id="tab-orders" class="tab-pane <%= "orders".equals(activeTab) ? "active" : ""%>">
                    <h2 class="tab-title">Custom Design Orders</h2>
                    <p style="color:#cbd5e1; font-size:13px; margin-bottom:24px;">
                        Orders from customers who hired you for custom design work.
                    </p>

                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Customer</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (designerOrders != null && !designerOrders.isEmpty()) {
                                for (Map<String, Object> o : designerOrders) {
                                    double price = (Double) o.get("totalPrice");
                                    String status = (String) o.get("status");
                                    java.sql.Timestamp createdAt = (java.sql.Timestamp) o.get("createAt");
                            %>
                            <tr>
                                <td>#<%= o.get("orderID")%></td>
                                <td><%= o.get("customerName")%></td>
                                <td><%= String.format("%,.0f", price)%>&#x20AB;</td>
                                <td>
                                    <span style="padding:4px 10px; border-radius:12px; font-size:12px; font-weight:700;
                                        <%= "Completed".equals(status) ? "background:rgba(40,167,69,0.2); color:#28a745;" : ("Cancelled".equals(status) ? "background:rgba(220,53,69,0.2); color:#dc3545;" : "background:rgba(255,193,7,0.2); color:#ffc107;")%>">
                                        <%= status%>
                                    </span>
                                </td>
                                <td style="color:#cbd5e1; font-weight:400;"><%= createdAt != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(createdAt) : "N/A"%></td>
                            </tr>
                            <% }
                            } else { %>
                            <tr><td colspan="5" style="text-align:center; padding:40px; color:#94a3b8;">No custom orders yet.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

            </section>
        </main>

        <%-- TOAST --%>
        <% if (toastMsg != null) {%>
        <div id="toastAlert" class="toast-msg"><%= toastMsg%></div>
        <% session.removeAttribute("toastMessage");
        }%>

        <footer class="main-footer">
            <div class="footer-container">
                <div class="footer-col brand-col">
                    <div class="brand-logo-desc-wrapper">
                        <img src="${pageContext.request.contextPath}/assets/images/logo.jpg" alt="Presenta Logo" class="footer-image-logo">
                        <div class="brand-text-content">
                            <a href="#" class="footer-logo" style="margin-bottom:4px;">Presenta</a>
                            <p class="footer-desc" style="margin-bottom:0;">The next generation template marketplace for academic visionaries and creative professionals.</p>
                        </div>
                    </div>
                    <div class="footer-socials">
                        <a href="https://www.facebook.com/profile.php?id=61590550761077" target="_blank" class="social-icon">&#x1F310;</a>
                        <a href="#" class="social-icon">&#x1F4AC;</a>
                        <a href="mailto:presentaproject05@gmail.com" target="_blank" class="social-icon">&#x1F4E7;</a>
                    </div>
                </div>
                <div class="footer-col contact-col">
                    <h4>GET IN TOUCH</h4>
                    <ul class="contact-info-list">
                        <li><span class="contact-icon">&#x1F4CD;</span><span>FPT University, District 9, Ho Chi Minh City</span></li>
                        <li><span class="contact-icon">&#x1F4E7;</span><span>presentaproject05@gmail.com</span></li>
                        <li><span class="contact-icon">&#x1F4DE;</span><span>+84 (28) 7300 5588</span></li>
                        <li><span class="contact-icon">&#x23F1;</span><span>Mon - Fri: 8:00 AM - 5:00 PM</span></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <div class="footer-bottom-container">
                    <p>&copy; 2026 Presenta. All rights reserved.</p>
                </div>
            </div>
        </footer>

        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/designer-account.js"></script>
        <script>
            const fileDropArea = document.querySelector('#portfolio-drop-area');
            const fileInput = document.querySelector('#portfolioFile');
            const fileMsg = document.querySelector('#portfolio-file-msg');

            if(fileDropArea && fileInput) {
                fileInput.addEventListener('dragenter', () => {
                    fileDropArea.style.borderColor = '#0075FF';
                    fileDropArea.style.background = 'rgba(15, 23, 42, 0.8)';
                });
                fileInput.addEventListener('focus', () => {
                    fileDropArea.style.borderColor = '#0075FF';
                    fileDropArea.style.background = 'rgba(15, 23, 42, 0.8)';
                });
                fileInput.addEventListener('click', () => {
                    fileDropArea.style.borderColor = '#0075FF';
                    fileDropArea.style.background = 'rgba(15, 23, 42, 0.8)';
                });

                fileInput.addEventListener('dragleave', () => {
                    fileDropArea.style.borderColor = 'rgba(255, 255, 255, 0.2)';
                    fileDropArea.style.background = 'rgba(15, 23, 42, 0.6)';
                });
                fileInput.addEventListener('blur', () => {
                    fileDropArea.style.borderColor = 'rgba(255, 255, 255, 0.2)';
                    fileDropArea.style.background = 'rgba(15, 23, 42, 0.6)';
                });
                fileInput.addEventListener('drop', () => {
                    fileDropArea.style.borderColor = 'rgba(255, 255, 255, 0.2)';
                    fileDropArea.style.background = 'rgba(15, 23, 42, 0.6)';
                });

                fileInput.addEventListener('change', async function() {
                    const file = this.files[0];
                    const imagePreview = document.querySelector('#portfolio-image-preview');
                    if (file) {
                        fileMsg.textContent = "Current file: " + file.name;
                        
                        if (file.type.startsWith('image/')) {
                            const reader = new FileReader();
                            reader.onload = function(e) {
                                imagePreview.src = e.target.result;
                                imagePreview.style.display = 'inline-block';
                            }
                            reader.readAsDataURL(file);
                        } else if (file.type === 'application/pdf') {
                            const submitBtn = document.querySelector('button[type="submit"]');
                            if(submitBtn) submitBtn.disabled = true;
                            
                            // Temporarily show loading state
                            fileMsg.textContent = "Current file: " + file.name + " (Loading preview...)";
                            
                            try {
                                if (typeof pdfjsLib === 'undefined') {
                                    throw new Error("pdf.js library is not loaded yet.");
                                }
                                const arrayBuffer = await new Promise((resolve, reject) => {
                                    const reader = new FileReader();
                                    reader.onload = () => resolve(reader.result);
                                    reader.onerror = () => reject(reader.error);
                                    reader.readAsArrayBuffer(file);
                                });
                                const uint8Array = new Uint8Array(arrayBuffer);
                                const pdf = await pdfjsLib.getDocument({ data: uint8Array }).promise;
                                const page = await pdf.getPage(1);
                                const viewport = page.getViewport({ scale: 1.5 });
                                
                                const canvas = document.createElement('canvas');
                                const context = canvas.getContext('2d');
                                canvas.height = viewport.height;
                                canvas.width = viewport.width;
                                
                                await page.render({ canvasContext: context, viewport: viewport }).promise;
                                
                                imagePreview.src = canvas.toDataURL('image/jpeg');
                                imagePreview.style.display = 'inline-block';
                                fileMsg.textContent = "Current file: " + file.name;
                                if(submitBtn) submitBtn.disabled = false;
                            } catch (error) {
                                console.error("Error converting PDF to preview image:", error);
                                // Fallback: just show a PDF icon as preview
                                imagePreview.src = "https://cdn-icons-png.flaticon.com/512/337/337946.png";
                                imagePreview.style.display = 'inline-block';
                                fileMsg.textContent = "Current file: " + file.name;
                                if(submitBtn) submitBtn.disabled = false;
                            }
                        }
                    } else {
                        <%
                            String defaultMsg = "or drag and drop Image/PDF here";
                            if (designer != null && designer.getPortfolioURL() != null && !designer.getPortfolioURL().trim().isEmpty()) {
                                String urlStr = designer.getPortfolioURL();
                                int lastSlash = urlStr.lastIndexOf('/');
                                if (lastSlash != -1 && lastSlash < urlStr.length() - 1) {
                                    defaultMsg = "Current file: " + urlStr.substring(lastSlash + 1);
                                } else {
                                    defaultMsg = "Current file uploaded";
                                }
                            }
                        %>
                        fileMsg.textContent = "<%= defaultMsg %>";
                        imagePreview.src = '<%= previewUrl != null ? previewUrl : "" %>';
                        imagePreview.style.display = '<%= previewUrl != null && !previewUrl.isEmpty() ? "inline-block" : "none" %>';
                    }
                });
            }
        </script>
    
<script src="${pageContext.request.contextPath}/assets/js/lang.js" charset="UTF-8"></script>
</body>
</html>
