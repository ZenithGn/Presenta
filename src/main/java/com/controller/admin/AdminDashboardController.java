/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.admin;

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
 * Admin Dashboard — loads real statistics for Chart.js.
 * @author lehan
 */
@WebServlet(name = "AdminDashboardController", urlPatterns = {"/AdminDashboardController"})
public class AdminDashboardController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("LOGIN_USER");

        if (loginUser == null || loginUser.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
            return;
        }

        try {
            // --- Stat Cards ---
            int totalUsers = getTotalUsers();
            double totalSales = getTotalSales();
            int totalTemplates = getTotalTemplates();
            int pendingWithdrawals = getPendingWithdrawalCount();

            request.setAttribute("TOTAL_USERS", totalUsers);
            request.setAttribute("TOTAL_SALES", totalSales);
            request.setAttribute("TOTAL_TEMPLATES", totalTemplates);
            request.setAttribute("PENDING_WITHDRAWALS", pendingWithdrawals);

            // --- Role Distribution (for Pie Chart) ---
            Map<String, Integer> roleDistribution = getRoleDistribution();
            List<String> roleLabels = new ArrayList<>(roleDistribution.keySet());
            List<Integer> roleData = new ArrayList<>(roleDistribution.values());
            request.setAttribute("ROLE_LABELS", roleLabels);
            request.setAttribute("ROLE_DATA", roleData);

            // --- Monthly Revenue (for Bar/Line Chart) ---
            Map<String, Double> monthlyRevenue = getMonthlyRevenue();
            List<String> monthLabels = new ArrayList<>(monthlyRevenue.keySet());
            List<Double> monthData = new ArrayList<>(monthlyRevenue.values());
            request.setAttribute("MONTH_LABELS", monthLabels);
            request.setAttribute("MONTH_DATA", monthData);

        } catch (Exception e) {
            log("Error at AdminDashboardController: " + e.getMessage());
            e.printStackTrace();
        }

        request.getRequestDispatcher("views/admin/dashboard.jsp").forward(request, response);
    }

    private int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM Users";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    private double getTotalSales() {
        String sql = "SELECT ISNULL(SUM(amount), 0) FROM Payments WHERE paymentStatus = 'Success'";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    private int getTotalTemplates() {
        String sql = "SELECT COUNT(*) FROM Templates";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    private int getPendingWithdrawalCount() {
        String sql = "SELECT COUNT(*) FROM Withdrawals WHERE status = 'Pending'";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    private Map<String, Integer> getRoleDistribution() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT CASE roleID WHEN 1 THEN 'Admin' WHEN 2 THEN 'Customer' WHEN 3 THEN 'Designer' END AS roleName, "
                   + "COUNT(*) AS cnt FROM Users GROUP BY roleID ORDER BY roleID";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("roleName"), rs.getInt("cnt"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return map;
    }

    private Map<String, Double> getMonthlyRevenue() {
        Map<String, Double> map = new LinkedHashMap<>();
        // Last 6 months
        String sql = "SELECT FORMAT(p.paymentDate, 'yyyy-MM') AS month, ISNULL(SUM(p.amount), 0) AS revenue "
                   + "FROM Payments p "
                   + "WHERE p.paymentStatus = 'Success' "
                   + "AND p.paymentDate >= DATEADD(MONTH, -5, GETDATE()) "
                   + "GROUP BY FORMAT(p.paymentDate, 'yyyy-MM') "
                   + "ORDER BY month";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("month"), rs.getDouble("revenue"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return map;
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
        return "Admin Dashboard Controller";
    }
}
