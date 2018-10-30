 package com.is.eus.pojo.schedule;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.Product;
 import java.util.Date;

 public class Schedule extends Entity
 {
   private String scheduleNo;
   private String contractNo;
   private Product product;
   private int amount;
   private int finishedAmount;
   private Date scheduleDate;
   private int Q1;
   private int Q2;
   private int Q3;
   private int Q4;
   private String memo;
   private int scheduleType;

   public String getScheduleNo()
   {
     return this.scheduleNo;
   }
   public void setScheduleNo(String scheduleNo) {
     this.scheduleNo = scheduleNo;
   }
   public String getContractNo() {
     return this.contractNo;
   }
   public void setContractNo(String contractNo) {
     this.contractNo = contractNo;
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
   public Date getScheduleDate() {
     return this.scheduleDate;
   }
   public void setScheduleDate(Date scheduleDate) {
     this.scheduleDate = scheduleDate;
   }
   public String getMemo() {
     return this.memo;
   }
   public void setMemo(String memo) {
     this.memo = memo;
   }
   public int getQ1() {
     return this.Q1;
   }
   public void setQ1(int q1) {
     this.Q1 = q1;
   }
   public int getQ2() {
     return this.Q2;
   }
   public void setQ2(int q2) {
     this.Q2 = q2;
   }
   public int getQ3() {
     return this.Q3;
   }
   public void setQ3(int q3) {
     this.Q3 = q3;
   }
   public int getQ4() {
     return this.Q4;
   }
   public void setQ4(int q4) {
     this.Q4 = q4;
   }
   public int getScheduleType() {
     return this.scheduleType;
   }
   public void setScheduleType(int scheduleType) {
     this.scheduleType = scheduleType;
   }
 }