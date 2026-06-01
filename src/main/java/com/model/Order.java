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

public class Order {
    private int orderId;
    private int customerId;
    
    // Dùng kiểu đối tượng (Integer) thay vì int nguyên thủy để có thể nhận giá trị null từ Database
    private Integer voucherId; 
    private Integer designerId; 
    
    private String orderType; // 'BUY_TEMPLATE' hoặc 'HIRE_DESIGNER'
    private double totalPrice;
    private String status; // 'Pending', 'Completed', 'Cancelled'
    private Timestamp createAt;

    public Order() {
        this.orderType = "BUY_TEMPLATE"; // Mặc định mua từ giỏ hàng
        this.status = "Pending";
    }

    // Getters and Setters
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public Integer getVoucherId() { return voucherId; }
    public void setVoucherId(Integer voucherId) { this.voucherId = voucherId; }

    public Integer getDesignerId() { return designerId; }
    public void setDesignerId(Integer designerId) { this.designerId = designerId; }

    public String getOrderType() { return orderType; }
    public void setOrderType(String orderType) { this.orderType = orderType; }

    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreateAt() { return createAt; }
    public void setCreateAt(Timestamp createAt) { this.createAt = createAt; }
}