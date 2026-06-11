<%-- 
    Document   : checkout
    Created on : May 28, 2026, 5:30:39 PM
    Author     : lehan
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.model.User" %>
<%@ page import="com.model.Template" %>
<%@ page import="com.model.CartItem" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Checkout - Presenta</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/checkout.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&family=Pacifico&display=swap" rel="stylesheet">
    </head>

    <%
        User loginUser = (User) session.getAttribute("LOGIN_USER");
        int roleId = (loginUser != null) ? loginUser.getRoleId() : 0;
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("CART");
    %>

    <body class="landing-body">

        <%-- NAVBAR (Đồng bộ từ home.jsp) --%>
        <% if (roleId == 0 || roleId == 2) { %>
        <nav class="navbar" style="border-bottom: none; background: transparent;">
            <a href="${pageContext.request.contextPath}/MainController" class="nav-brand" style="font-family: 'Pacifico', cursive; font-size: 28px;">Presenta</a>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/MainController">HOME</a>
                <a href="${pageContext.request.contextPath}/MainController?action=Shop">SHOP</a>
                <a href="${pageContext.request.contextPath}/MainController?action=DesignerHub">DESIGNER HUB</a>
                <% if (roleId == 2) { %>
                <a href="${pageContext.request.contextPath}/MainController?action=ViewCart" class="active">CART</a>
                <a href="${pageContext.request.contextPath}/MainController?action=Profile">PROFILE</a>
                <% } %>
            </div>
            <div class="nav-actions">
                <% if (roleId == 2) {%>
                <span style="color: #dae2fd; font-size: 14px; margin-right: 10px;">Welcome, <b><%= loginUser.getUsername()%></b></span>
                <form action="${pageContext.request.contextPath}/MainController" method="POST" style="margin:0; display: inline-block;">
                    <input type="hidden" name="action" value="Logout">
                    <button type="submit" class="btn-outline" style="padding: 6px 16px; font-size: 12px; border-radius: 999px;">Logout</button>
                </form>
                <% } %>
            
<button onclick="toggleLanguage()" class="lang-toggle-btn no-translate" style="background: transparent; border: 1px solid currentColor; color: inherit; padding: 4px 10px; border-radius: 20px; cursor: pointer; margin-left: 15px; font-weight: bold; white-space: nowrap;">EN/VI</button>
</div>
        
</nav>
        <% } %>

        <%-- NỘI DUNG CHÍNH TRANG CHECKOUT --%>
        <main class="checkout-page">
            <div class="checkout-header-wrapper">
                <a href="${pageContext.request.contextPath}/MainController?action=ViewCart" class="btn-back-to-cart">
                    &larr; Back to Cart
                </a>
                <h1 class="checkout-main-title">Checkout</h1>
            </div>

            <form action="${pageContext.request.contextPath}/MainController" method="POST">
                <input type="hidden" name="action" value="ProcessOrder">

                <div class="checkout-grid">

                    <div class="checkout-left-pane">
                        <div class="payment-methods-box">
                            <div style="margin-bottom: 30px;">
                                <h3 style="font-size: 18px; font-weight: 700; color: #11052C; margin-bottom: 20px;">Select Payment Method</h3>
                                <!-- Vnpay -->
                                <label class="payment-method-label" style="display: flex; align-items: center; padding: 16px 20px; border: 1px solid #cbd5e1; border-radius: 12px; margin-bottom: 15px; cursor: not-allowed; background: #f8fafc; opacity: 0.6; transition: all 0.3s ease;" title="VNPay is temporarily disabled">
                                    <input type="radio" name="paymentMethod" value="VNPAY" disabled style="margin-right: 15px; transform: scale(1.2); cursor: not-allowed;">

                                    <img src="${pageContext.request.contextPath}/assets/images/logo/vnpay.png" alt="VNPay Icon" style="width: 36px; height: 36px; object-fit: contain; margin-right: 12px; border-radius: 4px; filter: grayscale(100%);">

                                    <span style="font-size: 15px; font-weight: 600; color: #64748b;">VNPay Wallet / Banking (Disabled)</span>
                                </label>
                                <!-- Momo -->
                                <label class="payment-method-label" style="display: flex; align-items: center; padding: 16px 20px; border: 1px solid #cbd5e1; border-radius: 12px; margin-bottom: 15px; cursor: pointer; background: #ffffff; transition: all 0.3s ease;">
                                    <input type="radio" name="paymentMethod" value="MOMO" style="margin-right: 15px; transform: scale(1.2); cursor: pointer;">

                                    <img src="${pageContext.request.contextPath}/assets/images/logo/momo.png" alt="MoMo Icon" style="width: 36px; height: 36px; object-fit: contain; margin-right: 12px; border-radius: 8px;">

                                    <span style="font-size: 15px; font-weight: 600; color: #1e293b;">MoMo E-Wallet</span>
                                </label>

                                <label class="payment-method-label" style="display: flex; align-items: center; padding: 16px 20px; border: 1px solid #cbd5e1; border-radius: 12px; cursor: pointer; background: #ffffff; transition: all 0.3s ease;">
                                    <input type="radio" name="paymentMethod" value="PAYOS" style="margin-right: 15px; transform: scale(1.2); cursor: pointer;">

                                    <img src="${pageContext.request.contextPath}/assets/images/logo/payos.png" alt="PayOS Icon" style="width: 36px; height: 36px; object-fit: contain; margin-right: 12px; border-radius: 8px;">

                                    <span style="font-size: 15px; font-weight: 600; color: #1e293b;">PayOS (VietQR)</span>
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="checkout-right-pane">
                        <div class="order-summary-box">
                            <h2 class="pane-title" style="text-align: center; color: #4a8ee6;">Order Summary</h2>

                            <div class="summary-items-list">
                                <%
                                    double subTotal = 0;
                                    if (cart != null && !cart.isEmpty()) {
                                        for (Map.Entry<Integer, CartItem> entry : cart.entrySet()) {
                                            CartItem item = entry.getValue();
                                            Template t = item.getTemplate();
                                            subTotal += item.getItemTotal();
                                %>
                                <div class="summary-item-row">
                                    <span class="s-item-name"><%= t.getTitle()%> <small>(x<%= item.getQuantity()%>)</small></span>
                                    <span class="s-item-price"><%= String.format("%,.0f", item.getItemTotal())%>đ</span>
                                </div>
                                <%
                                        }
                                    }
                                %>
                            </div>

                            <div class="summary-divider"></div>

                            <div class="checkout-voucher-area">
                                <%-- Form phụ gửi riêng mã Voucher lên ApplyVoucherController --%>
                                <div class="voucher-input-wrapper">
                                    <input type="text" id="vCode" placeholder="Enter voucher code" class="voucher-input-field">
                                    <button type="button" class="btn-apply-checkout" onclick="submitVoucher()">Apply</button>
                                </div>

                                <%-- Hiển thị thông báo trạng thái của Voucher --%>
                                <%
                                    com.model.Voucher appliedVoucher = (com.model.Voucher) session.getAttribute("APPLIED_VOUCHER");
                                    String vMsg = (String) session.getAttribute("VOUCHER_MSG");
                                    String vMsgType = (String) session.getAttribute("VOUCHER_MSG_TYPE");
                                    if (vMsg != null) {
                                %>
                                <p class="checkout-v-msg <%= vMsgType%>"><%= vMsg%></p>
                                <%
                                        session.removeAttribute("VOUCHER_MSG");
                                        session.removeAttribute("VOUCHER_MSG_TYPE");
                                    }
                                %>
                            </div>

                            <%
                                double discount = 0;
                                if (appliedVoucher != null && subTotal > 0) {
                                    discount = subTotal * (appliedVoucher.getDiscountPercent() / 100.0);
                                    if (discount > appliedVoucher.getMaxDiscountAmount()) {
                                        discount = appliedVoucher.getMaxDiscountAmount();
                                    }
                                }
                                double totalAmount = subTotal - discount;
                                if (totalAmount < 0)
                                    totalAmount = 0;
                            %>

                            <div class="summary-divider"></div>

                            <div class="bill-row">
                                <span>Sub Total</span>
                                <span><%= String.format("%,.0f", subTotal)%>đ</span>
                            </div>
                            <div class="bill-row" style="color: #28a745;">
                                <span>Discount <%= (appliedVoucher != null) ? "(" + appliedVoucher.getCode() + ")" : ""%></span>
                                <span>-<%= String.format("%,.0f", discount)%>đ</span>
                            </div>
                            <div class="summary-divider"></div>
                            <div class="bill-row final-total-row">
                                <span>Total Amount</span>
                                <span><%= String.format("%,.0f", totalAmount)%>đ</span>
                            </div>

                            <button type="submit" class="btn-place-order" <%= (cart == null || cart.isEmpty()) ? "disabled style='background:#555;'" : ""%>>
                                Place Order
                            </button>
                        </div>
                    </div>

                </div>
            </form>
        </main>

        <%-- FORM ẨN ĐỂ XỬ LÝ JS GỬI VOUCHER MÀ KHÔNG LÀM MẤT RADIO CHECKED --%>
        <form id="hiddenVoucherForm" action="${pageContext.request.contextPath}/MainController" method="POST" style="display:none;">
            <input type="hidden" name="action" value="ApplyVoucher">
            <input type="hidden" name="voucherCode" id="hiddenVoucherCode">
        </form>

        <script>
            function submitVoucher() {
                var code = document.getElementById("vCode").value;
                if (code.trim() !== "") {
                    document.getElementById("hiddenVoucherCode").value = code;
                    document.getElementById("hiddenVoucherForm").submit();
                }
            }

            function updatePaymentMethodStyles() {
                const labels = document.querySelectorAll(".payment-method-label");
                labels.forEach(label => {
                    const radio = label.querySelector('input[type="radio"]');
                    if (radio && radio.checked) {
                        label.style.border = "2px solid #3b82f6";
                        label.style.background = "#f0f9ff";
                    } else if (radio) {
                        label.style.border = "1px solid #cbd5e1";
                        label.style.background = "#ffffff";
                    }
                });
            }

            // Giữ lại mã code cũ trên ô input sau khi trang load lại
            window.onload = function () {
            <% if (appliedVoucher != null) {%>
                document.getElementById("vCode").value = "<%= appliedVoucher.getCode()%>";
            <% }%>

                // Initialize payment method highlight
                updatePaymentMethodStyles();

                // Add event listeners to radio buttons
                const radios = document.querySelectorAll('input[name="paymentMethod"]');
                radios.forEach(radio => {
                    radio.addEventListener('change', updatePaymentMethodStyles);
                });
            }
        </script>

        <%-- FOOTER (Đồng bộ từ home.jsp) --%>
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