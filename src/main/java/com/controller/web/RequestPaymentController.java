/*
 * RequestPaymentController - Designer submits completed work and requests payment.
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

@WebServlet(name = "RequestPaymentController", urlPatterns = {"/RequestPaymentController"})
public class RequestPaymentController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User loginUser = (User) session.getAttribute("LOGIN_USER");

            // Must be logged in as Designer
            if (loginUser == null || loginUser.getRoleId() != 3) {
                response.sendRedirect("MainController?action=Login");
                return;
            }

            int orderId = Integer.parseInt(request.getParameter("orderID"));
            double price = Double.parseDouble(request.getParameter("price"));
            String fileURL = request.getParameter("fileURL");

            // Validate inputs
            if (price <= 0) {
                session.setAttribute("toastMessage", "Vui lòng nhập giá tiền hợp lệ (> 0)!");
                response.sendRedirect("MainController?action=DesignerHome");
                return;
            }
            if (fileURL == null || fileURL.trim().isEmpty()) {
                session.setAttribute("toastMessage", "Vui lòng nhập đường dẫn file thiết kế!");
                response.sendRedirect("MainController?action=DesignerHome");
                return;
            }

            DesignerDAO dao = new DesignerDAO();
            boolean success = dao.completeBookingAndSetPayment(orderId, price, fileURL.trim(), loginUser.getUserId());

            if (success) {
                session.setAttribute("toastMessage", "Đã gửi file thiết kế và yêu cầu thanh toán cho đơn #" + orderId + "!");
            } else {
                session.setAttribute("toastMessage", "Có lỗi khi xử lý. Vui lòng thử lại!");
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("toastMessage", "Giá tiền không hợp lệ!");
        } catch (Exception e) {
            log("Error at RequestPaymentController: " + e.toString());
            request.getSession().setAttribute("toastMessage", "Lỗi hệ thống!");
        }
        response.sendRedirect("MainController?action=DesignerHome");
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
