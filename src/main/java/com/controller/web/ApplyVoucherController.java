/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.web;

import com.model.VoucherDAO;
import com.model.Voucher;
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
@WebServlet(name = "ApplyVoucherController", urlPatterns = {"/ApplyVoucherController"})
public class ApplyVoucherController extends HttpServlet {

    public static final String VIEW_CART_ACTION = "MainController?action=ViewCart";
    public static final String CHECKOUT_ACTION = "MainController?action=Checkout";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = VIEW_CART_ACTION;

        try {
            String voucherCode = request.getParameter("voucherCode");
            HttpSession session = request.getSession();

            if (voucherCode != null && !voucherCode.trim().isEmpty()) {
                VoucherDAO vDao = new VoucherDAO();
                Voucher voucher = vDao.getValidVoucher(voucherCode);

                if (voucher != null) {
                    session.setAttribute("APPLIED_VOUCHER", voucher);
                    session.setAttribute("VOUCHER_MSG", "Voucher applied successfully!");
                    session.setAttribute("VOUCHER_MSG_TYPE", "success");
                } else {
                    session.removeAttribute("APPLIED_VOUCHER");
                    session.setAttribute("VOUCHER_MSG", "Invalid or expired voucher code!");
                    session.setAttribute("VOUCHER_MSG_TYPE", "error");
                }
            }
        } catch (Exception e) {
            log("Error at ApplyVoucherController: " + e.toString());
        } finally {
            response.sendRedirect(request.getContextPath() + "/" + CHECKOUT_ACTION);
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
