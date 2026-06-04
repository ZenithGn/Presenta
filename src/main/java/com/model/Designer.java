/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.model;

/**
 *
 * @author lehan
 */
public class Designer {

    private int userID;
    private String userName;
    private String avatarURL;
    private String bio;
    private String specialty; // Computed field: e.g. Motion Design, Branding...
    private String phone;           // from Designer_Profiles
    private String portfolioURL;    // from Designer_Profiles (porfolioURL in DB)
    private double balance;         // from Designer_Profiles

    // Constructors
    public Designer() {
    }

    public Designer(int userID, String userName, String avatarURL, String bio, String specialty) {
        this.userID = userID;
        this.userName = userName;
        this.avatarURL = avatarURL;
        this.bio = bio;
        this.specialty = specialty;
    }

    // Getters and Setters
    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getAvatarURL() {
        return avatarURL;
    }

    public void setAvatarURL(String avatarURL) {
        this.avatarURL = avatarURL;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public String getSpecialty() {
        return specialty;
    }

    public void setSpecialty(String specialty) {
        this.specialty = specialty;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPortfolioURL() {
        return portfolioURL;
    }

    public void setPortfolioURL(String portfolioURL) {
        this.portfolioURL = portfolioURL;
    }

    public double getBalance() {
        return balance;
    }

    public void setBalance(double balance) {
        this.balance = balance;
    }
}
