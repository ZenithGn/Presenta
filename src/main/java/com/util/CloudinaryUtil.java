package com.util;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import io.github.cdimascio.dotenv.Dotenv;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

/**
 * Utility class for uploading files to Cloudinary.
 */
public class CloudinaryUtil {
    
    private static Cloudinary cloudinary;
    
    static {
        try {
            Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load();
            String cloudinaryUrl = dotenv.get("CLOUDINARY_URL");
            
            if (cloudinaryUrl != null && !cloudinaryUrl.isEmpty()) {
                cloudinary = new Cloudinary(cloudinaryUrl);
                cloudinary.config.secure = true;
            } else {
                System.err.println("CloudinaryUtil: CLOUDINARY_URL is missing in .env");
            }
        } catch (Exception e) {
            System.err.println("CloudinaryUtil initialization error: " + e.getMessage());
        }
    }
    
    /**
     * Uploads an InputStream to Cloudinary and returns the secure URL.
     * @param is The input stream of the file to upload
     * @param originalFileName The original filename (to preserve extension or identify format)
     * @param folder The folder in Cloudinary (e.g. "avatars" or "portfolios")
     * @return The secure URL of the uploaded file
     * @throws IOException 
     */
    public static String uploadFile(InputStream is, String originalFileName, String folder) throws IOException {
        if (cloudinary == null) {
            throw new IOException("Cloudinary is not configured. Missing CLOUDINARY_URL.");
        }
        
        // Convert InputStream to a temporary file since Cloudinary SDK prefers File or byte[]
        File tempFile = File.createTempFile("upload_", "_" + originalFileName);
        try (FileOutputStream fos = new FileOutputStream(tempFile)) {
            byte[] buffer = new byte[1024];
            int len;
            while ((len = is.read(buffer)) != -1) {
                fos.write(buffer, 0, len);
            }
        }
        
        try {
            Map params = ObjectUtils.asMap(
                "folder", "presenta/" + folder,
                "use_filename", true,
                "unique_filename", true
            );
            
            Map uploadResult = cloudinary.uploader().upload(tempFile, params);
            return (String) uploadResult.get("secure_url");
        } finally {
            if (tempFile.exists()) {
                tempFile.delete();
            }
        }
    }
}
