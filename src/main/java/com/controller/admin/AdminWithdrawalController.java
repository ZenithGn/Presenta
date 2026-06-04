/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.admin;

import com.model.User;
import com.model.Withdrawal;
import com.model.WithdrawalDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Admin Withdrawal Management — paging, filter, batch approve, CSV export.
 * @author lehan
 */
@WebServlet(name = "AdminWithdrawalController", urlPatterns = {"/AdminWithdrawalController"})
public class AdminWithdrawalController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

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

        WithdrawalDAO wDao = new WithdrawalDAO();
        String action = request.getParameter("subAction");

        try {
            // --- CSV EXPORT ---
            if ("exportCSV".equals(action)) {
                handleCSVExport(request, response, wDao);
                return;
            }

            // --- BATCH APPROVE ---
            if ("batchApprove".equals(action)) {
                String[] selectedIds = request.getParameterValues("selectedIds");
                if (selectedIds != null && selectedIds.length > 0) {
                    java.util.List<Integer> ids = new java.util.ArrayList<>();
                    for (String s : selectedIds) {
                        try { ids.add(Integer.parseInt(s)); } catch (NumberFormatException e) { }
                    }
                    int count = wDao.batchApproveWithdrawals(ids);
                    session.setAttribute("toastMessage", "Đã duyệt " + count + "/" + ids.size() + " yêu cầu rút tiền.");
                }
                response.sendRedirect("MainController?action=AdminWithdrawals");
                return;
            }

            // --- SINGLE APPROVE ---
            String approveId = request.getParameter("approveId");
            if (approveId != null && !approveId.isEmpty()) {
                boolean ok = wDao.approveWithdrawal(Integer.parseInt(approveId));
                session.setAttribute("toastMessage", ok ? "Đã duyệt yêu cầu rút tiền #" + approveId : "Không thể duyệt.");
                response.sendRedirect("MainController?action=AdminWithdrawals");
                return;
            }

            // --- SINGLE REJECT ---
            String rejectId = request.getParameter("rejectId");
            if (rejectId != null && !rejectId.isEmpty()) {
                boolean ok = wDao.rejectWithdrawal(Integer.parseInt(rejectId));
                session.setAttribute("toastMessage", ok ? "Đã từ chối yêu cầu #" + rejectId + " (hoàn tiền vào ví designer)." : "Không thể từ chối.");
                response.sendRedirect("MainController?action=AdminWithdrawals");
                return;
            }

            // --- DEFAULT: LIST WITH PAGING & FILTER ---
            String pageStr = request.getParameter("page");
            int pageIndex = (pageStr != null && !pageStr.isEmpty()) ? Integer.parseInt(pageStr) : 1;
            String statusFilter = request.getParameter("statusFilter");
            if (statusFilter == null || statusFilter.isEmpty()) statusFilter = "Pending";

            int totalCount = wDao.getAllWithdrawalsCount(statusFilter);
            int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);
            if (totalPages < 1) totalPages = 1;
            if (pageIndex > totalPages) pageIndex = totalPages;
            if (pageIndex < 1) pageIndex = 1;

            List<Withdrawal> withdrawalList = wDao.getAllWithdrawals(pageIndex, PAGE_SIZE, statusFilter);

            request.setAttribute("WITHDRAWAL_LIST", withdrawalList);
            request.setAttribute("CURRENT_PAGE", pageIndex);
            request.setAttribute("TOTAL_PAGES", totalPages);
            request.setAttribute("TOTAL_COUNT", totalCount);
            request.setAttribute("STATUS_FILTER", statusFilter);

        } catch (Exception e) {
            log("Error at AdminWithdrawalController: " + e.getMessage());
            e.printStackTrace();
        }

        request.getRequestDispatcher("views/admin/withdrawals.jsp").forward(request, response);
    }

    /**
     * Export withdrawal data as CSV with BOM UTF-8 for Excel.
     */
    private void handleCSVExport(HttpServletRequest request, HttpServletResponse response, WithdrawalDAO wDao) throws IOException {
        String statusFilter = request.getParameter("statusFilter");
        if (statusFilter == null || statusFilter.isEmpty()) statusFilter = "Pending";

        List<Withdrawal> list = wDao.getAllWithdrawals(1, Integer.MAX_VALUE, statusFilter);

        response.setContentType("text/csv;charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"payout_summary.csv\"");

        // BOM for Excel UTF-8
        response.getOutputStream().write(0xEF);
        response.getOutputStream().write(0xBB);
        response.getOutputStream().write(0xBF);

        java.io.PrintWriter out = response.getWriter();
        out.println("Designer Name,Bank,Account Number,Account Holder,Amount (VND),Status,Request Date");

        for (Withdrawal w : list) {
            out.printf("\"%s\",\"%s\",\"%s\",\"%s\",%.0f,\"%s\",\"%s\"%n",
                    escapeCSV(w.getDesignerName()),
                    escapeCSV(w.getBankName()),
                    escapeCSV(w.getBankAccountNumber()),
                    escapeCSV(w.getAccountName()),
                    w.getAmount(),
                    escapeCSV(w.getStatus()),
                    w.getCreateAt() != null ? w.getCreateAt().toString() : ""
            );
        }
        out.flush();
    }

    private String escapeCSV(String value) {
        if (value == null) return "";
        return value.replace("\"", "\"\"");
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
        return "Admin Withdrawal Controller";
    }
}
