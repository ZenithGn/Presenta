/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.model;

/**
 *
 * @author lehan
 */
import com.util.DBUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class DesignerDAO {

    public List<Designer> getTop3Designers() {
        List<Designer> list = new ArrayList<>();
        // SỬA: dp.avatarURL -> u.avatarURL
        String sql = "SELECT TOP 3 u.userID, u.userName, u.avatarURL, dp.bio "
                + "FROM Users u "
                + "JOIN Designer_Profiles dp ON u.userID = dp.userID "
                + "WHERE u.roleID = 3 AND u.status = 1 "
                + "ORDER BY NEWID()";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Designer d = new Designer();
                d.setUserID(rs.getInt("userID"));
                d.setUserName(rs.getString("userName"));
                d.setAvatarURL(rs.getString("avatarURL"));
                d.setBio(rs.getString("bio"));
                d.setSpecialty("UI/UX & Branding");
                list.add(d);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, List<Designer>> getDesignersGroupedByCategory(String txtSearch) {
        Map<String, List<Designer>> map = new LinkedHashMap<>();

        String catSql = "SELECT categoryID, categoryName FROM Categories";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement psCat = conn.prepareStatement(catSql);  ResultSet rsCat = psCat.executeQuery()) {

            while (rsCat.next()) {
                int catId = rsCat.getInt("categoryID");
                String catName = rsCat.getString("categoryName");

                List<Designer> list = new ArrayList<>();

                // SỬA: dp.avatarURL -> u.avatarURL
                String dSql = "SELECT DISTINCT TOP 6 u.userID, u.userName, u.avatarURL, dp.bio "
                        + "FROM Users u "
                        + "JOIN Designer_Profiles dp ON u.userID = dp.userID "
                        + "JOIN Templates t ON t.designerID = u.userID "
                        + "WHERE u.roleID = 3 AND u.status = 1 AND t.categoryID = ? AND u.userName LIKE ? "
                        + "ORDER BY u.userID DESC";

                try ( PreparedStatement psD = conn.prepareStatement(dSql)) {
                    psD.setInt(1, catId);
                    psD.setString(2, "%" + txtSearch + "%");

                    try ( ResultSet rsD = psD.executeQuery()) {
                        while (rsD.next()) {
                            Designer d = new Designer();
                            d.setUserID(rsD.getInt("userID"));
                            d.setUserName(rsD.getString("userName"));
                            d.setAvatarURL(rsD.getString("avatarURL"));
                            d.setBio(rsD.getString("bio"));
                            d.setSpecialty(catName);
                            list.add(d);
                        }
                    }
                }

                if (!list.isEmpty()) {
                    map.put(catName, list);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    public Designer getDesignerById(int designerId) {
        // SỬA: dp.avatarURL -> u.avatarURL
        String sql = "SELECT u.userID, u.userName, u.avatarURL, dp.bio "
                + "FROM Users u JOIN Designer_Profiles dp ON u.userID = dp.userID "
                + "WHERE u.userID = ?";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, designerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Designer d = new Designer();
                d.setUserID(rs.getInt("userID"));
                d.setUserName(rs.getString("userName"));
                d.setAvatarURL(rs.getString("avatarURL"));
                d.setBio(rs.getString("bio"));
                d.setSpecialty("Academic Presentation Designer");
                return d;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Template> getTop3TemplatesByDesigner(int designerId) {
        List<Template> list = new ArrayList<>();
        String sql = "SELECT TOP 3 templateID, title, price, thumbnailURL "
                + "FROM Templates WHERE designerID = ? ORDER BY createAt DESC";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, designerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Template t = new Template();
                t.setTemplateID(rs.getInt("templateID"));
                t.setTitle(rs.getString("title"));
                t.setPrice(rs.getDouble("price"));
                t.setThumbnailURL(rs.getString("thumbnailURL"));
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Review> getReviewsByDesigner(int designerId) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.rating, r.comment, u.userName "
                + "FROM Reviews r "
                + "JOIN Templates t ON r.templateID = t.templateID "
                + "JOIN Users u ON r.customerID = u.userID "
                + "WHERE t.designerID = ? ORDER BY r.createAt DESC";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, designerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Review r = new Review();
                r.setRating(rs.getInt("rating"));
                r.setComment(rs.getString("comment"));
                r.setCustomerName(rs.getString("userName"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTemplatesSold(int designerId) {
        String sql = "SELECT COUNT(*) FROM OrderDetails od "
                + "JOIN Templates t ON od.templateID = t.templateID "
                + "JOIN Orders o ON od.orderID = o.orderID "
                + "WHERE t.designerID = ? AND o.status = 'Completed'";
        try ( Connection conn = com.util.DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, designerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
