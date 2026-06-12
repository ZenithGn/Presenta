/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.web;

import com.model.Designer;
import com.model.DesignerDAO;
import com.model.Review;
import com.model.Template;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author lehan
 */
@WebServlet(name = "DesignerDetailController", urlPatterns = {"/DesignerDetailController"})
public class DesignerDetailController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            int designerId = Integer.parseInt(request.getParameter("id"));
            DesignerDAO dao = new DesignerDAO();

            Designer designer = dao.getFullDesignerProfile(designerId);
            List<Template> templates = dao.getTop3TemplatesByDesigner(designerId);
            List<Review> reviews = dao.getReviewsByDesigner(designerId);
            int templatesSold = dao.getTemplatesSold(designerId);

            // Xử lý các thông số toán học động
            double avgRating = 0.0;
            int totalReviews = 0;
            int satisfactionRate = 0;

            if (reviews != null && !reviews.isEmpty()) {
                totalReviews = reviews.size();
                double sumRating = 0;
                for (Review r : reviews) {
                    sumRating += r.getRating();
                }
                avgRating = sumRating / totalReviews;
                // Công thức tính % hài lòng dựa trên số sao trung bình thu được
                satisfactionRate = (int) Math.round((avgRating / 5.0) * 100);
            }

            // Đẩy toàn bộ thuộc tính sang tầng giao diện
            // Lấy số điện thoại designer từ Designer_Profiles
            String designerPhone = dao.getDesignerPhone(designerId);

            request.setAttribute("designer", designer);
            request.setAttribute("templates", templates);
            request.setAttribute("reviews", reviews);
            request.setAttribute("templatesSold", templatesSold);
            request.setAttribute("designerPhone", designerPhone);
            request.setAttribute("avgRating", avgRating);
            request.setAttribute("totalReviews", totalReviews);
            request.setAttribute("satisfactionRate", satisfactionRate);

        } catch (Exception e) {
            log("Error at DesignerDetailController: " + e.toString());
        } finally {
            request.getRequestDispatcher("views/web/designer-profile.jsp").forward(request, response);
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
