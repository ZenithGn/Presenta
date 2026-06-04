/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.designer;

import com.model.DesignerDAO;
import com.model.User;
import com.util.DBUtils;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Designer Dashboard — loads stats, recent sales, withdrawals, and daily activity chart.
 * @author lehan
 */
@WebServlet(name = "DesignerHomeController", urlPatterns = {"/DesignerHomeController"})
public class DesignerHomeController extends HttpServlet {

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

            // Stats
            double balance = dao.getBalance(designerId);
            int activeTemplates = dao.getActiveTemplatesCount(designerId);
            int templatesSold = dao.getTemplatesSoldDashboard(designerId);
            double pendingPayouts = dao.getPendingPayouts(designerId);

            // Tables
            List<Map<String, Object>> recentSales = dao.getRecentSales(designerId);
            List<Map<String, Object>> withdrawalHistory = dao.getWithdrawalHistory(designerId);

            // Daily activity chart data (last 30 days)
            Map<String, Object> dailyStats = getDailyActivityStats(designerId);

            request.setAttribute("DESIGNER_BALANCE", balance);
            request.setAttribute("ACTIVE_TEMPLATES", activeTemplates);
            request.setAttribute("TEMPLATES_SOLD", templatesSold);
            request.setAttribute("PENDING_PAYOUTS", pendingPayouts);
            request.setAttribute("RECENT_SALES", recentSales);
            request.setAttribute("WITHDRAWAL_HISTORY", withdrawalHistory);
            request.setAttribute("DAILY_LABELS", dailyStats.get("labels"));
            request.setAttribute("DAILY_BUY", dailyStats.get("buyData"));
            request.setAttribute("DAILY_HIRE", dailyStats.get("hireData"));

            request.getRequestDispatcher("views/designer/designer-home.jsp").forward(request, response);

        } catch (Exception e) {
            log("Lỗi tại DesignerHomeController: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi tải dữ liệu Dashboard: " + e.getMessage());
            request.getRequestDispatcher("views/designer/designer-home.jsp").forward(request, response);
        }
    }

    /**
     * Query daily BUY_TEMPLATE purchases and HIRE_DESIGNER bookings for last 30 days.
     */
    private Map<String, Object> getDailyActivityStats(int designerId) {
        Map<String, Object> result = new LinkedHashMap<>();
        List<String> labels = new ArrayList<>();
        List<Integer> buyData = new ArrayList<>();
        List<Integer> hireData = new ArrayList<>();

        // BUY_TEMPLATE: count completed orders per day via OrderDetails
        String buySql = "SELECT CAST(o.createAt AS DATE) AS d, COUNT(DISTINCT o.orderID) AS cnt "
                      + "FROM Orders o "
                      + "JOIN OrderDetails od ON o.orderID = od.orderID "
                      + "JOIN Templates t ON od.templateID = t.templateID "
                      + "WHERE t.designerID = ? AND o.orderType = 'BUY_TEMPLATE' AND o.status = 'Completed' "
                      + "AND o.createAt >= DATEADD(DAY, -30, GETDATE()) "
                      + "GROUP BY CAST(o.createAt AS DATE) ORDER BY d";

        // HIRE_DESIGNER: count bookings per day
        String hireSql = "SELECT CAST(o.createAt AS DATE) AS d, COUNT(*) AS cnt "
                       + "FROM Orders o "
                       + "WHERE o.designerID = ? AND o.orderType = 'HIRE_DESIGNER' "
                       + "AND o.createAt >= DATEADD(DAY, -30, GETDATE()) "
                       + "GROUP BY CAST(o.createAt AS DATE) ORDER BY d";

        Map<String, Integer> buyMap = new LinkedHashMap<>();
        Map<String, Integer> hireMap = new LinkedHashMap<>();

        // Pre-fill last 30 days
        for (int i = 29; i >= 0; i--) {
            String label = java.time.LocalDate.now().minusDays(i).toString();
            labels.add(label);
            buyMap.put(label, 0);
            hireMap.put(label, 0);
        }

        try (Connection conn = DBUtils.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(buySql)) {
                ps.setInt(1, designerId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        buyMap.put(rs.getString("d"), rs.getInt("cnt"));
                    }
                }
            }
            try (PreparedStatement ps = conn.prepareStatement(hireSql)) {
                ps.setInt(1, designerId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        hireMap.put(rs.getString("d"), rs.getInt("cnt"));
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }

        for (String label : labels) {
            buyData.add(buyMap.getOrDefault(label, 0));
            hireData.add(hireMap.getOrDefault(label, 0));
        }

        result.put("labels", labels);
        result.put("buyData", buyData);
        result.put("hireData", hireData);
        return result;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Designer Dashboard Controller";
    }
}
