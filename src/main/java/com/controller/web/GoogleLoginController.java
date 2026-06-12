package com.controller.web;

import com.model.User;
import com.model.UserDAO;
import com.util.CloudinaryUtil;
import com.util.JwtUtil;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Controller to handle Sign-in with Google flow.
 */
@WebServlet(name = "GoogleLoginController", urlPatterns = { "/GoogleLoginController" })
public class GoogleLoginController extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(GoogleLoginController.class);
    
    private static final String ERROR_PAGE = "views/web/login.jsp";
    private static final String ADMIN_DASHBOARD = "AdminDashboardController";
    private static final String HOME_PAGE = "HomeController";
    private static final String DESIGNER_HOME = "DesignerHomeController";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET request to Login page
        response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        String credential = request.getParameter("credential");
        
        if (credential == null || credential.isEmpty()) {
            request.setAttribute("errorMessage", "Không nhận được thông tin đăng nhập từ Google!");
            request.getRequestDispatcher(ERROR_PAGE).forward(request, response);
            return;
        }

        try {
            // Validate Google ID Token via Google's tokeninfo API
            String verifyUrl = "https://oauth2.googleapis.com/tokeninfo?id_token=" + credential;
            URL url = new URL(verifyUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(5000);
            
            int responseCode = conn.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
                StringBuilder jsonResponse = new StringBuilder();
                String inputLine;
                while ((inputLine = in.readLine()) != null) {
                    jsonResponse.append(inputLine);
                }
                in.close();
                
                // Parse the verified token details
                JsonObject jsonObject = JsonParser.parseString(jsonResponse.toString()).getAsJsonObject();
                String email = jsonObject.get("email").getAsString();
                String name = jsonObject.has("name") ? jsonObject.get("name").getAsString() : email.split("@")[0];
                String picture = jsonObject.has("picture") ? jsonObject.get("picture").getAsString() : null;
                
                UserDAO dao = new UserDAO();
                User user = dao.getUserByEmail(email);
                
                if (user == null) {
                    // Create a new user automatically (Role 2: Customer)
                    String cloudinaryUrl = null;
                    if (picture != null && !picture.isEmpty()) {
                        try {
                            URL imgUrl = new URL(picture);
                            HttpURLConnection imgConn = (HttpURLConnection) imgUrl.openConnection();
                            imgConn.setRequestMethod("GET");
                            imgConn.setConnectTimeout(5000);
                            imgConn.setReadTimeout(5000);
                            try (InputStream is = imgConn.getInputStream()) {
                                cloudinaryUrl = CloudinaryUtil.uploadFile(is, "google_avatar.jpg", "avatars");
                            }
                        } catch (Exception e) {
                            logger.error("Error uploading avatar to Cloudinary for new Google user: " + email, e);
                            cloudinaryUrl = picture; // fallback to raw google avatar URL
                        }
                    }
                    
                    user = dao.registerGoogleUser(name, email, cloudinaryUrl);
                    if (user == null) {
                        request.setAttribute("errorMessage", "Không thể tạo tài khoản từ liên kết Google!");
                        request.getRequestDispatcher(ERROR_PAGE).forward(request, response);
                        return;
                    }
                    logger.info("Successfully registered a new customer via Google: {}", email);
                } else {
                    // Existing User. Update avatar if they don't have one set yet
                    if ((user.getAvatarUrl() == null || user.getAvatarUrl().isEmpty()) && picture != null && !picture.isEmpty()) {
                        String cloudinaryUrl = null;
                        try {
                            URL imgUrl = new URL(picture);
                            HttpURLConnection imgConn = (HttpURLConnection) imgUrl.openConnection();
                            imgConn.setRequestMethod("GET");
                            imgConn.setConnectTimeout(5000);
                            imgConn.setReadTimeout(5000);
                            try (InputStream is = imgConn.getInputStream()) {
                                cloudinaryUrl = CloudinaryUtil.uploadFile(is, "google_avatar.jpg", "avatars");
                            }
                        } catch (Exception e) {
                            logger.error("Error uploading Google avatar to Cloudinary for existing user: " + email, e);
                        }
                        if (cloudinaryUrl != null) {
                            dao.updateAvatar(user.getUserId(), cloudinaryUrl);
                            user.setAvatarUrl(cloudinaryUrl);
                        }
                    }
                    
                    // If user is banned (status = false), prevent login
                    if (!user.isStatus()) {
                        request.setAttribute("errorMessage", "Tài khoản của bạn đã bị khóa!");
                        request.getRequestDispatcher(ERROR_PAGE).forward(request, response);
                        return;
                    }
                }
                
                // Establish user session
                HttpSession session = request.getSession();
                session.setAttribute("LOGIN_USER", user);
                
                // Generate and save JWT login token inside Cookie (mirror normal LoginController)
                String token = JwtUtil.generateToken(user);
                Cookie jwtCookie = new Cookie("jwt", token);
                jwtCookie.setHttpOnly(true);
                jwtCookie.setPath("/");
                jwtCookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
                response.addCookie(jwtCookie);
                
                logger.info("User logged in via Google successfully: {}", email);
                
                // Determine home redirection URL by role
                String redirectUrl = HOME_PAGE;
                if (user.getRoleId() == 1) {
                    redirectUrl = ADMIN_DASHBOARD;
                } else if (user.getRoleId() == 3) {
                    redirectUrl = DESIGNER_HOME;
                }
                
                response.sendRedirect(request.getContextPath() + "/" + redirectUrl);
                
            } else {
                // Log failed validation response
                BufferedReader in = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
                StringBuilder errorResponse = new StringBuilder();
                String inputLine;
                while ((inputLine = in.readLine()) != null) {
                    errorResponse.append(inputLine);
                }
                in.close();
                
                logger.error("Google token validation failed. Code: {}, Error: {}", responseCode, errorResponse.toString());
                request.setAttribute("errorMessage", "Xác thực tài khoản Google không thành công!");
                request.getRequestDispatcher(ERROR_PAGE).forward(request, response);
            }
        } catch (Exception e) {
            logger.error("Error in GoogleLoginController post processing", e);
            request.setAttribute("errorMessage", "Hệ thống gặp sự cố khi xử lý đăng nhập bằng Google!");
            request.getRequestDispatcher(ERROR_PAGE).forward(request, response);
        }
    }
}
