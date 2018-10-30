 package com.is.eus.pojo.schedule;

 import com.is.eus.pojo.Entity;

 public class SchedulePrint extends Entity
 {
   private String itemNo;
   private String PC;
   private String amount;
   private String finishedAmount;
   private String unfinishedAmount;
   private String Q1;
   private String Q2;
   private String Q3;
   private String Q4;
   private String memo;

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
   public String getUnfinishedAmount() {
     return this.unfinishedAmount;
   }
   public void setUnfinishedAmount(String unfinishedAmount) {
     this.unfinishedAmount = unfinishedAmount;
   }
   public String getQ1() {
     return this.Q1;
   }
   public void setQ1(String q1) {
     this.Q1 = q1;
   }
   public String getQ2() {
     return this.Q2;
   }
   public void setQ2(String q2) {
     this.Q2 = q2;
   }
   public String getQ3() {
     return this.Q3;
   }
   public void setQ3(String q3) {
     this.Q3 = q3;
   }
   public String getQ4() {
     return this.Q4;
   }
   public void setQ4(String q4) {
     this.Q4 = q4;
   }
   public String getMemo() {
     return this.memo;
   }
   public void setMemo(String memo) {
     this.memo = memo;
   }
 }
