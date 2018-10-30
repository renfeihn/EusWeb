 package com.is.eus.pojo.contract;

 import com.is.eus.pojo.Entity;

 public class ContractItemOwnedSummeryViewPrint extends Entity
 {
   private String itemNo;
   private String PC;
   private String productCode;
   private String amount;
   private String finishedAmount;
   private String checkingAmount;
   private String unfinishedAmount;
   private String restAmount;
   private String ownedAmount;

   public String getItemNo()
   {
     return this.itemNo;
   }
   public void setItemNo(String itemNo) {
     this.itemNo = itemNo;
   }
   public String getPC() {
     return this.PC;
   }
   public void setPC(String pC) {
     this.PC = pC;
   }
   public String getProductCode() {
     return this.productCode;
   }
   public void setProductCode(String productCode) {
     this.productCode = productCode;
   }
   public String getAmount() {
     return this.amount;
   }
   public void setAmount(String amount) {
     this.amount = amount;
   }
   public String getFinishedAmount() {
     return this.finishedAmount;
   }
   public void setFinishedAmount(String finishedAmount) {
     this.finishedAmount = finishedAmount;
   }
   public String getCheckingAmount() {
     return this.checkingAmount;
   }
   public void setCheckingAmount(String checkingAmount) {
     this.checkingAmount = checkingAmount;
   }
   public String getUnfinishedAmount() {
     return this.unfinishedAmount;
   }
   public void setUnfinishedAmount(String unfinishedAmount) {
     this.unfinishedAmount = unfinishedAmount;
   }
   public String getRestAmount() {
     return this.restAmount;
   }
   public void setRestAmount(String restAmount) {
     this.restAmount = restAmount;
   }
   public String getOwnedAmount() {
     return this.ownedAmount;
   }
   public void setOwnedAmount(String ownedAmount) {
     this.ownedAmount = ownedAmount;
   }
 }

