/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.admin;

import com.model.User;
import com.model.UserDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Admin User List — search, filter by role, ban/unban, paging.
 * @author lehan
 */
@WebServlet(name = "AdminUserListController", urlPatterns = {"/AdminUserListController"})
public class AdminUserListController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

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

        UserDAO uDao = new UserDAO();

        try {
            // --- BAN/UNBAN ---
            String toggleId = request.getParameter("toggleId");
            if (toggleId != null && !toggleId.isEmpty()) {
                int userId = Integer.parseInt(toggleId);
                // Prevent self-ban
                if (userId != loginUser.getUserId()) {
                    boolean newStatus = uDao.toggleUserStatus(userId);
                    session.setAttribute("toastMessage", "User #" + userId + " đã " + (newStatus ? "được mở khóa" : "bị khóa") + ".");
                } else {
                    session.setAttribute("toastMessage", "Bạn không thể tự khóa tài khoản của mình.");
                }
                response.sendRedirect("MainController?action=AdminUsers");
                return;
            }

            // --- DEFAULT: LIST ---
            String pageStr = request.getParameter("page");
            int pageIndex = (pageStr != null && !pageStr.isEmpty()) ? Integer.parseInt(pageStr) : 1;

            String search = request.getParameter("search");
            String roleFilter = request.getParameter("roleFilter");
            if (roleFilter == null || roleFilter.isEmpty()) roleFilter = "All";

            int totalCount = uDao.getUsersCount(search, roleFilter);
            int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);
            if (totalPages < 1) totalPages = 1;
            if (pageIndex > totalPages) pageIndex = totalPages;
            if (pageIndex < 1) pageIndex = 1;

            List<User> userList = uDao.getUsersPaged(search, roleFilter, pageIndex, PAGE_SIZE);

            request.setAttribute("USER_LIST", userList);
            request.setAttribute("CURRENT_PAGE", pageIndex);
            request.setAttribute("TOTAL_PAGES", totalPages);
            request.setAttribute("TOTAL_COUNT", totalCount);
            request.setAttribute("SEARCH", search != null ? search : "");
            request.setAttribute("ROLE_FILTER", roleFilter);

        } catch (Exception e) {
            log("Error at AdminUserListController: " + e.getMessage());
            e.printStackTrace();
        }

        request.getRequestDispatcher("views/admin/users.jsp").forward(request, response);
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
        return "Admin User List Controller";
    }
}
