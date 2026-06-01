/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.model;

/**
 *
 * @author lehan
 */
import com.model.User;
import com.util.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import org.mindrot.jbcrypt.BCrypt;

public class UserDAO {

    // Khai báo Query là hằng số ở đầu Class
    public static final String CHECK_LOGIN_QUERY = "SELECT * FROM Users WHERE userName = ? AND status = 1";
    public static final String CHECK_DUPLICATE_QUERY = "SELECT userID FROM Users WHERE userName = ? OR email = ?";
    public static final String INSERT_USER_QUERY = "INSERT INTO Users (userName, password, email, roleID, status) VALUES (?, ?, ?, ?, 1)";
    public static final String INSERT_DESIGNER_PROFILE_QUERY = "INSERT INTO Designer_Profiles (userID, bio, phone, porfolioURL) VALUES (?, ?, ?, ?)";

    public User checkLogin(String username, String plainPassword) {
        User user = null;

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(CHECK_LOGIN_QUERY)) {

            // Chỉ truyền vào username
            ps.setString(1, username);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Lấy chuỗi mật khẩu đã băm từ Database
                    String dbHashedPassword = rs.getString("password");

                    // Nhờ Bcrypt kiểm tra xem mật khẩu nhập vào có khớp với chuỗi Hash không
                    if (BCrypt.checkpw(plainPassword, dbHashedPassword)) {

                        // Nếu khớp (True), khởi tạo đối tượng User cho đăng nhập thành công
                        user = new User(
                                rs.getInt("userID"),
                                rs.getString("userName"),
                                dbHashedPassword, // Có thể truyền dbHashedPassword hoặc null tùy ý
                                rs.getString("email"),
                                rs.getInt("roleID"),
                                rs.getBoolean("status")
                                
                        );
                        user.setAvatarUrl(rs.getString("avatarURL"));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean checkDuplicate(String username, String email) {
        boolean exist = false;
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(CHECK_DUPLICATE_QUERY)) {

            ps.setString(1, username);
            ps.setString(2, email);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    exist = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return exist;
    }

    public boolean registerUser(User user, String phone, String portfolioURL, String bio) {
        boolean check = false;
        Connection conn = null;
        PreparedStatement ptmUser = null;
        PreparedStatement ptmDesigner = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                // Tắt AutoCommit để thực hiện Transaction cho 2 bảng
                conn.setAutoCommit(false);

                ptmUser = conn.prepareStatement(INSERT_USER_QUERY, Statement.RETURN_GENERATED_KEYS);
                ptmUser.setString(1, user.getUsername());
                ptmUser.setString(2, user.getPassword());
                ptmUser.setString(3, user.getEmail());
                ptmUser.setInt(4, user.getRoleId());

                int rowUser = ptmUser.executeUpdate();

                if (rowUser > 0) {
                    // Nếu là Customer (roleId = 2)
                    if (user.getRoleId() == 2) {
                        conn.commit();
                        check = true;
                    } // Nếu là Designer (roleId = 3)
                    else if (user.getRoleId() == 3) {
                        rs = ptmUser.getGeneratedKeys();
                        if (rs.next()) {
                            int generatedUserID = rs.getInt(1);

                            ptmDesigner = conn.prepareStatement(INSERT_DESIGNER_PROFILE_QUERY);
                            ptmDesigner.setInt(1, generatedUserID);
                            ptmDesigner.setString(2, bio);
                            ptmDesigner.setString(3, phone);
                            ptmDesigner.setString(4, portfolioURL);

                            int rowDesigner = ptmDesigner.executeUpdate();
                            if (rowDesigner > 0) {
                                conn.commit();
                                check = true;
                            } else {
                                conn.rollback();
                            }
                        } else {
                            conn.rollback();
                        }
                    }
                } else {
                    conn.rollback();
                }
            }
        } catch (Exception e) {
            try {
                if (conn != null) {
                    conn.rollback(); // Có lỗi thì rollback tránh rác DB
                }
            } catch (SQLException se) {
                se.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ptmDesigner != null) {
                    ptmDesigner.close();
                }
                if (ptmUser != null) {
                    ptmUser.close();
                }
                if (conn != null) {
                    conn.setAutoCommit(true); // Trả lại trạng thái mặc định
                    conn.close();
                }
            } catch (SQLException se) {
                se.printStackTrace();
            }
        }
        return check;
    }

    // Hàm cập nhật địa chỉ Email của người dùng
    public boolean updateEmail(int userId, String email) {
        String sql = "UPDATE Users SET email = ? WHERE userID = ?";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateAvatar(int userId, String avatarUrl) {
        String sql = "UPDATE Users SET avatarURL = ? WHERE userID = ?";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, avatarUrl);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Hàm đổi mật khẩu (Giả sử bạn đang lưu mật khẩu thô hoặc bcrypt tùy dự án)
    public boolean changePassword(int userId, String oldPass, String newPass) {
        String getHashSql = "SELECT password FROM Users WHERE userID = ?";
        String updateSql = "UPDATE Users SET password = ? WHERE userID = ?";

        try ( Connection conn = DBUtils.getConnection()) {
            String currentHashedPass = null;
            try ( PreparedStatement psGet = conn.prepareStatement(getHashSql)) {
                psGet.setInt(1, userId);
                try ( ResultSet rs = psGet.executeQuery()) {
                    if (rs.next()) {
                        currentHashedPass = rs.getString("password");
                    } else {
                        return false;
                    }
                }
            }
            if (currentHashedPass == null || !BCrypt.checkpw(oldPass, currentHashedPass)) {
                return false; // Mật khẩu cũ không chính xác
            }
            String newHashedPass = BCrypt.hashpw(newPass, BCrypt.gensalt(12)); // Độ phức tạp (workload) = 12
            try ( PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                psUpdate.setString(1, newHashedPass);
                psUpdate.setInt(2, userId);
                return psUpdate.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
