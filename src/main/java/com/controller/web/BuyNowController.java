/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.web;

import com.model.CartItem;
import com.model.Template;
import com.model.TemplateDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
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
@WebServlet(name = "BuyNowController", urlPatterns = {"/BuyNowController"})
public class BuyNowController extends HttpServlet {

    public static final String CHECKOUT_REDIRECT = "MainController?action=Checkout";
    public static final String ERROR_REDIRECT = "MainController?action=Shop";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = CHECKOUT_REDIRECT;

        try {
            String idStr = request.getParameter("templateID");

            if (idStr != null && !idStr.trim().isEmpty()) {
                int templateID = Integer.parseInt(idStr);
                TemplateDAO dao = new TemplateDAO();
                Template t = dao.getTemplateByID(templateID);

                if (t != null) {
                    HttpSession session = request.getSession();

                    // Lấy giỏ hàng hiện tại trong Session ra (Hãy đồng bộ tên Attribute giống AddCartController của bạn, ví dụ: "CART")
                    Map<Integer, com.model.CartItem> cart = (Map<Integer, com.model.CartItem>) session.getAttribute("CART");
                    if (cart == null) {
                        cart = new HashMap<>();
                    }
                    
                    // Nếu sản phẩm chưa có trong giỏ hàng thì mới thêm vào
                    if (!cart.containsKey(t.getTemplateID())) {
                        CartItem item = new com.model.CartItem();
                        item.setTemplate(t);
                        
                        // CHỈ CẦN THIẾT LẬP SỐ LƯỢNG LÀ 1 (Không cần setPrice)
                        item.setQuantity(1); 
                        
                        cart.put(t.getTemplateID(), item);
                    }
                    
                    session.setAttribute("CART", cart);

                } else {
                    url = ERROR_REDIRECT;
                }
            } else {
                url = ERROR_REDIRECT;
            }
        } catch (Exception e) {
            log("Error at BuyNowController: " + e.toString());
            url = ERROR_REDIRECT;
        } finally {
            // Thực hiện chuyển hướng Get (PRG Pattern) sang trang Checkout an toàn
            response.sendRedirect(url);
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
