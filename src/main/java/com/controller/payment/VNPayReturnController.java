/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.payment;

import com.model.Template;
import com.util.VNPayConfig;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author lehan
 */
@WebServlet(name = "VNPayReturnController", urlPatterns = {"/VNPayReturnController"})
public class VNPayReturnController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
            String fieldName = URLEncoder.encode(params.nextElement(), StandardCharsets.US_ASCII.toString());
            String fieldValue = URLEncoder.encode(request.getParameter(fieldName), StandardCharsets.US_ASCII.toString());
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        if (fields.containsKey("vnp_SecureHashType")) {
            fields.remove("vnp_SecureHashType");
        }
        if (fields.containsKey("vnp_SecureHash")) {
            fields.remove("vnp_SecureHash");
        }

        // Checksum
        String signValue = VNPayConfig.hmacSHA512(VNPayConfig.vnp_HashSecret, hashAllFields(fields));

        if (signValue.equals(vnp_SecureHash)) {
            // Checksum hợp lệ
            if ("00".equals(request.getParameter("vnp_TransactionStatus"))) {
                String txnRef = request.getParameter("vnp_TxnRef"); // OrderID
                String amountStr = request.getParameter("vnp_Amount");
                String transactionNo = request.getParameter("vnp_TransactionNo");

                try {
                    int orderId = Integer.parseInt(txnRef);
                    double amount = Double.parseDouble(amountStr) / 100.0;

                    com.model.OrderDAO orderDao = new com.model.OrderDAO();
                    orderDao.updateOrderStatus(orderId, "Completed");

                    com.model.PaymentDAO paymentDao = new com.model.PaymentDAO();
                    paymentDao.insertPayment(orderId, "VNPay", transactionNo, amount, "Success");

                    // =======================================================
                    // THÊM MỚI: Lấy danh sách sản phẩm đã mua giao sang cho JSP
                    // =======================================================
                    List<Template> purchasedTemplates = orderDao.getPurchasedTemplatesByOrderId(orderId);
                    request.setAttribute("purchasedTemplates", purchasedTemplates);
                    // =======================================================

                    javax.servlet.http.HttpSession session = request.getSession();
                    com.model.Voucher appliedVoucher = (com.model.Voucher) session.getAttribute("APPLIED_VOUCHER");
                    if (appliedVoucher != null) {
                        com.model.VoucherDAO vDao = new com.model.VoucherDAO();
                        vDao.increaseUsedCount(appliedVoucher.getVoucherId());
                    }

                    session.removeAttribute("CART");
                    session.removeAttribute("APPLIED_VOUCHER");

                } catch (Exception e) {
                    log("Error processing download data: " + e.getMessage());
                }

                request.setAttribute("message", "Thanh toán thành công! Mã giao dịch: " + transactionNo);
                request.getRequestDispatcher("views/web/payment-return/payment-success.jsp").forward(request, response);
            } else {
                // GIAO DỊCH THẤT BẠI HOẶC BỊ HỦY (Ví dụ: Khách bấm nút Hủy trên app ngân hàng)
                String txnRef = request.getParameter("vnp_TxnRef");
                try {
                    int orderId = Integer.parseInt(txnRef);
                    com.model.OrderDAO orderDao = new com.model.OrderDAO();
                    // Đổi trạng thái Orders thành Cancelled để dọn rác
                    orderDao.updateOrderStatus(orderId, "Cancelled");
                } catch (Exception e) {
                }
                request.setAttribute("message", "Thanh toán thất bại hoặc đã bị hủy bởi người dùng.");
                request.getRequestDispatcher("views/web/payment-return/payment-failed.jsp").forward(request, response);
            }
        }
    }
    // Hàm phụ trợ tạo hash data từ params

    private String hashAllFields(Map<String, String> fields) {
        List<String> fieldNames = new ArrayList<>(fields.keySet());
        java.util.Collections.sort(fieldNames);
        StringBuilder sb = new StringBuilder();
        java.util.Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = fields.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                sb.append(fieldName);
                sb.append("=");
                sb.append(fieldValue);
            }
            if (itr.hasNext()) {
                sb.append("&");
            }
        }
        return sb.toString();
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
