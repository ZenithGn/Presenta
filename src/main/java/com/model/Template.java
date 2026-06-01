/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.model;

/**
 *
 * @author lehan
 */
import java.sql.Timestamp;

public class Template {

    private int templateID;
    private int designerID;
    private int categoryID;
    private String title;
    private String description;
    private double price;
    private String thumbnailURL;
    private String fileURL;
    private Timestamp createAt;
    private String designerName;
    private String designerBio;
    private String designerPortfolio;
    private String designerAvatar;
    private String coreFeatures, designAssets;

    public Template() {
    }

    // Getters and Setters (Bạn tự generate đầy đủ nhé)
    public int getTemplateID() {
        return templateID;
    }

    public void setTemplateID(int templateID) {
        this.templateID = templateID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getThumbnailURL() {
        return thumbnailURL;
    }

    public void setThumbnailURL(String thumbnailURL) {
        this.thumbnailURL = thumbnailURL;
    }

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    public int getDesignerID() {
        return designerID;
    }

    public void setDesignerID(int designerID) {
        this.designerID = designerID;
    }

    public String getDesignerName() {
        return designerName;
    }

    public void setDesignerName(String designerName) {
        this.designerName = designerName;
    }

    public String getDesignerBio() {
        return designerBio;
    }

    public void setDesignerBio(String designerBio) {
        this.designerBio = designerBio;
    }

    public String getDesignerPortfolio() {
        return designerPortfolio;
    }

    public void setDesignerPortfolio(String designerPortfolio) {
        this.designerPortfolio = designerPortfolio;
    }

    public String getDesignerAvatar() {
        return designerAvatar;
    }

    public void setDesignerAvatar(String designerAvatar) {
        this.designerAvatar = designerAvatar;
    }

    public String getCoreFeatures() {
        return coreFeatures;
    }

    public void setCoreFeatures(String coreFeatures) {
        this.coreFeatures = coreFeatures;
    }

    public String getDesignAssets() {
        return designAssets;
    }

    public void setDesignAssets(String designAssets) {
        this.designAssets = designAssets;
    }

    public String getFileURL() {
        return fileURL;
    }

    public void setFileURL(String fileURL) {
        this.fileURL = fileURL;
    }

    public Timestamp getCreateAt() {
        return createAt;
    }

    public void setCreateAt(Timestamp createAt) {
        this.createAt = createAt;
    }

    
}
