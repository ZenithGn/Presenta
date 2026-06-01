/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.util;

/**
 *
 * @author lehan
 */
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtils {

    private static final String DB_NAME = "Presenta"; 
    private static final String USER_NAME = "sa";
    private static final String PASSWORD = "Password12345"; 

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Connection conn = null;
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String url = "jdbc:sqlserver://presenta-db.cteg6oiuoyos.ap-southeast-2.rds.amazonaws.com:1433;"
                   + "databaseName=" + DB_NAME + ";"
                   + "encrypt=true;trustServerCertificate=true;";
        conn = DriverManager.getConnection(url, USER_NAME, PASSWORD);
        return conn;
    }
}
