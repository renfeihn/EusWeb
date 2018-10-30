 package com.is.eus.pojo.storage;

 public class StorageOutcomingPrint
 {
   private String PC;
   private String unit;
   private String amount;
   private String price;
   private String priceWithoutTax;
   private String subTotal;
   private String subTotalWithoutTax;
   private String tax;
   private String taxAmount;
   private String memo;

   public String getPC()
   {
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
   public String getPriceWithoutTax() {
     return this.priceWithoutTax;
   }
   public void setPriceWithoutTax(String priceWithoutTax) {
     this.priceWithoutTax = priceWithoutTax;
   }
   public String getSubTotal() {
     return this.subTotal;
   }
   public void setSubTotal(String subTotal) {
     this.subTotal = subTotal;
   }
   public String getSubTotalWithoutTax() {
     return this.subTotalWithoutTax;
   }
   public void setSubTotalWithoutTax(String subTotalWithoutTax) {
     this.subTotalWithoutTax = subTotalWithoutTax;
   }
   public String getTax() {
     return this.tax;
   }
   public void setTax(String tax) {
     this.tax = tax;
   }
   public String getTaxAmount() {
     return this.taxAmount;
   }
   public void setTaxAmount(String taxAmount) {
     this.taxAmount = taxAmount;
   }
   public String getMemo() {
     return this.memo;
   }
   public void setMemo(String memo) {
     this.memo = memo;
   }
 }

