/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.model;

/**
 *
 * @author lehan
 */
public class User {

    private int userId;
    private String username;
    private String password;
    private String email;
    private int roleId; // 1: Admin, 2: Customer, 3: Designer
    private boolean status;
    private String avatarUrl;

    public User() {
    }

    public User(int userId, String username, String password, String email, int roleId, boolean status, String avatarUrl) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.email = email;
        this.roleId = roleId;
        this.status = status;
        this.avatarUrl = avatarUrl;
    }

    
    
    public User(String username, String password, String email, int roleId, boolean status) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.roleId = roleId;
        this.status = status;
    }
    
    public User(int userId, String username, String password, String email, int roleId, boolean status) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.email = email;
        this.roleId = roleId;
        this.status = status;
    }

    // Getters and Setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }
    
    
}

