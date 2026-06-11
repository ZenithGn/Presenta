<%-- Document : dashboard Created on : May 24, 2026, 4:26:11 PM Author : lehan --%>

    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ page import="com.model.User" %>
            <%@ page import="java.util.List" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <title>Admin Dashboard - Presenta</title>
                    <link rel="apple-touch-icon" sizes="180x180"
                        href="${pageContext.request.contextPath}/assets/images/favicon/apple-touch-icon.png">
                    <link rel="icon" type="image/png" sizes="32x32"
                        href="${pageContext.request.contextPath}/assets/images/favicon/favicon-32x32.png">
                    <link rel="icon" type="image/png" sizes="16x16"
                        href="${pageContext.request.contextPath}/assets/images/favicon/favicon-16x16.png">
                    <link rel="manifest"
                        href="${pageContext.request.contextPath}/assets/images/favicon/site.webmanifest">
                    <link rel="shortcut icon"
                        href="${pageContext.request.contextPath}/assets/images/favicon/favicon.ico">
                    <link
                        href="https://fonts.googleapis.com/css2?family=Pacifico&family=Be+Vietnam+Pro:wght@400;500;600;700;800&display=swap"
                        rel="stylesheet">

                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
                    <link rel="stylesheet"
                        href="${pageContext.request.contextPath}/assets/css/designer/designer-home.css">

                    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

                    <style>
                        .admin-charts-grid {
                            display: grid;
                            grid-template-columns: 1fr 1fr;
                            gap: 24px;
                            margin-top: 24px;
                        }

                        .chart-box {
                            background: var(--surface);
                            border: 1px solid var(--border-glass);
                            border-radius: 16px;
                            padding: 24px;
                        }

                        .chart-box h3 {
                            color: white;
                            margin: 0 0 16px 0;
                            font-size: 16px;
                            font-weight: 700;
                        }

                        .chart-box canvas {
                            max-height: 300px;
                        }

                        @media (max-width: 768px) {
                            .admin-charts-grid {
                                grid-template-columns: 1fr;
                            }
                        }
                        .chip-btn {
                            display: inline-block;
                            padding: 6px 14px;
                            border-radius: 8px;
                            border: 1px solid rgba(255,255,255,0.2);
                            color: #A0AEC0;
                            text-decoration: none;
                            font-size: 12px;
                            font-weight: 600;
                            transition: all 0.2s;
                        }
                        .chip-btn:hover { background: rgba(255,255,255,0.1); color: white; }
                        .chip-btn.active { background: #0075FF; color: white; border-color: #0075FF; }
                    </style>
                </head>

                <body>

                    <%
                        User loginUser = (User) session.getAttribute("LOGIN_USER");
                        if (loginUser == null || loginUser.getRoleId() != 1) {
                            response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
                            return;
                        }

                        Integer totalUsersObj = (Integer) request.getAttribute("TOTAL_USERS");
                        int totalUsers = (totalUsersObj != null) ? totalUsersObj : 0;
                        Double totalSalesObj = (Double) request.getAttribute("TOTAL_SALES");
                        double totalSales = (totalSalesObj != null) ? totalSalesObj : 0.0;
                        Integer totalTemplatesObj = (Integer) request.getAttribute("TOTAL_TEMPLATES");
                        int totalTemplates = (totalTemplatesObj != null) ? totalTemplatesObj : 0;
                        Integer pendingWithdrawalsObj = (Integer) request.getAttribute("PENDING_WITHDRAWALS");
                        int pendingWithdrawals = (pendingWithdrawalsObj != null) ? pendingWithdrawalsObj : 0;

                        List<String> roleLabels = (List<String>) request.getAttribute("ROLE_LABELS");
                        List<Integer> roleData = (List<Integer>) request.getAttribute("ROLE_DATA");
                        List<String> monthLabels = (List<String>) request.getAttribute("MONTH_LABELS");
                        List<Double> monthData = (List<Double>) request.getAttribute("MONTH_DATA");
                        List<String> uploadLabels = (List<String>) request.getAttribute("UPLOAD_LABELS");
                        List<Integer> uploadData = (List<Integer>) request.getAttribute("UPLOAD_DATA");
                        String uploadFilter = (String) request.getAttribute("UPLOAD_FILTER");
                        if (uploadFilter == null) uploadFilter = "month";
                    %>

                    <%-- ============ ADMIN NAVBAR ============ --%>
                    <nav class="designer-navbar">
                        <a href="${pageContext.request.contextPath}/MainController?action=AdminDashboard" class="designer-brand">
                            Presenta <span>ADMIN</span>
                        </a>

                        <div class="designer-nav-links">
                            <a href="${pageContext.request.contextPath}/MainController?action=AdminDashboard" class="active">Dashboard</a>
                            <a href="${pageContext.request.contextPath}/MainController?action=AdminWithdrawals">Withdrawals</a>
                            <a href="${pageContext.request.contextPath}/MainController?action=AdminUsers">User List</a>
                            <a href="${pageContext.request.contextPath}/MainController?action=AdminProfile">Profile</a>
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

                        <%-- ============ STAT CARDS ============ --%>
                        <div class="stats-grid">
                            <div class="vision-card stat-card">
                                <div class="stat-info">
                                    <span class="stat-title">Total Users</span>
                                    <div class="stat-value"><%= totalUsers%></div>
                                </div>
                                <div class="stat-icon">👥</div>
                            </div>
                            <div class="vision-card stat-card">
                                <div class="stat-info">
                                    <span class="stat-title">Total Sales</span>
                                    <div class="stat-value"><%= String.format("%,.0f", totalSales)%>₫</div>
                                </div>
                                <div class="stat-icon">💳</div>
                            </div>
                            <div class="vision-card stat-card">
                                <div class="stat-info">
                                    <span class="stat-title">Total Templates</span>
                                    <div class="stat-value"><%= totalTemplates%></div>
                                </div>
                                <div class="stat-icon">📄</div>
                            </div>
                            <div class="vision-card stat-card">
                                <div class="stat-info">
                                    <span class="stat-title">Pending Withdrawals</span>
                                    <div class="stat-value"><%= pendingWithdrawals%></div>
                                </div>
                                <div class="stat-icon">⏳</div>
                            </div>
                        </div>

                        <%-- ============ CHARTS ============ --%>
                        <div class="admin-charts-grid">
                            <div class="chart-box">
                                <h3>📊 User Role Distribution</h3>
                                <canvas id="roleChart"></canvas>
                            </div>
                            <div class="chart-box">
                                <h3>📈 Monthly Revenue (Last 6 Months)</h3>
                                <canvas id="revenueChart"></canvas>
                            </div>
                        </div>

                        <%-- ============ TEMPLATE UPLOAD HISTOGRAM ============ --%>
                        <div class="chart-box" style="margin-top: 24px;">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                                <h3 style="color: white; font-size: 16px; font-weight: 700; margin: 0;">📋 Template Uploads</h3>
                                <div style="display: flex; gap: 8px;">
                                    <a href="${pageContext.request.contextPath}/MainController?action=AdminDashboard&uploadFilter=week"
                                       class="chip-btn <%="week".equals(uploadFilter) ? "active" : ""%>">This Week</a>
                                    <a href="${pageContext.request.contextPath}/MainController?action=AdminDashboard&uploadFilter=month"
                                       class="chip-btn <%="month".equals(uploadFilter) ? "active" : ""%>">This Month</a>
                                    <a href="${pageContext.request.contextPath}/MainController?action=AdminDashboard&uploadFilter=year"
                                       class="chip-btn <%="year".equals(uploadFilter) ? "active" : ""%>">This Year</a>
                                </div>
                            </div>
                            <canvas id="uploadChart" style="max-height: 280px;"></canvas>
                        </div>

                    </div>

                    <footer class="main-footer">
                        <div class="footer-container">
                            <div class="footer-col brand-col">
                                <div class="brand-logo-desc-wrapper">
                                    <img src="${pageContext.request.contextPath}/assets/images/logo.jpg" alt="Presenta Logo" class="footer-image-logo">
                                    <div class="brand-text-content">
                                        <a href="#" class="footer-logo" style="margin-bottom: 4px;">Presenta</a>
                                        <p class="footer-desc" style="margin-bottom: 0;">The next generation template marketplace for academic visionaries and creative professionals.</p>
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

                    <%-- ============ CHART.JS SCRIPTS ============ --%>
                    <%
                        // Build JSON arrays safely
                        String roleLabelsJson = "[]";
                        String roleDataJson = "[]";
                        String monthLabelsJson = "[]";
                        String monthDataJson = "[]";

                        if (roleLabels != null && !roleLabels.isEmpty()) {
                            StringBuilder sb = new StringBuilder("[");
                            for (int i = 0; i < roleLabels.size(); i++) {
                                if (i > 0) sb.append(",");
                                sb.append("\"").append(roleLabels.get(i)).append("\"");
                            }
                            sb.append("]");
                            roleLabelsJson = sb.toString();
                        }
                        if (roleData != null && !roleData.isEmpty()) {
                            StringBuilder sb = new StringBuilder("[");
                            for (int i = 0; i < roleData.size(); i++) {
                                if (i > 0) sb.append(",");
                                sb.append(roleData.get(i));
                            }
                            sb.append("]");
                            roleDataJson = sb.toString();
                        }
                        if (monthLabels != null && !monthLabels.isEmpty()) {
                            StringBuilder sb = new StringBuilder("[");
                            for (int i = 0; i < monthLabels.size(); i++) {
                                if (i > 0) sb.append(",");
                                sb.append("\"").append(monthLabels.get(i)).append("\"");
                            }
                            sb.append("]");
                            monthLabelsJson = sb.toString();
                        }
                        if (monthData != null && !monthData.isEmpty()) {
                            StringBuilder sb = new StringBuilder("[");
                            for (int i = 0; i < monthData.size(); i++) {
                                if (i > 0) sb.append(",");
                                sb.append(monthData.get(i));
                            }
                            sb.append("]");
                            monthDataJson = sb.toString();
                        }
                        String uploadLabelsJson = "[]";
                        String uploadDataJson = "[]";
                        if (uploadLabels != null && !uploadLabels.isEmpty()) {
                            StringBuilder sb = new StringBuilder("[");
                            for (int i = 0; i < uploadLabels.size(); i++) {
                                if (i > 0) sb.append(",");
                                sb.append("\"").append(uploadLabels.get(i)).append("\"");
                            }
                            sb.append("]");
                            uploadLabelsJson = sb.toString();
                        }
                        if (uploadData != null && !uploadData.isEmpty()) {
                            StringBuilder sb = new StringBuilder("[");
                            for (int i = 0; i < uploadData.size(); i++) {
                                if (i > 0) sb.append(",");
                                sb.append(uploadData.get(i));
                            }
                            sb.append("]");
                            uploadDataJson = sb.toString();
                        }
                    %>
                    <script>
                        // Pie Chart — Role Distribution
                        const roleCtx = document.getElementById('roleChart').getContext('2d');
                        new Chart(roleCtx, {
                            type: 'doughnut',
                            data: {
                                labels: <%= roleLabelsJson%>,
                                datasets: [{
                                        data: <%= roleDataJson%>,
                                        backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0'],
                                        borderColor: 'rgba(30, 30, 30, 1)',
                                        borderWidth: 2
                                    }]
                            },
                            options: {
                                responsive: true,
                                plugins: {
                                    legend: {
                                        position: 'bottom',
                                        labels: { color: '#A0AEC0', padding: 16, font: { size: 13 } }
                                    }
                                }
                            }
                        });

                        // Bar Chart — Monthly Revenue
                        const revCtx = document.getElementById('revenueChart').getContext('2d');
                        const gradient = revCtx.createLinearGradient(0, 0, 0, 300);
                        gradient.addColorStop(0, 'rgba(0, 117, 255, 0.7)');
                        gradient.addColorStop(1, 'rgba(0, 117, 255, 0.05)');

                        new Chart(revCtx, {
                            type: 'bar',
                            data: {
                                labels: <%= monthLabelsJson%>,
                                datasets: [{
                                        label: 'Revenue (VND)',
                                        data: <%= monthDataJson%>,
                                        backgroundColor: gradient,
                                        borderColor: '#0075FF',
                                        borderWidth: 1,
                                        borderRadius: 8
                                    }]
                            },
                            options: {
                                responsive: true,
                                scales: {
                                    y: {
                                        beginAtZero: true,
                                        ticks: {
                                            color: '#A0AEC0',
                                            callback: function (val) { return (val / 1000000).toFixed(0) + 'M ₫'; }
                                        },
                                        grid: { color: 'rgba(255,255,255,0.05)' }
                                    },
                                    x: {
                                        ticks: { color: '#A0AEC0' },
                                        grid: { display: false }
                                    }
                                },
                                plugins: {
                                    legend: {
                                        display: false
                                    },
                                    tooltip: {
                                        callbacks: {
                                            label: function (ctx) {
                                                return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(ctx.raw);
                                            }
                                        }
                                    }
                                }
                            }
                        });

                        // Bar Chart — Template Uploads
                        const uploadCtx = document.getElementById('uploadChart').getContext('2d');
                        const uploadGradient = uploadCtx.createLinearGradient(0, 0, 0, 280);
                        uploadGradient.addColorStop(0, 'rgba(1, 181, 116, 0.7)');
                        uploadGradient.addColorStop(1, 'rgba(1, 181, 116, 0.05)');

                        new Chart(uploadCtx, {
                            type: 'bar',
                            data: {
                                labels: <%= uploadLabelsJson%>,
                                datasets: [{
                                        label: 'Templates Uploaded',
                                        data: <%= uploadDataJson%>,
                                        backgroundColor: uploadGradient,
                                        borderColor: '#01B574',
                                        borderWidth: 1,
                                        borderRadius: 6
                                    }]
                            },
                            options: {
                                responsive: true,
                                scales: {
                                    y: {
                                        beginAtZero: true,
                                        ticks: {
                                            color: '#A0AEC0',
                                            stepSize: 1,
                                            callback: function(val) { return Number.isInteger(val) ? val : ''; }
                                        },
                                        grid: { color: 'rgba(255,255,255,0.05)' }
                                    },
                                    x: {
                                        ticks: { color: '#A0AEC0' },
                                        grid: { display: false }
                                    }
                                },
                                plugins: {
                                    legend: { display: false },
                                    tooltip: {
                                        callbacks: {
                                            label: function(ctx) {
                                                return ctx.raw + ' template' + (ctx.raw !== 1 ? 's' : '');
                                            }
                                        }
                                    }
                                }
                            }
                        });
                    </script>
                
<script src="${pageContext.request.contextPath}/assets/js/lang.js" charset="UTF-8"></script>
</body>

                </html>
