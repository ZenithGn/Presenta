/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.model;

import com.util.DBUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 *
 * @author lehan
 */
public class OrderDAO {

    public String insertOrder(Order order, Map<Integer, CartItem> cart) {
        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psDetail = null;
        ResultSet rs = null;
        String generatedOrderId = null;

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                // TẮT AUTO COMMIT ĐỂ BẮT ĐẦU TRANSACTION
                conn.setAutoCommit(false);

                // 1. LƯU BẢNG ORDERS
                String sqlOrder = "INSERT INTO Orders (customerID, voucherID, orderType, designerID, totalPrice, status) "
                        + "VALUES (?, ?, ?, ?, ?, ?)";

                // Thuộc tính RETURN_GENERATED_KEYS dùng để lấy ra orderID vừa được Database tự động sinh ra (IDENTITY)
                psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
                psOrder.setInt(1, order.getCustomerId());

                if (order.getVoucherId() != null && order.getVoucherId() > 0) {
                    psOrder.setInt(2, order.getVoucherId());
                } else {
                    psOrder.setNull(2, Types.INTEGER); // Set Null an toàn theo chuẩn SQL Server
                }

                psOrder.setString(3, order.getOrderType());

                if (order.getDesignerId() != null && order.getDesignerId() > 0) {
                    psOrder.setInt(4, order.getDesignerId());
                } else {
                    psOrder.setNull(4, Types.INTEGER);
                }

                psOrder.setDouble(5, order.getTotalPrice());
                psOrder.setString(6, "Pending"); // Trạng thái chờ thanh toán

                int affectedRows = psOrder.executeUpdate();
                if (affectedRows > 0) {
                    rs = psOrder.getGeneratedKeys();
                    if (rs.next()) {
                        int newOrderId = rs.getInt(1);
                        generatedOrderId = String.valueOf(newOrderId);

                        // 2. LƯU BẢNG ORDERDETAILS BẰNG KỸ THUẬT BATCH THỰC THI NHANH
                        if (cart != null && !cart.isEmpty()) {
                            String sqlDetail = "INSERT INTO OrderDetails (orderID, templateID, price) VALUES (?, ?, ?)";
                            psDetail = conn.prepareStatement(sqlDetail);

                            for (CartItem item : cart.values()) {
                                psDetail.setInt(1, newOrderId);
                                psDetail.setInt(2, item.getTemplate().getTemplateID());
                                // Lưu giá gốc của 1 item tại thời điểm mua (không nhân số lượng)
                                psDetail.setDouble(3, item.getTemplate().getPrice());
                                psDetail.addBatch(); // Đưa vào hàng chờ
                            }
                            psDetail.executeBatch(); // Thực thi lưu tất cả sản phẩm cùng lúc
                        }

                        // CHỐT TRANSACTION (XÁC NHẬN LƯU THÀNH CÔNG VÀO DB)
                        conn.commit();
                    }
                }
            }
        } catch (Exception e) {
            // NẾU CÓ BẤT CỨ LỖI NÀO (DÙ LÀ NHỎ NHẤT), ROLLBACK (HỦY BỎ) TOÀN BỘ DỮ LIỆU ĐÃ GHI
            if (conn != null) {
                try {
                    conn.rollback();
                    System.out.println("Transaction rolled back due to error.");
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            generatedOrderId = null; // Trả về null để Controller biết lỗi
        } finally {
            // Đóng các resource để giải phóng bộ nhớ
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                if (psDetail != null) {
                    psDetail.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                if (psOrder != null) {
                    psOrder.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                if (conn != null) {
                    conn.setAutoCommit(true); // Bật lại Auto Commit cho các hàm khác dùng chung
                    conn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return generatedOrderId;
    }

    public boolean updateOrderStatus(int orderId, String newStatus) {
        boolean result = false;
        String sql = "UPDATE Orders SET status = ? WHERE orderID = ?";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setInt(2, orderId);

            result = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<Template> getPurchasedTemplatesByOrderId(int orderId) {
        java.util.List<com.model.Template> list = new java.util.ArrayList<>();
        String sql = "SELECT t.templateID, t.title, t.fileURL FROM OrderDetails od "
                + "JOIN Templates t ON od.templateID = t.templateID WHERE od.orderID = ?";
        try ( java.sql.Connection conn = com.util.DBUtils.getConnection();  java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            try ( java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    com.model.Template t = new com.model.Template();
                    t.setTemplateID(rs.getInt("templateID"));
                    t.setTitle(rs.getString("title"));
                    t.setFileURL(rs.getString("fileURL"));
                    list.add(t);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<com.model.Template> getPurchasedTemplates(int customerId, int offset, int fetchSize) {
        List<com.model.Template> list = new ArrayList<>();
        String sql = "SELECT t.templateID, t.title, t.price, t.fileURL, o.createAt "
                + "FROM Orders o JOIN OrderDetails od ON o.orderID = od.orderID "
                + "JOIN Templates t ON od.templateID = t.templateID "
                + "WHERE o.customerID = ? AND o.orderType = 'BUY_TEMPLATE' AND o.status = 'Completed' "
                + "ORDER BY o.createAt DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try ( java.sql.Connection conn = com.util.DBUtils.getConnection();  java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, offset);
            ps.setInt(3, fetchSize);
            try ( java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    com.model.Template t = new com.model.Template();
                    t.setTemplateID(rs.getInt("templateID"));
                    t.setTitle(rs.getString("title"));
                    t.setPrice(rs.getDouble("price"));
                    t.setFileURL(rs.getString("fileURL"));
                    t.setCreateAt(rs.getTimestamp("createAt"));
                    list.add(t);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Đếm tổng số lượng để tính số trang
    public int getTotalPurchasedTemplates(int customerId) {
        String sql = "SELECT COUNT(od.templateID) FROM Orders o JOIN OrderDetails od ON o.orderID = od.orderID "
                + "WHERE o.customerID = ? AND o.orderType = 'BUY_TEMPLATE' AND o.status = 'Completed'";
        try ( java.sql.Connection conn = com.util.DBUtils.getConnection();  java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try ( java.sql.ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy danh sách Đơn đặt CUSTOMIZE
    public List<com.model.Order> getCustomOrders(int customerId) {
        List<com.model.Order> list = new ArrayList<>();
        String sql = "SELECT orderID, designerID, totalPrice, status, createAt "
                + "FROM Orders WHERE customerID = ? AND orderType = 'HIRE_DESIGNER' ORDER BY createAt DESC";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    com.model.Order o = new com.model.Order();
                    o.setOrderId(rs.getInt("orderID"));
                    o.setDesignerId(rs.getInt("designerID"));
                    o.setTotalPrice(rs.getDouble("totalPrice"));
                    o.setStatus(rs.getString("status"));
                    o.setCreateAt(rs.getTimestamp("createAt"));
                    list.add(o);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Order getCustomOrderById(int orderId) {
        String sql = "SELECT orderID, customerID, designerID, orderType, totalPrice, status, createAt "
                   + "FROM Orders WHERE orderID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order o = new Order();
                    o.setOrderId(rs.getInt("orderID"));
                    o.setCustomerId(rs.getInt("customerID"));
                    o.setDesignerId(rs.getInt("designerID"));
                    o.setOrderType(rs.getString("orderType"));
                    o.setTotalPrice(rs.getDouble("totalPrice"));
                    o.setStatus(rs.getString("status"));
                    o.setCreateAt(rs.getTimestamp("createAt"));
                    return o;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Template getTemplateByCustomOrder(int orderId) {
        String sql = "SELECT t.templateID, t.title, t.price, t.fileURL, t.thumbnailURL "
                   + "FROM OrderDetails od JOIN Templates t ON od.templateID = t.templateID "
                   + "WHERE od.orderID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Template t = new Template();
                    t.setTemplateID(rs.getInt("templateID"));
                    t.setTitle(rs.getString("title"));
                    t.setPrice(rs.getDouble("price"));
                    t.setFileURL(rs.getString("fileURL"));
                    t.setThumbnailURL(rs.getString("thumbnailURL"));
                    return t;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertFreeOrder(int customerId, int templateId) {
        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psDetail = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                conn.setAutoCommit(false);
                
                String sqlOrder = "INSERT INTO Orders (customerID, orderType, totalPrice, status) VALUES (?, 'BUY_TEMPLATE', 0, 'Completed')";
                psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
                psOrder.setInt(1, customerId);
                
                int affectedRows = psOrder.executeUpdate();
                if (affectedRows > 0) {
                    rs = psOrder.getGeneratedKeys();
                    if (rs.next()) {
                        int newOrderId = rs.getInt(1);
                        String sqlDetail = "INSERT INTO OrderDetails (orderID, templateID, price) VALUES (?, ?, 0)";
                        psDetail = conn.prepareStatement(sqlDetail);
                        psDetail.setInt(1, newOrderId);
                        psDetail.setInt(2, templateId);
                        psDetail.executeUpdate();
                        conn.commit();
                        return true;
                    }
                }
            }
        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (Exception ex) {}
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (psDetail != null) psDetail.close(); } catch (Exception e) {}
            try { if (psOrder != null) psOrder.close(); } catch (Exception e) {}
            try { if (conn != null) { conn.setAutoCommit(true); conn.close(); } } catch (Exception e) {}
        }
        return false;
    }

    public boolean hasPurchasedTemplate(int customerId, int templateId) {
        String sql = "SELECT COUNT(*) FROM Orders o JOIN OrderDetails od ON o.orderID = od.orderID "
                   + "WHERE o.customerID = ? AND od.templateID = ? AND o.orderType = 'BUY_TEMPLATE' AND o.status = 'Completed'";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, templateId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
