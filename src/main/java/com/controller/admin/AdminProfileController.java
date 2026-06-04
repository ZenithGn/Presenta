/*
 * AdminProfileController — Admin profile page with email & password change.
 */
package com.controller.admin;

import com.model.User;
import com.model.UserDAO;
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
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("LOGIN_USER");

        if (loginUser == null || loginUser.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
            return;
        }

        String method = request.getParameter("method");
        UserDAO dao = new UserDAO();

        String toastMessage = null;
        String toastType = "success";

        if ("changeEmail".equals(method)) {
            String newEmail = request.getParameter("newEmail");
            if (newEmail != null && !newEmail.trim().isEmpty()) {
                boolean ok = dao.updateEmail(loginUser.getUserId(), newEmail.trim());
                if (ok) {
                    loginUser.setEmail(newEmail.trim());
                    session.setAttribute("LOGIN_USER", loginUser);
                    toastMessage = "Email updated successfully!";
                } else {
                    toastMessage = "Failed to update email.";
                    toastType = "error";
                }
            }
        } else if ("changePassword".equals(method)) {
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (oldPassword == null || newPassword == null ||
                oldPassword.trim().isEmpty() || newPassword.trim().isEmpty()) {
                toastMessage = "All password fields are required.";
                toastType = "error";
            } else if (!newPassword.equals(confirmPassword)) {
                toastMessage = "New password and confirmation do not match.";
                toastType = "error";
            } else if (newPassword.length() < 6) {
                toastMessage = "New password must be at least 6 characters.";
                toastType = "error";
            } else {
                boolean ok = dao.changePassword(loginUser.getUserId(), oldPassword, newPassword);
                if (ok) {
                    toastMessage = "Password changed successfully!";
                } else {
                    toastMessage = "Current password is incorrect.";
                    toastType = "error";
                }
            }
        }

        if (toastMessage != null) {
            session.setAttribute("toastMessage", toastMessage);
            session.setAttribute("toastType", toastType);
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
