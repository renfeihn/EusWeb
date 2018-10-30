 package com.is.eus.pojo.storage;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.system.Employee;
 import java.util.Date;
 import java.util.Set;

 public class StorageIncoming extends Entity
 {
   private String sicNo;
   private Date sicDate;
   private int totalAmount;
   private Employee sicChecker;
   private Date sicChecker_createTime;
   private Employee sicManager;
   private Date sicManager_createTime;
   private Set<StorageIncomingItem> items;

   public String getSicNo()
   {
     return this.sicNo;
   }
   public void setSicNo(String sicNo) {
     this.sicNo = sicNo;
   }
   public Date getSicDate() {
     return this.sicDate;
   }
   public void setSicDate(Date sicDate) {
     this.sicDate = sicDate;
   }
   public int getTotalAmount() {
     return this.totalAmount;
   }
   public void setTotalAmount(int totalAmount) {
     this.totalAmount = totalAmount;
   }
   public Employee getSicChecker() {
     return this.sicChecker;
   }
   public void setSicChecker(Employee sicChecker) {
     this.sicChecker = sicChecker;
   }
   public Date getSicChecker_createTime() {
     return this.sicChecker_createTime;
   }
   public void setSicChecker_createTime(Date sicCheckerCreateTime) {
     this.sicChecker_createTime = sicCheckerCreateTime;
   }
   public Employee getSicManager() {
     return this.sicManager;
   }
   public void setSicManager(Employee sicManager) {
     this.sicManager = sicManager;
   }
   public Date getSicManager_createTime() {
     return this.sicManager_createTime;
   }
   public void setSicManager_createTime(Date sicManagerCreateTime) {
     this.sicManager_createTime = sicManagerCreateTime;
   }
   public Set<StorageIncomingItem> getItems() {
     return this.items;
   }
   public void setItems(Set<StorageIncomingItem> items) {
     this.items = items;
   }
 }
