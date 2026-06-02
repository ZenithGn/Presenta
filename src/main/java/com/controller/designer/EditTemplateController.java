/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.designer;

import com.model.DesignerDAO;
import com.model.User;
import java.io.IOException;
import java.io.PrintWriter;
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
@WebServlet(name = "EditTemplateController", urlPatterns = {"/EditTemplateController"})
public class EditTemplateController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet EditTemplateController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditTemplateController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

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

            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                int templateId = Integer.parseInt(idParam);
                DesignerDAO dao = new DesignerDAO();

                Map<String, Object> template = dao.getTemplateById(templateId, loginUser.getUserId());
                if (template != null) {
                    request.setAttribute("TEMPLATE_DATA", template);
                    request.setAttribute("CATEGORY_LIST", dao.getAllCategories());
                    request.getRequestDispatcher("views/designer/edit-template.jsp").forward(request, response);
                    return;
                }
            }
            // Nếu không tìm thấy sản phẩm, quay về trang quản lý
            response.sendRedirect("MainController?action=ManageTemplate");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("MainController?action=ManageTemplate");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // Hỗ trợ tiếng Việt

        try {
            HttpSession session = request.getSession();
            User loginUser = (User) session.getAttribute("LOGIN_USER");
            if (loginUser == null || loginUser.getRoleId() != 3) {
                response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
                return;
            }

            // Lấy dữ liệu từ Form
            int templateId = Integer.parseInt(request.getParameter("templateId"));
            String title = request.getParameter("title");
            int categoryId = Integer.parseInt(request.getParameter("categoryID"));
            double price = Double.parseDouble(request.getParameter("price"));
            String description = request.getParameter("description");
            String coreFeatures = request.getParameter("coreFeatures");
            String designAssets = request.getParameter("designAssets");
            String thumbnailURL = request.getParameter("thumbnailURL");
            String fileURL = request.getParameter("fileURL");

            DesignerDAO dao = new DesignerDAO();
            boolean isUpdated = dao.updateTemplate(templateId, loginUser.getUserId(), categoryId, title, description, price, thumbnailURL, fileURL, coreFeatures, designAssets);

            if (isUpdated) {
                session.setAttribute("toastMessage", "Template updated successfully!");
            } else {
                session.setAttribute("toastMessage", "Failed to update template.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("toastMessage", "An error occurred!");
        }
        response.sendRedirect("MainController?action=ManageTemplate");
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
