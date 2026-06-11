package com.controller.admin;

import com.model.User;
import com.util.SearchEngineUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "AdminRebuildIndexController", urlPatterns = {"/AdminRebuildIndexController"})
public class AdminRebuildIndexController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("LOGIN_USER");
        if (loginUser == null || loginUser.getRoleId() != 1) { // 1 = Admin
            response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
            return;
        }

        try {
            // Rebuild the Lucene Index
            SearchEngineUtil.buildIndex();
            
            // Set success message
            request.setAttribute("SUCCESS_MSG", "Search Engine Index has been rebuilt successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ERROR", "Failed to rebuild index: " + e.getMessage());
        }

        // Forward back to dashboard
        request.getRequestDispatcher("MainController?action=AdminDashboard").forward(request, response);
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
}
