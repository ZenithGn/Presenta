/*
 * AccountController - Handles account/profile updates for all user roles.
 * Uses external upload directory (ImageServlet) for file storage.
 */
package com.controller.web;

import com.model.DesignerDAO;
import com.model.User;
import com.model.UserDAO;
import java.io.File;
import java.io.IOException;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet(name = "AccountController", urlPatterns = {"/AccountController"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB max per file
        maxRequestSize = 1024 * 1024 * 15 // 15 MB max request
)
public class AccountController extends HttpServlet {

    public static final String PROFILE_INFO_REDIRECT = "MainController?action=Profile&tab=info";
    public static final String DESIGNER_PROFILE_REDIRECT = "MainController?action=DesignerProfile&tab=info";
    public static final String ADMIN_PROFILE_REDIRECT = "MainController?action=AdminProfile&tab=info";
    public static final String AUTH_ACTION = "MainController";

    private static final String UPLOAD_SUB_DIR = "avatars";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = PROFILE_INFO_REDIRECT;

        try {
            HttpSession session = request.getSession();
            User loginUser = (User) session.getAttribute("LOGIN_USER");

            if (loginUser == null) {
                url = AUTH_ACTION;
            } else {
                String updateType = request.getParameter("updateType");
                UserDAO userDao = new UserDAO();

                if ("profile".equals(updateType)) {
                    // --- Profile Update ---
                    String email = request.getParameter("email");
                    String username = request.getParameter("username");

                    boolean success = true;
                    String message = "Cập nhật thông tin thành công!";

                    if (username != null && !username.trim().isEmpty() && !username.equals(loginUser.getUsername())) {
                        if (userDao.checkUsernameExists(username, loginUser.getUserId())) {
                            success = false;
                            message = "Tên đăng nhập đã tồn tại!";
                        } else {
                            if (userDao.updateUsername(loginUser.getUserId(), username)) {
                                loginUser.setUsername(username);
                            } else {
                                success = false;
                                message = "Cập nhật tên đăng nhập thất bại!";
                            }
                        }
                    }

                    if (success && email != null && !email.trim().isEmpty() && !email.equals(loginUser.getEmail())) {
                        if (userDao.updateEmail(loginUser.getUserId(), email)) {
                            loginUser.setEmail(email);
                        } else {
                            success = false;
                            if (message.equals("Cập nhật thông tin thành công!")) {
                                message = "Cập nhật Email thất bại!";
                            }
                        }
                    }

                    session.setAttribute("toastMessage", message);
                    if (loginUser.getRoleId() == 3) {
                        url = DESIGNER_PROFILE_REDIRECT;
                    } else if (loginUser.getRoleId() == 1) {
                        url = ADMIN_PROFILE_REDIRECT;
                    }

                } else if ("avatar".equals(updateType)) {
                    // --- Avatar Upload (Customer) ---
                    String savedPath = saveAvatar(request, loginUser, userDao, session);
                    if (savedPath != null) {
                        loginUser.setAvatarUrl(savedPath);
                    }
                    if (loginUser.getRoleId() == 3) {
                        url = DESIGNER_PROFILE_REDIRECT;
                    } else if (loginUser.getRoleId() == 1) {
                        url = ADMIN_PROFILE_REDIRECT;
                    }

                } else if ("designer_profile".equals(updateType)) {
                    // --- Designer Portfolio Update ---
                    String bio = request.getParameter("bio");
                    String phone = request.getParameter("phone");
                    String portfolioURL = request.getParameter("portfolioURL");

                    DesignerDAO designerDao = new DesignerDAO();
                    if (designerDao.updateDesignerProfile(loginUser.getUserId(), bio, phone, portfolioURL)) {
                        session.setAttribute("toastMessage", "Cập nhật hồ sơ Designer thành công!");
                    } else {
                        session.setAttribute("toastMessage", "Cập nhật hồ sơ Designer thất bại!");
                    }
                    url = "MainController?action=DesignerProfile&tab=portfolio";

                } else if ("designer_avatar".equals(updateType)) {
                    // --- Avatar Upload (Designer) ---
                    String savedPath = saveAvatar(request, loginUser, userDao, session);
                    if (savedPath != null) {
                        loginUser.setAvatarUrl(savedPath);
                    }
                    url = "MainController?action=DesignerProfile&tab=info";

                } else if ("password".equals(updateType)) {
                    // --- Password Change ---
                    String oldPass = request.getParameter("oldPass");
                    String newPass = request.getParameter("newPass");
                    if (userDao.changePassword(loginUser.getUserId(), oldPass, newPass)) {
                        session.setAttribute("toastMessage", "Đổi mật khẩu thành công!");
                    } else {
                        session.setAttribute("toastMessage", "Mật khẩu cũ không chính xác!");
                    }
                    if (loginUser.getRoleId() == 3) {
                        url = DESIGNER_PROFILE_REDIRECT;
                    } else if (loginUser.getRoleId() == 1) {
                        url = ADMIN_PROFILE_REDIRECT;
                    }
                }
            }
        } catch (Exception e) {
            log("Error at AccountController: " + e.toString());
            request.getSession().setAttribute("toastMessage", "Hệ thống lỗi khi xử lý yêu cầu!");
        } finally {
            response.sendRedirect(url);
        }
    }

    /**
     * Saves uploaded avatar to external directory via ImageServlet.
     * Returns the DB-relative path on success, null on failure.
     */
    private String saveAvatar(HttpServletRequest request, User loginUser,
                               UserDAO userDao, HttpSession session)
            throws IOException, ServletException {
        Part filePart = request.getPart("avatarFile");

        if (filePart == null || filePart.getSize() <= 0) {
            session.setAttribute("toastMessage", "Vui lòng chọn một file ảnh!");
            return null;
        }

        // External upload directory (survives redeploys)
        String uploadRoot = ImageServlet.getUploadRoot();
        String uploadFilePath = uploadRoot + File.separator + UPLOAD_SUB_DIR;
        File uploadLoc = new File(uploadFilePath);
        if (!uploadLoc.exists()) {
            uploadLoc.mkdirs();
        }

        // Generate unique filename
        String fileName = getFileName(filePart);
        String fileExt = fileName.substring(fileName.lastIndexOf("."));
        String uniqueFileName = "user_" + loginUser.getUserId() + "_" + UUID.randomUUID().toString() + fileExt;

        // Write file to external directory
        filePart.write(uploadFilePath + File.separator + uniqueFileName);

        // DB path via ImageServlet
        String dbRelativePath = request.getContextPath() + "/uploads/" + UPLOAD_SUB_DIR + "/" + uniqueFileName;

        if (userDao.updateAvatar(loginUser.getUserId(), dbRelativePath)) {
            session.setAttribute("toastMessage", "Đổi ảnh đại diện thành công!");
            return dbRelativePath;
        } else {
            session.setAttribute("toastMessage", "Lỗi cập nhật CSDL ảnh!");
            return null;
        }
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Account Controller";
    }
}
