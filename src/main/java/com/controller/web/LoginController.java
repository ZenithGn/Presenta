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
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import com.util.JwtUtil;
import javax.servlet.http.Cookie;

/**
 *
 * @author lehan
 */
@WebServlet(name = "LoginController", urlPatterns = { "/LoginController" })
public class LoginController extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(LoginController.class);

    private static final String ERROR_PAGE = "views/web/login.jsp";
    private static final String ADMIN_DASHBOARD = "AdminDashboardController";
    private static final String HOME_PAGE = "HomeController";
    private static final String DESIGNER_HOME = "DesignerHomeController";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR_PAGE;

        try {
            // Load Google Client ID for frontend
            io.github.cdimascio.dotenv.Dotenv dotenv = io.github.cdimascio.dotenv.Dotenv.configure().ignoreIfMissing().load();
            String googleClientId = dotenv.get("GOOGLE_CLIENT_ID");
            request.setAttribute("googleClientId", googleClientId);

            // Lấy dữ liệu từ form
            String email = request.getParameter("email");
            String pass = request.getParameter("password");
            String rememberMe = request.getParameter("rememberMe");

            // FIX LỖI: Kiểm tra xem user có đang thực sự submit form hay không
            // Nếu email và pass khác null, tức là họ đã bấm nút "Đăng Nhập"
            if (email != null && pass != null) {

                UserDAO dao = new UserDAO();
                User loginUser = dao.checkLogin(email, pass);

                if (loginUser != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("LOGIN_USER", loginUser);
                    
                    if ("on".equalsIgnoreCase(rememberMe) || "true".equalsIgnoreCase(rememberMe)) {
                        // Generate JWT and set it in a Cookie
                        String token = JwtUtil.generateToken(loginUser);
                        Cookie jwtCookie = new Cookie("jwt", token);
                        jwtCookie.setHttpOnly(true);
                        jwtCookie.setPath("/");
                        jwtCookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
                        response.addCookie(jwtCookie);
                    } else {
                        // Clear the JWT cookie if it exists
                        Cookie jwtCookie = new Cookie("jwt", "");
                        jwtCookie.setHttpOnly(true);
                        jwtCookie.setPath("/");
                        jwtCookie.setMaxAge(0);
                        response.addCookie(jwtCookie);
                    }
                    
                    logger.info("User logged in successfully: {}", loginUser.getEmail());

                    // Phân quyền điều hướng
                    if (loginUser.getRoleId() == 1) {
                        url = ADMIN_DASHBOARD;
                    } else if (loginUser.getRoleId() == 3) {
                        url = DESIGNER_HOME;
                    } else {
                        url = HOME_PAGE;
                    }
                } else {
                    logger.warn("Failed login attempt for email: {}", email);
                    request.setAttribute("errorMessage", "Email hoặc mật khẩu không chính xác!");
                }
            }
            // Nếu email và pass là null (mới click vào trang) -> Bỏ qua khối lệnh trên, chỉ
            // load url = ERROR_PAGE (login.jsp) bình thường

        } catch (Exception e) {
            logger.error("Error at LoginController", e);
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the
    // + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
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
