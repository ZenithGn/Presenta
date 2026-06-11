package com.controller.web;

import com.model.UserDAO;
import com.util.RedisUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ResetPasswordController", urlPatterns = {"/ResetPasswordController"})
public class ResetPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String token = request.getParameter("token");
        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Đường link không hợp lệ.");
            request.getRequestDispatcher("views/web/reset-password.jsp").forward(request, response);
            return;
        }

        // Kiểm tra xem token có trong Redis không
        if (RedisUtil.isAvailable()) {
            String email = RedisUtil.getCache("RESET_TOKEN:" + token);
            if (email == null) {
                request.setAttribute("errorMessage", "Đường link đã hết hạn hoặc không tồn tại.");
            }
        } else {
            request.setAttribute("errorMessage", "Hệ thống Redis đang bảo trì.");
        }
        
        request.getRequestDispatcher("views/web/reset-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Token không hợp lệ.");
            request.getRequestDispatcher("views/web/reset-password.jsp").forward(request, response);
            return;
        }

        if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("views/web/reset-password.jsp").forward(request, response);
            return;
        }

        if (RedisUtil.isAvailable()) {
            String email = RedisUtil.getCache("RESET_TOKEN:" + token);
            if (email != null) {
                UserDAO dao = new UserDAO();
                if (dao.updatePasswordByEmail(email, newPassword)) {
                    // Xóa token khỏi Redis để không dùng lại được nữa
                    RedisUtil.deleteCache("RESET_TOKEN:" + token);
                    request.setAttribute("successMessage", "Mật khẩu của bạn đã được đặt lại thành công!");
                } else {
                    request.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật mật khẩu.");
                }
            } else {
                request.setAttribute("errorMessage", "Đường link đã hết hạn hoặc không hợp lệ.");
            }
        } else {
            request.setAttribute("errorMessage", "Hệ thống đang bảo trì.");
        }
        
        request.getRequestDispatcher("views/web/reset-password.jsp").forward(request, response);
    }
}
