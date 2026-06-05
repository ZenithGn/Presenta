/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.payment;

import com.model.CartItem;
import com.model.Order;
import com.model.OrderDAO;
import com.model.User;
import com.model.Voucher;
import com.util.PayOSConfig;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import vn.payos.model.v2.paymentRequests.CreatePaymentLinkRequest;
import vn.payos.model.v2.paymentRequests.CreatePaymentLinkResponse;
import vn.payos.model.v2.paymentRequests.PaymentLinkItem;

/**
 *
 * @author lehan
 */
@WebServlet(name = "PayOSController", urlPatterns = {"/PayOSController"})
public class PayOSController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("LOGIN_USER");
        String orderType = request.getParameter("orderType");

        try {
            if (PayOSConfig.payOS == null) {
                request.setAttribute("errorMessage", "Cổng thanh toán PayOS chưa được cấu hình!");
                request.getRequestDispatcher("views/web/checkout.jsp").forward(request, response);
                return;
            }

            // ===== HIRE_DESIGNER FLOW =====
            if ("HIRE_DESIGNER".equals(orderType)) {
                if (loginUser == null) {
                    response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
                    return;
                }
                String orderIdStr = request.getParameter("orderId");
                int orderId;
                try {
                    orderId = Integer.parseInt(orderIdStr);
                } catch (NumberFormatException e) {
                    request.setAttribute("message", "Mã đơn hàng không hợp lệ!");
                    request.getRequestDispatcher("views/web/payment-return/payment-failed.jsp").forward(request, response);
                    return;
                }

                OrderDAO orderDao = new OrderDAO();
                Order existingOrder = orderDao.getCustomOrderById(orderId);
                if (existingOrder == null || existingOrder.getCustomerId() != loginUser.getUserId()
                        || !"Completed_Design".equals(existingOrder.getStatus())) {
                    request.setAttribute("message", "Đơn hàng không tồn tại hoặc chưa sẵn sàng thanh toán!");
                    request.getRequestDispatcher("views/web/payment-return/payment-failed.jsp").forward(request, response);
                    return;
                }

                int amount = (int) existingOrder.getTotalPrice();
                // orderCode requires to be unique int <= 53 bits.
                long orderCode = Long.parseLong(String.valueOf(orderId) + String.valueOf(System.currentTimeMillis() % 10000));

                String description = "Thanh toan don " + orderId;
                String returnUrl = PayOSConfig.PAYOS_RETURN_URL + "?orderId=" + orderId;
                String cancelUrl = PayOSConfig.PAYOS_CANCEL_URL + "?orderId=" + orderId;

                PaymentLinkItem item = PaymentLinkItem.builder().name("Don thiet ke " + orderId).quantity(1).price((long) amount).build();
                java.util.List<PaymentLinkItem> itemsList = new java.util.ArrayList<>();
                itemsList.add(item);
                
                CreatePaymentLinkRequest paymentData = CreatePaymentLinkRequest.builder()
                        .orderCode(orderCode)
                        .amount((long) amount)
                        .description(description)
                        .returnUrl(returnUrl)
                        .cancelUrl(cancelUrl)
                        .items(itemsList)
                        .build();

                CreatePaymentLinkResponse data = PayOSConfig.payOS.paymentRequests().create(paymentData);
                response.sendRedirect(data.getCheckoutUrl());
                return;
            }

            // ===== BUY_TEMPLATE FLOW =====
            Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("CART");
            Voucher appliedVoucher = (Voucher) session.getAttribute("APPLIED_VOUCHER");

            if (loginUser == null || cart == null || cart.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/MainController?action=ViewCart");
                return;
            }

            double subTotal = 0;
            for (CartItem item : cart.values()) {
                subTotal += item.getItemTotal();
            }

            double discount = 0;
            if (appliedVoucher != null && subTotal > 0) {
                discount = subTotal * (appliedVoucher.getDiscountPercent() / 100.0);
                if (discount > appliedVoucher.getMaxDiscountAmount()) {
                    discount = appliedVoucher.getMaxDiscountAmount();
                }
            }

            double finalTotal = subTotal - discount;
            if (finalTotal <= 0) {
                finalTotal = 0;
            }

            OrderDAO orderDao = new OrderDAO();
            Order order = new Order();
            order.setCustomerId(loginUser.getUserId());
            order.setTotalPrice(finalTotal);
            order.setOrderType("BUY_TEMPLATE");

            if (appliedVoucher != null) {
                order.setVoucherId(appliedVoucher.getVoucherId());
            }

            String orderIdStr = orderDao.insertOrder(order, cart);

            if (orderIdStr == null) {
                request.setAttribute("errorMessage", "Lỗi tạo đơn hàng trong hệ thống!");
                request.getRequestDispatcher("views/web/checkout.jsp").forward(request, response);
                return;
            }

            int amount = (int) finalTotal;
            long orderCode = Long.parseLong(orderIdStr + String.valueOf(System.currentTimeMillis() % 10000));
            String description = "Thanh toan template";
            String returnUrl = PayOSConfig.PAYOS_RETURN_URL + "?orderId=" + orderIdStr;
            String cancelUrl = PayOSConfig.PAYOS_CANCEL_URL + "?orderId=" + orderIdStr;

            CreatePaymentLinkRequest.CreatePaymentLinkRequestBuilder builder = CreatePaymentLinkRequest.builder()
                    .orderCode(orderCode)
                    .amount((long) amount)
                    .description(description)
                    .returnUrl(returnUrl)
                    .cancelUrl(cancelUrl);

            java.util.List<PaymentLinkItem> itemsList = new java.util.ArrayList<>();
            for (CartItem item : cart.values()) {
                itemsList.add(PaymentLinkItem.builder()
                        .name(item.getTemplate().getTitle())
                        .quantity(item.getQuantity())
                        .price((long) item.getTemplate().getPrice())
                        .build());
            }
            builder.items(itemsList);

            CreatePaymentLinkRequest paymentData = builder.build();
            CreatePaymentLinkResponse data = PayOSConfig.payOS.paymentRequests().create(paymentData);
            response.sendRedirect(data.getCheckoutUrl());

        }  catch (Exception e) {
            log("Error at PayOSController: " + e.getMessage());
            request.setAttribute("errorMessage", "Lỗi khi tạo liên kết thanh toán PayOS: " + e.getMessage());
            request.getRequestDispatcher("views/web/checkout.jsp").forward(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
