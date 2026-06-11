<%--
    Document   : withdrawals
    Author     : lehan
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.model.User" %>
<%@ page import="com.model.Withdrawal" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Withdrawal Management - Presenta Admin</title>
        <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/assets/images/favicon/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/images/favicon/favicon-16x16.png">
        <link rel="manifest" href="${pageContext.request.contextPath}/assets/images/favicon/site.webmanifest">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon/favicon.ico">
        <link href="https://fonts.googleapis.com/css2?family=Pacifico&family=Be+Vietnam+Pro:wght@400;500;600;700;800&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer/designer-home.css">

        <style>
            .filter-bar {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 20px;
                flex-wrap: wrap;
            }
            .filter-bar select, .filter-bar a, .filter-bar button {
                padding: 8px 16px;
                border-radius: 8px;
                border: 1px solid rgba(255,255,255,0.15);
                background: rgba(255,255,255,0.06);
                color: white;
                font-size: 13px;
                cursor: pointer;
                text-decoration: none;
            }
            .filter-bar .btn-export {
                background: #28a745;
                border-color: #28a745;
                font-weight: 600;
            }
            .filter-bar .btn-approve-all {
                background: #0075FF;
                border-color: #0075FF;
                font-weight: 600;
            }
            .filter-bar .btn-reject {
                background: #dc3545;
                border-color: #dc3545;
                color: white;
                padding: 4px 10px;
                font-size: 12px;
            }
            .filter-bar .btn-approve {
                background: #28a745;
                border-color: #28a745;
                color: white;
                padding: 4px 10px;
                font-size: 12px;
            }
            .admin-table {
                width: 100%;
                border-collapse: collapse;
            }
            .admin-table th {
                text-align: left;
                padding: 12px 16px;
                color: #A0AEC0;
                font-size: 12px;
                text-transform: uppercase;
                border-bottom: 1px solid rgba(255,255,255,0.1);
            }
            .admin-table td {
                padding: 14px 16px;
                border-bottom: 1px solid rgba(255,255,255,0.05);
                color: #E2E8F0;
                font-size: 14px;
            }
            .admin-table tr:hover td {
                background: rgba(255,255,255,0.03);
            }
            .badge-pending { background: rgba(255,193,7,0.2); color: #FFC107; padding: 4px 10px; border-radius: 999px; font-size: 12px; font-weight: 600; }
            .badge-approved { background: rgba(40,167,69,0.2); color: #28a745; padding: 4px 10px; border-radius: 999px; font-size: 12px; font-weight: 600; }
            .badge-rejected { background: rgba(220,53,69,0.2); color: #dc3545; padding: 4px 10px; border-radius: 999px; font-size: 12px; font-weight: 600; }
            .pagination {
                display: flex;
                gap: 8px;
                justify-content: center;
                margin-top: 24px;
            }
            .pagination a, .pagination span {
                padding: 8px 14px;
                border-radius: 8px;
                border: 1px solid rgba(255,255,255,0.15);
                color: white;
                text-decoration: none;
                font-size: 13px;
            }
            .pagination a:hover { background: rgba(255,255,255,0.1); }
            .pagination .active-page { background: #0075FF; border-color: #0075FF; font-weight: 700; }
            .vision-card { margin-bottom: 24px; }
        </style>
    </head>
    <body>

        <%
            User loginUser = (User) session.getAttribute("LOGIN_USER");
            if (loginUser == null || loginUser.getRoleId() != 1) {
                response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
                return;
            }

            List<Withdrawal> withdrawalList = (List<Withdrawal>) request.getAttribute("WITHDRAWAL_LIST");
            Integer currentPage = (Integer) request.getAttribute("CURRENT_PAGE");
            Integer totalPages = (Integer) request.getAttribute("TOTAL_PAGES");
            Integer totalCount = (Integer) request.getAttribute("TOTAL_COUNT");
            String statusFilter = (String) request.getAttribute("STATUS_FILTER");

            if (currentPage == null) currentPage = 1;
            if (totalPages == null) totalPages = 1;
            if (totalCount == null) totalCount = 0;
            if (statusFilter == null) statusFilter = "Pending";
        %>

        <%-- ============ ADMIN NAVBAR ============ --%>
        <nav class="designer-navbar">
            <a href="${pageContext.request.contextPath}/MainController?action=AdminDashboard" class="designer-brand">
                Presenta <span>ADMIN</span>
            </a>

            <div class="designer-nav-links">
                <a href="${pageContext.request.contextPath}/MainController?action=AdminDashboard">Dashboard</a>
                <a href="${pageContext.request.contextPath}/MainController?action=AdminWithdrawals" class="active">Withdrawals</a>
                <a href="${pageContext.request.contextPath}/MainController?action=AdminUsers">User List</a>
                <a href="${pageContext.request.contextPath}/MainController?action=AdminProfile">Profile</a>
            </div>

            <div style="display: flex; align-items: center; gap: 20px;">
<div onclick="toggleLanguage()" class="lang-toggle-switch no-translate" style="position: relative; display: flex; align-items: center; width: 64px; height: 28px; border: 1px solid currentColor; border-radius: 20px; cursor: pointer; margin-right: 15px; color: inherit;">
    <div class="lang-slider" style="position: absolute; top: 2px; left: 2px; width: 28px; height: 22px; background: currentColor; opacity: 0.2; border-radius: 14px; transition: transform 0.3s cubic-bezier(0.4, 0.0, 0.2, 1); z-index: 1;"></div>
    <span style="flex: 1; text-align: center; font-size: 11px; font-weight: bold; z-index: 2; pointer-events: none;">EN</span>
    <span style="flex: 1; text-align: center; font-size: 11px; font-weight: bold; z-index: 2; pointer-events: none;">VI</span>
</div>

                <span style="font-size: 14px; color: #A0AEC0;">Welcome, <b style="color: white;"><%= loginUser.getUsername()%></b></span>
                <form action="${pageContext.request.contextPath}/MainController" method="POST" style="margin: 0;">
                    <input type="hidden" name="action" value="Logout">
                    <button type="submit" style="background: transparent; border: none; color: #A0AEC0; font-weight: 700; cursor: pointer;">Sign Out</button>
                </form>
            
</div>
        
</nav>

        <div class="designer-container">
            <div class="vision-card" style="padding: 24px;">
                <h2 style="color: white; margin: 0 0 4px 0; font-size: 22px;">💸 Withdrawal Requests</h2>
                <p style="color: #A0AEC0; margin: 0 0 20px 0; font-size: 14px;"><%= totalCount%> total request(s)</p>

                <%-- ============ FILTER BAR ============ --%>
                <div class="filter-bar">
                    <form action="${pageContext.request.contextPath}/MainController" method="GET" style="display:flex; align-items:center; gap:12px; margin:0;">
                        <input type="hidden" name="action" value="AdminWithdrawals">
                        <select name="statusFilter" onchange="this.form.submit()">
                            <option value="All" <%= "All".equals(statusFilter) ? "selected" : ""%>>All Status</option>
                            <option value="Pending" <%= "Pending".equals(statusFilter) ? "selected" : ""%>>Pending</option>
                            <option value="Approved" <%= "Approved".equals(statusFilter) ? "selected" : ""%>>Approved</option>
                            <option value="Rejected" <%= "Rejected".equals(statusFilter) ? "selected" : ""%>>Rejected</option>
                        </select>
                    </form>

                    <a href="${pageContext.request.contextPath}/MainController?action=AdminWithdrawals&subAction=exportCSV&statusFilter=<%= statusFilter%>" class="btn-export">
                        📥 Export CSV
                    </a>

                    <% if ("Pending".equals(statusFilter)) { %>
                    <button type="submit" form="batchForm" class="btn-approve-all">
                        ✅ Batch Approve Selected
                    </button>
                    <% } %>
                </div>

                <%-- ============ TABLE ============ --%>
                <form id="batchForm" action="${pageContext.request.contextPath}/MainController" method="POST">
                    <input type="hidden" name="action" value="AdminWithdrawals">
                    <input type="hidden" name="subAction" value="batchApprove">

                    <table class="admin-table">
                        <thead>
                            <tr>
                                <% if ("Pending".equals(statusFilter)) { %><th style="width:40px;"><input type="checkbox" id="selectAll" onclick="toggleAll(this)"></th><% } %>
                                <th>ID</th>
                                <th>Designer</th>
                                <th>Balance</th>
                                <th>Bank</th>
                                <th>Account No.</th>
                                <th>Holder</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (withdrawalList != null && !withdrawalList.isEmpty()) {
                                    for (Withdrawal w : withdrawalList) {
                                        String badgeClass = "badge-pending";
                                        if ("Approved".equals(w.getStatus())) badgeClass = "badge-approved";
                                        if ("Rejected".equals(w.getStatus())) badgeClass = "badge-rejected";
                            %>
                            <tr>
                                <% if ("Pending".equals(statusFilter)) { %>
                                <td><input type="checkbox" name="selectedIds" value="<%= w.getWithdrawalID()%>"></td>
                                <% } %>
                                <td>#<%= w.getWithdrawalID()%></td>
                                <td style="font-weight:600;"><%= w.getDesignerName() != null ? w.getDesignerName() : "—"%></td>
                                <td><%= String.format("%,.0f", w.getDesignerBalance())%>₫</td>
                                <td><%= w.getBankName()%></td>
                                <td><%= w.getBankAccountNumber()%></td>
                                <td><%= w.getAccountName()%></td>
                                <td style="font-weight:600; color:#FFD700;"><%= String.format("%,.0f", w.getAmount())%>₫</td>
                                <td><span class="<%= badgeClass%>"><%= w.getStatus()%></span></td>
                                <td style="font-size:12px; color:#A0AEC0;"><%= w.getCreateAt() != null ? w.getCreateAt().toString().substring(0, 10) : ""%></td>
                                <td>
                                    <% if ("Pending".equals(w.getStatus())) { %>
                                    <a href="${pageContext.request.contextPath}/MainController?action=AdminWithdrawals&approveId=<%= w.getWithdrawalID()%>&statusFilter=<%= statusFilter%>"
                                       class="btn-approve" style="text-decoration:none;">Approve</a>
                                    <a href="${pageContext.request.contextPath}/MainController?action=AdminWithdrawals&rejectId=<%= w.getWithdrawalID()%>&statusFilter=<%= statusFilter%>"
                                       class="btn-reject" style="text-decoration:none;">Reject</a>
                                    <% } else { %>
                                    <span style="color:#A0AEC0; font-size:12px;">—</span>
                                    <% } %>
                                </td>
                            </tr>
                            <%
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="11" style="text-align:center; padding:48px; color:#A0AEC0;">
                                    No withdrawal requests found.
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </form>

                <%-- ============ PAGINATION ============ --%>
                <% if (totalPages > 1) { %>
                <div class="pagination">
                    <% if (currentPage > 1) { %>
                    <a href="${pageContext.request.contextPath}/MainController?action=AdminWithdrawals&page=<%= currentPage - 1%>&statusFilter=<%= statusFilter%>">&laquo; Prev</a>
                    <% } %>
                    <%
                        for (int i = 1; i <= totalPages; i++) {
                            if (i == currentPage) {
                    %>
                    <span class="active-page"><%= i%></span>
                    <% } else { %>
                    <a href="${pageContext.request.contextPath}/MainController?action=AdminWithdrawals&page=<%= i%>&statusFilter=<%= statusFilter%>"><%= i%></a>
                    <% }
                        } %>
                    <% if (currentPage < totalPages) { %>
                    <a href="${pageContext.request.contextPath}/MainController?action=AdminWithdrawals&page=<%= currentPage + 1%>&statusFilter=<%= statusFilter%>">Next &raquo;</a>
                    <% } %>
                </div>
                <% } %>
            </div>
        </div>

        <script>
            function toggleAll(source) {
                var checkboxes = document.getElementsByName('selectedIds');
                for (var i = 0; i < checkboxes.length; i++) {
                    checkboxes[i].checked = source.checked;
                }
            }
        </script>
    
<script src="${pageContext.request.contextPath}/assets/js/lang.js" charset="UTF-8"></script>
</body>
</html>
