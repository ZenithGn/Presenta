/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.payment;

import com.model.OrderDAO;
import com.model.PaymentDAO;
import com.model.VoucherDAO;
import com.util.MomoConfig;
import java.io.IOException;
import java.io.PrintWriter;
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
@WebServlet(name = "MomoReturnController", urlPatterns = {"/MomoReturnController"})
public class MomoReturnController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String partnerCode = request.getParameter("partnerCode");
        String orderIdStr = request.getParameter("orderId");
        String requestId = request.getParameter("requestId");
        String amountStr = request.getParameter("amount");
        String orderInfo = request.getParameter("orderInfo");
        String orderType = request.getParameter("orderType");
        String transId = request.getParameter("transId");
        String resultCode = request.getParameter("resultCode");
        String message = request.getParameter("message");
        String payType = request.getParameter("payType");
        String responseTime = request.getParameter("responseTime");
        String extraData = request.getParameter("extraData");
        String m2signature = request.getParameter("signature");

        // Gom chuỗi dữ liệu để kiểm tra chữ ký (Signature)
        String rawHash = "accessKey=" + MomoConfig.ACCESS_KEY
                + "&amount=" + amountStr
                + "&extraData=" + extraData
                + "&message=" + message
                + "&orderId=" + orderIdStr
                + "&orderInfo=" + orderInfo
                + "&orderType=" + orderType
                + "&partnerCode=" + partnerCode
                + "&payType=" + payType
                + "&requestId=" + requestId
                + "&responseTime=" + responseTime
                + "&resultCode=" + resultCode
                + "&transId=" + transId;

        String mySignature = MomoConfig.hmacSHA256(rawHash, MomoConfig.SECRET_KEY);

        try {
            int orderId = Integer.parseInt(orderIdStr);
            OrderDAO orderDao = new OrderDAO();

            // Kiểm tra chữ ký an toàn
            if (mySignature.equals(m2signature)) {

                // resultCode = 0 nghĩa là giao dịch thành công (VNPay là "00", MoMo là "0")
                if ("0".equals(resultCode)) {
                    double amount = Double.parseDouble(amountStr);

                    // 1. Cập nhật DB
                    orderDao.updateOrderStatus(orderId, "Completed");
                    PaymentDAO paymentDao = new PaymentDAO();
                    paymentDao.insertPayment(orderId, "Momo", transId, amount, "Success");

                    // 2. Lấy link sản phẩm
                    java.util.List<com.model.Template> purchasedTemplates = orderDao.getPurchasedTemplatesByOrderId(orderId);
                    request.setAttribute("purchasedTemplates", purchasedTemplates);

                    // 3. Xóa Session & Trừ Voucher
                    HttpSession session = request.getSession();
                    com.model.Voucher appliedVoucher = (com.model.Voucher) session.getAttribute("APPLIED_VOUCHER");
                    if (appliedVoucher != null) {
                        new VoucherDAO().increaseUsedCount(appliedVoucher.getVoucherId());
                    }
                    session.removeAttribute("CART");
                    session.removeAttribute("APPLIED_VOUCHER");

                    request.setAttribute("message", "Thanh toán MoMo thành công! Mã GD: " + transId);
                    request.getRequestDispatcher("views/web/payment-return/payment-success.jsp").forward(request, response);

                } else {
                    // Thanh toán thất bại
                    orderDao.updateOrderStatus(orderId, "Cancelled");
                    request.setAttribute("message", "Thanh toán MoMo thất bại: " + message);
                    request.getRequestDispatcher("views/web/payment-return/payment-failed.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("message", "Dữ liệu trả về không hợp lệ (Sai chữ ký bảo mật).");
                request.getRequestDispatcher("views/web/payment-return/payment-failed.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
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
