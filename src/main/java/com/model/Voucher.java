/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.model;

/**
 *
 * @author lehan
 */
public class Voucher {
    private int voucherId;
    private String code;
    private double discountPercent;
    private double maxDiscountAmount;

    public Voucher() {
    }

    public int getVoucherId() { return voucherId; }
    public void setVoucherId(int voucherId) { this.voucherId = voucherId; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public double getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(double discountPercent) { this.discountPercent = discountPercent; }

    public double getMaxDiscountAmount() { return maxDiscountAmount; }
    public void setMaxDiscountAmount(double maxDiscountAmount) { this.maxDiscountAmount = maxDiscountAmount; }
}