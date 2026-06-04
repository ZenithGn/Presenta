/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.designer;

import com.model.User;
import com.model.Withdrawal;
import com.model.WithdrawalDAO;
import com.model.DesignerDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Designer Withdrawals Page — shows withdrawal form + history for the logged-in designer.
 * @author lehan
 */
@WebServlet(name = "DesignerWithdrawalController", urlPatterns = {"/DesignerWithdrawalController"})
public class DesignerWithdrawalController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("LOGIN_USER");

        if (loginUser == null || loginUser.getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
            return;
        }

        int designerId = loginUser.getUserId();
        DesignerDAO dDao = new DesignerDAO();
        WithdrawalDAO wDao = new WithdrawalDAO();

        try {
            // Get current balance
            double balance = dDao.getBalance(designerId);
            request.setAttribute("DESIGNER_BALANCE", balance);

            // Get withdrawal history
            List<Withdrawal> history = wDao.getWithdrawalsByDesigner(designerId);
            request.setAttribute("WITHDRAWAL_HISTORY", history);

        } catch (Exception e) {
            log("Error at DesignerWithdrawalController: " + e.getMessage());
            e.printStackTrace();
        }

        request.getRequestDispatcher("views/designer/withdrawals.jsp").forward(request, response);
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
        return "Designer Withdrawals Controller";
    }
}
