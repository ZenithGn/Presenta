/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.model;

/**
 *
 * @author lehan
 */
public class CartItem {
    private Template template;
    private int quantity;

    public CartItem() {
    }

    public CartItem(Template template, int quantity) {
        this.template = template;
        this.quantity = quantity;
    }

    public Template getTemplate() {
        return template;
    }

    public void setTemplate(Template template) {
        this.template = template;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    // Hàm phụ trợ tính tổng tiền của item này
    public double getItemTotal() {
        return this.template.getPrice() * this.quantity;
    }
}