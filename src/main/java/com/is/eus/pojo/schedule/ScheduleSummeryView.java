 package com.is.eus.pojo.schedule;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.Product;

 public class ScheduleSummeryView extends Entity
 {
   private Product product;
   private int amount;
   private int finishedAmount;
   private int restAmount;

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
   public int getFinishedAmount() {
     return this.finishedAmount;
   }
   public void setFinishedAmount(int finishedAmount) {
     this.finishedAmount = finishedAmount;
   }
   public int getRestAmount() {
     return this.restAmount;
   }
   public void setRestAmount(int restAmount) {
     this.restAmount = restAmount;
   }
 }
