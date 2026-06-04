/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.model;

import java.sql.Timestamp;

/**
 *
 * @author lehan
 */
public class Withdrawal {
    private int withdrawalID;
    private int designerID;
    private double amount;
    private String bankName;
    private String bankAccountNumber;
    private String accountName;
    private String status; // Pending, Approved, Rejected
    private Timestamp createAt;

    // Extra fields for joined queries
    private String designerName;
    private double designerBalance;

    public Withdrawal() {
        this.status = "Pending";
    }

    public int getWithdrawalID() { return withdrawalID; }
    public void setWithdrawalID(int withdrawalID) { this.withdrawalID = withdrawalID; }

    public int getDesignerID() { return designerID; }
    public void setDesignerID(int designerID) { this.designerID = designerID; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public String getBankName() { return bankName; }
    public void setBankName(String bankName) { this.bankName = bankName; }

    public String getBankAccountNumber() { return bankAccountNumber; }
    public void setBankAccountNumber(String bankAccountNumber) { this.bankAccountNumber = bankAccountNumber; }

    public String getAccountName() { return accountName; }
    public void setAccountName(String accountName) { this.accountName = accountName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreateAt() { return createAt; }
    public void setCreateAt(Timestamp createAt) { this.createAt = createAt; }

    public String getDesignerName() { return designerName; }
    public void setDesignerName(String designerName) { this.designerName = designerName; }

    public double getDesignerBalance() { return designerBalance; }
    public void setDesignerBalance(double designerBalance) { this.designerBalance = designerBalance; }
}
