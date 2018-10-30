 package com.is.eus.pojo.storage;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.Product;

 public class StorageResourceView extends Entity
 {
   private Product product;
   private int amount;
   private int totalAmount;
   private int advancedAmount;
   private int restAmount;
   private int varAmount;

   public Product getProduct()
   {
     return this.product;
   }
   public void setProduct(Product product) {
     this.product = product;
   }
   public int getAmount() {
     return this.amount;
   }
   public void setAmount(int amount) {
     this.amount = amount;
   }
   public int getTotalAmount() {
     return this.totalAmount;
   }
   public void setTotalAmount(int totalAmount) {
     this.totalAmount = totalAmount;
   }
   public int getAdvancedAmount() {
     return this.advancedAmount;
   }
   public void setAdvancedAmount(int advancedAmount) {
     this.advancedAmount = advancedAmount;
   }
   public int getRestAmount() {
     return this.restAmount;
   }
   public void setRestAmount(int restAmount) {
     this.restAmount = restAmount;
   }
   public int getVarAmount() {
     return this.varAmount;
   }
   public void setVarAmount(int varAmount) {
     this.varAmount = varAmount;
   }
 }
