package com.util;

import io.github.cdimascio.dotenv.Dotenv;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;
import java.util.concurrent.CompletableFuture;

public class EmailUtil {
    private static final Logger logger = LogManager.getLogger(EmailUtil.class);

    private static String emailAddress;
    private static String emailPassword;
    private static boolean isConfigured = false;

    static {
        try {
            Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load();
            emailAddress = dotenv.get("MAIL_ADDRESS");
            emailPassword = dotenv.get("MAIL_PASSWORD");

            if (emailAddress != null && !emailAddress.isEmpty() && emailPassword != null && !emailPassword.isEmpty()) {
                isConfigured = true;
            } else {
                logger.warn("MAIL_ADDRESS or MAIL_PASSWORD not found in .env. Email Service is disabled.");
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
                logger.info("Successfully sent email to {}", toAddress);
            } catch (Exception e) {
                logger.error("Failed to send email to " + toAddress, e);
            }
        });
    }

    private static void sendEmailSynchronous(String toAddress, String subject, String body) throws MessagingException {
        Properties properties = new Properties();
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.ssl.protocols", "TLSv1.2");
        properties.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        // Fix lỗi tên máy tính có dấu (Vietnamese computer name issue in EHLO)
        properties.put("mail.smtp.localhost", "localhost");

        Session session = Session.getInstance(properties, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(emailAddress, emailPassword);
            }
        });

        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(emailAddress));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toAddress));
        message.setSubject(subject, "UTF-8");
        message.setText(body, "UTF-8", "html");

        Transport.send(message);
    }
}
