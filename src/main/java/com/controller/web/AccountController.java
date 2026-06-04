/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller.web;

import com.model.User;
import com.model.UserDAO;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

/**
 *
 * @author lehan
 */
@WebServlet(name = "AccountController", urlPatterns = { "/AccountController" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 1, // 1 MB - bộ nhớ tạm
        maxFileSize = 1024 * 1024 * 10, // 10 MB - kích thước tối đa 1 file
        maxRequestSize = 1024 * 1024 * 15 // 15 MB - tổng kích thước request
)
public class AccountController extends HttpServlet {

    public static final String PROFILE_INFO_REDIRECT = "MainController?action=Profile&tab=info";
    public static final String AUTH_ACTION = "MainController";

    private static final String UPLOAD_DIR = "assets/images/avatars";

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
                // Do form là multipart, ta lấy parameter theo cách này
                String updateType = request.getParameter("updateType");
                UserDAO userDao = new UserDAO();

                if ("profile".equals(updateType)) {
                    // 1. Xử lý cập nhật Email (giữ nguyên)
                    String email = request.getParameter("email");
                    if (userDao.updateEmail(loginUser.getUserId(), email)) {
                        loginUser.setEmail(email);
                        session.setAttribute("toastMessage", "Cập nhật Email thành công!");
                    } else {
                        session.setAttribute("toastMessage", "Cập nhật Email thất bại!");
                    }

                } else if ("avatar".equals(updateType)) {
                    // =======================================================
                    // 2. XỬ LÝ UPLOAD FILE ẢNH ĐẠI DIỆN THẬT
                    // =======================================================
                    Part filePart = request.getPart("avatarFile"); // Lấy file từ input name="avatarFile"

                    if (filePart != null && filePart.getSize() > 0) {
                        // A. Xác định đường dẫn tuyệt đối đến thư mục lưu trữ trên server
                        String applicationPath = request.getServletContext().getRealPath("");
                        String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;

                        // Đảm bảo thư mục tồn tại, nếu không thì tạo mới
                        File uploadLoc = new File(uploadFilePath);
                        if (!uploadLoc.exists()) {
                            uploadLoc.mkdirs();
                        }

                        // B. Lấy tên file gốc và sinh tên mới ĐỘC NHẤT để tránh trùng file
                        String fileName = getFileName(filePart);
                        // Lấy phần mở rộng (ví dụ: .jpg)
                        String fileExt = fileName.substring(fileName.lastIndexOf("."));
                        // Sinh tên mới: user_1_uuid.jpg
                        String uniqueFileName = "user_" + loginUser.getUserId() + "_" + UUID.randomUUID().toString()
                                + fileExt;

                        // C. Ghi file vật lý xuống ổ đĩa server
                        filePart.write(uploadFilePath + File.separator + uniqueFileName);

                        // D. Tạo đường dẫn tương đối để lưu vào DB (dùng để hiển thị trên web)
                        // VD: /EXE202_Maven/assets/images/avatars/unique_file.jpg
                        String dbRelativePath = request.getContextPath() + "/" + UPLOAD_DIR + "/" + uniqueFileName;

                        // E. Cập nhật đường dẫn mới vào Database
                        if (userDao.updateAvatar(loginUser.getUserId(), dbRelativePath)) {
                            // TODO (Tùy chọn): Có thể viết code xóa file ảnh cũ ở đây để dọn rác server

                            loginUser.setAvatarUrl(dbRelativePath); // Cập nhật session
                            session.setAttribute("toastMessage", "Đổi ảnh đại diện thành công!");
                        } else {
                            session.setAttribute("toastMessage", "Lỗi cập nhật CSDL ảnh!");
                        }
                    } else {
                        session.setAttribute("toastMessage", "Vui lòng chọn một file ảnh!");
                    }

                } else if ("password".equals(updateType)) {
                    // 3. Xử lý đổi mật khẩu (giữ nguyên, dùng BCrypt)
                    String oldPass = request.getParameter("oldPass");
                    String newPass = request.getParameter("newPass");
                    if (userDao.changePassword(loginUser.getUserId(), oldPass, newPass)) {
                        session.setAttribute("toastMessage", "Đổi mật khẩu thành công!");
                    } else {
                        session.setAttribute("toastMessage", "Mật khẩu cũ không chính xác!");
                    }
                }
            }
        } catch (Exception e) {
            log("Error at AccountController (File Upload): " + e.toString());
            request.getSession().setAttribute("toastMessage", "Hệ thống lỗi khi xử lý file!");
        } finally {
            response.sendRedirect(url);
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

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the
    // + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
