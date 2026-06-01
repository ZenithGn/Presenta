/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.web;

import com.model.CartItem;
import com.model.Template;
import com.model.TemplateDAO;
import com.model.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author lehan
 */
@WebServlet(name = "AddCartController", urlPatterns = {"/AddCartController"})
public class AddCartController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            HttpSession session = request.getSession();
            User loginUser = (User) session.getAttribute("LOGIN_USER");

            // KIỂM TRA AUTHENTICATION
            if (loginUser == null) {
                // Nếu chưa đăng nhập, forward thẳng sang trang Login và ngắt luồng (return)
                request.setAttribute("errorMessage", "Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng!");
                request.getRequestDispatcher("views/web/login.jsp").forward(request, response);
                return;
            }

            int templateId = Integer.parseInt(request.getParameter("id"));
            HashMap<Integer, CartItem> cart = (HashMap<Integer, CartItem>) session.getAttribute("CART");

            if (cart == null) {
                cart = new HashMap<>();
            }

            if (cart.containsKey(templateId)) {
                CartItem item = cart.get(templateId);
                item.setQuantity(item.getQuantity() + 1);
            } else {
                TemplateDAO dao = new TemplateDAO();
                Template template = dao.getTemplateById(templateId);
                if (template != null) {
                    cart.put(templateId, new CartItem(template, 1));
                }
            }          

            session.setAttribute("toastMessage", "Đã thêm sản phẩm vào giỏ hàng thành công!");
            session.setAttribute("CART", cart);

        } catch (Exception e) {
            log("Error at AddCartController: " + e.toString());
        } finally {
            // Lệnh isCommitted() dùng để check xem phía trên ta đã forward qua trang Login chưa
            // Nếu chưa (nghĩa là đã log in và code chạy mượt), thì ta mới cho phép sendRedirect về trang cũ
            if (!response.isCommitted()) {
                String referer = request.getHeader("referer");
                if (referer != null) {
                    response.sendRedirect(referer);
                } else {
                    response.sendRedirect(request.getContextPath() + "/MainController?action=Shop");
                }
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
