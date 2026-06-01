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
        try (InputStream in = Thread.currentThread().getContextClassLoader().getResourceAsStream(".env")) {
            if (in == null) {
                throw new RuntimeException("Không tìm thấy file .env trong thư mục src/main/resources");
            }
            props.load(in);
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi đọc file .env trong MomoConfig", e);
        }
    }

    // Đọc các thông số cấu hình MoMo từ file .env
    public static final String PARTNER_CODE = props.getProperty("MOMO_PARTNER_CODE");
    public static final String ACCESS_KEY = props.getProperty("MOMO_ACCESS_KEY");
    public static final String SECRET_KEY = props.getProperty("MOMO_SECRET_KEY");
    
    public static final String ENDPOINT = props.getProperty("MOMO_ENDPOINT");
    public static final String RETURN_URL = props.getProperty("MOMO_RETURN_URL");
    public static final String IPN_URL = props.getProperty("MOMO_IPN_URL");

    // Thuật toán HmacSHA256 của MoMo (Giữ nguyên gốc)
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
