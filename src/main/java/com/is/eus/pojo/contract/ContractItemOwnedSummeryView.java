 package com.is.eus.pojo.contract;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.Product;

 public class ContractItemOwnedSummeryView extends Entity
 {
   private Product product;
   private String productCombination;
   private int amount;
   private int finishedAmount;
   private int checkingAmount;
   private int unfinishedAmount;
   private int restAmount;
   private int ownedAmount;

   public Product getProduct()
   {
     return this.product;
   }
   public void setProduct(Product product) {
     this.product = product;
   }
   public String getProductCombination() {
     return this.productCombination;
   }
   public void setProductCombination(String productCombination) {
     this.productCombination = productCombination;
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
   public int getCheckingAmount() {
     return this.checkingAmount;
   }
   public void setCheckingAmount(int checkingAmount) {
     this.checkingAmount = checkingAmount;
   }
   public int getUnfinishedAmount() {
     return this.unfinishedAmount;
   }
   public void setUnfinishedAmount(int unfinishedAmount) {
     this.unfinishedAmount = unfinishedAmount;
   }
   public int getRestAmount() {
     return this.restAmount;
   }
   public void setRestAmount(int restAmount) {
     this.restAmount = restAmount;
   }
   public int getOwnedAmount() {
     return this.ownedAmount;
   }
   public void setOwnedAmount(int ownedAmount) {
     this.ownedAmount = ownedAmount;
   }
 }