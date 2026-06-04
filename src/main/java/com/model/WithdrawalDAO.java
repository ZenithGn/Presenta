/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.model;

import com.util.DBUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author lehan
 */
public class WithdrawalDAO {

    /**
     * Insert a new withdrawal request.
     * Deducts from designer balance immediately (balance is held until approved/rejected).
     */
    public boolean insertWithdrawal(int designerId, double amount, String bankName, String bankAccountNumber, String accountName) {
        Connection conn = null;
        PreparedStatement psWithdraw = null;
        PreparedStatement psBalance = null;
        try {
            conn = DBUtils.getConnection();
            conn.setAutoCommit(false);

            // Check balance
            String checkSql = "SELECT balance FROM Designer_Profiles WHERE userID = ?";
            double currentBalance = 0;
            try (PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
                psCheck.setInt(1, designerId);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) currentBalance = rs.getDouble("balance");
                }
            }
            if (currentBalance < amount) {
                conn.rollback();
                return false;
            }

            // Deduct balance
            String balanceSql = "UPDATE Designer_Profiles SET balance = balance - ? WHERE userID = ?";
            psBalance = conn.prepareStatement(balanceSql);
            psBalance.setDouble(1, amount);
            psBalance.setInt(2, designerId);
            psBalance.executeUpdate();

            // Insert withdrawal
            String sql = "INSERT INTO Withdrawals (designerID, amount, bankName, bankAccountNumber, accountName, status) "
                       + "VALUES (?, ?, ?, ?, ?, 'Pending')";
            psWithdraw = conn.prepareStatement(sql);
            psWithdraw.setInt(1, designerId);
            psWithdraw.setDouble(2, amount);
            psWithdraw.setString(3, bankName);
            psWithdraw.setString(4, bankAccountNumber);
            psWithdraw.setString(5, accountName);
            psWithdraw.executeUpdate();

            conn.commit();
            return true;
        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException se) { se.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try { if (psWithdraw != null) psWithdraw.close(); } catch (SQLException e) { }
            try { if (psBalance != null) psBalance.close(); } catch (SQLException e) { }
            try { if (conn != null) { conn.setAutoCommit(true); conn.close(); } } catch (SQLException e) { }
        }
        return false;
    }

    /**
     * Get withdrawals for a specific designer (history).
     */
    public List<Withdrawal> getWithdrawalsByDesigner(int designerId) {
        List<Withdrawal> list = new ArrayList<>();
        String sql = "SELECT withdrawalID, amount, bankName, bankAccountNumber, accountName, status, createAt "
                   + "FROM Withdrawals WHERE designerID = ? ORDER BY createAt DESC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, designerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Withdrawal w = new Withdrawal();
                    w.setWithdrawalID(rs.getInt("withdrawalID"));
                    w.setDesignerID(designerId);
                    w.setAmount(rs.getDouble("amount"));
                    w.setBankName(rs.getString("bankName"));
                    w.setBankAccountNumber(rs.getString("bankAccountNumber"));
                    w.setAccountName(rs.getString("accountName"));
                    w.setStatus(rs.getString("status"));
                    w.setCreateAt(rs.getTimestamp("createAt"));
                    list.add(w);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    /**
     * Get all withdrawals (admin) with pagination. Joined with Users for designerName.
     */
    public List<Withdrawal> getAllWithdrawals(int pageIndex, int pageSize, String statusFilter) {
        List<Withdrawal> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT w.withdrawalID, w.designerID, u.userName AS designerName, w.amount, "
          + "w.bankName, w.bankAccountNumber, w.accountName, w.status, w.createAt, dp.balance "
          + "FROM Withdrawals w "
          + "JOIN Users u ON w.designerID = u.userID "
          + "JOIN Designer_Profiles dp ON w.designerID = dp.userID "
        );
        if (statusFilter != null && !statusFilter.isEmpty() && !"All".equals(statusFilter)) {
            sql.append("WHERE w.status = ? ");
        }
        sql.append("ORDER BY w.createAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIdx = 1;
            if (statusFilter != null && !statusFilter.isEmpty() && !"All".equals(statusFilter)) {
                ps.setString(paramIdx++, statusFilter);
            }
            ps.setInt(paramIdx++, (pageIndex - 1) * pageSize);
            ps.setInt(paramIdx, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Withdrawal w = new Withdrawal();
                    w.setWithdrawalID(rs.getInt("withdrawalID"));
                    w.setDesignerID(rs.getInt("designerID"));
                    w.setDesignerName(rs.getString("designerName"));
                    w.setAmount(rs.getDouble("amount"));
                    w.setBankName(rs.getString("bankName"));
                    w.setBankAccountNumber(rs.getString("bankAccountNumber"));
                    w.setAccountName(rs.getString("accountName"));
                    w.setStatus(rs.getString("status"));
                    w.setCreateAt(rs.getTimestamp("createAt"));
                    w.setDesignerBalance(rs.getDouble("balance"));
                    list.add(w);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    /**
     * Count all withdrawals (for admin paging).
     */
    public int getAllWithdrawalsCount(String statusFilter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Withdrawals w ");
        if (statusFilter != null && !statusFilter.isEmpty() && !"All".equals(statusFilter)) {
            sql.append("WHERE w.status = ?");
        }
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (statusFilter != null && !statusFilter.isEmpty() && !"All".equals(statusFilter)) {
                ps.setString(1, statusFilter);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    /**
     * Approve a single withdrawal.
     */
    public boolean approveWithdrawal(int withdrawalId) {
        String sql = "UPDATE Withdrawals SET status = 'Approved' WHERE withdrawalID = ? AND status = 'Pending'";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, withdrawalId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    /**
     * Reject a withdrawal. Refunds the amount back to designer balance.
     */
    public boolean rejectWithdrawal(int withdrawalId) {
        Connection conn = null;
        PreparedStatement psSelect = null;
        PreparedStatement psRefund = null;
        PreparedStatement psReject = null;
        try {
            conn = DBUtils.getConnection();
            conn.setAutoCommit(false);

            // Get withdrawal info
            String selectSql = "SELECT designerID, amount, status FROM Withdrawals WHERE withdrawalID = ?";
            psSelect = conn.prepareStatement(selectSql);
            psSelect.setInt(1, withdrawalId);
            int designerId = 0;
            double amount = 0;
            try (ResultSet rs = psSelect.executeQuery()) {
                if (rs.next() && "Pending".equals(rs.getString("status"))) {
                    designerId = rs.getInt("designerID");
                    amount = rs.getDouble("amount");
                } else {
                    conn.rollback();
                    return false;
                }
            }

            // Refund balance
            String refundSql = "UPDATE Designer_Profiles SET balance = balance + ? WHERE userID = ?";
            psRefund = conn.prepareStatement(refundSql);
            psRefund.setDouble(1, amount);
            psRefund.setInt(2, designerId);
            psRefund.executeUpdate();

            // Reject withdrawal
            String rejectSql = "UPDATE Withdrawals SET status = 'Rejected' WHERE withdrawalID = ?";
            psReject = conn.prepareStatement(rejectSql);
            psReject.setInt(1, withdrawalId);
            psReject.executeUpdate();

            conn.commit();
            return true;
        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException se) { se.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try { if (psSelect != null) psSelect.close(); } catch (SQLException e) { }
            try { if (psRefund != null) psRefund.close(); } catch (SQLException e) { }
            try { if (psReject != null) psReject.close(); } catch (SQLException e) { }
            try { if (conn != null) { conn.setAutoCommit(true); conn.close(); } } catch (SQLException e) { }
        }
        return false;
    }

    /**
     * Batch approve withdrawals. Returns count of approved.
     */
    public int batchApproveWithdrawals(List<Integer> withdrawalIds) {
        String sql = "UPDATE Withdrawals SET status = 'Approved' WHERE withdrawalID = ? AND status = 'Pending'";
        int count = 0;
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int id : withdrawalIds) {
                ps.setInt(1, id);
                ps.addBatch();
            }
            int[] results = ps.executeBatch();
            for (int r : results) {
                if (r > 0) count++;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }
}
