<%--
    Document   : withdrawals
    Author     : lehan
    Designer Withdrawals — form to request payout + history table
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.model.User" %>
<%@ page import="com.model.Withdrawal" %>
<%@ page import="java.util.List" %>
<%
    User loginUser = (User) session.getAttribute("LOGIN_USER");
    if (loginUser == null || loginUser.getRoleId() != 3) {
        response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
        return;
    }

    Double balance = (Double) request.getAttribute("DESIGNER_BALANCE");
    double displayBalance = (balance != null) ? balance : 0.0;
    List<Withdrawal> history = (List<Withdrawal>) request.getAttribute("WITHDRAWAL_HISTORY");

    String toastMsg = (String) session.getAttribute("toastMessage");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Withdrawals - Presenta Designer</title>
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
            .withdrawals-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 24px;
            }
            @media (max-width: 768px) {
                .withdrawals-grid { grid-template-columns: 1fr; }
            }
            .badge-pending { background: rgba(255,193,7,0.2); color: #FFC107; padding: 4px 10px; border-radius: 999px; font-size: 12px; font-weight: 600; }
            .badge-approved { background: rgba(40,167,69,0.2); color: #28a745; padding: 4px 10px; border-radius: 999px; font-size: 12px; font-weight: 600; }
            .badge-rejected { background: rgba(220,53,69,0.2); color: #dc3545; padding: 4px 10px; border-radius: 999px; font-size: 12px; font-weight: 600; }
            .vision-card { margin-bottom: 24px; }
            .custom-table {
                width: 100%;
                border-collapse: collapse;
            }
            .custom-table th {
                text-align: left;
                padding: 12px 16px;
                color: #A0AEC0;
                font-size: 11px;
                text-transform: uppercase;
                border-bottom: 1px solid rgba(255,255,255,0.1);
            }
            .custom-table td {
                padding: 14px 16px;
                border-bottom: 1px solid rgba(255,255,255,0.05);
                color: #E2E8F0;
                font-size: 14px;
            }
        </style>
    </head>
    <body class="designer-body">

        <%-- ============ NAVBAR ============ --%>
        <nav class="designer-navbar">
            <a href="${pageContext.request.contextPath}/MainController?action=DesignerHome" class="designer-brand">
                Presenta <span>DESIGNER</span>
            </a>
            <div class="designer-nav-links">
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerHome">Dashboard</a>
                <a href="${pageContext.request.contextPath}/MainController?action=ManageTemplate">Manage Templates</a>
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerWithdrawals" class="active">Withdrawals</a>
                <a href="${pageContext.request.contextPath}/MainController?action=CustomerBooking">Customer Booking</a>
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerProfile">Profile</a>
            </div>
            <div style="display: flex; align-items: center; gap: 20px;">
                <span style="font-size: 14px; color: #A0AEC0;">Welcome, <b style="color: white;"><%= loginUser.getUsername()%></b></span>
                <form action="${pageContext.request.contextPath}/MainController" method="POST" style="margin: 0;">
                    <input type="hidden" name="action" value="Logout">
                    <button type="submit" style="background: transparent; border: none; color: #A0AEC0; font-weight: 700; cursor: pointer;">Sign Out</button>
                </form>
            
<button onclick="toggleLanguage()" class="lang-toggle-btn no-translate" style="background: transparent; border: 1px solid currentColor; color: inherit; padding: 4px 10px; border-radius: 20px; cursor: pointer; margin-left: 15px; font-weight: bold; white-space: nowrap;">EN/VI</button>
</div>
        
</nav>

        <div class="designer-container">

            <div class="withdrawals-grid">
                <%-- ============ WITHDRAWAL FORM ============ --%>
                <div class="vision-card" style="padding: 32px;">
                    <h3 style="color: white; margin-bottom: 4px; font-size: 20px;">💸 Request a Payout</h3>
                    <p style="color: #A0AEC0; font-size: 13px; margin-bottom: 8px;">
                        Available Balance: <b style="color: #FFD700;"><%= String.format("%,.0f", displayBalance)%>₫</b>
                    </p>

                    <form action="${pageContext.request.contextPath}/MainController" method="POST">
                        <input type="hidden" name="action" value="WithdrawalRequest">
                        <div style="margin-bottom: 12px;">
                            <label style="display:block; color:#A0AEC0; font-size:12px; margin-bottom:4px;">Amount (VND)</label>
                            <input type="number" name="amount" required placeholder="e.g. 500000"
                                   style="width:100%; padding:10px 14px; border-radius:8px; border:1px solid rgba(255,255,255,0.15);
                                          background: rgba(255,255,255,0.06); color: white; font-size:14px; box-sizing:border-box;"
                                   min="10000" step="1000">
                        </div>
                        <div style="margin-bottom: 12px;">
                            <label style="display:block; color:#A0AEC0; font-size:12px; margin-bottom:4px;">Bank Name</label>
                            <input type="text" name="bankName" required placeholder="e.g. Vietcombank"
                                   style="width:100%; padding:10px 14px; border-radius:8px; border:1px solid rgba(255,255,255,0.15);
                                          background: rgba(255,255,255,0.06); color: white; font-size:14px; box-sizing:border-box;">
                        </div>
                        <div style="margin-bottom: 12px;">
                            <label style="display:block; color:#A0AEC0; font-size:12px; margin-bottom:4px;">Account Number</label>
                            <input type="text" name="bankAccountNumber" required placeholder="e.g. 1234567890"
                                   style="width:100%; padding:10px 14px; border-radius:8px; border:1px solid rgba(255,255,255,0.15);
                                          background: rgba(255,255,255,0.06); color: white; font-size:14px; box-sizing:border-box;">
                        </div>
                        <div style="margin-bottom: 16px;">
                            <label style="display:block; color:#A0AEC0; font-size:12px; margin-bottom:4px;">Account Holder Name</label>
                            <input type="text" name="accountName" required placeholder="e.g. Nguyen Van A"
                                   style="width:100%; padding:10px 14px; border-radius:8px; border:1px solid rgba(255,255,255,0.15);
                                          background: rgba(255,255,255,0.06); color: white; font-size:14px; box-sizing:border-box;">
                        </div>
                        <button type="submit" class="btn-vision" style="width:100%; cursor:pointer;">Submit Withdrawal Request</button>
                    </form>
                </div>

                <%-- ============ WITHDRAWAL HISTORY ============ --%>
                <div class="vision-card" style="padding: 24px;">
                    <div class="panel-header" style="margin-bottom: 16px;">
                        Withdrawal History
                    </div>

                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th>Bank / Account</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (history != null && !history.isEmpty()) {
                                    for (Withdrawal w : history) {
                                        String badgeClass = "badge-pending";
                                        if ("Approved".equals(w.getStatus())) badgeClass = "badge-approved";
                                        if ("Rejected".equals(w.getStatus())) badgeClass = "badge-rejected";

                                        String acc = w.getBankAccountNumber();
                                        if (acc != null && acc.length() > 4) {
                                            acc = "****" + acc.substring(acc.length() - 4);
                                        }
                            %>
                            <tr>
                                <td>
                                    <div style="font-weight: 700; color: white;"><%= w.getBankName()%></div>
                                    <div style="font-size: 12px; color: #A0AEC0;"><%= w.getAccountName()%> · <%= acc%></div>
                                </td>
                                <td style="font-weight: 600; color: white;"><%= String.format("%,.0f", w.getAmount())%>₫</td>
                                <td><span class="<%= badgeClass%>"><%= w.getStatus()%></span></td>
                                <td style="font-size:12px; color:#A0AEC0;">
                                    <%= w.getCreateAt() != null ? w.getCreateAt().toString().substring(0, 10) : ""%>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr><td colspan="4" style="text-align: center; color: #A0AEC0; padding: 48px 0;">No withdrawal history yet.</td></tr>
                            <% }%>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>

        <%-- ============ TOAST ============ --%>
        <% if (toastMsg != null) { %>
        <div id="custom-toast" class="show">
            <span class="toast-icon">✔️</span>
            <span class="toast-text"><%= toastMsg%></span>
        </div>
        <% session.removeAttribute("toastMessage"); } %>

        <footer class="main-footer">
            <div class="footer-container">
                <div class="footer-col brand-col">
                    <div class="brand-logo-desc-wrapper">
                        <img src="${pageContext.request.contextPath}/assets/images/logo.jpg" alt="Presenta Logo" class="footer-image-logo">
                        <div class="brand-text-content">
                            <a href="${pageContext.request.contextPath}/MainController" class="footer-logo" style="margin-bottom: 4px;">Presenta</a>
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
        <script src="${pageContext.request.contextPath}/assets/js/toast.js?v=1.0"></script>
    
<script src="${pageContext.request.contextPath}/assets/js/lang.js" charset="UTF-8"></script>
</body>
</html>
