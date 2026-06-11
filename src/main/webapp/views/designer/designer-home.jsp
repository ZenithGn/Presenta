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
    List<String> dailyLabels = (List<String>) request.getAttribute("DAILY_LABELS");
    List<Integer> dailyBuy = (List<Integer>) request.getAttribute("DAILY_BUY");
    List<Integer> dailyHire = (List<Integer>) request.getAttribute("DAILY_HIRE");
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
        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    </head>

    <body class="designer-body">

        <nav class="designer-navbar">
            <a href="${pageContext.request.contextPath}/MainController?action=DesignerHome" class="designer-brand">
                Presenta <span>DESIGNER</span>
            </a>

            <div class="designer-nav-links">
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerHome" class="active">Dashboard</a>
                <a href="${pageContext.request.contextPath}/MainController?action=ManageTemplate">Manage Templates</a>
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerWithdrawals">Withdrawals</a>
                <a href="${pageContext.request.contextPath}/MainController?action=CustomerBooking">Customer Booking</a>
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

                <div class="vision-card" style="padding: 24px;">
                    <h3 style="color: white; margin: 0 0 4px 0; font-size: 18px;">📈 Daily Activity (Last 30 Days)</h3>
                    <p style="color: #A0AEC0; font-size: 12px; margin-bottom: 16px;">Template sales vs Booking requests per day</p>
                    <div style="height: 250px;">
                        <canvas id="dailyActivityChart"></canvas>
                    </div>
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

        </div>

        <%-- ============ CHART.JS: DAILY ACTIVITY LINE CHART ============ --%>
        <%
            StringBuilder dlJson = new StringBuilder("[");
            StringBuilder dbJson = new StringBuilder("[");
            StringBuilder dhJson = new StringBuilder("[");
            if (dailyLabels != null) {
                for (int i = 0; i < dailyLabels.size(); i++) {
                    if (i > 0) { dlJson.append(","); dbJson.append(","); dhJson.append(","); }
                    dlJson.append("\"").append(dailyLabels.get(i)).append("\"");
                    dbJson.append(dailyBuy != null && i < dailyBuy.size() ? dailyBuy.get(i) : 0);
                    dhJson.append(dailyHire != null && i < dailyHire.size() ? dailyHire.get(i) : 0);
                }
            }
            dlJson.append("]"); dbJson.append("]"); dhJson.append("]");
        %>
        <script>
            const ctx = document.getElementById('dailyActivityChart').getContext('2d');
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: <%= dlJson.toString()%>,
                    datasets: [
                        {
                            label: 'Template Sales',
                            data: <%= dbJson.toString()%>,
                            borderColor: '#0075FF',
                            backgroundColor: 'rgba(0,117,255,0.1)',
                            fill: true,
                            tension: 0.3,
                            pointRadius: 1,
                            borderWidth: 2
                        },
                        {
                            label: 'Bookings (Hire)',
                            data: <%= dhJson.toString()%>,
                            borderColor: '#D8B4FF',
                            backgroundColor: 'rgba(216,180,255,0.1)',
                            fill: true,
                            tension: 0.3,
                            pointRadius: 1,
                            borderWidth: 2
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: { color: '#A0AEC0', stepSize: 1 },
                            grid: { color: 'rgba(255,255,255,0.05)' }
                        },
                        x: {
                            ticks: { color: '#A0AEC0', maxTicksLimit: 7, maxRotation: 45 },
                            grid: { display: false }
                        }
                    },
                    plugins: {
                        legend: {
                            labels: { color: '#A0AEC0', usePointStyle: true, padding: 20 }
                        }
                    }
                }
            });
        </script>

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