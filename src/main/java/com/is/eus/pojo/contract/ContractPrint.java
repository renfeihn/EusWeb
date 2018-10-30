 package com.is.eus.pojo.contract;

 import com.is.eus.pojo.Entity;

 public class ContractPrint extends Entity
 {
   private String no;
   private String contractNo;
   private String itemNo;
   private String PC;
   private String unit;
   private String amount;
   private String price;
   private String subTotal;
   private String memo;

   public String getNo()
   {
     return this.no;
   }
   public void setNo(String no) {
     this.no = no;
   }
   public String getContractNo() {
     return this.contractNo;
   }
   public void setContractNo(String contractNo) {
     this.contractNo = contractNo;
   }
   public String getItemNo() {
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
   public String getUnit() {
     return this.unit;
   }
   public void setUnit(String unit) {
     this.unit = unit;
   }
   public String getAmount() {
     return this.amount;
   }
   public void setAmount(String amount) {
     this.amount = amount;
   }
   public String getPrice() {
     return this.price;
   }
   public void setPrice(String price) {
     this.price = price;
   }
   public String getSubTotal() {
     return this.subTotal;
   }
   public void setSubTotal(String subTotal) {
     this.subTotal = subTotal;
   }
   public String getMemo() {
     return this.memo;
   }
   public void setMemo(String memo) {
     this.memo = memo;
   }
 }