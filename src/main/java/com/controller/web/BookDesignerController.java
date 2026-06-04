/*
 * BookDesignerController - Customer books a designer for custom work.
 */
package com.controller.web;

import com.model.DesignerDAO;
import com.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "BookDesignerController", urlPatterns = {"/BookDesignerController"})
public class BookDesignerController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User loginUser = (User) session.getAttribute("LOGIN_USER");

            // Must be logged in as Customer
            if (loginUser == null || loginUser.getRoleId() != 2) {
                session.setAttribute("toastMessage", "Vui lòng đăng nhập tài khoản khách hàng để đặt thiết kế!");
                response.sendRedirect("MainController?action=Login");
                return;
            }

            int designerId = Integer.parseInt(request.getParameter("designerID"));
            DesignerDAO dao = new DesignerDAO();

            int orderId = dao.createBookingOrder(loginUser.getUserId(), designerId);
            if (orderId > 0) {
                session.setAttribute("toastMessage", "Đã gửi yêu cầu thiết kế riêng thành công! Đơn hàng #" + orderId);
            } else {
                session.setAttribute("toastMessage", "Có lỗi khi tạo đơn đặt thiết kế. Vui lòng thử lại!");
            }

        } catch (Exception e) {
            log("Error at BookDesignerController: " + e.toString());
            request.getSession().setAttribute("toastMessage", "Lỗi hệ thống!");
        }
        response.sendRedirect("MainController?action=Profile&tab=custom");
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
