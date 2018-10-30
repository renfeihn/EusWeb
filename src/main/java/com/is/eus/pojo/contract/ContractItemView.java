 package com.is.eus.pojo.contract;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.Product;

 public class ContractItemView extends Entity
 {
   private int contractItemNo;
   private Product product;
   private int amount;
   private int finishedAmount;
   private int checkingAmount;
   private int totalAmount;
   private int advancedAmount;
   private int restAmount;
   private int varAmount;
   private float price;
   private float originalPrice;
   private int duration;
   private String memo;
   private float subTotal;
   private ContractView contract;

   public int getContractItemNo()
   {
     return this.contractItemNo;
   }
   public void setContractItemNo(int contractItemNo) {
     this.contractItemNo = contractItemNo;
   }
   public Product getProduct() {
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
   public int getCheckingAmount() {
     return this.checkingAmount;
   }
   public void setCheckingAmount(int checkingAmount) {
     this.checkingAmount = checkingAmount;
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
   public float getPrice() {
     return this.price;
   }
   public void setPrice(float price) {
     this.price = price;
   }
   public float getOriginalPrice() {
     return this.originalPrice;
   }
   public void setOriginalPrice(float originalPrice) {
     this.originalPrice = originalPrice;
   }
   public int getDuration() {
     return this.duration;
   }
   public void setDuration(int duration) {
     this.duration = duration;
   }
   public String getMemo() {
     return this.memo;
   }
   public void setMemo(String memo) {
     this.memo = memo;
   }
   public float getSubTotal() {
     return this.subTotal;
   }
   public void setSubTotal(float subTotal) {
     this.subTotal = subTotal;
   }
   public ContractView getContract() {
     return this.contract;
   }
   public void setContract(ContractView contract) {
     this.contract = contract;
   }
   public int getVarAmount() {
     return this.varAmount;
   }
   public void setVarAmount(int varAmount) {
     this.varAmount = varAmount;
   }
 }
