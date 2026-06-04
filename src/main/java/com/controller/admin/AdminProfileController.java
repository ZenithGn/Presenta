/*
 * AdminProfileController — Serves the admin profile page.
 * Form submissions (email, password, avatar) go to AccountController.
 */
package com.controller.admin;

import com.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AdminProfileController", urlPatterns = {"/AdminProfileController"})
public class AdminProfileController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("LOGIN_USER");

        if (loginUser == null || loginUser.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
            return;
        }

        request.getRequestDispatcher("views/admin/profile.jsp").forward(request, response);
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
        return "Admin Profile Controller";
    }
}
