package com.controller.web;

import com.model.UserDAO;
import com.util.EmailUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Random;

@WebServlet(name = "ForgotPasswordController", urlPatterns = {"/ForgotPasswordController"})
public class ForgotPasswordController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String email = request.getParameter("email");
        
        if (email != null && !email.trim().isEmpty()) {
            UserDAO dao = new UserDAO();
            if (dao.checkEmailExists(email)) {
                // Generate a 6-digit OTP
                String otp = String.format("%06d", new Random().nextInt(999999));
                
                // Store OTP and Expiration Time (5 minutes) in HttpSession
                HttpSession session = request.getSession();
                session.setAttribute("RESET_OTP_" + email, otp);
                session.setAttribute("RESET_OTP_EXPIRE_" + email, System.currentTimeMillis() + 5 * 60 * 1000L);
                
                String subject = "Mã xác thực khôi phục mật khẩu - Presenta";
                String body = "<h3>Y&#234;u c&#7847;u kh&#244;i ph&#7909;c m&#7853;t kh&#7849;u</h3>"
                            + "<p>B&#7841;n v&#7915;a y&#234;u c&#7847;u kh&#244;i ph&#7909;c m&#7853;t kh&#7849;u. D&#432;&#7899;i &#273;&#226;y l&#224; m&#227; x&#225;c th&#7921;c (OTP) c&#7911;a b&#7841;n:</p>"
                            + "<h2 style='color: #4f46e5; font-size: 32px; letter-spacing: 4px; padding: 12px; background: #f3f4f6; display: inline-block; border-radius: 8px;'>" + otp + "</h2>"
                            + "<p>M&#227; x&#225;c th&#7921;c n&#224;y s&#7869; h&#7871;t h&#7841;n sau <strong>5 ph&#250;t</strong>.</p>"
                            + "<p>N&#7871;u b&#7841;n kh&#244;ng th&#7921;c hi&#7879;n y&#234;u c&#7847;u n&#224;y, vui l&#242;ng &#273;&#7893;i m&#7853;t kh&#7849;u t&#224;i kho&#7843;n ngay l&#7853;p t&#7913;c ho&#7863;c b&#7887; qua email n&#224;y.</p>";
                
                EmailUtil.sendEmailAsync(email, subject, body);
                
                // Forward to verify-otp page with email param
                request.setAttribute("verifyEmail", email);
                request.getRequestDispatcher("views/web/verify-otp.jsp").forward(request, response);
                return;
            } else {
                request.setAttribute("errorMessage", "Email không tồn tại trong hệ thống!");
            }
        }
        
        request.getRequestDispatcher("views/web/forgot-password.jsp").forward(request, response);
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
