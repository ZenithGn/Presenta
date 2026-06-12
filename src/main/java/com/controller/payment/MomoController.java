/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.payment;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.model.CartItem;
import com.model.OrderDAO;
import com.model.User;
import com.model.Voucher;
import com.util.MomoConfig;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Map;
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
@WebServlet(name = "MomoController", urlPatterns = {"/MomoController"})
public class MomoController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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
            int orderIdInt;
            try { orderIdInt = Integer.parseInt(orderIdStr); }
            catch (NumberFormatException e) {
                request.setAttribute("message", "Mã đơn hàng không hợp lệ!");
                request.getRequestDispatcher("views/web/payment-return/payment-failed.jsp").forward(request, response);
                return;
            }

            com.model.OrderDAO orderCheckDao = new com.model.OrderDAO();
            com.model.Order existingOrder = orderCheckDao.getCustomOrderById(orderIdInt);
            if (existingOrder == null || existingOrder.getCustomerId() != loginUser.getUserId()
                    || !"Completed_Design".equals(existingOrder.getStatus())) {
                request.setAttribute("message", "Đơn hàng không tồn tại hoặc chưa sẵn sàng thanh toán!");
                request.getRequestDispatcher("views/web/payment-return/payment-failed.jsp").forward(request, response);
                return;
            }

            long amount = (long) existingOrder.getTotalPrice();
            String orderId = String.valueOf(orderIdInt);
            String requestId = String.valueOf(System.currentTimeMillis());
            String orderInfo = "Thanh toan thiet ke rieng Presenta #" + orderId;
            String returnUrl = MomoConfig.RETURN_URL;
            String notifyUrl = MomoConfig.IPN_URL;
            String requestType = "captureWallet";
            String extraData = "";

            String rawHash = "accessKey=" + MomoConfig.ACCESS_KEY
                    + "&amount=" + amount
                    + "&extraData=" + extraData
                    + "&ipnUrl=" + notifyUrl
                    + "&orderId=" + orderId
                    + "&orderInfo=" + orderInfo
                    + "&partnerCode=" + MomoConfig.PARTNER_CODE
                    + "&redirectUrl=" + returnUrl
                    + "&requestId=" + requestId
                    + "&requestType=" + requestType;
            String signature = MomoConfig.hmacSHA256(rawHash, MomoConfig.SECRET_KEY);

            JsonObject jsonReq = new JsonObject();
            jsonReq.addProperty("partnerCode", MomoConfig.PARTNER_CODE);
            jsonReq.addProperty("partnerName", "Presenta");
            jsonReq.addProperty("storeId", "PresentaStore");
            jsonReq.addProperty("requestId", requestId);
            jsonReq.addProperty("amount", amount);
            jsonReq.addProperty("orderId", orderId);
            jsonReq.addProperty("orderInfo", orderInfo);
            jsonReq.addProperty("redirectUrl", returnUrl);
            jsonReq.addProperty("ipnUrl", notifyUrl);
            jsonReq.addProperty("lang", "vi");
            jsonReq.addProperty("extraData", extraData);
            jsonReq.addProperty("requestType", requestType);
            jsonReq.addProperty("signature", signature);

            try {
                URL url = new URL(MomoConfig.ENDPOINT);
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                connection.setRequestMethod("POST");
                connection.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
                connection.setDoOutput(true);

                try (OutputStream os = connection.getOutputStream()) {
                    byte[] input = jsonReq.toString().getBytes(StandardCharsets.UTF_8);
                    os.write(input, 0, input.length);
                }

                int responseCode = connection.getResponseCode();
                java.io.InputStream is = (responseCode >= 400) ? connection.getErrorStream() : connection.getInputStream();
                BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
                StringBuilder responseStrBuilder = new StringBuilder();
                String inputStr;
                while ((inputStr = br.readLine()) != null) {
                    responseStrBuilder.append(inputStr);
                }
                br.close();
                System.out.println("MOMO RESPONSE 1: " + responseStrBuilder.toString());

                JsonObject jsonRes = JsonParser.parseString(responseStrBuilder.toString()).getAsJsonObject();
                if (jsonRes.has("payUrl")) {
                    String payUrl = jsonRes.get("payUrl").getAsString();
                    response.sendRedirect(payUrl);
                } else {
                    String msg = jsonRes.has("message") ? jsonRes.get("message").getAsString() : "Lỗi không xác định";
                    request.setAttribute("message", "Chi tiết lỗi MoMo: " + msg);
                    request.getRequestDispatcher("views/web/payment-return/payment-failed.jsp").forward(request, response);
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("message", "Không thể kết nối đến MoMo Server: " + e.getMessage());
                request.getRequestDispatcher("views/web/payment-return/payment-failed.jsp").forward(request, response);
            }
            return;
        }

        // ===== BUY_TEMPLATE FLOW (original) =====
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("CART");
        Voucher appliedVoucher = (Voucher) session.getAttribute("APPLIED_VOUCHER");

        if (loginUser == null || cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=ViewCart");
            return;
        }

        // 1. TÍNH TOÁN TỔNG TIỀN (Giống VNPay)
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

        // Ép kiểu tiền (MoMo không nhân 100 như VNPay, MoMo giữ nguyên giá trị VD: 50000)
        long amount = (long) finalTotal;

        // 2. LƯU ĐƠN HÀNG VÀO DATABASE BẰNG ORDER_DAO
        OrderDAO orderDao = new OrderDAO();
        com.model.Order order = new com.model.Order();
        order.setCustomerId(loginUser.getUserId());
        order.setTotalPrice(finalTotal);
        order.setOrderType("BUY_TEMPLATE");
        if (appliedVoucher != null) {
            order.setVoucherId(appliedVoucher.getVoucherId());
        }

        String orderId = orderDao.insertOrder(order, cart);
        if (orderId == null) {
            response.sendRedirect("views/web/checkout.jsp");
            return;
        }

        // 3. CẤU HÌNH DỮ LIỆU ĐẨY LÊN MOMO
        String requestId = String.valueOf(System.currentTimeMillis());
        String orderInfo = "Thanh toan don hang Presenta #" + orderId;
        String returnUrl = MomoConfig.RETURN_URL;
        String notifyUrl = MomoConfig.IPN_URL;
        String requestType = "captureWallet"; // Quét mã QR MoMo
        String extraData = ""; // Bắt buộc phải có nhưng để trống

        // Xây dựng chuỗi chữ ký (Đúng chuẩn cú pháp MoMo yêu cầu)
        String rawHash = "accessKey=" + MomoConfig.ACCESS_KEY
                + "&amount=" + amount
                + "&extraData=" + extraData
                + "&ipnUrl=" + notifyUrl
                + "&orderId=" + orderId
                + "&orderInfo=" + orderInfo
                + "&partnerCode=" + MomoConfig.PARTNER_CODE
                + "&redirectUrl=" + returnUrl
                + "&requestId=" + requestId
                + "&requestType=" + requestType;

        String signature = MomoConfig.hmacSHA256(rawHash, MomoConfig.SECRET_KEY);

        // 4. ĐÓNG GÓI JSON BẰNG GSON
        JsonObject jsonReq = new JsonObject();
        jsonReq.addProperty("partnerCode", MomoConfig.PARTNER_CODE);
        jsonReq.addProperty("partnerName", "Presenta");
        jsonReq.addProperty("storeId", "PresentaStore");
        jsonReq.addProperty("requestId", requestId);
        jsonReq.addProperty("amount", amount);
        jsonReq.addProperty("orderId", orderId);
        jsonReq.addProperty("orderInfo", orderInfo);
        jsonReq.addProperty("redirectUrl", returnUrl);
        jsonReq.addProperty("ipnUrl", notifyUrl);
        jsonReq.addProperty("lang", "vi");
        jsonReq.addProperty("extraData", extraData);
        jsonReq.addProperty("requestType", requestType);
        jsonReq.addProperty("signature", signature);

        // 5. GỬI HTTP POST LÊN SERVER MOMO
        try {
            URL url = new URL(MomoConfig.ENDPOINT);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            connection.setDoOutput(true);

            try ( OutputStream os = connection.getOutputStream()) {
                byte[] input = jsonReq.toString().getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            // Đọc phản hồi (Response) từ MoMo
            int responseCode = connection.getResponseCode();
            java.io.InputStream is = (responseCode >= 400) ? connection.getErrorStream() : connection.getInputStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            StringBuilder responseStrBuilder = new StringBuilder();
            String inputStr;
            while ((inputStr = br.readLine()) != null) {
                responseStrBuilder.append(inputStr);
            }
            br.close();
            System.out.println("MOMO RESPONSE 2: " + responseStrBuilder.toString());

            // Trích xuất link payUrl từ chuỗi JSON trả về
            JsonObject jsonRes = JsonParser.parseString(responseStrBuilder.toString()).getAsJsonObject();
            if (jsonRes.has("payUrl")) {
                String payUrl = jsonRes.get("payUrl").getAsString();
                response.sendRedirect(payUrl); // CHUYỂN HƯỚNG TỚI TRANG QUÉT MÃ MOMO
            } else {
                String msg = jsonRes.has("message") ? jsonRes.get("message").getAsString() : "Lỗi không xác định";
                request.setAttribute("message", "Chi tiết lỗi MoMo: " + msg);
                request.getRequestDispatcher("views/web/payment-return/payment-failed.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Không thể kết nối đến MoMo Server: " + e.getMessage());
            request.getRequestDispatcher("views/web/payment-return/payment-failed.jsp").forward(request, response);
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
