/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.web;

import com.model.User;
import com.model.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author lehan
 */
@WebServlet(name = "RegisterController", urlPatterns = {"/RegisterController"})
public class RegisterController extends HttpServlet {

    private static final String ERROR_PAGE = "views/web/register.jsp";
    private static final String SUCCESS_PAGE = "views/web/login.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR_PAGE;

        try {
            // Kiểm tra Method: Nếu là GET (bấm từ link) thì chỉ trả về trang register.jsp
            if (request.getMethod().equalsIgnoreCase("GET")) {
                request.getRequestDispatcher(ERROR_PAGE).forward(request, response);
                return;
            }

            // --- NẾU LÀ POST (Submit Form Đăng Ký) ---
            String roleIDStr = request.getParameter("roleID");
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String plainPassword = request.getParameter("password"); // Đổi tên biến cho rõ ràng

            // Băm mật khẩu với độ phức tạp (work factor) là 12
            String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));

            // Chỉ lấy số điện thoại
            String phone = request.getParameter("phone");

            // Chủ động gán null cho bio và portfolio để lưu rỗng vào Database
            String portfolioURL = null;
            String bio = null;

            int roleID = Integer.parseInt(roleIDStr);
            UserDAO dao = new UserDAO();

            // 1. Kiểm tra trùng lặp User hoặc Email
            if (dao.checkDuplicate(username, email)) {
                request.setAttribute("errorMessage", "Tên đăng nhập hoặc Email đã tồn tại!");
            } else {
                User newUser = new User();
                newUser.setUsername(username);
                newUser.setPassword(hashedPassword);
                newUser.setEmail(email);
                newUser.setRoleId(roleID);
                newUser.setStatus(true);

                // Vẫn gọi hàm cũ, nó sẽ insert giá trị NULL vào DB cho 2 trường này
                boolean checkInsert = dao.registerUser(newUser, phone, portfolioURL, bio);

                if (checkInsert) {
                    request.setAttribute("successMessage", "Đăng ký thành công! Vui lòng đăng nhập.");
                    url = SUCCESS_PAGE;
                } else {
                    request.setAttribute("errorMessage", "Đã có lỗi hệ thống xảy ra, vui lòng thử lại.");
                }
            }
        } catch (Exception e) {
            log("Error at RegisterController: " + e.toString());
            request.setAttribute("errorMessage", "Lỗi Server: " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
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
