/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.designer;

import com.model.DesignerDAO;
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
@WebServlet(name = "DeleteTemplateController", urlPatterns = {"/DeleteTemplateController"})
public class DeleteTemplateController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String pageParam = request.getParameter("page");
        if (pageParam == null || pageParam.trim().isEmpty()) {
            pageParam = "1";
        }

        try {
            HttpSession session = request.getSession();
            User loginUser = (User) session.getAttribute("LOGIN_USER");

            // 1. Kiểm tra quyền truy cập an toàn hệ thống
            if (loginUser == null || loginUser.getRoleId() != 3) {
                response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
                return;
            }

            // 2. Lấy ID sản phẩm cần xóa
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.trim().isEmpty()) {
                int templateId = Integer.parseInt(idParam);
                DesignerDAO dao = new DesignerDAO();

                // 3. Thực thi xóa trong Database
                boolean isDeleted = dao.deleteTemplate(templateId);

                // 4. Thiết lập thông báo trạng thái lên session (Dùng cho component Toast hiển thị)
                if (isDeleted) {
                    session.setAttribute("toastMessage", "Xóa thiết kế thành công!");
                } else {
                    session.setAttribute("toastMessage", "Không thể xóa! Thiết kế này đã có khách hàng mua hoặc đánh giá.");
                }
            }

        } catch (Exception e) {
            log("Error at DeleteTemplateController: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // 5. Điều hướng ngược về trang danh sách và giữ nguyên số trang hiện tại
            response.sendRedirect("MainController?action=ManageTemplate&page=" + pageParam);
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
