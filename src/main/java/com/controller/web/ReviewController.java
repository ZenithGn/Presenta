/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.web;

import com.model.ReviewDAO;
import com.model.User;
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
@WebServlet(name = "ReviewController", urlPatterns = {"/ReviewController"})
public class ReviewController extends HttpServlet {

    public static final String PROFILE_REDIRECT = "MainController?action=Profile";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = PROFILE_REDIRECT;

        try {
            HttpSession session = request.getSession();
            User loginUser = (User) session.getAttribute("LOGIN_USER");

            if (loginUser != null) {
                // Nhận thông tin gửi từ Modal Đánh giá
                int templateId = Integer.parseInt(request.getParameter("templateId"));
                int rating = Integer.parseInt(request.getParameter("rating"));
                String comment = request.getParameter("comment");

                ReviewDAO reviewDao = new ReviewDAO();
                // Kiểm tra ràng buộc: Mỗi tài khoản chỉ được review mẫu thiết kế này 1 lần duy nhất
                if (!reviewDao.checkAlreadyReviewed(templateId, loginUser.getUserId())) {
                    reviewDao.insertReview(templateId, loginUser.getUserId(), rating, comment);
                    session.setAttribute("toastMessage", "Đánh giá của bạn đã được ghi nhận!");
                } else {
                    session.setAttribute("toastMessage", "Bạn đã gửi đánh giá cho sản phẩm này trước đó!");
                }
            }

        } catch (Exception e) {
            log("Error at ReviewController: " + e.toString());
        } finally {
            // Thực hiện chuyển hướng an toàn để bảo vệ biểu mẫu dữ liệu
            response.sendRedirect(url);
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
