package com.controller.web;

import com.model.UserDAO;
import com.util.EmailUtil;
import com.util.RedisUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;

@WebServlet(name = "ForgotPasswordController", urlPatterns = {"/ForgotPasswordController"})
public class ForgotPasswordController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String email = request.getParameter("email");
        
        if (email != null && !email.trim().isEmpty()) {
            UserDAO dao = new UserDAO();
            if (dao.checkEmailExists(email)) {
                // Generate a unique token
                String token = UUID.randomUUID().toString();
                
                // Store in Redis with 15 minutes expiration (900 seconds)
                if (RedisUtil.isAvailable()) {
                    RedisUtil.setCache("RESET_TOKEN:" + token, email, 900);
                    
                    // Build reset link
                    String scheme = request.getScheme();             // http
                    String serverName = request.getServerName();     // localhost
                    int serverPort = request.getServerPort();        // 8080
                    String contextPath = request.getContextPath();   // /Presenta
                    
                    String resetLink = scheme + "://" + serverName + ":" + serverPort + contextPath + "/MainController?action=ResetPassword&token=" + token;
                    
                    // Send Email asynchronously
                    String subject = "Khôi phục mật khẩu - Presenta";
                    String body = "<h3>Yêu cầu khôi phục mật khẩu</h3>"
                                + "<p>Bạn vừa yêu cầu khôi phục mật khẩu. Vui lòng click vào đường link bên dưới để đặt lại mật khẩu mới:</p>"
                                + "<p><a href='" + resetLink + "'>Đặt lại mật khẩu</a></p>"
                                + "<p>Đường link này sẽ hết hạn sau 15 phút.</p>"
                                + "<p>Nếu bạn không thực hiện yêu cầu này, vui lòng bỏ qua email này.</p>";
                    
                    EmailUtil.sendEmailAsync(email, subject, body);
                    
                    request.setAttribute("successMessage", "Một đường link khôi phục đã được gửi đến email của bạn. Vui lòng kiểm tra hộp thư (kể cả thư mục Spam).");
                } else {
                    request.setAttribute("errorMessage", "Hệ thống Redis đang bảo trì, không thể tạo mã khôi phục lúc này.");
                }
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
