/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.util;

/**
 *
 * @author lehan
 */
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBUtils {

private static final Properties props = new Properties();

    static {
        // Sử dụng ClassLoader lấy file .env từ thư mục resources
        try (InputStream in = Thread.currentThread().getContextClassLoader().getResourceAsStream(".env")) {
            if (in == null) {
                throw new RuntimeException("Không tìm thấy file .env trong thư mục src/main/resources");
            }
            props.load(in);
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi đọc file .env trong DBUtils", e);
        }
    }

    // Đọc các thông số cấu hình Database từ file .env
    private static final String DB_HOST = props.getProperty("DB_HOST");
    private static final String DB_NAME = props.getProperty("DB_NAME");
    private static final String USER_NAME = props.getProperty("DB_USER");
    private static final String PASSWORD = props.getProperty("DB_PASSWORD");

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Connection conn = null;
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String url = "jdbc:sqlserver://" + DB_HOST + ":1433;"
                   + "databaseName=" + DB_NAME + ";"
                   + "encrypt=true;trustServerCertificate=true;";
        conn = DriverManager.getConnection(url, USER_NAME, PASSWORD);
        return conn;
    }
}
