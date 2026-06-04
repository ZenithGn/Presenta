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
        try (InputStream in = Thread.currentThread().getContextClassLoader().getResourceAsStream(".env")) {
            if (in != null) {
                props.load(in);
            } else {
                // Trên Render sẽ chạy vào nhánh này vì không có file .env vật lý
                System.out.println("[INFO] Không tìm thấy file .env, sử dụng System Environment của Cloud.");
            }
        } catch (Exception e) {
            System.err.println("[WARN] Lỗi đọc file .env cục bộ: " + e.getMessage());
        }
    }

    // Hàm đa năng: Tìm trên Render trước, nếu không có mới tìm trong file .env
    // local
    private static String getEnv(String key) {
        String value = System.getenv(key);
        if (value != null && !value.isEmpty()) {
            return value;
        }
        return props.getProperty(key);
    }

    private static final String DB_HOST = getEnv("DB_HOST");
    private static final String DB_NAME = getEnv("DB_NAME");
    private static final String USER_NAME = getEnv("DB_USER");
    private static final String PASSWORD = getEnv("DB_PASSWORD");

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
