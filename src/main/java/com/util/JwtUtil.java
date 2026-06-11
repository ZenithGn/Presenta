package com.util;

import com.model.User;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import io.github.cdimascio.dotenv.Dotenv;

import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class JwtUtil {

    private static final long EXPIRATION_TIME = 86400000; // 24 hours in milliseconds

    // We use a static key generated for the application lifecycle, 
    // or load it from .env if preferred.
    private static Key getSigningKey() {
        try {
            Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load();
            String secret = dotenv.get("JWT_SECRET");
            if (secret != null && secret.length() >= 32) {
                return Keys.hmacShaKeyFor(secret.getBytes());
            }
        } catch (Exception e) {
            // Ignore if dotenv fails
        }
        // Default static key for demonstration (In production, use a strong external secret)
        String defaultSecret = "MySuperSecretKeyForPresentaApplicationWhichIsVeryLongAndSecure123!";
        return Keys.hmacShaKeyFor(defaultSecret.getBytes());
    }

    private static final Key key = getSigningKey();

    /**
     * Generate JWT for a specific user
     */
    public static String generateToken(User user) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("userId", user.getUserId());
        claims.put("username", user.getUsername());
        claims.put("email", user.getEmail());
        claims.put("roleId", user.getRoleId());
        claims.put("status", user.isStatus());
        claims.put("avatarUrl", user.getAvatarUrl());

        return Jwts.builder()
                .setClaims(claims)
                .setSubject(user.getEmail())
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + EXPIRATION_TIME))
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();
    }

    /**
     * Validate JWT
     */
    public static boolean validateToken(String token) {
        try {
            Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Get User object back from JWT token
     */
    public static User getUserFromToken(String token) {
        try {
            Claims claims = Jwts.parserBuilder()
                    .setSigningKey(key)
                    .build()
                    .parseClaimsJws(token)
                    .getBody();

            int userId = claims.get("userId", Integer.class);
            String username = claims.get("username", String.class);
            String email = claims.get("email", String.class);
            int roleId = claims.get("roleId", Integer.class);
            boolean status = claims.get("status", Boolean.class);
            String avatarUrl = claims.get("avatarUrl", String.class);

            return new User(userId, username, null, email, roleId, status, avatarUrl);
        } catch (Exception e) {
            return null;
        }
    }
}
