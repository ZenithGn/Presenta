/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.model;

import com.util.DBUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 *
 * @author lehan
 */
public class PaymentDAO {

    public boolean insertPayment(int orderId, String paymentMethod, String transactionId, double amount, String paymentStatus) {
        boolean result = false;
        String sql = "INSERT INTO Payments (orderID, paymentMethod, transactionID, amount, paymentStatus) VALUES (?, ?, ?, ?, ?)";

        try (
                 Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setString(2, paymentMethod);
            ps.setString(3, transactionId);
            ps.setDouble(4, amount);
            ps.setString(5, paymentStatus);

            result = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}
