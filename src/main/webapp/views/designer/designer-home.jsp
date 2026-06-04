<%-- 
    Document   : designer-home
    Created on : Jun 2, 2026, 10:31:32 AM
    Author     : lehan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%    User loginUser = (User) session.getAttribute("LOGIN_USER");
    if (loginUser == null || loginUser.getRoleId() != 3) {
        response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
        return;
    }
    List<Map<String, Object>> recentSales = (List<Map<String, Object>>) request.getAttribute("RECENT_SALES");
    List<Map<String, Object>> withdrawalHistory = (List<Map<String, Object>>) request.getAttribute("WITHDRAWAL_HISTORY");
    List<Map<String, Object>> bookingRequests = (List<Map<String, Object>>) request.getAttribute("BOOKING_REQUESTS");
    String toastMsg2 = (String) session.getAttribute("toastMessage");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Designer Workspace - Presenta</title>
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
                width: 90%; border: 1px solid rgba(255,255,255,0.1);
            }
            .status-processing { background: rgba(0, 117, 255, 0.15); color: #0075FF; }
            .status-completed { background: rgba(1, 181, 116, 0.15); color: #01B574; }
            .status-pending { background: rgba(251, 191, 36, 0.15); color: #FBBF24; }
            .status-rejected { background: rgba(239, 68, 68, 0.15); color: #EF4444; }
        </style>
    </head>

    <body class="designer-body">

        <nav class="designer-navbar">
            <a href="${pageContext.request.contextPath}/MainController?action=DesignerHome" class="designer-brand">
                Presenta <span>DESIGNER</span>
            </a>

            <div class="designer-nav-links">
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerHome" class="active">Dashboard</a>
                <a href="${pageContext.request.contextPath}/MainController?action=ManageTemplate">Manage Templates</a>
                <a href="#">Withdrawals</a>
                <a href="#">Orders</a>
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerProfile">Profile</a>
            </div>

            <div style="display: flex; align-items: center; gap: 20px;">
                <span style="font-size: 14px; color: #A0AEC0;">Welcome, <b style="color: white;"><%= loginUser.getUsername()%></b></span>
                <form action="${pageContext.request.contextPath}/MainController" method="POST" style="margin: 0;">
                    <input type="hidden" name="action" value="Logout">
                    <button type="submit" style="background: transparent; border: none; color: #A0AEC0; font-weight: 700; cursor: pointer;">Sign Out</button>
                </form>
            </div>
        </nav>

        <div class="designer-container">

            <%-- Đọc các thông số từ Controller gửi sang --%>
            <%
                // Ép kiểu dữ liệu và kiểm tra tránh lỗi NullPointerException
                Double balance = (Double) request.getAttribute("DESIGNER_BALANCE");
                Integer activeTemplates = (Integer) request.getAttribute("ACTIVE_TEMPLATES");
                Integer templatesSold = (Integer) request.getAttribute("TEMPLATES_SOLD");
                Double pendingPayouts = (Double) request.getAttribute("PENDING_PAYOUTS");

                // Định dạng hiển thị mặc định nếu null
                double displayBalance = (balance != null) ? balance : 0.0;
                int displayActive = (activeTemplates != null) ? activeTemplates : 0;
                int displaySold = (templatesSold != null) ? templatesSold : 0;
                double displayPending = (pendingPayouts != null) ? pendingPayouts : 0.0;
            %>

            <div class="stats-grid">
                <div class="vision-card stat-card">
                    <div class="stat-info">
                        <span class="stat-title">Total Balance</span>
                        <div class="stat-value"><%= String.format("%,.0f", displayBalance)%>₫</div>
                    </div>
                    <div class="stat-icon">💰</div>
                </div>

                <div class="vision-card stat-card">
                    <div class="stat-info">
                        <span class="stat-title">Active Templates</span>
                        <div class="stat-value"><%= displayActive%> <span class="stat-trend" style="color: #A0AEC0; font-weight: normal;">items</span></div>
                    </div>
                    <div class="stat-icon">📄</div>
                </div>

                <div class="vision-card stat-card">
                    <div class="stat-info">
                        <span class="stat-title">Templates Sold</span>
                        <div class="stat-value"><%= displaySold%> <span class="stat-trend" style="color: #A0AEC0; font-weight: normal;">sales</span></div>
                    </div>
                    <div class="stat-icon">🛒</div>
                </div>

                <div class="vision-card stat-card">
                    <div class="stat-info">
                        <span class="stat-title">Pending Payouts</span>
                        <div class="stat-value"><%= String.format("%,.0f", displayPending)%>₫</div>
                    </div>
                    <div class="stat-icon">💳</div>
                </div>
            </div>

            <div class="dashboard-grid">
                <div class="vision-card welcome-card" style="background: url('${pageContext.request.contextPath}/assets/images/designer-bg.jpg') center/cover;backdrop-filter: blur(6px); ">

                    <div class="welcome-content">
                        <p>Welcome back,</p>
                        <h2><%= loginUser.getUsername()%></h2>
                        <p class="sub-text">Glad to see you again! Track your template sales, monitor withdrawal requests, and execute your balance transfers.</p>
                    </div>
                    <div class="welcome-content" style="margin-top: 32px;">
                        <a href="#" style="color: white; font-weight: 700; text-decoration: none; font-size: 14px;">Tap to record →</a>
                    </div>

                </div>

                <div class="vision-card" style="display: flex; flex-direction: column; justify-content: center; align-items: center; text-align: center;">
                    <div style="width: 80px; height: 80px; background: rgba(0, 117, 255, 0.2); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-bottom: 24px;">
                        <span style="font-size: 32px;">💸</span>
                    </div>
                    <h3 style="color: white; margin-bottom: 8px; font-size: 20px;">Need a Payout?</h3>
                    <p style="color: #A0AEC0; font-size: 14px; margin-bottom: 24px;">Withdraw your earnings directly to your bank account securely.</p>
                    <a href="#" class="btn-vision" style="width: 80%;">Create New Request</a>
                </div>
            </div>

            <div class="dashboard-grid" style="grid-template-columns: 1fr 1fr;">
                <div class="vision-card">
                    <div class="panel-header">
                        Recent Sales
                        <span style="font-size: 14px; color: #01B574; font-weight: normal;">+<%= displaySold%> done this month</span>
                    </div>

                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th>Item / Type</th>
                                <th>Price</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (recentSales != null && !recentSales.isEmpty()) {
                                    for (Map<String, Object> sale : recentSales) {
                                        double price = (Double) sale.get("price");
                                        String status = (String) sale.get("status");
                                        // Set class CSS dựa theo status
                                        String badgeClass = "status-completed";
                                        if (status.equals("Pending")) {
                                            badgeClass = "status-pending";
                                        }
                                        if (status.equals("Cancelled"))
                                            badgeClass = "status-rejected";
                            %>
                            <tr>
                                <td>
                                    <div style="font-weight: 700; color: white;"><%= sale.get("itemName")%></div>
                                    <div style="font-size: 12px; color: #A0AEC0;"><%= sale.get("itemType")%> (ID: <%= sale.get("orderID")%>)</div>
                                </td>
                                <td style="color: white; font-weight: 600;"><%= String.format("%,.0f", price)%>₫</td>
                                <td><span class="status-badge <%= badgeClass%>"><%= status%></span></td>
                            </tr>
                            <%
                                }
                            } else {
                            %>
                            <tr><td colspan="3" style="text-align: center; color: #A0AEC0;">No recent sales found.</td></tr>
                            <% }%>
                        </tbody>
                    </table>
                </div>

                <div class="vision-card">
                    <div class="panel-header">
                        Withdrawal History
                        <a href="#" style="font-size: 12px; color: #0075FF; text-decoration: none; font-weight: bold;">View All</a>
                    </div>

                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th>Bank Details</th>
                                <th>Amount</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (withdrawalHistory != null && !withdrawalHistory.isEmpty()) {
                                    for (Map<String, Object> w : withdrawalHistory) {
                                        double amount = (Double) w.get("amount");
                                        String status = (String) w.get("status");
                                        String badgeClass = "status-pending";
                                        if (status.equals("Approved")) {
                                            badgeClass = "status-approved";
                                        }
                                        if (status.equals("Rejected")) {
                                            badgeClass = "status-rejected";
                                        }

                                        // Xử lý giấu bớt số tài khoản (Masking)
                                        String acc = (String) w.get("accountNumber");
                                        if (acc != null && acc.length() > 4) {
                                            acc = acc.substring(0, acc.length() - 4) + "****";
                                        }
                            %>
                            <tr>
                                <td>
                                    <div style="font-weight: 700; color: white;"><%= w.get("bankName")%></div>
                                    <div style="font-size: 12px; color: #A0AEC0;"><%= acc%></div>
                                </td>
                                <td style="font-weight: 600; color: white;"><%= String.format("%,.0f", amount)%>₫</td>
                                <td><span class="status-badge <%= badgeClass%>"><%= status%></span></td>
                            </tr>
                            <%
                                }
                            } else {
                            %>
                            <tr><td colspan="3" style="text-align: center; color: #A0AEC0;">No withdrawal history.</td></tr>
                            <% }%>
                        </tbody>
                    </table>
                </div>
            </div>

            <%-- ================================================ --%>
            <%-- BOOKING REQUESTS PANEL (HIRE_DESIGNER)             --%>
            <%-- ================================================ --%>
            <div class="vision-card" style="margin-top: 24px;">
                <div class="panel-header">
                    Booking Requests
                    <span style="font-size: 14px; color: #D8B4FF; font-weight: normal;">
                        <% if (bookingRequests != null) { %><%= bookingRequests.size()%> requests<% } else { %>0 requests<% } %>
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
                            String dateStr = createAt != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(createAt) : "N/A";

                            String badgeClass = "status-pending";
                            if (status.equals("Processing")) badgeClass = "status-processing";
                            else if (status.equals("Completed_Design") || status.equals("Completed")) badgeClass = "status-completed";
                            else if (status.equals("Cancelled")) badgeClass = "status-rejected";
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
                                <% if (status.equals("Pending")) { %>
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
                                <% } else if (status.equals("Processing")) { %>
                                <button onclick="openPaymentModal(<%= orderId%>)"
                                        style="background: #D8B4FF; color: #11052C; border: none; padding: 6px 14px; border-radius: 6px; font-size: 12px; font-weight: 700; cursor: pointer;">
                                    Gửi File & Yêu Cầu Thanh Toán
                                </button>
                                <% } else if (status.equals("Completed_Design")) { %>
                                <span style="color: #fbbf24; font-size: 12px;">⏳ Chờ khách thanh toán</span>
                                <% } else if (status.equals("Completed")) { %>
                                <span style="color: #01B574; font-size: 12px; font-weight: 700;">✓ Hoàn thành</span>
                                <% } else if (status.equals("Cancelled")) { %>
                                <span style="color: #ef4444; font-size: 12px;">✕ Đã hủy</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } else { %>
                <div style="text-align: center; padding: 40px; color: #A0AEC0;">
                    <p style="font-size: 15px; margin: 0;">Chưa có yêu cầu đặt thiết kế nào.</p>
                </div>
                <% } %>
            </div>

        </div>

        <%-- ================================================ --%>
        <%-- PAYMENT REQUEST MODAL (Send File + Request $$$)  --%>
        <%-- ================================================ --%>
        <div id="paymentModal" class="modal-overlay" style="display: none;">
            <div class="modal-content" style="max-width: 460px;">
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
            // Close modal when clicking outside
            document.getElementById('paymentModal').addEventListener('click', function(e) {
                if (e.target === this) closePaymentModal();
            });
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
    </body>
</html>