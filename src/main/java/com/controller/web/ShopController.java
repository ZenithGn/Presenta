/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.web;

import com.model.Category;
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
@WebServlet(name = "ShopController", urlPatterns = {"/ShopController"})
public class ShopController extends HttpServlet {

    private static final String SHOP_PAGE = "views/web/shop.jsp";
    private static final String ERROR_PAGE = "views/web/shop.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR_PAGE;

        try {
            TemplateDAO dao = new TemplateDAO();
            
            // 1. Lấy và chuẩn hóa các tham số từ View truyền lên
            String keyword = request.getParameter("keyword");
            if (keyword == null) keyword = ""; // Nếu không có keyword thì gán chuỗi rỗng
            
            String categoryIDStr = request.getParameter("categoryID");
            int categoryID = (categoryIDStr != null && !categoryIDStr.isEmpty()) ? Integer.parseInt(categoryIDStr) : 0;
            
            String indexStr = request.getParameter("index");
            int index = (indexStr != null && !indexStr.isEmpty()) ? Integer.parseInt(indexStr) : 1;
            
            // 2. Cấu hình phân trang
            int pageSize = 9; // Số sản phẩm trên 1 trang (bạn có thể đổi thành 9, 12 tùy ý)
            int totalTemplates = dao.countTotalTemplates(keyword, categoryID);
            
            // Tính toán tổng số trang (endPage)
            int endPage = totalTemplates / pageSize;
            if (totalTemplates % pageSize != 0) {
                endPage++;
            }
            
            // 3. Lấy dữ liệu theo các tham số
            List<Category> listCategories = dao.getAllCategories();
            List<Template> listTemplates = dao.searchAndPagingTemplates(keyword, categoryID, index, pageSize);
            List<Template> recommendTemplates = dao.getRecommendations();
            Template bestTemplate = dao.getBestTemplateOfTheWeek();
            
            // 4. Đẩy dữ liệu về lại JSP
            request.setAttribute("listCategories", listCategories);
            request.setAttribute("listTemplates", listTemplates); // Đổi tên từ historyTemplates thành listTemplates cho chuẩn nghĩa
            request.setAttribute("recommendTemplates", recommendTemplates);
            request.setAttribute("bestTemplate", bestTemplate);
            
            // Trả về các tham số trạng thái để JSP giữ nguyên trạng thái khi bấm chuyển trang
            request.setAttribute("endPage", endPage);
            request.setAttribute("tag", index); // tag là trang hiện tại đang đứng
            request.setAttribute("saveKeyword", keyword);
            request.setAttribute("saveCategoryID", categoryID);

        } catch (Exception e) {
            log("Error at ShopController: " + e.toString());
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
