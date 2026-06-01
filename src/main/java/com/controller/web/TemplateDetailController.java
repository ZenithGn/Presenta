/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.web;

import com.model.Review;
import com.model.Template;
import com.model.TemplateDAO;
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
@WebServlet(name = "TemplateDetailController", urlPatterns = {"/TemplateDetailController"})
public class TemplateDetailController extends HttpServlet {

    public static final String DETAIL_PAGE = "views/web/template-detail.jsp";
    public static final String ERROR_REDIRECT = "MainController?action=Shop";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = DETAIL_PAGE;
        boolean isRedirect = false;

        try {
            String idStr = request.getParameter("templateID");

            if (idStr == null || idStr.trim().isEmpty()) {
                request.getSession().setAttribute("toastMessage", "Không tìm thấy mã sản phẩm yêu cầu.");
                url = ERROR_REDIRECT;
                isRedirect = true;
            } else {
                int templateID = Integer.parseInt(idStr);
                TemplateDAO dao = new TemplateDAO();

                // 1. Gọi DAO lấy thông tin chi tiết sản phẩm
                Template t = dao.getTemplateByID(templateID);

                if (t != null) {
                    request.setAttribute("templateDetail", t);

                    // 2. Lấy danh sách các sản phẩm gợi ý cùng danh mục
                    List<Template> relatedTemplates = dao.getRelatedTemplates(t.getCategoryID(), templateID);
                    request.setAttribute("relatedTemplates", relatedTemplates);

                    // 3. Lấy danh sách đánh giá từ người dùng
                    List<Review> reviews = dao.getReviewsByTemplateID(templateID);
                    request.setAttribute("reviews", reviews);
                } else {
                    request.getSession().setAttribute("toastMessage", "Sản phẩm không tồn tại hoặc đã bị gỡ bỏ.");
                    url = ERROR_REDIRECT;
                    isRedirect = true;
                }
            }
        } catch (Exception e) {
            log("Error at TemplateDetailController: " + e.toString());
            request.getSession().setAttribute("toastMessage", "Hệ thống gặp sự cố khi tải chi tiết sản phẩm.");
            url = ERROR_REDIRECT;
            isRedirect = true;
        } finally {
            // Điều hướng tập trung duy nhất một lần tại khối finally
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
