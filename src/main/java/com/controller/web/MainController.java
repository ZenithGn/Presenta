/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.web;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author lehan
 */
@WebServlet(name = "MainController", urlPatterns = {"/MainController"})
public class MainController extends HttpServlet {

    private static final String WELCOME = "views/web/home.jsp";
    private static final String LOGIN = "Login";
    private static final String LOGIN_CONTROLLER = "LoginController";
    private static final String LOGOUT = "Logout";
    private static final String LOGOUT_CONTROLLER = "LogoutController";
    private static final String REGISTER = "Register";
    private static final String REGISTER_CONTROLLER = "RegisterController";
    private static final String SHOP = "Shop";
    private static final String SHOP_CONTROLLER = "ShopController";
    private static final String TEMPLATE_DETAIL = "TemplateDetail";
    private static final String TEMPLATE_DETAIL_CONTROLLER = "TemplateDetailController";
    private static final String DESIGNER_HUB = "DesignerHub";
    private static final String DESIGNER_HUB_CONTROLLER = "DesignerHubController";
    private static final String DESIGNER_LIST = "DesignerList";
    private static final String DESIGNER_LIST_CONTROLLER = "DesignerListController";
    private static final String DESIGNER_DETAIL = "DesignerDetail";
    private static final String DESIGNER_DETAIL_CONTROLLER = "DesignerDetailController";
    private static final String ADD_CART = "AddCart";
    private static final String ADD_CART_CONTROLLER = "AddCartController";
    private static final String VIEW_CART = "ViewCart";
    private static final String VIEW_CART_CONTROLLER = "ViewCartController";
    private static final String REMOVE_CART = "RemoveCart";
    private static final String REMOVE_CART_CONTROLLER = "RemoveCartController";
    private static final String APPLY_VOUCHER = "ApplyVoucher";
    private static final String APPLY_VOUCHER_CONTROLLER = "ApplyVoucherController";
    private static final String CHECKOUT = "Checkout";
    private static final String CHECKOUT_CONTROLLER = "CheckoutController";
    
    //Paymejt
    private static final String PROCESS_ORDER = "ProcessOrder";
    private static final String PROCESS_ORDER_CONTROLLER_VNPAY = "VNPayController";
    private static final String PROCESS_ORDER_CONTROLLER_MOMO = "MomoController";
    private static final String PROCESS_ORDER_CONTROLLER_PAYOS = "PayOSController";
    
    private static final String PROFILE = "Profile";
    private static final String PROFILE_CONTROLLER = "ProfileController";
    private static final String SUBMIT_REVIEW = "SubmitReview";
    private static final String SUBMIT_REVIEW_CONTROLLER = "ReviewController";
    private static final String BUY_NOW = "BuyNow";
    private static final String BUY_NOW_CONTROLLER = "BuyNowController";
    private static final String GET_FREE_TEMPLATE = "GetFreeTemplate";
    private static final String GET_FREE_TEMPLATE_CONTROLLER = "GetFreeTemplateController";

    //Designer 
    private static final String DESIGNER_HOME = "DesignerHome";
    private static final String DESIGNER_HOME_CONTROLLER = "DesignerHomeController";
    private static final String MANAGE_TEMPLATE = "ManageTemplate";
    private static final String MANAGE_TEMPLATE_CONTROLLER = "ManageTemplateController";
    private static final String EDIT_TEMPLATE = "EditTemplate";
    private static final String EDIT_TEMPLATE_CONTROLLER = "EditTemplateController";
    private static final String DELETE_TEMPLATE = "DeleteTemplate";
    private static final String DELETE_TEMPLATE_CONTROLLER = "DeleteTemplateController";
    private static final String CREATE_TEMPLATE = "CreateTemplateForm";
    private static final String CREATE_TEMPLATE_CONTROLLER = "CreateTemplateController";
    private static final String DESIGNER_PROFILE = "DesignerProfile";
    private static final String DESIGNER_PROFILE_CONTROLLER = "DesignerProfileController";
    private static final String BOOK_DESIGNER = "BookDesigner";
    private static final String BOOK_DESIGNER_CONTROLLER = "BookDesignerController";
    private static final String ACCEPT_BOOKING = "AcceptBooking";
    private static final String ACCEPT_BOOKING_CONTROLLER = "AcceptBookingController";
    private static final String REQUEST_PAYMENT = "RequestPayment";
    private static final String REQUEST_PAYMENT_CONTROLLER = "RequestPaymentController";
    private static final String CUSTOMER_BOOKING = "CustomerBooking";
    private static final String CUSTOMER_BOOKING_CONTROLLER = "CustomerBookingController";

    // Designer Withdrawal
    private static final String DESIGNER_WITHDRAWALS = "DesignerWithdrawals";
    private static final String DESIGNER_WITHDRAWALS_CONTROLLER = "DesignerWithdrawalController";
    private static final String WITHDRAWAL_REQUEST = "WithdrawalRequest";
    private static final String WITHDRAWAL_CONTROLLER = "WithdrawalController";

    // Admin
    private static final String ADMIN_DASHBOARD = "AdminDashboard";
    private static final String ADMIN_DASHBOARD_CONTROLLER = "AdminDashboardController";
    private static final String ADMIN_WITHDRAWALS = "AdminWithdrawals";
    private static final String ADMIN_WITHDRAWALS_CONTROLLER = "AdminWithdrawalController";
    private static final String ADMIN_USERS = "AdminUsers";
    private static final String ADMIN_USERS_CONTROLLER = "AdminUserListController";
    private static final String ADMIN_PROFILE = "AdminProfile";
    private static final String ADMIN_PROFILE_CONTROLLER = "AdminProfileController";
    private static final String ADMIN_VOUCHERS = "AdminVouchers";
    private static final String ADMIN_VOUCHERS_CONTROLLER = "AdminVoucherController";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = WELCOME;
        try {
            String action = request.getParameter("action");
            if (action == null) {
                url = WELCOME;
            } else if (LOGIN.equals(action)) {
                url = LOGIN_CONTROLLER;
            } else if (LOGOUT.equals(action)) {
                url = LOGOUT_CONTROLLER;
            } else if (REGISTER.equals(action)) {
                url = REGISTER_CONTROLLER;
            } else if (SHOP.equals(action)) {
                url = SHOP_CONTROLLER;
            } else if (TEMPLATE_DETAIL.equals(action)) {
                url = TEMPLATE_DETAIL_CONTROLLER;
            } else if (DESIGNER_HUB.equals(action)) {
                url = DESIGNER_HUB_CONTROLLER;
            } else if (DESIGNER_LIST.equals(action)) {
                url = DESIGNER_LIST_CONTROLLER;
            } else if (DESIGNER_DETAIL.equals(action)) {
                url = DESIGNER_DETAIL_CONTROLLER;
            } else if (ADD_CART.equals(action)) {
                url = ADD_CART_CONTROLLER;
            } else if (VIEW_CART.equals(action)) {
                url = VIEW_CART_CONTROLLER;
            } else if (REMOVE_CART.equals(action)) {
                url = REMOVE_CART_CONTROLLER;
            } else if (APPLY_VOUCHER.equals(action)) {
                url = APPLY_VOUCHER_CONTROLLER;
            } else if (CHECKOUT.equals(action)) {
                url = CHECKOUT_CONTROLLER;
            } else if (PROCESS_ORDER.equals(action)) {
                String paymentMethod = request.getParameter("paymentMethod");
                if ("VNPAY".equals(paymentMethod)) {
                    url = PROCESS_ORDER_CONTROLLER_VNPAY;
                } else if ("MOMO".equals(paymentMethod)) {
                    url = PROCESS_ORDER_CONTROLLER_MOMO;
                } else if ("PAYOS".equals(paymentMethod)) {
                    url = PROCESS_ORDER_CONTROLLER_PAYOS;
                }else {
                    request.setAttribute("errorMessage", "Phương thức thanh toán không hợp lệ!");
                    url = "ViewCartController";
                }
            } else if (action.equals(PROFILE)) {
                url = PROFILE_CONTROLLER;
            } else if (action.equals(SUBMIT_REVIEW)) {
                url = SUBMIT_REVIEW_CONTROLLER;
            } else if (BUY_NOW.equals(action)) {
                url = BUY_NOW_CONTROLLER;
            } else if (GET_FREE_TEMPLATE.equals(action)) {
                url = GET_FREE_TEMPLATE_CONTROLLER;
            } else if (DESIGNER_HOME.equals(action)) {
                url = DESIGNER_HOME_CONTROLLER;
            } else if (MANAGE_TEMPLATE.equals(action)) {
                url = MANAGE_TEMPLATE_CONTROLLER;
            } else if (EDIT_TEMPLATE.equals(action)) {
                url = EDIT_TEMPLATE_CONTROLLER;
            } else if (DELETE_TEMPLATE.equals(action)) {
                url = DELETE_TEMPLATE_CONTROLLER;
            } else if (CREATE_TEMPLATE.equals(action)) {
                url = CREATE_TEMPLATE_CONTROLLER;
            } else if (DESIGNER_PROFILE.equals(action)) {
                url = DESIGNER_PROFILE_CONTROLLER;
            } else if (BOOK_DESIGNER.equals(action)) {
                url = BOOK_DESIGNER_CONTROLLER;
            } else if (ACCEPT_BOOKING.equals(action)) {
                url = ACCEPT_BOOKING_CONTROLLER;
            } else if (REQUEST_PAYMENT.equals(action)) {
                url = REQUEST_PAYMENT_CONTROLLER;
            } else if (CUSTOMER_BOOKING.equals(action)) {
                url = CUSTOMER_BOOKING_CONTROLLER;
            } else if (DESIGNER_WITHDRAWALS.equals(action)) {
                url = DESIGNER_WITHDRAWALS_CONTROLLER;
            } else if (WITHDRAWAL_REQUEST.equals(action)) {
                url = WITHDRAWAL_CONTROLLER;
            } else if (ADMIN_DASHBOARD.equals(action)) {
                url = ADMIN_DASHBOARD_CONTROLLER;
            } else if (ADMIN_WITHDRAWALS.equals(action)) {
                url = ADMIN_WITHDRAWALS_CONTROLLER;
            } else if (ADMIN_USERS.equals(action)) {
                url = ADMIN_USERS_CONTROLLER;
            } else if (ADMIN_PROFILE.equals(action)) {
                url = ADMIN_PROFILE_CONTROLLER;
            } else if (ADMIN_VOUCHERS.equals(action)) {
                url = ADMIN_VOUCHERS_CONTROLLER;
            }
        } catch (Exception e) {
            log("Error at MainController: " + e.toString());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
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
