/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.model;

import com.util.DBUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author lehan
 */
public class ReviewDAO {

    public boolean insertReview(int templateId, int customerId, int rating, String comment) {
        String sql = "INSERT INTO Reviews (templateID, customerID, rating, comment) VALUES (?, ?, ?, ?)";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, templateId);
            ps.setInt(2, customerId);
            ps.setInt(3, rating);
            ps.setString(4, comment);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Kiểm tra xem khách đã đánh giá template này chưa (Chỉ cho đánh giá 1 lần)
    public boolean checkAlreadyReviewed(int templateId, int customerId) {
        String sql = "SELECT 1 FROM Reviews WHERE templateID = ? AND customerID = ?";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, templateId);
            ps.setInt(2, customerId);
            try ( ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
