/*
 * CustomerBookingController - Designer manages HIRE_DESIGNER booking orders with paging.
 */
package com.controller.designer;

import com.model.DesignerDAO;
import com.model.User;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "CustomerBookingController", urlPatterns = {"/CustomerBookingController"})
public class CustomerBookingController extends HttpServlet {

    private static final String BOOKING_PAGE = "views/designer/customer-booking.jsp";
    private static final int PAGE_SIZE = 10;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            HttpSession session = request.getSession();
            User loginUser = (User) session.getAttribute("LOGIN_USER");

            if (loginUser == null || loginUser.getRoleId() != 3) {
                response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
                return;
            }

            int designerId = loginUser.getUserId();
            DesignerDAO dao = new DesignerDAO();

            // Paging
            int pageIndex = 1;
            if (request.getParameter("page") != null) {
                pageIndex = Integer.parseInt(request.getParameter("page"));
            }

            int totalItems = dao.getDesignerBookingCount(designerId);
            int endPage = (int) Math.ceil((double) totalItems / PAGE_SIZE);

            List<Map<String, Object>> bookingRequests = dao.getDesignerBookingsPaged(designerId, pageIndex, PAGE_SIZE);

            request.setAttribute("BOOKING_REQUESTS", bookingRequests);
            request.setAttribute("tag", pageIndex);
            request.setAttribute("endPage", endPage);

        } catch (Exception e) {
            log("Error at CustomerBookingController: " + e.toString());
        }
        request.getRequestDispatcher(BOOKING_PAGE).forward(request, response);
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

    @Override
    public String getServletInfo() {
        return "Customer Booking Management Controller";
    }
}
