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
@WebServlet(name = "DesignerHomeController", urlPatterns = {"/DesignerHomeController"})
public class DesignerHomeController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            HttpSession session = request.getSession();
            User loginUser = (User) session.getAttribute("LOGIN_USER");

            // 1. Kiểm tra đăng nhập và phân quyền (Bảo mật)
            if (loginUser == null || loginUser.getRoleId() != 3) {
                response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
                return;
            }

            int designerId = loginUser.getUserId();
            DesignerDAO dao = new DesignerDAO();

            // 2. Lấy dữ liệu 4 chỉ số thống kê
            double balance = dao.getBalance(designerId);
            int activeTemplates = dao.getActiveTemplatesCount(designerId);
            int templatesSold = dao.getTemplatesSoldDashboard(designerId);
            double pendingPayouts = dao.getPendingPayouts(designerId);

            // 3. Lấy dữ liệu cho 2 bảng (Recent Sales & Withdrawals)
            List<Map<String, Object>> recentSales = dao.getRecentSales(designerId);
            List<Map<String, Object>> withdrawalHistory = dao.getWithdrawalHistory(designerId);

            // 4. Gắn dữ liệu vào Request để trang JSP hứng
            request.setAttribute("DESIGNER_BALANCE", balance);
            request.setAttribute("ACTIVE_TEMPLATES", activeTemplates);
            request.setAttribute("TEMPLATES_SOLD", templatesSold);
            request.setAttribute("PENDING_PAYOUTS", pendingPayouts);
            request.setAttribute("RECENT_SALES", recentSales);
            request.setAttribute("WITHDRAWAL_HISTORY", withdrawalHistory);

            // 5. Điều hướng sang file JSP
            request.getRequestDispatcher("views/designer/designer-home.jsp").forward(request, response);

        } catch (Exception e) {
            // Ghi log lỗi ra server
            log("Lỗi tại DesignerHomeController: " + e.getMessage());
            e.printStackTrace();

            // Có thể đẩy một thông báo lỗi sang JSP nếu muốn
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi tải dữ liệu Dashboard: " + e.getMessage());
            request.getRequestDispatcher("views/designer/designer-home.jsp").forward(request, response);
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
