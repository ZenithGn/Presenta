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
import com.util.VNPayConfig;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author lehan
 */
@WebServlet(name = "VNPayController", urlPatterns = {"/VNPayController"})
public class VNPayController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("LOGIN_USER");
        String orderType = request.getParameter("orderType"); // "HIRE_DESIGNER" or null (= BUY_TEMPLATE)

        // ===== HIRE_DESIGNER FLOW: Pay for existing booking =====
        if ("HIRE_DESIGNER".equals(orderType)) {
            if (loginUser == null) {
                response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
                return;
            }
            String orderIdStr = request.getParameter("orderId");
            int orderId;
            try { orderId = Integer.parseInt(orderIdStr); }
            catch (NumberFormatException e) {
                request.setAttribute("message", "Mã đơn hàng không hợp lệ!");
                request.getRequestDispatcher("views/web/payment-return/payment-failed.jsp").forward(request, response);
                return;
            }

            com.model.OrderDAO orderDao = new com.model.OrderDAO();
            com.model.Order existingOrder = orderDao.getCustomOrderById(orderId);
            if (existingOrder == null || existingOrder.getCustomerId() != loginUser.getUserId()
                    || !"Completed_Design".equals(existingOrder.getStatus())) {
                request.setAttribute("message", "Đơn hàng không tồn tại hoặc chưa sẵn sàng thanh toán!");
                request.getRequestDispatcher("views/web/payment-return/payment-failed.jsp").forward(request, response);
                return;
            }

            long amount = (long) (existingOrder.getTotalPrice() * 100);
            String vnp_TxnRef = String.valueOf(orderId);

            Map<String, String> vnp_Params = new HashMap<>();
            vnp_Params.put("vnp_Version", "2.1.0");
            vnp_Params.put("vnp_Command", "pay");
            vnp_Params.put("vnp_TmnCode", VNPayConfig.vnp_TmnCode);
            vnp_Params.put("vnp_Amount", String.valueOf(amount));
            vnp_Params.put("vnp_CurrCode", "VND");

            String bankCode = request.getParameter("bankCode");
            if (bankCode != null && !bankCode.isEmpty()) {
                vnp_Params.put("vnp_BankCode", bankCode);
            } else {
                vnp_Params.put("vnp_BankCode", "NCB");
            }

            vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
            vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang: " + vnp_TxnRef);
            vnp_Params.put("vnp_OrderType", "other");
            vnp_Params.put("vnp_Locale", "vn");
            vnp_Params.put("vnp_ReturnUrl", VNPayConfig.vnp_Returnurl);

            String vnp_IpAddr = VNPayConfig.getIpAddress(request);
            if (vnp_IpAddr == null || vnp_IpAddr.equals("0:0:0:0:0:0:0:1")) {
                vnp_IpAddr = "127.0.0.1";
            }
            vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

            Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            vnp_Params.put("vnp_CreateDate", formatter.format(cld.getTime()));
            cld.add(Calendar.MINUTE, 15);
            vnp_Params.put("vnp_ExpireDate", formatter.format(cld.getTime()));

            List fieldNames = new ArrayList(vnp_Params.keySet());
            Collections.sort(fieldNames);
            StringBuilder hashData = new StringBuilder();
            StringBuilder query = new StringBuilder();
            Iterator itr = fieldNames.iterator();
            while (itr.hasNext()) {
                String fieldName = (String) itr.next();
                String fieldValue = (String) vnp_Params.get(fieldName);
                if ((fieldValue != null) && (fieldValue.length() > 0)) {
                    hashData.append(fieldName);
                    hashData.append('=');
                    hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                    query.append('=');
                    query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    if (itr.hasNext()) {
                        query.append('&');
                        hashData.append('&');
                    }
                }
            }
            String queryUrl = query.toString();
            String vnp_SecureHash = VNPayConfig.hmacSHA512(VNPayConfig.vnp_HashSecret, hashData.toString());
            queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
            String paymentUrl = VNPayConfig.vnp_PayUrl + "?" + queryUrl;
            response.sendRedirect(paymentUrl);
            return;
        }

        // ===== BUY_TEMPLATE FLOW (original) =====
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("CART");
        Voucher appliedVoucher = (Voucher) session.getAttribute("APPLIED_VOUCHER");

        // 1. Kiểm tra hợp lệ
        if (loginUser == null || cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=ViewCart");
            return;
        }

        // 2. BẢO MẬT: Tự tính toán lại tiền từ hệ thống (Không dùng getParameter)
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

        // 3. TƯ DUY CỦA BẠN: Lưu đơn hàng vào Database với trạng thái 'Pending'
        com.model.OrderDAO orderDao = new com.model.OrderDAO();
        com.model.Order order = new com.model.Order();

        order.setCustomerId(loginUser.getUserId());
        order.setTotalPrice(finalTotal);
        order.setOrderType("BUY_TEMPLATE");

        if (appliedVoucher != null) {
            order.setVoucherId(appliedVoucher.getVoucherId());
        }

        String orderId = orderDao.insertOrder(order, cart); // Giả sử hàm này trả về mã đơn hàng (vd: ORD12345)

        if (orderId == null) {
            request.setAttribute("errorMessage", "Lỗi tạo đơn hàng trong hệ thống!");
            request.getRequestDispatcher("views/web/checkout.jsp").forward(request, response);
            return;
        }

        // 4. Khởi tạo VNPay với vnp_TxnRef chính là mã Đơn hàng
        long amount = (long) (finalTotal * 100);
        String vnp_TxnRef = orderId; // Gắn OrderID vào mã giao dịch

        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", "2.1.0");
        vnp_Params.put("vnp_Command", "pay");
        vnp_Params.put("vnp_TmnCode", VNPayConfig.vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode", "VND");

        // Nhận bankCode nếu có (hoặc mặc định NCB để test)
        String bankCode = request.getParameter("bankCode");
        if (bankCode != null && !bankCode.isEmpty()) {
            vnp_Params.put("vnp_BankCode", bankCode);
        } else {
            vnp_Params.put("vnp_BankCode", "NCB");
        }

        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang: " + vnp_TxnRef);
        vnp_Params.put("vnp_OrderType", "other");
        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_ReturnUrl", VNPayConfig.vnp_Returnurl);

        String vnp_IpAddr = VNPayConfig.getIpAddress(request);
        if (vnp_IpAddr == null || vnp_IpAddr.equals("0:0:0:0:0:0:0:1")) {
            vnp_IpAddr = "127.0.0.1";
        }
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        vnp_Params.put("vnp_CreateDate", formatter.format(cld.getTime()));

        cld.add(Calendar.MINUTE, 15);
        vnp_Params.put("vnp_ExpireDate", formatter.format(cld.getTime()));

        // 5. Hash và Redirect
        List fieldNames = new ArrayList(vnp_Params.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        Iterator itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = (String) itr.next();
            String fieldValue = (String) vnp_Params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));

                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                if (itr.hasNext()) {
                    query.append('&');
                    hashData.append('&');
                }
            }
        }

        String queryUrl = query.toString();
        String vnp_SecureHash = VNPayConfig.hmacSHA512(VNPayConfig.vnp_HashSecret, hashData.toString());
        queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
        String paymentUrl = VNPayConfig.vnp_PayUrl + "?" + queryUrl;

        System.out.println("====== VNPAY DEBUG ======");
        System.out.println("1. TMN CODE: '" + VNPayConfig.vnp_TmnCode + "'");
        System.out.println("2. AMOUNT: " + amount);
        System.out.println("3. TXN_REF (OrderID): " + vnp_TxnRef);
        System.out.println("4. PAYMENT URL: \n" + paymentUrl);
        System.out.println("=========================");

        response.sendRedirect(paymentUrl);
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
