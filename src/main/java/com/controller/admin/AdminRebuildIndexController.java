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
            
            // Set success message in session so it survives redirect
            session.setAttribute("SUCCESS_MSG", "Search Engine Index has been rebuilt successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("ERROR", "Failed to rebuild index: " + e.getMessage());
        }

        // Redirect back to dashboard to avoid nested forward 500 errors
        response.sendRedirect(request.getContextPath() + "/MainController?action=AdminDashboard");
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
