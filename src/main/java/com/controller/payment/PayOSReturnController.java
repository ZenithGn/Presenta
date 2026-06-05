/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.payment;

import com.model.Template;
import com.util.PayOSConfig;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import vn.payos.PayOS;
import vn.payos.model.v2.paymentRequests.PaymentLink;
import vn.payos.model.v2.paymentRequests.PaymentLinkStatus;

/**
 *
 * @author lehan
 */
@WebServlet(name = "PayOSReturnController", urlPatterns = {"/PayOSReturnController"})
public class PayOSReturnController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            // Check if user cancelled
            String cancel = request.getParameter("cancel");
            String orderIdStr = request.getParameter("orderId");
            String orderCodeStr = request.getParameter("orderCode");

            if ("true".equals(cancel)) {
                // Người dùng hủy thanh toán
                if (orderIdStr != null && !orderIdStr.isEmpty()) {
                    try {
                        int orderId = Integer.parseInt(orderIdStr);
                        com.model.OrderDAO orderDao = new com.model.OrderDAO();
                        orderDao.updateOrderStatus(orderId, "Cancelled");
                    } catch (Exception e) {
                        log("Error updating Cancelled status: " + e.getMessage());
                    }
                }
                request.setAttribute("message", "Thanh toán thất bại hoặc đã bị hủy bởi người dùng.");
                request.getRequestDispatcher("views/web/payment-return/payment-failed.jsp").forward(request, response);
                return;
            }

            // Verify payment success via PayOS API
            if (orderCodeStr != null && !orderCodeStr.isEmpty()) {
                long orderCode = Long.parseLong(orderCodeStr);
                PaymentLink paymentLinkData = PayOSConfig.payOS.paymentRequests().get(orderCode);

                if (PaymentLinkStatus.PAID.equals(paymentLinkData.getStatus())) {
                    int orderId = Integer.parseInt(orderIdStr);
                    double amount = paymentLinkData.getAmountPaid();
                    String transactionNo = paymentLinkData.getId(); // Use payment link ID as transaction no

                    com.model.OrderDAO orderDao = new com.model.OrderDAO();
                    orderDao.updateOrderStatus(orderId, "Completed");

                    com.model.PaymentDAO paymentDao = new com.model.PaymentDAO();
                    paymentDao.insertPayment(orderId, "PayOS", transactionNo, amount, "Success");

                    new com.model.DesignerDAO().creditDesignerRevenue(orderId);

                    List<Template> purchasedTemplates = orderDao.getPurchasedTemplatesByOrderId(orderId);
                    request.setAttribute("purchasedTemplates", purchasedTemplates);

                    javax.servlet.http.HttpSession session = request.getSession();
                    com.model.Voucher appliedVoucher = (com.model.Voucher) session.getAttribute("APPLIED_VOUCHER");
                    if (appliedVoucher != null) {
                        com.model.VoucherDAO vDao = new com.model.VoucherDAO();
                        vDao.increaseUsedCount(appliedVoucher.getVoucherId());
                    }

                    session.removeAttribute("CART");
                    session.removeAttribute("APPLIED_VOUCHER");

                    request.setAttribute("message", "Thanh toán thành công! Mã giao dịch: " + transactionNo);
                    request.getRequestDispatcher("views/web/payment-return/payment-success.jsp").forward(request, response);
                } else {
                    request.setAttribute("message", "Thanh toán chưa hoàn tất. Trạng thái: " + paymentLinkData.getStatus());
                    request.getRequestDispatcher("views/web/payment-return/payment-failed.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("message", "Dữ liệu trả về không hợp lệ.");
                request.getRequestDispatcher("views/web/payment-return/payment-failed.jsp").forward(request, response);
            }

        } catch (Exception e) {
            log("Error at PayOSReturnController: " + e.getMessage());
            request.setAttribute("message", "Lỗi xử lý thanh toán PayOS: " + e.getMessage());
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
