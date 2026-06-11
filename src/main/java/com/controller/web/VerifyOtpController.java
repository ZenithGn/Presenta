package com.controller.web;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "VerifyOtpController", urlPatterns = {"/VerifyOtpController"})
public class VerifyOtpController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String email = request.getParameter("email");
        String otp = request.getParameter("otp");
        
        if (email != null && otp != null) {
            HttpSession session = request.getSession();
            
            String storedOtp = (String) session.getAttribute("RESET_OTP_" + email);
            Long expireTime = (Long) session.getAttribute("RESET_OTP_EXPIRE_" + email);
            
            if (storedOtp == null || expireTime == null) {
                request.setAttribute("errorMessage", "Mã xác thực không tồn tại hoặc đã bị hủy.");
            } else if (System.currentTimeMillis() > expireTime) {
                request.setAttribute("errorMessage", "Mã xác thực đã hết hạn. Vui lòng yêu cầu mã mới.");
                session.removeAttribute("RESET_OTP_" + email);
                session.removeAttribute("RESET_OTP_EXPIRE_" + email);
            } else if (storedOtp.equals(otp)) {
                // Mã chính xác, cấp quyền đổi mật khẩu cho email này
                session.setAttribute("CAN_RESET_" + email, true);
                
                // Xóa OTP đi để không bị dùng lại
                session.removeAttribute("RESET_OTP_" + email);
                session.removeAttribute("RESET_OTP_EXPIRE_" + email);
                
                // Chuyển tới trang đổi mật khẩu
                request.setAttribute("resetEmail", email);
                request.getRequestDispatcher("views/web/reset-password.jsp").forward(request, response);
                return;
            } else {
                request.setAttribute("errorMessage", "Mã xác thực không chính xác. Vui lòng thử lại.");
            }
        }
        
        request.setAttribute("verifyEmail", email);
        request.getRequestDispatcher("views/web/verify-otp.jsp").forward(request, response);
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
