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
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

public class MomoConfig {

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

    public static final String PARTNER_CODE = getEnv("MOMO_PARTNER_CODE");
    public static final String ACCESS_KEY = getEnv("MOMO_ACCESS_KEY");
    public static final String SECRET_KEY = getEnv("MOMO_SECRET_KEY");

    public static final String ENDPOINT = getEnv("MOMO_ENDPOINT");
    public static final String RETURN_URL = getEnv("MOMO_RETURN_URL");
    public static final String IPN_URL = getEnv("MOMO_IPN_URL");

    public static String hmacSHA256(String data, String key) {
        try {
            Mac sha256_HMAC = Mac.getInstance("HmacSHA256");
            SecretKeySpec secret_key = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
            sha256_HMAC.init(secret_key);
            byte[] hash = sha256_HMAC.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
