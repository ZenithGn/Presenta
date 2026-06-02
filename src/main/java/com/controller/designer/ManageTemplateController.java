/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.designer;

import com.model.DesignerDAO;
import com.model.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;
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
@WebServlet(name = "ManageTemplateController", urlPatterns = {"/ManageTemplateController"})
public class ManageTemplateController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            HttpSession session = request.getSession();
            User loginUser = (User) session.getAttribute("LOGIN_USER");
            
            if (loginUser == null || loginUser.getRoleId() != 3) {
                response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
                return;
            }
            
            int designerId = loginUser.getUserId();
            DesignerDAO dao = new DesignerDAO();
            
            // --- XỬ LÝ PHÂN TRANG ---
            int pageIndex = 1; // Trang mặc định ban đầu là 1
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                pageIndex = Integer.parseInt(pageParam);
            }
            
            int pageSize = 5; // Cấu hình hiển thị 5 sản phẩm trên một trang
            
            // Lấy tổng số lượng template và tính toán số lượng trang tối đa (endPage)
            int totalTemplates = dao.getTotalTemplatesCount(designerId);
            int endPage = totalTemplates / pageSize;
            if (totalTemplates % pageSize != 0) {
                endPage++;
            }
            
            // Gọi hàm lấy danh sách đã áp dụng phân trang từ DB
            List<Map<String, Object>> myTemplates = dao.getTemplatesByDesignerPaginated(designerId, pageIndex, pageSize);
            
            // Đẩy dữ liệu điều hướng và thông số phân trang sang request attribute
            request.setAttribute("MY_TEMPLATES", myTemplates);
            request.setAttribute("END_PAGE", endPage);
            request.setAttribute("CURRENT_PAGE", pageIndex);
            
            request.getRequestDispatcher("views/designer/manage-template.jsp").forward(request, response);
            
        } catch (Exception e) {
            log("Error at ManageTemplateController: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/MainController?action=DesignerHome");
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
