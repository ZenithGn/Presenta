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
import javax.servlet.http.HttpServletRequest;

public class VNPayConfig {

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

    public static final String vnp_TmnCode = getEnv("VNPAY_TMN_CODE");
    public static final String vnp_HashSecret = getEnv("VNPAY_HASH_SECRET");
    public static final String vnp_PayUrl = getEnv("VNPAY_URL");
    public static final String vnp_Returnurl = getEnv("VNPAY_RETURN_URL");

    public static String hmacSHA512(final String key, final String data) {
        try {
            if (key == null || data == null) {
                throw new NullPointerException();
            }
            final Mac hmac512 = Mac.getInstance("HmacSHA512");
            byte[] hmacKeyBytes = key.getBytes(StandardCharsets.UTF_8);
            final SecretKeySpec secretKey = new SecretKeySpec(hmacKeyBytes, "HmacSHA512");
            hmac512.init(secretKey);
            byte[] dataBytes = data.getBytes(StandardCharsets.UTF_8);
            byte[] result = hmac512.doFinal(dataBytes);
            StringBuilder sb = new StringBuilder(2 * result.length);
            for (byte b : result) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
        } catch (Exception ex) {
            return "";
        }
    }

    public static String getIpAddress(HttpServletRequest request) {
        String ipAddress = request.getHeader("X-FORWARDED-FOR");
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getRemoteAddr();
        }
        return ipAddress;
    }
}
