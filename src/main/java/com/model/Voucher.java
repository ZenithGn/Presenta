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
    private int usageLimit;
    private int usedCount;
    private java.sql.Timestamp validFrom;
    private java.sql.Timestamp validTo;
    private boolean status;

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

    public int getUsageLimit() { return usageLimit; }
    public void setUsageLimit(int usageLimit) { this.usageLimit = usageLimit; }

    public int getUsedCount() { return usedCount; }
    public void setUsedCount(int usedCount) { this.usedCount = usedCount; }

    public java.sql.Timestamp getValidFrom() { return validFrom; }
    public void setValidFrom(java.sql.Timestamp validFrom) { this.validFrom = validFrom; }

    public java.sql.Timestamp getValidTo() { return validTo; }
    public void setValidTo(java.sql.Timestamp validTo) { this.validTo = validTo; }

    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }
}