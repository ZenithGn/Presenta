/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.designer;

import com.model.User;
import com.model.WithdrawalDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Handles withdrawal requests from designers.
 * @author lehan
 */
@WebServlet(name = "WithdrawalController", urlPatterns = {"/WithdrawalController"})
public class WithdrawalController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("LOGIN_USER");

        // Validate designer login
        if (loginUser == null || loginUser.getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
            return;
        }

        try {
            int designerId = loginUser.getUserId();
            String amountStr = request.getParameter("amount");
            String bankName = request.getParameter("bankName");
            String bankAccountNumber = request.getParameter("bankAccountNumber");
            String accountName = request.getParameter("accountName");

            // Validate inputs
            if (amountStr == null || amountStr.trim().isEmpty()
                    || bankName == null || bankName.trim().isEmpty()
                    || bankAccountNumber == null || bankAccountNumber.trim().isEmpty()
                    || accountName == null || accountName.trim().isEmpty()) {
                session.setAttribute("toastMessage", "Vui lòng điền đầy đủ thông tin rút tiền.");
                response.sendRedirect("MainController?action=DesignerHome");
                return;
            }

            double amount;
            try {
                amount = Double.parseDouble(amountStr.trim());
                if (amount <= 0) throw new NumberFormatException();
            } catch (NumberFormatException e) {
                session.setAttribute("toastMessage", "Số tiền rút không hợp lệ.");
                response.sendRedirect("MainController?action=DesignerHome");
                return;
            }

            WithdrawalDAO wDao = new WithdrawalDAO();
            boolean success = wDao.insertWithdrawal(
                    designerId, amount,
                    bankName.trim(),
                    bankAccountNumber.trim(),
                    accountName.trim()
            );

            if (success) {
                session.setAttribute("toastMessage", "Yêu cầu rút tiền đã được gửi! Đang chờ Admin duyệt.");
            } else {
                session.setAttribute("toastMessage", "Số dư không đủ để thực hiện rút tiền.");
            }

        } catch (Exception e) {
            log("Error at WithdrawalController: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("toastMessage", "Đã xảy ra lỗi khi gửi yêu cầu rút tiền.");
        }

        response.sendRedirect("MainController?action=DesignerHome");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Designer Withdrawal Controller";
    }
}
