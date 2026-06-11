package com.controller.admin;

import com.model.User;
import com.model.Voucher;
import com.model.VoucherDAO;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AdminVoucherController", urlPatterns = {"/AdminVoucherController"})
public class AdminVoucherController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("LOGIN_USER");
        if (loginUser == null || loginUser.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
            return;
        }

        String subAction = request.getParameter("subAction");
        VoucherDAO voucherDAO = new VoucherDAO();

        try {
            if ("Add".equals(subAction)) {
                String code = request.getParameter("code");
                double discountPercent = Double.parseDouble(request.getParameter("discountPercent"));
                double maxDiscountAmount = Double.parseDouble(request.getParameter("maxDiscountAmount"));
                int usageLimit = Integer.parseInt(request.getParameter("usageLimit"));
                
                String validFromStr = request.getParameter("validFrom");
                String validToStr = request.getParameter("validTo");
                
                // HTML datetime-local format is yyyy-MM-dd'T'HH:mm
                SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                Date fromDate = format.parse(validFromStr);
                Date toDate = format.parse(validToStr);
                
                Voucher v = new Voucher();
                v.setCode(code);
                v.setDiscountPercent(discountPercent);
                v.setMaxDiscountAmount(maxDiscountAmount);
                v.setUsageLimit(usageLimit);
                v.setValidFrom(new Timestamp(fromDate.getTime()));
                v.setValidTo(new Timestamp(toDate.getTime()));
                
                boolean success = voucherDAO.createVoucher(v);
                if (success) {
                    session.setAttribute("toastMessage", "Thêm Voucher thành công!");
                } else {
                    session.setAttribute("toastMessage", "Thêm Voucher thất bại (có thể trùng mã)!");
                }
                response.sendRedirect(request.getContextPath() + "/MainController?action=AdminVouchers");
                return;
            } else if ("Update".equals(subAction)) {
                int voucherId = Integer.parseInt(request.getParameter("voucherId"));
                String code = request.getParameter("code");
                double discountPercent = Double.parseDouble(request.getParameter("discountPercent"));
                double maxDiscountAmount = Double.parseDouble(request.getParameter("maxDiscountAmount"));
                int usageLimit = Integer.parseInt(request.getParameter("usageLimit"));
                
                String validFromStr = request.getParameter("validFrom");
                String validToStr = request.getParameter("validTo");
                
                SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                Date fromDate = format.parse(validFromStr);
                Date toDate = format.parse(validToStr);
                
                Voucher v = new Voucher();
                v.setVoucherId(voucherId);
                v.setCode(code);
                v.setDiscountPercent(discountPercent);
                v.setMaxDiscountAmount(maxDiscountAmount);
                v.setUsageLimit(usageLimit);
                v.setValidFrom(new Timestamp(fromDate.getTime()));
                v.setValidTo(new Timestamp(toDate.getTime()));
                
                boolean success = voucherDAO.updateVoucher(v);
                if (success) {
                    session.setAttribute("toastMessage", "Cập nhật Voucher thành công!");
                } else {
                    session.setAttribute("toastMessage", "Cập nhật Voucher thất bại!");
                }
                response.sendRedirect(request.getContextPath() + "/MainController?action=AdminVouchers");
                return;
            } else if ("Delete".equals(subAction)) {
                int voucherId = Integer.parseInt(request.getParameter("voucherId"));
                boolean success = voucherDAO.deleteVoucher(voucherId);
                if (success) {
                    session.setAttribute("toastMessage", "Xóa Voucher thành công!");
                } else {
                    session.setAttribute("toastMessage", "Không thể xóa Voucher này (có thể đã được sử dụng)!");
                }
                response.sendRedirect(request.getContextPath() + "/MainController?action=AdminVouchers");
                return;
            }

            // Default: List vouchers
            List<Voucher> listVouchers = voucherDAO.getAllVouchers();
            request.setAttribute("LIST_VOUCHERS", listVouchers);
            request.getRequestDispatcher("/views/admin/vouchers.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("toastMessage", "Lỗi dữ liệu!");
            response.sendRedirect(request.getContextPath() + "/MainController?action=AdminVouchers");
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
