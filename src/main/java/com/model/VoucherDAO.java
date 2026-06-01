package com.model;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author lehan
 */
import com.model.Voucher;
import com.util.DBUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class VoucherDAO {

    // Lấy voucher hợp lệ (Còn hiệu lực, chưa hết lượt dùng)
    public Voucher getValidVoucher(String code) {
        String sql = "SELECT * FROM Vouchers WHERE code = ? AND status = 1 "
                + "AND usedCount < usageLimit AND validFrom <= GETDATE() AND validTo >= GETDATE()";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Voucher v = new Voucher();
                v.setVoucherId(rs.getInt("voucherID"));
                v.setCode(rs.getString("code"));
                v.setDiscountPercent(rs.getDouble("discountPercent"));
                v.setMaxDiscountAmount(rs.getDouble("maxDiscountAmount"));
                return v;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Thêm hàm này vào VoucherDAO.java
    public boolean increaseUsedCount(int voucherId) {
        // Lệnh SQL cộng thêm 1 vào số lượt đã sử dụng
        String sql = "UPDATE Vouchers SET usedCount = usedCount + 1 WHERE voucherID = ?";
        try ( java.sql.Connection conn = com.util.DBUtils.getConnection();  java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, voucherId);
            int rowsAffected = ps.executeUpdate();

            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
