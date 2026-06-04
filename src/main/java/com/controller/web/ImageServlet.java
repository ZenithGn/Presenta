/*
 * ImageServlet - Serves uploaded files from external directory.
 * This keeps uploaded files safe across redeploys and works in online environments.
 */
package com.controller.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ImageServlet", urlPatterns = {"/uploads/*"})
public class ImageServlet extends HttpServlet {

    private static final String UPLOAD_ROOT;

    static {
        // Read upload root from system property, env var, or fallback to user home
        String path = System.getProperty("presenta.upload.root");
        if (path == null || path.isEmpty()) {
            path = System.getenv("PRESENTA_UPLOAD_ROOT");
        }
        if (path == null || path.isEmpty()) {
            // Default: user home directory (works on both Windows and Linux)
            path = System.getProperty("user.home") + File.separator + "presenta_uploads";
        }
        UPLOAD_ROOT = path;
        // Ensure directory exists
        File dir = new File(UPLOAD_ROOT);
        if (!dir.exists()) {
            dir.mkdirs();
        }
    }

    /**
     * Returns the external upload root directory path.
     * Used by AccountController and other file-uploading servlets.
     */
    public static String getUploadRoot() {
        return UPLOAD_ROOT;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Extract the file path after /uploads/
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        File file = new File(UPLOAD_ROOT, pathInfo);

        if (!file.exists() || !file.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
            return;
        }

        // Set content type based on extension
        String fileName = file.getName().toLowerCase();
        if (fileName.endsWith(".png")) {
            response.setContentType("image/png");
        } else if (fileName.endsWith(".jpg") || fileName.endsWith(".jpeg")) {
            response.setContentType("image/jpeg");
        } else if (fileName.endsWith(".gif")) {
            response.setContentType("image/gif");
        } else if (fileName.endsWith(".svg")) {
            response.setContentType("image/svg+xml");
        } else {
            response.setContentType("application/octet-stream");
        }

        // Cache for 1 hour
        response.setHeader("Cache-Control", "public, max-age=3600");
        response.setContentLengthLong(file.length());

        // Stream the file
        try (FileInputStream fis = new FileInputStream(file);
             OutputStream os = response.getOutputStream()) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }
        }
    }
}
