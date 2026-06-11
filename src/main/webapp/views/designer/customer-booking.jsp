<%--
    Customer Booking Page - Designer manages HIRE_DESIGNER orders
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    User loginUser = (User) session.getAttribute("LOGIN_USER");
    if (loginUser == null || loginUser.getRoleId() != 3) {
        response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
        return;
    }

    List<Map<String, Object>> bookingRequests = (List<Map<String, Object>>) request.getAttribute("BOOKING_REQUESTS");
    String toastMsg2 = (String) session.getAttribute("toastMessage");
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Customer Booking - Presenta</title>
        <link href="https://fonts.googleapis.com/css2?family=Pacifico&family=Be+Vietnam+Pro:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/assets/images/favicon/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-16x16.png">
        <link rel="manifest" href="${pageContext.request.contextPath}/assets/images/favicon/site.webmanifest">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon/favicon.ico">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer/designer-home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/toast.css">
        <style>
            .modal-overlay {
                position: fixed; top: 0; left: 0; width: 100%; height: 100%;
                background: rgba(0,0,0,0.7); display: flex; align-items: center;
                justify-content: center; z-index: 9999;
            }
            .modal-content {
                background: #1a1033; border-radius: 16px; padding: 32px;
                width: 90%; max-width: 460px; border: 1px solid rgba(255,255,255,0.1);
            }
            .status-processing { background: rgba(0, 117, 255, 0.15); color: #0075FF; }
            .status-completed { background: rgba(1, 181, 116, 0.15); color: #01B574; }
            .status-pending { background: rgba(251, 191, 36, 0.15); color: #FBBF24; }
            .status-rejected { background: rgba(239, 68, 68, 0.15); color: #EF4444; }
            .status-approved { background: rgba(1, 181, 116, 0.15); color: #01B574; }
            .status-badge {
                display: inline-block; padding: 4px 12px; border-radius: 12px;
                font-size: 12px; font-weight: 700;
            }
            .paging { display: flex; justify-content: center; gap: 8px; margin-top: 24px; }
            .paging a {
                padding: 8px 14px; border-radius: 8px; text-decoration: none; color: white;
                border: 1px solid rgba(255,255,255,0.2); font-size: 13px;
            }
            .paging a.active { background: #D8B4FF; color: #11052C; border-color: #D8B4FF; }
            .paging a:hover { background: rgba(255,255,255,0.1); }
        </style>
    </head>

    <body class="designer-body">

        <nav class="designer-navbar">
            <a href="${pageContext.request.contextPath}/MainController?action=DesignerHome" class="designer-brand">
                Presenta <span>DESIGNER</span>
            </a>

            <div class="designer-nav-links">
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerHome">Dashboard</a>
                <a href="${pageContext.request.contextPath}/MainController?action=ManageTemplate">Manage Templates</a>
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerWithdrawals">Withdrawals</a>
                <a href="${pageContext.request.contextPath}/MainController?action=CustomerBooking" class="active">Customer Booking</a>
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerProfile">Profile</a>
            </div>

            <div style="display: flex; align-items: center; gap: 20px;">
<button onclick="toggleLanguage()" class="lang-toggle-btn no-translate" style="background: transparent; border: 1px solid currentColor; color: inherit; padding: 4px 10px; border-radius: 20px; cursor: pointer; margin-right: 15px; font-weight: bold; white-space: nowrap;">EN/VI</button>

                <span style="font-size: 14px; color: #A0AEC0;">Welcome, <b style="color: white;"><%= loginUser.getUsername()%></b></span>
                <form action="${pageContext.request.contextPath}/MainController" method="POST" style="margin: 0;">
                    <input type="hidden" name="action" value="Logout">
                    <button type="submit" style="background: transparent; border: none; color: #A0AEC0; font-weight: 700; cursor: pointer;">Sign Out</button>
                </form>
            
</div>
        
</nav>

        <div class="designer-container">

            <div class="vision-card">
                <div class="panel-header">
                    Customer Booking Requests
                    <span style="font-size: 14px; color: #D8B4FF; font-weight: normal;">
                        <% if (bookingRequests != null) { %><%= bookingRequests.size()%> on this page<% } %>
                    </span>
                </div>

                <% if (bookingRequests != null && !bookingRequests.isEmpty()) { %>
                <table class="custom-table">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Customer</th>
                            <th>Date</th>
                            <th>Price</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Map<String, Object> br : bookingRequests) {
                            int orderId = (Integer) br.get("orderID");
                            String customerName = (String) br.get("customerName");
                            String status = (String) br.get("status");
                            double price = br.get("totalPrice") != null ? (Double) br.get("totalPrice") : 0.0;
                            java.sql.Timestamp createAt = (java.sql.Timestamp) br.get("createAt");
                            String dateStr = createAt != null ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(createAt) : "N/A";

                            String badgeClass = "status-pending";
                            if ("Processing".equals(status)) badgeClass = "status-processing";
                            else if ("Completed_Design".equals(status) || "Completed".equals(status)) badgeClass = "status-completed";
                            else if ("Cancelled".equals(status)) badgeClass = "status-rejected";
                        %>
                        <tr>
                            <td style="font-weight: 700; color: white;">#<%= orderId%></td>
                            <td style="color: white;"><%= customerName%></td>
                            <td style="color: #A0AEC0; font-size: 13px;"><%= dateStr%></td>
                            <td style="color: #D8B4FF; font-weight: 600;">
                                <%= price > 0 ? String.format("%,.0f₫", price) : "—"%>
                            </td>
                            <td><span class="status-badge <%= badgeClass%>"><%= status%></span></td>
                            <td>
                                <% if ("Pending".equals(status)) { %>
                                <div style="display: flex; gap: 6px;">
                                    <form action="${pageContext.request.contextPath}/MainController" method="POST" style="margin: 0;">
                                        <input type="hidden" name="action" value="AcceptBooking">
                                        <input type="hidden" name="orderID" value="<%= orderId%>">
                                        <input type="hidden" name="actionType" value="accept">
                                        <button type="submit" style="background: #01B574; color: white; border: none; padding: 6px 14px; border-radius: 6px; font-size: 12px; font-weight: 700; cursor: pointer;">Chấp Nhận</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/MainController" method="POST" style="margin: 0;">
                                        <input type="hidden" name="action" value="AcceptBooking">
                                        <input type="hidden" name="orderID" value="<%= orderId%>">
                                        <input type="hidden" name="actionType" value="reject">
                                        <button type="submit" style="background: #ef4444; color: white; border: none; padding: 6px 14px; border-radius: 6px; font-size: 12px; font-weight: 700; cursor: pointer;">Từ Chối</button>
                                    </form>
                                </div>
                                <% } else if ("Processing".equals(status)) { %>
                                <button onclick="openPaymentModal(<%= orderId%>)"
                                        style="background: #D8B4FF; color: #11052C; border: none; padding: 6px 14px; border-radius: 6px; font-size: 12px; font-weight: 700; cursor: pointer;">
                                    Gửi File & Yêu Cầu Thanh Toán
                                </button>
                                <% } else if ("Completed_Design".equals(status)) { %>
                                <span style="color: #fbbf24; font-size: 12px;">⏳ Chờ khách thanh toán</span>
                                <% } else if ("Completed".equals(status)) { %>
                                <span style="color: #01B574; font-size: 12px; font-weight: 700;">✓ Hoàn thành</span>
                                <% } else if ("Cancelled".equals(status)) { %>
                                <span style="color: #ef4444; font-size: 12px;">✕ Đã hủy</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>

                <%-- PAGING --%>
                <%
                    Integer tag = (Integer) request.getAttribute("tag");
                    Integer endPage = (Integer) request.getAttribute("endPage");
                    if (tag != null && endPage != null && endPage > 1) {
                %>
                <div class="paging">
                    <% for (int i = 1; i <= endPage; i++) { %>
                    <a href="MainController?action=CustomerBooking&page=<%= i%>" class="<%= (i == tag) ? "active" : ""%>">
                        <%= i%>
                    </a>
                    <% } %>
                </div>
                <% } %>

                <% } else { %>
                <div style="text-align: center; padding: 60px 40px; color: #A0AEC0;">
                    <div style="font-size: 48px; margin-bottom: 16px;">📋</div>
                    <p style="font-size: 16px; margin-bottom: 8px;">Chưa có yêu cầu đặt thiết kế nào.</p>
                    <p style="font-size: 14px;">Khi khách hàng đặt thiết kế riêng của bạn, chúng sẽ hiển thị ở đây.</p>
                </div>
                <% } %>
            </div>

        </div>

        <%-- ================================================ --%>
        <%-- PAYMENT REQUEST MODAL (Send File + Request $$$)  --%>
        <%-- ================================================ --%>
        <div id="paymentModal" class="modal-overlay" style="display: none;">
            <div class="modal-content">
                <h3 style="margin-top: 0; color: #ffffff;">Gửi File & Yêu Cầu Thanh Toán</h3>
                <form action="${pageContext.request.contextPath}/MainController" method="POST">
                    <input type="hidden" name="action" value="RequestPayment">
                    <input type="hidden" name="orderID" id="modalOrderID">

                    <label style="display:block; font-size:13px; color:#E2D7FF; font-weight:700; margin-bottom:8px;">Giá thiết kế (VNĐ)</label>
                    <input type="number" name="price" id="modalPrice" min="1000" step="1000" required
                           placeholder="VD: 500000"
                           style="width:100%; padding:12px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:16px; background:rgba(255,255,255,0.05); color:#ffffff; box-sizing: border-box;">

                    <label style="display:block; font-size:13px; color:#E2D7FF; font-weight:700; margin-bottom:8px;">Đường dẫn file thiết kế (URL)</label>
                    <input type="url" name="fileURL" id="modalFileURL" required
                           placeholder="VD: https://drive.google.com/..."
                           style="width:100%; padding:12px; border:1px solid rgba(255,255,255,0.1); border-radius:8px; margin-bottom:20px; background:rgba(255,255,255,0.05); color:#ffffff; box-sizing: border-box;">

                    <div style="display: flex; gap: 10px; justify-content: flex-end;">
                        <button type="button" onclick="closePaymentModal()"
                                style="background: rgba(255,255,255,0.1); color: #ffffff; padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; font-weight: 600;">Hủy</button>
                        <button type="submit"
                                style="background: #D8B4FF; color: #11052C; padding: 10px 24px; border: none; border-radius: 8px; cursor: pointer; font-weight: 700;">Gửi & Yêu Cầu Thanh Toán</button>
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

        <% if (toastMsg2 != null) { %>
        <div id="toastAlert" class="toast-msg"><%= toastMsg2%></div>
        <% session.removeAttribute("toastMessage"); } %>

        <script>
            function openPaymentModal(orderId) {
                document.getElementById('modalOrderID').value = orderId;
                document.getElementById('paymentModal').style.display = 'flex';
            }
            function closePaymentModal() {
                document.getElementById('paymentModal').style.display = 'none';
            }
            document.getElementById('paymentModal').addEventListener('click', function(e) {
                if (e.target === this) closePaymentModal();
            });
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
    
<script src="${pageContext.request.contextPath}/assets/js/lang.js" charset="UTF-8"></script>
</body>
</html>
