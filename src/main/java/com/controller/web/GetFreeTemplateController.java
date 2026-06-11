package com.controller.web;

import com.model.OrderDAO;
import com.model.User;
import com.model.Template;
import com.model.TemplateDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "GetFreeTemplateController", urlPatterns = {"/GetFreeTemplateController"})
public class GetFreeTemplateController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            HttpSession session = request.getSession();
            User loginUser = (User) session.getAttribute("LOGIN_USER");
            
            if (loginUser == null) {
                session.setAttribute("toastMessage", "Bạn cần đăng nhập để lấy template này!");
                response.sendRedirect("MainController?action=Login");
                return;
            }

            int templateId = Integer.parseInt(request.getParameter("templateID"));
            TemplateDAO templateDAO = new TemplateDAO();
            Template t = templateDAO.getTemplateByID(templateId);

            if (t == null) {
                session.setAttribute("toastMessage", "Template không tồn tại!");
                response.sendRedirect("MainController?action=Shop");
                return;
            }

            if (t.getPrice() > 0) {
                session.setAttribute("toastMessage", "Template này không miễn phí!");
                response.sendRedirect("MainController?action=Shop");
                return;
            }

            OrderDAO orderDAO = new OrderDAO();
            boolean alreadyPurchased = orderDAO.hasPurchasedTemplate(loginUser.getUserId(), templateId);

            if (alreadyPurchased) {
                session.setAttribute("toastMessage", "Bạn đã sở hữu template này rồi!");
                response.sendRedirect("MainController?action=Profile&tab=purchased");
                return;
            }

            boolean success = orderDAO.insertFreeOrder(loginUser.getUserId(), templateId);

            if (success) {
                session.setAttribute("toastMessage", "Nhận template miễn phí thành công!");
                response.sendRedirect("MainController?action=Profile&tab=purchased");
            } else {
                session.setAttribute("toastMessage", "Có lỗi xảy ra, vui lòng thử lại sau!");
                response.sendRedirect("MainController?action=Shop");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("toastMessage", "Lỗi hệ thống!");
            response.sendRedirect("MainController?action=Shop");
        }
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
