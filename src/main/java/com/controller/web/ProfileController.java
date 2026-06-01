/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.web;

import com.model.Order;
import com.model.OrderDAO;
import com.model.Template;
import com.model.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
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
@WebServlet(name = "ProfileController", urlPatterns = {"/ProfileController"})
public class ProfileController extends HttpServlet {

    public static final String PROFILE_PAGE = "views/web/profile.jsp";
    public static final String AUTH_ACTION = "MainController";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = PROFILE_PAGE;
        boolean isRedirect = false;

        try {
            HttpSession session = request.getSession();
            User loginUser = (User) session.getAttribute("LOGIN_USER");
            if (loginUser == null) {
                url = AUTH_ACTION;
                isRedirect = true;
            } else {
                OrderDAO orderDao = new OrderDAO();

                // ---- XỬ LÝ PHÂN TRANG (PAGING) ----
                int pageIndex = 1;
                int pageSize = 5; // Hiện 5 template 1 trang
                if (request.getParameter("page") != null) {
                    pageIndex = Integer.parseInt(request.getParameter("page"));
                }
                int offset = (pageIndex - 1) * pageSize;
                int totalItems = orderDao.getTotalPurchasedTemplates(loginUser.getUserId());
                int endPage = (int) Math.ceil((double) totalItems / pageSize);

                List<Template> purchasedTemplates = orderDao.getPurchasedTemplates(loginUser.getUserId(), offset, pageSize);
                List<Order> customOrders = orderDao.getCustomOrders(loginUser.getUserId());

                request.setAttribute("purchasedTemplates", purchasedTemplates);
                request.setAttribute("customOrders", customOrders);
                request.setAttribute("tag", pageIndex);
                request.setAttribute("endPage", endPage);
            }
        } catch (Exception e) {
            log("Error at ProfileController: " + e.toString());
        } finally {
            // Điều hướng duy nhất một lần tại khối lệnh finally
            if (isRedirect) {
                response.sendRedirect(url);
            } else {
                request.getRequestDispatcher(url).forward(request, response);
            }
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
