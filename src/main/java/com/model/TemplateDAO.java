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
import java.util.List;

public class TemplateDAO {

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM Categories";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Category(rs.getInt("categoryID"), rs.getString("categoryName")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy danh sách template theo mã danh mục (Category ID)
    public List<Template> getTemplatesByCategoryID(int categoryID) {
        List<Template> list = new ArrayList<>();
        String sql = "SELECT * FROM Templates WHERE categoryID = ?";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryID);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Template t = new Template();
                    t.setTemplateID(rs.getInt("templateID"));
                    t.setTitle(rs.getString("title"));
                    t.setDescription(rs.getString("description"));
                    t.setPrice(rs.getDouble("price"));
                    t.setThumbnailURL(rs.getString("thumbnailURL"));
                    t.setCategoryID(rs.getInt("categoryID"));
                    list.add(t);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // =========================================================================
    // HÀM DUY NHẤT: LẤY CHI TIẾT 1 TEMPLATE KÈM THÔNG TIN ĐỒNG BỘ CỦA DESIGNER
    // =========================================================================
    public Template getTemplateByID(int templateID) {
        Template t = null;
        // Sử dụng LEFT JOIN để đảm bảo an toàn nếu Designer chưa cấu hình bio/portfolio
        String sql = "SELECT t.*, u.userName, u.avatarURL, dp.bio, dp.porfolioURL "
                + "FROM Templates t "
                + "JOIN Users u ON t.designerID = u.userID "
                + "LEFT JOIN Designer_Profiles dp ON u.userID = dp.userID "
                + "WHERE t.templateID = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, templateID);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    t = new Template();
                    t.setTemplateID(rs.getInt("templateID"));
                    t.setTitle(rs.getString("title"));
                    t.setDescription(rs.getString("description"));
                    t.setPrice(rs.getDouble("price"));
                    t.setThumbnailURL(rs.getString("thumbnailURL"));
                    t.setFileURL(rs.getString("fileURL"));
                    t.setCategoryID(rs.getInt("categoryID"));
                    t.setDesignerID(rs.getInt("designerID"));
                    t.setCoreFeatures(rs.getString("coreFeatures"));
                    t.setDesignAssets(rs.getString("designAssets"));
                    t.setCreateAt(rs.getTimestamp("createAt"));

                    // Đồng bộ thông tin thực tế của Designer sang Object Template
                    t.setDesignerName(rs.getString("userName"));
                    t.setDesignerAvatar(rs.getString("avatarURL"));
                    t.setDesignerBio(rs.getString("bio"));
                    t.setDesignerPortfolio(rs.getString("porfolioURL"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return t;
    }

    // Lấy ngẫu nhiên 4 sản phẩm làm Explore Recommendations cho trang chủ
    public List<Template> getRecommendations() {
        List<Template> list = new ArrayList<>();
        String sql = "SELECT TOP 4 * FROM Templates ORDER BY NEWID()";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
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

    // Lấy sản phẩm bán chạy nhất trong vòng 7 ngày gần nhất
    public Template getBestTemplateOfTheWeek() {
        Template bestTemplate = null;
        String sql = "SELECT TOP 1 t.*, COUNT(od.orderDetailID) as TotalSales "
                + "FROM Templates t "
                + "JOIN OrderDetails od ON t.templateID = od.templateID "
                + "JOIN Orders o ON od.orderID = o.orderID "
                + "WHERE o.createAt >= DATEADD(day, -7, GETDATE()) AND o.status = 'Completed' AND o.orderType = 'BUY_TEMPLATE' "
                + "GROUP BY t.templateID, t.designerID, t.categoryID, t.title, t.description, t.price, t.thumbnailURL, t.fileURL, t.createAt "
                + "ORDER BY TotalSales DESC";

        String fallbackSql = "SELECT TOP 1 * FROM Templates ORDER BY price DESC";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                bestTemplate = new Template();
                bestTemplate.setTemplateID(rs.getInt("templateID"));
                bestTemplate.setTitle(rs.getString("title"));
                bestTemplate.setDescription(rs.getString("description"));
                bestTemplate.setPrice(rs.getDouble("price"));
                bestTemplate.setThumbnailURL(rs.getString("thumbnailURL"));
            } else {
                // Hướng giải quyết Fallback nếu tuần này chưa phát sinh giao dịch completed
                try ( PreparedStatement ps2 = conn.prepareStatement(fallbackSql);  ResultSet rs2 = ps2.executeQuery()) {
                    if (rs2.next()) {
                        bestTemplate = new Template();
                        bestTemplate.setTemplateID(rs2.getInt("templateID"));
                        bestTemplate.setTitle(rs2.getString("title"));
                        bestTemplate.setDescription(rs2.getString("description"));
                        bestTemplate.setPrice(rs2.getDouble("price"));
                        bestTemplate.setThumbnailURL(rs2.getString("thumbnailURL"));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bestTemplate;
    }

    // Đếm tổng số lượng sản phẩm phục vụ cho thuật toán phân trang của Shop
    // Loại trừ các template thuộc đơn HIRE_DESIGNER (thiết kế riêng)
    public int countTotalTemplates(String keyword, int categoryID) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Templates t WHERE t.templateID NOT IN "
                   + "(SELECT od.templateID FROM OrderDetails od "
                   + "JOIN Orders o ON od.orderID = o.orderID "
                   + "WHERE o.orderType = 'HIRE_DESIGNER' AND od.templateID IS NOT NULL) "
                   + "AND t.title LIKE ? ";
        if (categoryID > 0) {
            sql += " AND t.categoryID = ? ";
        }

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            if (categoryID > 0) {
                ps.setInt(2, categoryID);
            }
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    // Truy vấn danh sách sản phẩm có áp dụng bộ lọc Tìm kiếm, Danh mục, Phân trang và Sắp xếp giá
    // Loại trừ các template thuộc đơn HIRE_DESIGNER (thiết kế riêng)
    public List<Template> searchAndPagingTemplates(String keyword, int categoryID, int index, int pageSize, String priceSort) {
        List<Template> list = new ArrayList<>();
        String sql = "SELECT * FROM Templates t WHERE t.templateID NOT IN "
                   + "(SELECT od.templateID FROM OrderDetails od "
                   + "JOIN Orders o ON od.orderID = o.orderID "
                   + "WHERE o.orderType = 'HIRE_DESIGNER' AND od.templateID IS NOT NULL) "
                   + "AND t.title LIKE ? ";
        if (categoryID > 0) {
            sql += " AND t.categoryID = ? ";
        }
        // Sắp xếp theo giá nếu có, mặc định theo templateID
        if ("asc".equals(priceSort)) {
            sql += " ORDER BY t.price ASC ";
        } else if ("desc".equals(priceSort)) {
            sql += " ORDER BY t.price DESC ";
        } else {
            sql += " ORDER BY t.templateID DESC ";
        }
        sql += " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");

            int paramIndex = 2;
            if (categoryID > 0) {
                ps.setInt(paramIndex++, categoryID);
            }

            int offset = (index - 1) * pageSize;
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex, pageSize);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Template t = new Template();
                    t.setTemplateID(rs.getInt("templateID"));
                    t.setTitle(rs.getString("title"));
                    t.setDescription(rs.getString("description"));
                    t.setPrice(rs.getDouble("price"));
                    t.setThumbnailURL(rs.getString("thumbnailURL"));
                    t.setCategoryID(rs.getInt("categoryID"));
                    list.add(t);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy danh sách sản phẩm gợi ý cùng danh mục (loại trừ sản phẩm chính đang xem chi tiết)
    public List<Template> getRelatedTemplates(int categoryID, int currentTemplateID) {
        List<Template> list = new ArrayList<>();
        String sql = "SELECT TOP 4 * FROM Templates WHERE categoryID = ? AND templateID != ? ORDER BY NEWID()";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryID);
            ps.setInt(2, currentTemplateID);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Template t = new Template();
                    t.setTemplateID(rs.getInt("templateID"));
                    t.setTitle(rs.getString("title"));
                    t.setPrice(rs.getDouble("price"));
                    t.setThumbnailURL(rs.getString("thumbnailURL"));
                    list.add(t);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy toàn bộ danh sách lịch sử đánh giá của sản phẩm
    public List<Review> getReviewsByTemplateID(int templateID) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT u.userName, r.rating, r.comment FROM Reviews r JOIN Users u ON r.customerID = u.userID WHERE r.templateID = ? ORDER BY r.createAt DESC";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, templateID);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Review(rs.getString("userName"), rs.getInt("rating"), rs.getString("comment")));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public Template getTemplateById(int templateId) {
        return getTemplateByID(templateId);
    }
}
