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
@WebServlet(name = "CreateTemplateController", urlPatterns = {"/CreateTemplateController"})
public class CreateTemplateController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CreateTemplateFormController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateTemplateFormController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            HttpSession session = request.getSession();
            User loginUser = (User) session.getAttribute("LOGIN_USER");

            if (loginUser == null || loginUser.getRoleId() != 3) {
                response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
                return;
            }

            // Lấy danh sách Categories lên cho Designer chọn
            DesignerDAO dao = new DesignerDAO();
            request.setAttribute("CATEGORY_LIST", dao.getAllCategories());

            // Forward qua form tạo mới
            request.getRequestDispatcher("views/designer/create-template.jsp").forward(request, response);

        } catch (Exception e) {
            log("Error at CreateTemplateController doGet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("MainController?action=ManageTemplate");
        }
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

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            HttpSession session = request.getSession();
            User loginUser = (User) session.getAttribute("LOGIN_USER");

            if (loginUser == null || loginUser.getRoleId() != 3) {
                response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
                return;
            }

            // Lấy dữ liệu bắt buộc từ Form
            String title = request.getParameter("title");
            int categoryId = Integer.parseInt(request.getParameter("categoryID"));
            double price = Double.parseDouble(request.getParameter("price"));
            String description = request.getParameter("description");
            String coreFeatures = request.getParameter("coreFeatures");
            String designAssets = request.getParameter("designAssets");
            String fileURL = request.getParameter("fileURL");

            // Lấy ThumbnailURL và XỬ LÝ NULL (Nếu người dùng để trống)
            String thumbnailURL = request.getParameter("thumbnailURL");
            if (thumbnailURL == null || thumbnailURL.trim().isEmpty()) {
                thumbnailURL = null; // Ép về null chuẩn xác để Database nhận thẻ NULL
            }

            // Gọi DAO
            DesignerDAO dao = new DesignerDAO();
            boolean isInserted = dao.insertTemplate(loginUser.getUserId(), categoryId, title, description, price, thumbnailURL, fileURL, coreFeatures, designAssets);

            // Báo kết quả
            if (isInserted) {
                session.setAttribute("toastMessage", "Thêm thiết kế mới thành công!");
            } else {
                session.setAttribute("toastMessage", "Thêm thất bại. Vui lòng thử lại.");
            }

        } catch (Exception e) {
            log("Error at CreateTemplateController doPost: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("toastMessage", "Lỗi dữ liệu đầu vào!");
        }

        // Tạo xong quay về trang quản lý
        response.sendRedirect("MainController?action=ManageTemplate");
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
