package com.util;

import java.io.InputStream;
import java.util.Properties;
import vn.payos.PayOS;

public class PayOSConfig {

    private static final Properties props = new Properties();

    static {
        try ( InputStream in = Thread.currentThread().getContextClassLoader().getResourceAsStream(".env")) {
            if (in != null) {
                props.load(in);
            } else {
                System.out.println("[INFO] Không tìm thấy file .env, sử dụng System Environment của Cloud.");
            }
        } catch (Exception e) {
            System.err.println("[WARN] Lỗi đọc file .env cục bộ: " + e.getMessage());
        }
    }

    private static String getEnv(String key) {
        String value = System.getenv(key);
        if (value != null && !value.isEmpty()) {
            return value;
        }
        return props.getProperty(key);
    }

    public static final String PAYOS_CLIENT_ID = getEnv("PAYOS_CLIENT_ID");
    public static final String PAYOS_API_KEY = getEnv("PAYOS_API_KEY");
    public static final String PAYOS_CHECKSUM_KEY = getEnv("PAYOS_CHECKSUM_KEY");
    
    // Default URLs if not specified in env
    public static final String PAYOS_RETURN_URL = getEnv("PAYOS_RETURN_URL") != null ? getEnv("PAYOS_RETURN_URL") : "http://localhost:8080/EXE202_Maven/PayOSReturnController";
    public static final String PAYOS_CANCEL_URL = getEnv("PAYOS_CANCEL_URL") != null ? getEnv("PAYOS_CANCEL_URL") : "http://localhost:8080/EXE202_Maven/PayOSReturnController";

    public static PayOS payOS;

    static {
        if (PAYOS_CLIENT_ID != null && PAYOS_API_KEY != null && PAYOS_CHECKSUM_KEY != null) {
            payOS = new PayOS(PAYOS_CLIENT_ID, PAYOS_API_KEY, PAYOS_CHECKSUM_KEY);
        } else {
            System.err.println("[WARN] PayOS configuration is missing in .env. PayOS instance will not be initialized.");
        }
    }
}
