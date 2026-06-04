/*
 * DesignerProfileController - Loads designer profile page with full stats.
 */
package com.controller.web;

import com.model.Designer;
import com.model.DesignerDAO;
import com.model.User;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "DesignerProfileController", urlPatterns = {"/DesignerProfileController"})
public class DesignerProfileController extends HttpServlet {

    private static final String PROFILE_PAGE = "views/designer/designer-profile.jsp";
    private static final String LOGIN_REDIRECT = "MainController?action=Login";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            HttpSession session = request.getSession();
            User loginUser = (User) session.getAttribute("LOGIN_USER");

            // Auth: must be logged in as Designer
            if (loginUser == null || loginUser.getRoleId() != 3) {
                response.sendRedirect(LOGIN_REDIRECT);
                return;
            }

            int designerId = loginUser.getUserId();
            DesignerDAO dao = new DesignerDAO();

            // 1. Full profile from Users + Designer_Profiles
            Designer designer = dao.getFullDesignerProfile(designerId);
            if (designer == null) {
                response.sendRedirect("MainController?action=DesignerHome");
                return;
            }

            // 2. Stats for dashboard cards
            double balance = dao.getBalance(designerId);
            int activeTemplates = dao.getActiveTemplatesCount(designerId);
            int templatesSold = dao.getTemplatesSoldDashboard(designerId);
            double pendingPayouts = dao.getPendingPayouts(designerId);

            // 3. Recent sales & withdrawals
            List<Map<String, Object>> recentSales = dao.getRecentSales(designerId);
            List<Map<String, Object>> withdrawalHistory = dao.getWithdrawalHistory(designerId);

            // 4. HIRE_DESIGNER orders
            List<Map<String, Object>> designerOrders = dao.getDesignerOrders(designerId);

            // Set attributes
            request.setAttribute("designer", designer);
            request.setAttribute("DESIGNER_BALANCE", balance);
            request.setAttribute("ACTIVE_TEMPLATES", activeTemplates);
            request.setAttribute("TEMPLATES_SOLD", templatesSold);
            request.setAttribute("PENDING_PAYOUTS", pendingPayouts);
            request.setAttribute("RECENT_SALES", recentSales);
            request.setAttribute("WITHDRAWAL_HISTORY", withdrawalHistory);
            request.setAttribute("DESIGNER_ORDERS", designerOrders);

            request.getRequestDispatcher(PROFILE_PAGE).forward(request, response);

        } catch (Exception e) {
            log("Error at DesignerProfileController: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("MainController?action=DesignerHome");
        }
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
        return "Designer Profile Controller";
    }
}
