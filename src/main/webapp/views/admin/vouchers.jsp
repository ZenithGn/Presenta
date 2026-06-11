<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="com.model.User" %>
<%@ page import="com.model.Voucher" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Voucher Management - Presenta Admin</title>
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
            .admin-table tr:hover td { background: rgba(255,255,255,0.03); }
            
            .btn-ban {
                background: #dc3545;
                border: none;
                color: white;
                padding: 6px 14px;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 600;
                cursor: pointer;
                text-decoration: none;
            }
            .vision-card { margin-bottom: 24px; }
            
            .form-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 16px;
                margin-bottom: 20px;
            }
            .form-group label {
                display: block;
                color: #A0AEC0;
                font-size: 13px;
                margin-bottom: 6px;
            }
            .form-group input {
                width: 100%;
                padding: 10px 14px;
                border-radius: 8px;
                border: 1px solid rgba(255,255,255,0.15);
                background: rgba(255,255,255,0.06);
                color: white;
                font-size: 14px;
            }
            .btn-submit {
                background: #0075FF;
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
            }
            .btn-submit:hover { background: #005bb5; }
        </style>
    </head>
    <body>

        <%
            User loginUser = (User) session.getAttribute("LOGIN_USER");
            if (loginUser == null || loginUser.getRoleId() != 1) {
                response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
                return;
            }

            List<Voucher> voucherList = (List<Voucher>) request.getAttribute("LIST_VOUCHERS");
        %>

        <%-- ============ ADMIN NAVBAR ============ --%>
        <nav class="designer-navbar">
            <a href="${pageContext.request.contextPath}/MainController?action=AdminDashboard" class="designer-brand">
                Presenta <span>ADMIN</span>
            </a>

            <div class="designer-nav-links">
                <a href="${pageContext.request.contextPath}/MainController?action=AdminDashboard">Dashboard</a>
                <a href="${pageContext.request.contextPath}/MainController?action=AdminWithdrawals">Withdrawals</a>
                <a href="${pageContext.request.contextPath}/MainController?action=AdminUsers">User List</a>
                <a href="${pageContext.request.contextPath}/MainController?action=AdminVouchers" class="active">Vouchers</a>
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
                <h2 id="formTitle" style="color: white; margin: 0 0 20px 0; font-size: 22px;"><span class="no-translate">🎟️</span> Add Voucher</h2>
                
                <form id="voucherForm" action="${pageContext.request.contextPath}/MainController" method="POST">
                    <input type="hidden" name="action" value="AdminVouchers">
                    <input type="hidden" name="subAction" id="subAction" value="Add">
                    <input type="hidden" name="voucherId" id="voucherId" value="0">
                    
                    <div class="form-grid">
                        <div class="form-group">
                            <label>Voucher Code</label>
                            <input type="text" name="code" id="code" required>
                        </div>
                        <div class="form-group">
                            <label>Discount %</label>
                            <input type="number" step="0.01" name="discountPercent" id="discountPercent" required>
                        </div>
                        <div class="form-group">
                            <label>Max Discount Amount</label>
                            <input type="number" step="0.01" name="maxDiscountAmount" id="maxDiscountAmount" required>
                        </div>
                        <div class="form-group">
                            <label>Usage Limit</label>
                            <input type="number" name="usageLimit" id="usageLimit" required>
                        </div>
                        <div class="form-group">
                            <label>Valid From</label>
                            <input type="datetime-local" name="validFrom" id="validFrom" required>
                        </div>
                        <div class="form-group">
                            <label>Valid To</label>
                            <input type="datetime-local" name="validTo" id="validTo" required>
                        </div>
                    </div>
                    <button type="submit" id="btnSubmit" class="btn-submit">Add Voucher</button>
                    <button type="button" id="btnCancel" class="btn-outline" style="display:none; margin-left: 10px;" onclick="cancelEdit()">Cancel</button>
                </form>
            </div>

            <div class="vision-card" style="padding: 24px;">
                <h2 style="color: white; margin: 0 0 20px 0; font-size: 22px;"><span class="no-translate">📋</span> Vouchers List</h2>

                <%-- ============ TABLE ============ --%>
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Code</th>
                            <th>Discount</th>
                            <th>Max</th>
                            <th>Limit/Used</th>
                            <th>Valid From - To</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (voucherList != null && !voucherList.isEmpty()) {
                                for (Voucher v : voucherList) {
                                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
                                    java.text.SimpleDateFormat dtFormat = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                                    String fromDt = v.getValidFrom() != null ? dtFormat.format(v.getValidFrom()) : "";
                                    String toDt = v.getValidTo() != null ? dtFormat.format(v.getValidTo()) : "";
                        %>
                        <tr>
                            <td><%= v.getVoucherId()%></td>
                            <td style="font-weight: bold; color: #0075FF;"><%= v.getCode()%></td>
                            <td><%= v.getDiscountPercent()%>%</td>
                            <td><%= String.format("%,.0f", v.getMaxDiscountAmount())%>₫</td>
                            <td><%= v.getUsedCount()%> / <%= v.getUsageLimit()%></td>
                            <td style="font-size: 13px; color: #A0AEC0;">
                                <%= v.getValidFrom() != null ? sdf.format(v.getValidFrom()) : "N/A" %> <br> 
                                <%= v.getValidTo() != null ? sdf.format(v.getValidTo()) : "N/A" %>
                            </td>
                            <td>
                                <div style="display:flex; gap:8px;">
                                    <button type="button" class="btn-submit" style="padding: 6px 14px; font-size: 12px;" 
                                            onclick="editVoucher(<%= v.getVoucherId()%>, '<%= v.getCode()%>', <%= v.getDiscountPercent()%>, <%= v.getMaxDiscountAmount()%>, <%= v.getUsageLimit()%>, '<%= fromDt%>', '<%= toDt%>')">Edit</button>
                                    <form action="${pageContext.request.contextPath}/MainController" method="POST" style="margin:0;" onsubmit="return confirm('Are you sure you want to delete this voucher?');">
                                        <input type="hidden" name="action" value="AdminVouchers">
                                        <input type="hidden" name="subAction" value="Delete">
                                        <input type="hidden" name="voucherId" value="<%= v.getVoucherId()%>">
                                        <button type="submit" class="btn-ban">Delete</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="7" style="text-align:center; padding:48px; color:#A0AEC0;">
                                No vouchers found.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    
        <script>
            function editVoucher(id, code, discount, maxDiscount, limit, fromDate, toDate) {
                document.getElementById('formTitle').innerHTML = '<span class="no-translate">🎟️</span> Edit Voucher';
                document.getElementById('subAction').value = 'Update';
                document.getElementById('voucherId').value = id;
                document.getElementById('code').value = code;
                document.getElementById('discountPercent').value = discount;
                document.getElementById('maxDiscountAmount').value = maxDiscount;
                document.getElementById('usageLimit').value = limit;
                document.getElementById('validFrom').value = fromDate;
                document.getElementById('validTo').value = toDate;
                
                document.getElementById('btnSubmit').innerText = 'Update Voucher';
                document.getElementById('btnCancel').style.display = 'inline-block';
                
                window.scrollTo({top: 0, behavior: 'smooth'});
                if(typeof applyLanguage === 'function') {
                    applyLanguage(localStorage.getItem('lang') || 'vi');
                }
            }
            
            function cancelEdit() {
                document.getElementById('formTitle').innerHTML = '<span class="no-translate">🎟️</span> Add Voucher';
                document.getElementById('subAction').value = 'Add';
                document.getElementById('voucherForm').reset();
                
                document.getElementById('btnSubmit').innerText = 'Add Voucher';
                document.getElementById('btnCancel').style.display = 'none';
                if(typeof applyLanguage === 'function') {
                    applyLanguage(localStorage.getItem('lang') || 'vi');
                }
            }
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/lang.js" charset="UTF-8"></script>
    </body>
</html>
