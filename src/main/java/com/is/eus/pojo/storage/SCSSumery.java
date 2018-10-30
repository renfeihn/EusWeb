 package com.is.eus.pojo.storage;

 import com.is.eus.pojo.Entity;

 public class SCSSumery extends Entity
 {
   int srTotalAmount = 0;
   int srAmount = 0;
   int coCheckingAmount = 0;
   int coUnfinishedAmount = 0;
   int coOwnedAmount = 0;
   int ssRestAmount = 0;
   int varAmount = 0;

   public int getSrTotalAmount() { return this.srTotalAmount; }

   public void setSrTotalAmount(int srTotalAmount) {
     this.srTotalAmount = srTotalAmount;
   }
   public int getSrAmount() {
     return this.srAmount;
   }
   public void setSrAmount(int srAmount) {
     this.srAmount = srAmount;
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
   public int getCoOwnedAmount() {
     return this.coOwnedAmount;
   }
   public void setCoOwnedAmount(int coOwnedAmount) {
     this.coOwnedAmount = coOwnedAmount;
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
