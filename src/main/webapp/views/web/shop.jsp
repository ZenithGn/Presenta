<%-- 
    Document   : shop
    Created on : May 26, 2026, 3:21:26 PM
    Author     : lehan
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.model.Category" %>
<%@ page import="com.model.Template" %>
<%@ page import="com.model.User" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Shop - Presenta</title>
        <link href="https://fonts.googleapis.com/css2?family=Pacifico&family=Be+Vietnam+Pro:wght@400;500;700;800&display=swap" rel="stylesheet">
        <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/assets/images/favicon/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-16x16.png">
        <link rel="manifest" href="${pageContext.request.contextPath}/assets/images/favicon/site.webmanifest">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon/favicon.ico">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css"> 
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shop.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer-hub.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/toast.css?v=1.0">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@1,700&display=swap" rel="stylesheet">
    </head>


    <%
        // 1. Lấy thông tin User đăng nhập và phân quyền để hiển thị Navbar tương ứng
        User loginUser = (User) session.getAttribute("LOGIN_USER");
        int roleId = (loginUser != null) ? loginUser.getRoleId() : 0; // 0 = Khách, 2 = Customer, 3 = Designer

        // 2. Ép kiểu dữ liệu lấy từ Request (do ShopController gửi sang)
        List<Category> listCategories = (List<Category>) request.getAttribute("listCategories");
        List<Template> historyTemplates = (List<Template>) request.getAttribute("historyTemplates");
        List<Template> recommendTemplates = (List<Template>) request.getAttribute("recommendTemplates");
    %>
    <body class="<%= (roleId == 0 || roleId == 2) ? "landing-body" : ""%>">
        <%-- ======================================================= --%>
        <%-- NAVIGATION BARS (DYNAMIC BASED ON ROLE)                 --%>
        <%-- ======================================================= --%>
        <% if (roleId == 0 || roleId == 2) { %>
        <nav class="navbar" style="border-bottom: none; background: transparent;">
            <a href="${pageContext.request.contextPath}/MainController" class="nav-brand" style="font-family: 'Pacifico', cursive; font-size: 28px;">Presenta</a>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/MainController">HOME</a>
                <a href="${pageContext.request.contextPath}/MainController?action=Shop" class="active">SHOP</a>
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
        <%-- SHOP MAIN CONTENT AREA                                  --%>
        <%-- ======================================================= --%>
        <div class="shop-body-wrapper">
            <div class="shop-container">

                <h1 class="hub-title-script" style="margin-bottom: 40px; text-align: center"> Shop</h1>

                    <%
                        // Nhận object bestTemplate từ Controller
                        Template bestTemplate = (Template) request.getAttribute("bestTemplate");

                        // Nếu có sản phẩm hot thì mới render Banner
                        if (bestTemplate != null) {
                            // Xử lý ảnh (dùng ảnh mờ nếu thumbnail rỗng)
                            String heroImg = (bestTemplate.getThumbnailURL() != null && !bestTemplate.getThumbnailURL().trim().isEmpty())
                                    ? bestTemplate.getThumbnailURL()
                                    : "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=400";
                    %>
                    <section class="shop-hero-card">
                    <div class="hero-content">
                        <h2>Best Of<br>The Week</h2>
                        <h3 style="color: var(--primary); margin-bottom: 8px; font-size: 24px;"><%= bestTemplate.getTitle()%></h3>

                        <form action="MainController" method="POST" style="margin:0;">
                            <input type="hidden" name="action" value="AddToCart">
                            <input type="hidden" name="templateID" value="<%= bestTemplate.getTemplateID()%>">
                            <button type="submit" class="btn-primary" style="background: white; color: black; padding: 12px 32px; border-radius: 999px; text-decoration: none; font-weight: 700; border: none; cursor: pointer;">
                                Get It Now - <%= (int) (bestTemplate.getPrice() / 1000)%>k
                            </button>
                        </form>
                    </div>
                    <div class="hero-image">
                        <div style="width: 400px; height: 350px; background: url('<%= heroImg%>') center/cover; border-radius: 24px; box-shadow: 0 10px 30px rgba(0,0,0,0.5);"></div>
                    </div>
                    </section>
                    <%
                        } // Kết thúc if check null
                    %>

                    <%
                        // Lấy các tham số trạng thái từ Controller
                        String keyword = (String) request.getAttribute("saveKeyword");
                        int categoryID = request.getAttribute("saveCategoryID") != null ? (Integer) request.getAttribute("saveCategoryID") : 0;
                        int endPage = request.getAttribute("endPage") != null ? (Integer) request.getAttribute("endPage") : 0;
                        int tag = request.getAttribute("tag") != null ? (Integer) request.getAttribute("tag") : 1;
                        String priceSort = (String) request.getAttribute("savePriceSort");
                        if (priceSort == null) {
                            priceSort = "";
                        }

                        List<Template> listTemplates = (List<Template>) request.getAttribute("listTemplates");
                    %>

                    <section class="shop-filter-section" id="shop-content">
                        <form action="MainController" method="GET" style="width: 100%; max-width: 600px; display: flex; gap: 12px; margin-bottom: 24px;">
                            <input type="hidden" name="action" value="Shop">
                            <input type="hidden" name="categoryID" value="<%= categoryID%>">
                            <input type="hidden" name="priceSort" value="<%= priceSort%>">

                            <input type="text" name="keyword" value="<%= keyword%>" class="shop-search-bar" placeholder="Search templates... 🔍" style="margin-bottom: 0; flex: 1;">
                            <button type="submit" class="btn-primary" style="border-radius: 999px; padding: 0 32px;">Search</button>
                        </form>

                        <div class="shop-category-chips">
                            <a href="MainController?action=Shop&keyword=<%= keyword%>&categoryID=0&priceSort=<%= priceSort%>"
                               class="chip-btn <%= (categoryID == 0) ? "active" : ""%>" style="text-decoration: none;">
                                All Templates
                            </a>

                            <%
                                if (listCategories != null && !listCategories.isEmpty()) {
                                    for (Category cat : listCategories) {
                            %>
                            <a href="MainController?action=Shop&keyword=<%= keyword%>&categoryID=<%= cat.getCategoryID()%>&priceSort=<%= priceSort%>"
                               class="chip-btn <%= (categoryID == cat.getCategoryID()) ? "active" : ""%>" style="text-decoration: none;">
                                <%= cat.getCategoryName()%>
                            </a>
                            <%
                                    }
                                }
                            %>
                        </div>

                        <%-- SORT BUTTONS --%>
                        <div style="display: flex; gap: 8px; margin-top: 16px;">
                            <span style="color: #A0AEC0; font-size: 13px; align-self: center;">Sort by price:</span>
                            <a href="MainController?action=Shop&keyword=<%= keyword%>&categoryID=<%= categoryID%>&priceSort=asc"
                               class="chip-btn <%= "asc".equals(priceSort) ? "active" : ""%>" style="text-decoration: none;">
                                ⬆ Ascending
                            </a>
                            <a href="MainController?action=Shop&keyword=<%= keyword%>&categoryID=<%= categoryID%>&priceSort=desc"
                               class="chip-btn <%= "desc".equals(priceSort) ? "active" : ""%>" style="text-decoration: none;">
                                ⬇ Descending
                            </a>
                        </div>
                    </section>

                    <section class="shop-category-section">
                        <div class="shop-section-header">
                            <h2 class="shop-section-title">
                                <%= (categoryID == 0) ? "All Products" : "Filtered Results"%>
                                <%= (!keyword.isEmpty()) ? " - Search: '" + keyword + "'" : ""%>
                            </h2>
                        </div>

                        <div class="product-grid">
                            <%
                                if (listTemplates != null && !listTemplates.isEmpty()) {
                                    for (Template t : listTemplates) {
                                        String thumb = (t.getThumbnailURL() != null && !t.getThumbnailURL().trim().isEmpty())
                                                ? t.getThumbnailURL()
                                                : "https://images.unsplash.com/photo-1505664194779-8beaceb93744?q=80&w=400";
                            %>
                            <div class="product-card">
                                <img src="<%= thumb%>" class="product-img" alt="Template">
                                <div class="product-info">
                                    <span class="product-title"><%= t.getTitle()%></span>
                                    <span class="product-price"><%= (int) (t.getPrice() / 1000)%>k</span>
                                </div>
                                <p class="product-desc"><%= (t.getDescription() != null) ? t.getDescription() : ""%></p>

                                <div class="card-actions" style="display: flex; gap: 8px; flex-wrap: wrap; margin-top: 16px;">
                                    <% if (t.getPrice() == 0) { %>
                                    <form action="MainController" method="GET" style="flex: 1; min-width: 100%; margin:0;">
                                        <input type="hidden" name="action" value="TemplateDetail">
                                        <input type="hidden" name="templateID" value="<%= t.getTemplateID()%>">
                                        <button type="submit" class="btn-card btn-dark" style="width:100%;">VIEW DETAIL</button>
                                    </form>
                                    <form action="MainController" method="POST" style="flex: 1; min-width: 100%; margin:0; margin-top: 4px;">
                                        <input type="hidden" name="action" value="GetFreeTemplate">
                                        <input type="hidden" name="templateID" value="<%= t.getTemplateID()%>">
                                        <button type="submit" class="btn-card" style="width:100%; background: #01B574; color: white; border: none; cursor:pointer;">GET NOW</button>
                                    </form>
                                    <% } else { %>
                                    <form action="MainController" method="GET" style="flex: 1; min-width: 45%; margin:0;">
                                        <input type="hidden" name="action" value="TemplateDetail">
                                        <input type="hidden" name="templateID" value="<%= t.getTemplateID()%>">
                                        <button type="submit" class="btn-card btn-dark" style="width:100%;">VIEW DETAIL</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/MainController?action=AddCart&id=<%= t.getTemplateID()%>" method="POST" style="flex: 1; min-width: 45%; margin:0;">
                                        <input type="hidden" name="action" value="AddToCart">
                                        <input type="hidden" name="templateID" value="<%= t.getTemplateID()%>">
                                        <button type="submit" class="btn-card btn-dark" style="width:100%;">ADD TO CART</button>
                                    </form>

                                    <form action="MainController" method="POST" style="flex: 1; min-width: 100%; margin:0; margin-top: 4px;">
                                        <input type="hidden" name="action" value="BuyNow">
                                        <input type="hidden" name="templateID" value="<%= t.getTemplateID()%>">
                                        <button type="submit" class="btn-card" style="width:100%; border:none; cursor:pointer;">Buy Now</button>
                                    </form>
                                    <% } %>
                                </div>
                            </div>
                            <%
                                }
                            } else {
                            %>
                            <p style="color: #ccc3d8; text-align: center; width: 100%; grid-column: 1 / -1;">
                                Không tìm thấy sản phẩm nào phù hợp với yêu cầu của bạn.
                            </p>
                            <%
                                }
                            %>
                        </div>

                        <% if (endPage > 1) { %>
                        <div class="pagination-container" style="display: flex; justify-content: center; align-items: center; gap: 8px; margin-top: 40px;">

                            <% if (tag > 1) {%>
                            <a href="MainController?action=Shop&priceSort=<%= priceSort%>&index=<%= tag - 1%>&keyword=<%= keyword%>&categoryID=<%= categoryID%>" 
                               class="btn-outline" style="padding: 8px 16px; border-radius: 8px; font-size: 14px; text-decoration: none;">&laquo; Prev</a>
                            <% } %>

                            <% for (int i = 1; i <= endPage; i++) {%>
                            <a href="MainController?action=Shop&priceSort=<%= priceSort%>&index=<%= i%>&keyword=<%= keyword%>&categoryID=<%= categoryID%>" 
                               class="<%= (i == tag) ? "btn-primary" : "btn-outline"%>" 
                               style="padding: 8px 16px; border-radius: 8px; font-size: 14px; text-decoration: none;">
                                <%= i%>
                            </a>
                            <% } %>

                            <% if (tag < endPage) {%>
                            <a href="MainController?action=Shop&priceSort=<%= priceSort%>&index=<%= tag + 1%>&keyword=<%= keyword%>&categoryID=<%= categoryID%>" 
                               class="btn-outline" style="padding: 8px 16px; border-radius: 8px; font-size: 14px; text-decoration: none;">Next &raquo;</a>
                            <% } %>
                        </div>
                        <% }%>
                    </section>

            </div>
        </div>

        <%
            String toastMsg = (String) session.getAttribute("toastMessage");
            if (toastMsg != null) {
        %>
        <div id="custom-toast" class="show">
            <span class="toast-icon">✔️</span>
            <span class="toast-text"><%= toastMsg%></span>
        </div>
        <%
                session.removeAttribute("toastMessage");
            }
        %>
        <%-- ======================================================= --%>
        <%-- FOOTER SECTION                                          --%>
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

            </div> 
            <div class="footer-bottom">
                <div class="footer-bottom-container">
                    <p>&copy; 2026 Presenta. All rights reserved.</p>
                </div>
            </div>
        </footer>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js?v=1.0"></script>
        <script src="${pageContext.request.contextPath}/assets/js/shop.js"></script>
    
<script src="${pageContext.request.contextPath}/assets/js/lang.js" charset="UTF-8"></script>
</body>
</html>