package com.util;

import io.github.cdimascio.dotenv.Dotenv;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Scanner;
import java.util.concurrent.CompletableFuture;

public class EmailUtil {
    private static final Logger logger = LogManager.getLogger(EmailUtil.class);

    private static String emailAddress;
    private static String brevoApiKey;
    private static boolean isConfigured = false;

    static {
        try {
            Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load();
            emailAddress = dotenv.get("MAIL_ADDRESS");
            if (emailAddress == null || emailAddress.isEmpty()) {
                emailAddress = System.getenv("MAIL_ADDRESS");
            }
            
            brevoApiKey = dotenv.get("BREVO_API_KEY");
            if (brevoApiKey == null || brevoApiKey.isEmpty()) {
                brevoApiKey = System.getenv("BREVO_API_KEY");
            }

            if (emailAddress != null && !emailAddress.isEmpty() && brevoApiKey != null && !brevoApiKey.isEmpty()) {
                isConfigured = true;
            } else {
                logger.warn("MAIL_ADDRESS or BREVO_API_KEY not found in .env. Email Service is disabled.");
            }
        } catch (Exception e) {
            logger.warn("Failed to load email config from .env: " + e.getMessage());
        }
    }

    /**
     * Gửi email dưới nền (Asynchronous / Broker Pattern).
     * Hàm này trả về ngay lập tức để không làm block luồng chính.
     */
    public static void sendEmailAsync(String toAddress, String subject, String body) {
        if (!isConfigured) {
            logger.warn("Cannot send email to {}. Email Service is not configured.", toAddress);
            return;
        }

        CompletableFuture.runAsync(() -> {
            try {
                sendEmailSynchronous(toAddress, subject, body);
            } catch (Exception e) {
                logger.error("Failed to send email to " + toAddress, e);
            }
        });
    }

    private static void sendEmailSynchronous(String toAddress, String subject, String body) throws Exception {
        URL url = new URL("https://api.brevo.com/v3/smtp/email");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("accept", "application/json");
        conn.setRequestProperty("api-key", brevoApiKey);
        conn.setRequestProperty("content-type", "application/json");
        conn.setDoOutput(true);

        // Tạo JSON Payload
        JSONObject payload = new JSONObject();
        
        JSONObject sender = new JSONObject();
        sender.put("email", emailAddress);
        sender.put("name", "Presenta System");
        payload.put("sender", sender);

        JSONArray toArray = new JSONArray();
        JSONObject toObj = new JSONObject();
        toObj.put("email", toAddress);
        toArray.put(toObj);
        payload.put("to", toArray);

        payload.put("subject", subject);
        payload.put("htmlContent", body);

        String jsonInputString = payload.toString();

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = jsonInputString.getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }

        int responseCode = conn.getResponseCode();
        if (responseCode >= 200 && responseCode < 300) {
            logger.info("Successfully sent email to {}", toAddress);
        } else {
            // Đọc thông báo lỗi từ Brevo
            InputStream errorStream = conn.getErrorStream();
            if (errorStream != null) {
                try (Scanner scanner = new Scanner(errorStream, StandardCharsets.UTF_8.name())) {
                    String errorResponse = scanner.useDelimiter("\\A").hasNext() ? scanner.next() : "";
                    logger.error("Brevo API Error: {}", errorResponse);
                    throw new Exception("Brevo API returned code " + responseCode + ": " + errorResponse);
                }
            } else {
                throw new Exception("Brevo API returned code " + responseCode);
            }
        }
    }
}
