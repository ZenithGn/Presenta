/*
 * AcceptBookingController - Designer accepts or rejects a booking request.
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

@WebServlet(name = "AcceptBookingController", urlPatterns = {"/AcceptBookingController"})
public class AcceptBookingController extends HttpServlet {

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
            String action = request.getParameter("actionType"); // "accept" or "reject"

            DesignerDAO dao = new DesignerDAO();

            if ("reject".equals(action)) {
                dao.updateBookingStatus(orderId, "Cancelled");
                session.setAttribute("toastMessage", "Đã từ chối đơn đặt thiết kế #" + orderId);
            } else {
                dao.updateBookingStatus(orderId, "Processing");
                session.setAttribute("toastMessage", "Đã chấp nhận đơn đặt thiết kế #" + orderId + "! Hãy bắt đầu thiết kế.");
            }

        } catch (Exception e) {
            log("Error at AcceptBookingController: " + e.toString());
        }
        response.sendRedirect("MainController?action=CustomerBooking");
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
