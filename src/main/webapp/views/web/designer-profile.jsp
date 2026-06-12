<%-- 
    Document   : designer-profile
    Created on : May 28, 2026, 12:34:24 AM
    Author     : lehan
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.model.Designer" %>
<%@ page import="com.model.Template" %>
<%@ page import="com.model.Review" %>
<%@ page import="com.model.User" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Designer Profile - Presenta</title>
        <link href="https://fonts.googleapis.com/css2?family=Pacifico&family=Be+Vietnam+Pro:wght@400;500;700;800&display=swap" rel="stylesheet">
        <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/assets/images/favicon/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-16x16.png">
        <link rel="manifest" href="${pageContext.request.contextPath}/assets/images/favicon/site.webmanifest">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon/favicon.ico">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shop.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer-profile.css?v=2.0">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/toast.css?v=1.0">
    </head>

    <%
        User loginUser = (User) session.getAttribute("LOGIN_USER");
        int roleId = (loginUser != null) ? loginUser.getRoleId() : 0;

        Designer designer = (Designer) request.getAttribute("designer");
        List<Template> templates = (List<Template>) request.getAttribute("templates");
        List<Review> reviews = (List<Review>) request.getAttribute("reviews");

        Integer templatesSoldObj = (Integer) request.getAttribute("templatesSold");
        int templatesSold = (templatesSoldObj != null) ? templatesSoldObj : 0;

        Double avgRatingObj = (Double) request.getAttribute("avgRating");
        double avgRating = (avgRatingObj != null) ? avgRatingObj : 0.0;

        Integer totalReviewsObj = (Integer) request.getAttribute("totalReviews");
        int totalReviews = (totalReviewsObj != null) ? totalReviewsObj : 0;

        Integer satisfactionRateObj = (Integer) request.getAttribute("satisfactionRate");
        int satisfactionRate = (satisfactionRateObj != null) ? satisfactionRateObj : 0;

        String designerPhone = (String) request.getAttribute("designerPhone");
        if (designerPhone == null) designerPhone = "";

        if (designer == null) {
            response.sendRedirect("MainController?action=DesignerList");
            return;
        }

        String avatar = (designer.getAvatarURL() != null && !designer.getAvatarURL().trim().isEmpty())
                ? designer.getAvatarURL()
                : "https://ui-avatars.com/api/?name=" + designer.getUserName() + "&background=7C3AED&color=fff";
    %>

    <body class="landing-body">

        <%-- ======================================================= --%>
        <%-- NAVBAR                                                  --%>
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
        <% } %>

        <%-- ======================================================= --%>
        <%-- HERO BANNER                                             --%>
        <%-- ======================================================= --%>
        <section class="dp-hero">
            <div class="dp-hero-orb"></div>
            <div class="dp-hero-inner">
                <div class="dp-avatar" id="heroAvatar">
                    <img src="<%= avatar%>" alt="<%= designer.getUserName()%>">
                </div>
                <div class="dp-hero-text" id="heroText">
                    <h1><%= designer.getUserName()%></h1>
                    <p class="dp-tagline">Motion & Interaction & Academic Presentation Designer</p>
                    <div class="dp-hero-actions">
                        <% if (roleId == 2) { %>
                        <form action="${pageContext.request.contextPath}/MainController" method="POST" style="margin: 0;" onsubmit="return confirm(localStorage.getItem('lang') === 'en' ? 'Are you sure you want to hire this designer?' : 'Bạn có chắc chắn muốn thuê designer này không?');">
                            <input type="hidden" name="action" value="BookDesigner">
                            <input type="hidden" name="designerID" value="<%= designer.getUserID()%>">
                            <button type="submit" class="btn-primary">Book Now</button>
                        </form>
                        <% } else if (roleId == 0) { %>
                        <a href="${pageContext.request.contextPath}/MainController?action=Login" class="btn-primary">Book Now</a>
                        <% } %>
                        <% if (!designerPhone.isEmpty()) { %>
                        <a href="https://zalo.me/<%= designerPhone.replaceAll("[^0-9]", "")%>" target="_blank" class="btn-outline" style="border-color: rgba(255,255,255,0.4); color: white;">Contact</a>
                        <% } else { %>
                        <a href="#" class="btn-outline" style="border-color: rgba(255,255,255,0.2); color: white; opacity: 0.5; pointer-events: none;">Contact</a>
                        <% } %>
                        <% if (designer.getPortfolioURL() != null && !designer.getPortfolioURL().trim().isEmpty()) { %>
                        <a href="#portfolioSection" class="btn-outline" style="border-color: #D8B4FF; color: #D8B4FF;">View Portfolio</a>
                        <% } %>
                    </div>
                </div>
            </div>
        </section>

        <%-- ======================================================= --%>
        <%-- STATS BAR                                               --%>
        <%-- ======================================================= --%>
        <div class="dp-stats-bar" id="statsBar">
            <div class="dp-stats-inner">
                <div class="dp-stat">
                    <div class="dp-stat-value"><%= totalReviews > 0 ? String.format("%.1f", avgRating) : "0"%></div>
                    <div class="dp-stat-label">Rating</div>
                </div>
                <div class="dp-stat">
                    <div class="dp-stat-value"><%= totalReviews%></div>
                    <div class="dp-stat-label">Reviews</div>
                </div>
                <div class="dp-stat">
                    <div class="dp-stat-value"><%= templatesSold%></div>
                    <div class="dp-stat-label">Templates Sold</div>
                </div>
                <div class="dp-stat">
                    <div class="dp-stat-value"><%= satisfactionRate%>%</div>
                    <div class="dp-stat-label">Satisfaction</div>
                </div>
            </div>
        </div>

        <%-- ======================================================= --%>
        <%-- ABOUT                                                   --%>
        <%-- ======================================================= --%>
        <div class="dp-about" id="aboutSection">
            <div class="dp-about-card">
                <h3>About</h3>
                <p><%= (designer.getBio() != null && !designer.getBio().trim().isEmpty()) ? designer.getBio() : "This designer has not added a bio yet."%></p>
            </div>
        </div>

        <%-- ======================================================= --%>
        <%-- PORTFOLIO                                               --%>
        <%-- ======================================================= --%>
        <% if (designer.getPortfolioURL() != null && !designer.getPortfolioURL().trim().isEmpty()) { 
            String pUrl = designer.getPortfolioURL();
            String pUrlLower = pUrl.toLowerCase();
            
            // If it is a Cloudinary-hosted PDF file, dynamically convert it to a JPG url
            if (pUrlLower.endsWith(".pdf") && pUrlLower.contains("res.cloudinary.com")) {
                int lastDot = pUrl.lastIndexOf('.');
                if (lastDot != -1) {
                    pUrl = pUrl.substring(0, lastDot) + ".jpg";
                    pUrlLower = pUrl.toLowerCase();
                }
            }
            
            boolean isPdf = pUrlLower.endsWith(".pdf");
            boolean isImage = pUrlLower.endsWith(".png") || pUrlLower.endsWith(".jpg") || pUrlLower.endsWith(".jpeg") || pUrlLower.endsWith(".gif") || pUrlLower.endsWith(".webp") || pUrlLower.contains("res.cloudinary.com");
        %>
        <div class="dp-section-header">
            <h2>Portfolio</h2>
            <div class="dp-section-line"></div>
        </div>
        <div class="dp-portfolio" id="portfolioSection" style="margin-bottom: 60px; max-width: 1000px; margin-left: auto; margin-right: auto; padding: 0 20px; text-align: center;">
            <% if (isPdf) { %>
                <iframe src="https://docs.google.com/gview?url=<%= pUrl %>&embedded=true" width="100%" height="800px" style="border-radius: 12px; border: 1px solid rgba(255,255,255,0.1);"></iframe>
            <% } else if (isImage && !pUrlLower.contains("behance.net") && !pUrlLower.contains("dribbble.com") && !pUrlLower.contains("drive.google.com")) { %>
                <img src="<%= pUrl %>" alt="Portfolio" style="max-width: 100%; height: auto; border-radius: 12px; border: 1px solid rgba(255,255,255,0.1); display: block; margin: 0 auto;">
            <% } else { %>
                <a href="<%= pUrl %>" target="_blank" class="btn-outline" style="padding: 12px 32px; border-radius: 999px; color: white; border-color: rgba(255,255,255,0.3); display: inline-block;">
                    View External Portfolio &rarr;
                </a>
            <% } %>
        </div>
        <% } %>

        <%-- ======================================================= --%>
        <%-- TEMPLATES BY THIS DESIGNER                              --%>
        <%-- ======================================================= --%>
        <div class="dp-section-header">
            <h2>Template By This Designer</h2>
            <div class="dp-section-line"></div>
        </div>

        <div class="dp-templates" id="templatesSection">
            <div class="product-grid" style="margin-bottom: 0;">
                <%
                    if (templates != null && !templates.isEmpty()) {
                        for (Template t : templates) {
                            String tThumb = (t.getThumbnailURL() != null) ? t.getThumbnailURL() : "https://images.unsplash.com/photo-1614850523459-c2f4c699c52e?q=80&w=400";
                %>
                <div class="product-card">
                    <img src="<%= tThumb%>" class="product-img" alt="<%= t.getTitle()%>">
                    <div class="product-info">
                        <span class="product-title"><%= t.getTitle()%></span>
                        <span class="product-price"><%= (int) (t.getPrice() / 1000)%>k</span>
                    </div>
                    <div class="card-actions" style="margin-top: 16px;">
                        <a href="MainController?action=TemplateDetail&templateID=<%= t.getTemplateID()%>" class="btn-card btn-white" style="text-decoration:none; display:block; width:100%;">View Detail</a>
                        <a href="${pageContext.request.contextPath}/MainController?action=AddCart&id=<%= t.getTemplateID()%>" class="btn-card btn-dark" style="text-decoration:none; display:block; width:100%;">Add To Cart</a>
                    </div>
                </div>
                <%      }
                    } else { %>
                <p style="color: rgba(255,255,255,0.4); grid-column: span 3; text-align: center;">This designer has no templates for sale yet.</p>
                <%  } %>
            </div>
        </div>

        <%-- ======================================================= --%>
        <%-- CLIENT REVIEWS                                          --%>
        <%-- ======================================================= --%>
        <div class="dp-section-header">
            <h2>Client Reviews</h2>
            <div class="dp-section-line"></div>
        </div>

        <div class="dp-reviews" id="reviewsSection">
            <div class="review-grid" id="reviewContainer">
                <%
                    if (reviews != null && !reviews.isEmpty()) {
                        int count = 0;
                        for (Review r : reviews) {
                            String hiddenClass = (count >= 4) ? "review-hidden" : "";
                %>
                <div class="review-card js-review-item <%= hiddenClass%>">
                    <div class="review-stars">
                        <% for (int i = 0; i < r.getRating(); i++) {
                                out.print("\u2605 ");
                            }%>
                    </div>
                    <div class="review-text">"<%= r.getComment()%>"</div>
                    <div class="review-user"><%= r.getCustomerName()%></div>
                </div>
                <%
                            count++;
                        }
                    } else {
                %>
                <p style="color: rgba(255,255,255,0.4); grid-column: span 2; text-align: center;">No reviews yet.</p>
                <%  } %>
            </div>
        </div>

        <% if (reviews != null && reviews.size() > 4) { %>
        <div class="dp-reviews-more">
            <button id="btnLoadMore" onclick="loadMoreReviews()" class="btn-outline" style="padding: 12px 40px; border-radius: 999px; color: white; border-color: rgba(255,255,255,0.3);">View More Reviews</button>
        </div>
        <% } else { %>
        <div style="margin-bottom: 96px;"></div>
        <% }%>

        <%-- ======================================================= --%>
        <%-- TOAST                                                   --%>
        <%-- ======================================================= --%>
        <%
            String toastMsg = (String) session.getAttribute("toastMessage");
            if (toastMsg != null) {
        %>
        <div id="custom-toast" class="show">
            <span class="toast-icon">&#10004;&#65039;</span>
            <span class="toast-text"><%= toastMsg%></span>
        </div>
        <%
                session.removeAttribute("toastMessage");
            }
        %>

        <%-- ======================================================= --%>
        <%-- FOOTER                                                  --%>
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

        <%-- ======================================================= --%>
        <%-- SCRIPTS                                                 --%>
        <%-- ======================================================= --%>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js?v=1.0"></script>
        <script src="${pageContext.request.contextPath}/assets/js/designer-profile.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/lang.js" charset="UTF-8"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/ScrollTrigger.min.js"></script>
        <script>
            gsap.registerPlugin(ScrollTrigger);

            /* ---- Hero entrance ---- */
            const heroTl = gsap.timeline({ defaults: { ease: "power3.out" } });
            heroTl
                .from("#heroAvatar", { opacity: 0, scale: 0.7, y: 40, duration: 1 })
                .from("#heroText h1", { opacity: 0, y: 50, duration: 0.8 }, "-=0.6")
                .from("#heroText .dp-tagline", { opacity: 0, y: 30, duration: 0.6 }, "-=0.5")
                .from("#heroText .dp-hero-actions", { opacity: 0, y: 20, duration: 0.5 }, "-=0.3")
                .from(".dp-hero-orb", { opacity: 0, scale: 0.5, duration: 1.2, ease: "power2.out" }, 0);

            /* ---- Stats bar counter ---- */
            gsap.from("#statsBar", {
                scrollTrigger: { trigger: "#statsBar", start: "top 90%" },
                opacity: 0, y: 40, duration: 0.8, ease: "power2.out"
            });

            gsap.from(".dp-stat", {
                scrollTrigger: { trigger: "#statsBar", start: "top 90%" },
                opacity: 0, y: 30, duration: 0.6, stagger: 0.1, ease: "power2.out"
            });

            /* ---- About card ---- */
            gsap.from("#aboutSection .dp-about-card", {
                scrollTrigger: { trigger: "#aboutSection", start: "top 85%" },
                opacity: 0, y: 40, duration: 0.7, ease: "power2.out"
            });

            /* ---- Section headers ---- */
            gsap.utils.toArray(".dp-section-header").forEach(function(header) {
                gsap.from(header, {
                    scrollTrigger: { trigger: header, start: "top 88%" },
                    opacity: 0, x: -30, duration: 0.6, ease: "power2.out"
                });
            });

            /* ---- Template cards stagger ---- */
            gsap.from("#templatesSection .product-card", {
                scrollTrigger: { trigger: "#templatesSection", start: "top 85%" },
                opacity: 0, y: 50, scale: 0.95, duration: 0.6, stagger: 0.12, ease: "power2.out"
            });

            /* ---- Review cards stagger ---- */
            gsap.from("#reviewsSection .js-review-item", {
                scrollTrigger: { trigger: "#reviewsSection", start: "top 85%" },
                opacity: 0, y: 50, duration: 0.6, stagger: 0.12, ease: "power2.out"
            });
        </script>
    </body>
</html>