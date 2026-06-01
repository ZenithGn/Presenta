/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.util;

/**
 *
 * @author lehan
 */
import io.github.cdimascio.dotenv.Dotenv;
import java.nio.charset.StandardCharsets;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

public class MomoConfig {

    // .env file load karva mate
    private static final Dotenv dotenv = Dotenv.load();

    public static final String PARTNER_CODE = dotenv.get("MOMO_PARTNER_CODE");
    public static final String ACCESS_KEY = dotenv.get("MOMO_ACCESS_KEY");
    public static final String SECRET_KEY = dotenv.get("MOMO_SECRET_KEY");
    
    public static final String ENDPOINT = dotenv.get("MOMO_ENDPOINT");
    public static final String RETURN_URL = dotenv.get("MOMO_RETURN_URL");
    public static final String IPN_URL = dotenv.get("MOMO_IPN_URL");

    // Thuật toán HmacSHA256 của MoMo
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