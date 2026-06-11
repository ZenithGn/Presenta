package com.filter;

import com.model.User;
import com.util.JwtUtil;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(filterName = "JwtAuthFilter", urlPatterns = {"/*"})
public class JwtAuthFilter implements Filter {

    private static final Logger logger = LogManager.getLogger(JwtAuthFilter.class);

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String path = req.getRequestURI();

        // Skip static resources
        if (path.contains("/assets/") || path.contains("/images/") || path.contains("/css/") || path.contains("/js/")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(true);
        User sessionUser = (User) session.getAttribute("LOGIN_USER");

        // If user is not in session, try to restore from JWT
        if (sessionUser == null) {
            String jwtToken = extractJwtFromCookie(req);
            if (jwtToken != null && JwtUtil.validateToken(jwtToken)) {
                User jwtUser = JwtUtil.getUserFromToken(jwtToken);
                if (jwtUser != null) {
                    session.setAttribute("LOGIN_USER", jwtUser);
                    logger.debug("Restored user session from JWT token for: {}", jwtUser.getEmail());
                } else {
                    logger.warn("JWT token was valid but user payload could not be extracted.");
                }
            }
        } else {
            // User is already in session, maybe check if JWT still exists and is valid
            // But for simplicity, we trust the session here.
        }

        chain.doFilter(request, response);
    }

    private String extractJwtFromCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("jwt".equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}
