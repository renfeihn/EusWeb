 package com.is.eus.pojo.storage;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.Product;

 public class SCSSummeryView extends Entity
 {
   private Product product;
   private int coAmount;
   private int coFinishedAmount;
   private int coCheckingAmount;
   private int coUnfinishedAmount;
   private int coRestAmount;
   private int coOwnedAmount;
   private int srAmount;
   private int srAdvancedAmount;
   private int srTotalAmount;
   private int srRestAmount;
   private int srVarAmount;
   private int ssAmount;
   private int ssFinishedAmount;
   private int ssRestAmount;
   private int varAmount;

   public Product getProduct()
   {
     return this.product;
   }
   public void setProduct(Product product) {
     this.product = product;
   }
   public int getCoAmount() {
     return this.coAmount;
   }
   public void setCoAmount(int coAmount) {
     this.coAmount = coAmount;
   }
   public int getCoFinishedAmount() {
     return this.coFinishedAmount;
   }
   public void setCoFinishedAmount(int coFinishedAmount) {
     this.coFinishedAmount = coFinishedAmount;
   }
   public int getCoCheckingAmount() {
     return this.coCheckingAmount;
   }
   public void setCoCheckingAmount(int coCheckingAmount) {
     this.coCheckingAmount = coCheckingAmount;
   }
   public int getCoUnfinishedAmount() {
     return this.coUnfinishedAmount;
   }
   public void setCoUnfinishedAmount(int coUnfinishedAmount) {
     this.coUnfinishedAmount = coUnfinishedAmount;
   }
   public int getCoRestAmount() {
     return this.coRestAmount;
   }
   public void setCoRestAmount(int coRestAmount) {
     this.coRestAmount = coRestAmount;
   }
   public int getCoOwnedAmount() {
     return this.coOwnedAmount;
   }
   public void setCoOwnedAmount(int coOwnedAmount) {
     this.coOwnedAmount = coOwnedAmount;
   }
   public int getSrAmount() {
     return this.srAmount;
   }
   public void setSrAmount(int srAmount) {
     this.srAmount = srAmount;
   }
   public int getSrAdvancedAmount() {
     return this.srAdvancedAmount;
   }
   public void setSrAdvancedAmount(int srAdvancedAmount) {
     this.srAdvancedAmount = srAdvancedAmount;
   }
   public int getSrTotalAmount() {
     return this.srTotalAmount;
   }
   public void setSrTotalAmount(int srTotalAmount) {
     this.srTotalAmount = srTotalAmount;
   }
   public int getSrRestAmount() {
     return this.srRestAmount;
   }
   public void setSrRestAmount(int srRestAmount) {
     this.srRestAmount = srRestAmount;
   }
   public int getSrVarAmount() {
     return this.srVarAmount;
   }
   public void setSrVarAmount(int srVarAmount) {
     this.srVarAmount = srVarAmount;
   }
   public int getSsAmount() {
     return this.ssAmount;
   }
   public void setSsAmount(int ssAmount) {
     this.ssAmount = ssAmount;
   }
   public int getSsFinishedAmount() {
     return this.ssFinishedAmount;
   }
   public void setSsFinishedAmount(int ssFinishedAmount) {
     this.ssFinishedAmount = ssFinishedAmount;
   }
   public int getSsRestAmount() {
     return this.ssRestAmount;
   }
   public void setSsRestAmount(int ssRestAmount) {
     this.ssRestAmount = ssRestAmount;
   }
   public int getVarAmount() {
     return this.varAmount;
   }
   public void setVarAmount(int varAmount) {
     this.varAmount = varAmount;
   }
 }