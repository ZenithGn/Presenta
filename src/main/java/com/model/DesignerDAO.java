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
import java.sql.SQLException;
import java.sql.Statement;
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

    // 1. Lấy số dư ví của Designer
    public double getBalance(int designerId) {
        String sql = "SELECT balance FROM Designer_Profiles WHERE userID = ?";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, designerId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("balance");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    // 2. Lấy số lượng Template đang bán trên Marketplace
    public int getActiveTemplatesCount(int designerId) {
        String sql = "SELECT COUNT(*) FROM Templates WHERE designerID = ?";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, designerId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 3. Cập nhật lại hàm đếm Template đã bán (Chỉ tính đơn hoàn thành và loại là BUY_TEMPLATE)
    public int getTemplatesSoldDashboard(int designerId) {
        String sql = "SELECT COUNT(*) FROM OrderDetails od "
                + "JOIN Templates t ON od.templateID = t.templateID "
                + "JOIN Orders o ON od.orderID = o.orderID "
                + "WHERE t.designerID = ? AND o.status = 'Completed' AND o.orderType = 'BUY_TEMPLATE'";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, designerId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 4. Tổng tiền các đơn rút tiền đang chờ duyệt (Pending)
    public double getPendingPayouts(int designerId) {
        String sql = "SELECT SUM(amount) FROM Withdrawals WHERE designerID = ? AND status = 'Pending'";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, designerId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    // 5. Lấy danh sách đơn hàng gần đây (Recent Sales) cho Bảng 1
    public List<Map<String, Object>> getRecentSales(int designerId) {
        List<Map<String, Object>> list = new ArrayList<>();

        // Thêm AND o.status = 'Completed' vào mệnh đề WHERE
        String sql = "SELECT TOP 3 o.orderID, t.title AS itemName, 'Template Sale' AS itemType, od.price, o.status "
                + "FROM OrderDetails od "
                + "JOIN Templates t ON od.templateID = t.templateID "
                + "JOIN Orders o ON od.orderID = o.orderID "
                + "WHERE t.designerID = ? AND o.status = 'Completed' "
                + "ORDER BY o.createAt DESC";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, designerId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new LinkedHashMap<>();
                    map.put("orderID", rs.getString("orderID"));
                    map.put("itemName", rs.getString("itemName"));
                    map.put("itemType", rs.getString("itemType"));
                    map.put("price", rs.getDouble("price"));
                    map.put("status", rs.getString("status"));
                    list.add(map);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 6. Lấy lịch sử yêu cầu rút tiền cho Bảng 2
    public List<Map<String, Object>> getWithdrawalHistory(int designerId) {
        List<Map<String, Object>> list = new ArrayList<>();
        // SỬA Ở ĐÂY: SELECT TOP 5 -> SELECT TOP 3
        String sql = "SELECT TOP 3 bankName, bankAccountNumber, amount, status "
                + "FROM Withdrawals WHERE designerID = ? ORDER BY createAt DESC";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, designerId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new LinkedHashMap<>();
                    map.put("bankName", rs.getString("bankName"));
                    map.put("accountNumber", rs.getString("bankAccountNumber"));
                    map.put("amount", rs.getDouble("amount"));
                    map.put("status", rs.getString("status"));
                    list.add(map);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // 1. Đếm tổng số lượng Template của Designer để tính số trang (endPage)
    public int getTotalTemplatesCount(int designerId) {
        String sql = "SELECT COUNT(*) FROM Templates WHERE designerID = ?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, designerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 2. Lấy danh sách Template phân trang sử dụng OFFSET và FETCH NEXT (Dành cho SQL Server)
    public List<Map<String, Object>> getTemplatesByDesignerPaginated(int designerId, int pageIndex, int pageSize) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT t.templateID, t.title, t.price, t.thumbnailURL, t.createAt, c.categoryName "
                   + "FROM Templates t "
                   + "JOIN Categories c ON t.categoryID = c.categoryID "
                   + "WHERE t.designerID = ? "
                   + "ORDER BY t.createAt DESC "
                   + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"; // Cú pháp phân trang của SQL Server
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, designerId);
            // Tính số dòng cần bỏ qua (Ví dụ: Trang 2, mỗi trang 5 dòng -> Bỏ qua (2-1)*5 = 5 dòng đầu)
            ps.setInt(2, (pageIndex - 1) * pageSize); 
            ps.setInt(3, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new LinkedHashMap<>();
                    map.put("templateID", rs.getInt("templateID"));
                    map.put("title", rs.getString("title"));
                    map.put("price", rs.getDouble("price"));
                    map.put("thumbnailURL", rs.getString("thumbnailURL"));
                    map.put("createAt", rs.getTimestamp("createAt"));
                    map.put("categoryName", rs.getString("categoryName"));
                    list.add(map);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public boolean deleteTemplate(int templateId) {
        String sql = "DELETE FROM Templates WHERE templateID = ?";
        try (Connection conn = DBUtils.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, templateId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            // In log lỗi nếu vướng khóa ngoại ràng buộc dữ liệu giao dịch
            e.printStackTrace();
        }
        return false;
    }
    
    // 1. Lấy danh sách các danh mục (Categories) cho Dropdown
    public List<Map<String, Object>> getAllCategories() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT categoryID, categoryName FROM Categories";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new LinkedHashMap<>();
                map.put("categoryID", rs.getInt("categoryID"));
                map.put("categoryName", rs.getString("categoryName"));
                list.add(map);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 2. Lấy chi tiết một Template (Chỉ lấy nếu đúng là của Designer đó để bảo mật)
    public Map<String, Object> getTemplateById(int templateId, int designerId) {
        String sql = "SELECT * FROM Templates WHERE templateID = ? AND designerID = ?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, templateId);
            ps.setInt(2, designerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> map = new LinkedHashMap<>();
                    map.put("templateID", rs.getInt("templateID"));
                    map.put("categoryID", rs.getInt("categoryID"));
                    map.put("title", rs.getString("title"));
                    map.put("description", rs.getString("description"));
                    map.put("price", rs.getDouble("price"));
                    map.put("thumbnailURL", rs.getString("thumbnailURL"));
                    map.put("fileURL", rs.getString("fileURL"));
                    map.put("coreFeatures", rs.getString("coreFeatures"));
                    map.put("designAssets", rs.getString("designAssets"));
                    return map;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // 3. Cập nhật Template
    public boolean updateTemplate(int templateId, int designerId, int categoryId, String title, String description, double price, String thumb, String file, String core, String assets) {
        String sql = "UPDATE Templates SET categoryID=?, title=?, description=?, price=?, thumbnailURL=?, fileURL=?, coreFeatures=?, designAssets=? WHERE templateID=? AND designerID=?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.setString(2, title);
            ps.setString(3, description);
            ps.setDouble(4, price);
            ps.setString(5, thumb);
            ps.setString(6, file);
            ps.setString(7, core);
            ps.setString(8, assets);
            ps.setInt(9, templateId);
            ps.setInt(10, designerId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
    
    // Thêm mới một Template vào hệ thống
    public boolean insertTemplate(int designerId, int categoryId, String title, String description, double price, String thumbnailURL, String fileURL, String coreFeatures, String designAssets) {
        String sql = "INSERT INTO Templates (designerID, categoryID, title, description, price, thumbnailURL, fileURL, coreFeatures, designAssets) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, designerId);
            ps.setInt(2, categoryId);
            ps.setString(3, title);
            ps.setString(4, description);
            ps.setDouble(5, price);
            
            // Nếu thumbnailURL truyền vào là null, JDBC sẽ tự động hiểu và gán NULL vào Database
            ps.setString(6, thumbnailURL); 
            
            ps.setString(7, fileURL);
            ps.setString(8, coreFeatures);
            ps.setString(9, designAssets);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ============================================================
    // DESIGNER PROFILE METHODS
    // ============================================================

    // Get full designer profile from Users + Designer_Profiles
    public Designer getFullDesignerProfile(int designerId) {
        String sql = "SELECT u.userID, u.userName, u.email, u.avatarURL, "
                   + "dp.bio, dp.phone, dp.porfolioURL, dp.balance "
                   + "FROM Users u "
                   + "JOIN Designer_Profiles dp ON u.userID = dp.userID "
                   + "WHERE u.userID = ? AND u.roleID = 3 AND u.status = 1";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, designerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Designer d = new Designer();
                    d.setUserID(rs.getInt("userID"));
                    d.setUserName(rs.getString("userName"));
                    d.setAvatarURL(rs.getString("avatarURL"));
                    d.setBio(rs.getString("bio"));
                    d.setPhone(rs.getString("phone"));
                    d.setPortfolioURL(rs.getString("porfolioURL"));
                    d.setBalance(rs.getDouble("balance"));
                    d.setSpecialty("Academic Presentation Designer");
                    return d;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update designer public profile (Designer_Profiles table)
    public boolean updateDesignerProfile(int designerId, String bio, String phone, String portfolioURL) {
        String sql = "UPDATE Designer_Profiles SET bio = ?, phone = ?, porfolioURL = ? WHERE userID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, bio);
            ps.setString(2, phone);
            ps.setString(3, portfolioURL);
            ps.setInt(4, designerId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get orders for designer (hire_designer orders for this designer)
    public List<Map<String, Object>> getDesignerOrders(int designerId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT o.orderID, u.userName AS customerName, o.totalPrice, o.status, o.createAt "
                   + "FROM Orders o "
                   + "JOIN Users u ON o.customerID = u.userID "
                   + "WHERE o.designerID = ? AND o.orderType = 'HIRE_DESIGNER' "
                   + "ORDER BY o.createAt DESC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, designerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new LinkedHashMap<>();
                    map.put("orderID", rs.getInt("orderID"));
                    map.put("customerName", rs.getString("customerName"));
                    map.put("totalPrice", rs.getDouble("totalPrice"));
                    map.put("status", rs.getString("status"));
                    map.put("createAt", rs.getTimestamp("createAt"));
                    list.add(map);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ============================================================
    // BOOKING / HIRE_DESIGNER METHODS
    // ============================================================

    public String getDesignerPhone(int designerId) {
        String sql = "SELECT phone FROM Designer_Profiles WHERE userID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, designerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("phone");
            }
        } catch (Exception e) { e.printStackTrace(); }
        return "";
    }

    public int createBookingOrder(int customerId, int designerId) {
        String sql = "INSERT INTO Orders (customerID, designerID, orderType, totalPrice, status) "
                   + "OUTPUT INSERTED.orderID VALUES (?, ?, 'HIRE_DESIGNER', 0, 'Pending')";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, designerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return -1;
    }

    public boolean updateBookingStatus(int orderId, String status) {
        String sql = "UPDATE Orders SET status = ? WHERE orderID = ? AND orderType = 'HIRE_DESIGNER'";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean completeBookingAndSetPayment(int orderId, double price, String fileURL, int designerId) {
        Connection conn = null;
        PreparedStatement psTemplate = null, psDetail = null, psOrder = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            conn.setAutoCommit(false);

            // 1. Insert Template
            String insertTemplate = "INSERT INTO Templates (designerID, categoryID, title, description, price, fileURL) "
                                  + "VALUES (?, 1, ?, ?, ?, ?)";
            psTemplate = conn.prepareStatement(insertTemplate, Statement.RETURN_GENERATED_KEYS);
            psTemplate.setInt(1, designerId);
            psTemplate.setString(2, "Custom Design #" + orderId);
            psTemplate.setString(3, "Thiết kế riêng theo đơn đặt hàng #" + orderId);
            psTemplate.setDouble(4, price);
            psTemplate.setString(5, fileURL);
            psTemplate.executeUpdate();

            int templateId;
            rs = psTemplate.getGeneratedKeys();
            if (!rs.next()) { conn.rollback(); return false; }
            templateId = rs.getInt(1);
            rs.close();
            psTemplate.close();

            // 2. Insert OrderDetails
            String insertDetail = "INSERT INTO OrderDetails (orderID, templateID, price) VALUES (?, ?, ?)";
            psDetail = conn.prepareStatement(insertDetail);
            psDetail.setInt(1, orderId);
            psDetail.setInt(2, templateId);
            psDetail.setDouble(3, price);
            psDetail.executeUpdate();
            psDetail.close();

            // 3. Update Orders
            String updateOrder = "UPDATE Orders SET totalPrice = ?, status = 'Completed_Design' WHERE orderID = ?";
            psOrder = conn.prepareStatement(updateOrder);
            psOrder.setDouble(1, price);
            psOrder.setInt(2, orderId);
            psOrder.executeUpdate();

            conn.commit();
            return true;
        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException se) { se.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { }
            try { if (psTemplate != null) psTemplate.close(); } catch (SQLException e) { }
            try { if (psDetail != null) psDetail.close(); } catch (SQLException e) { }
            try { if (psOrder != null) psOrder.close(); } catch (SQLException e) { }
            try { if (conn != null) { conn.setAutoCommit(true); conn.close(); } } catch (SQLException e) { }
        }
        return false;
    }

    public List<Map<String, Object>> getCustomerBookings(int customerId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT o.orderID, o.designerID, u.userName AS designerName, o.totalPrice, o.status, o.createAt "
                   + "FROM Orders o JOIN Users u ON o.designerID = u.userID "
                   + "WHERE o.customerID = ? AND o.orderType = 'HIRE_DESIGNER' "
                   + "ORDER BY o.createAt DESC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new LinkedHashMap<>();
                    map.put("orderID", rs.getInt("orderID"));
                    map.put("designerID", rs.getInt("designerID"));
                    map.put("designerName", rs.getString("designerName"));
                    map.put("totalPrice", rs.getDouble("totalPrice"));
                    map.put("status", rs.getString("status"));
                    map.put("createAt", rs.getTimestamp("createAt"));
                    list.add(map);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, Object>> getDesignerBookings(int designerId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT o.orderID, o.customerID, u.userName AS customerName, o.totalPrice, o.status, o.createAt "
                   + "FROM Orders o JOIN Users u ON o.customerID = u.userID "
                   + "WHERE o.designerID = ? AND o.orderType = 'HIRE_DESIGNER' "
                   + "ORDER BY o.createAt DESC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, designerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new LinkedHashMap<>();
                    map.put("orderID", rs.getInt("orderID"));
                    map.put("customerID", rs.getInt("customerID"));
                    map.put("customerName", rs.getString("customerName"));
                    map.put("totalPrice", rs.getDouble("totalPrice"));
                    map.put("status", rs.getString("status"));
                    map.put("createAt", rs.getTimestamp("createAt"));
                    list.add(map);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public int getDesignerBookingCount(int designerId) {
        String sql = "SELECT COUNT(*) FROM Orders WHERE designerID = ? AND orderType = 'HIRE_DESIGNER'";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, designerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public List<Map<String, Object>> getDesignerBookingsPaged(int designerId, int pageIndex, int pageSize) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT o.orderID, o.customerID, u.userName AS customerName, o.totalPrice, o.status, o.createAt "
                   + "FROM Orders o JOIN Users u ON o.customerID = u.userID "
                   + "WHERE o.designerID = ? AND o.orderType = 'HIRE_DESIGNER' "
                   + "ORDER BY o.createAt DESC "
                   + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, designerId);
            ps.setInt(2, (pageIndex - 1) * pageSize);
            ps.setInt(3, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new LinkedHashMap<>();
                    map.put("orderID", rs.getInt("orderID"));
                    map.put("customerID", rs.getInt("customerID"));
                    map.put("customerName", rs.getString("customerName"));
                    map.put("totalPrice", rs.getDouble("totalPrice"));
                    map.put("status", rs.getString("status"));
                    map.put("createAt", rs.getTimestamp("createAt"));
                    list.add(map);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}
