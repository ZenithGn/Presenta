package com.controller.web;

import com.model.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ResetPasswordController", urlPatterns = {"/ResetPasswordController"})
public class ResetPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // GET request is not allowed directly for reset password page
        // It must come from VerifyOtpController
        response.sendRedirect(request.getContextPath() + "/MainController?action=ForgotPassword");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Email không hợp lệ.");
            request.getRequestDispatcher("views/web/reset-password.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        Boolean canReset = (Boolean) session.getAttribute("CAN_RESET_" + email);
        
        // Kiểm tra quyền đổi mật khẩu từ session
        if (canReset == null || !canReset) {
            request.setAttribute("errorMessage", "Phiên làm việc đã hết hạn hoặc bạn chưa xác thực mã OTP.");
            request.getRequestDispatcher("views/web/reset-password.jsp").forward(request, response);
            return;
        }

        if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("resetEmail", email);
            request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("views/web/reset-password.jsp").forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();
        if (dao.updatePasswordByEmail(email, newPassword)) {
            // Xóa quyền để không dùng lại được nữa
            session.removeAttribute("CAN_RESET_" + email);
            request.setAttribute("successMessage", "Đổi mật khẩu thành công! Hãy quay lại trang Đăng nhập.");
        } else {
            request.setAttribute("resetEmail", email);
            request.setAttribute("errorMessage", "Đã có lỗi xảy ra. Vui lòng thử lại sau.");
        }
        
        request.getRequestDispatcher("views/web/reset-password.jsp").forward(request, response);
    }
}
