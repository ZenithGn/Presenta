/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.web;

import com.model.Template;
import com.model.TemplateDAO;
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
@WebServlet(name = "ViewCartController", urlPatterns = {"/ViewCartController"})
public class ViewCartController extends HttpServlet {

    public static final String CART_PAGE = "views/web/cart.jsp";
    public static final String LOGIN_PAGE = "views/web/login.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = CART_PAGE;

        try {
            HttpSession session = request.getSession();
            User loginUser = (User) session.getAttribute("LOGIN_USER");

            // KIỂM TRA AUTHENTICATION
            if (loginUser == null) {
                // Nếu chưa đăng nhập, bẻ lái URL về trang Login kèm thông báo
                request.setAttribute("errorMessage", "Vui lòng đăng nhập để xem giỏ hàng!");
                url = LOGIN_PAGE;
            } else {
                // Nếu đã đăng nhập, cho phép chạy logic lấy dữ liệu giỏ hàng bình thường
                TemplateDAO dao = new TemplateDAO();
                List<Template> recommendTemplates = dao.getRecommendations();
                request.setAttribute("recommendTemplates", recommendTemplates);
            }
        } catch (Exception e) {
            log("Error at ViewCartController: " + e.toString());
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
