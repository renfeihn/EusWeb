 package com.is.eus.pojo.storage;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.contract.Contract;
 import com.is.eus.pojo.system.Employee;
 import java.util.Date;
 import java.util.Set;

 public class StorageOutcoming extends Entity
 {
   private Contract contract;
   private String socNo;
   private Date socDate;
   private String printDate;
   private int totalAmount;
   private float totalSum;
   private float totalSumWithoutTax;
   private float totalTaxAmount;
   private Employee socChecker;
   private Date socChecker_createTime;
   private Set<StorageOutcomingItem> socItems;

   public Contract getContract()
   {
     return this.contract;
   }
   public void setContract(Contract contract) {
     this.contract = contract;
   }
   public String getSocNo() {
     return this.socNo;
   }
   public void setSocNo(String socNo) {
     this.socNo = socNo;
   }
   public Date getSocDate() {
     return this.socDate;
   }
   public void setSocDate(Date socDate) {
     this.socDate = socDate;
   }
   public String getPrintDate() {
     return this.printDate;
   }
   public void setPrintDate(String printDate) {
     this.printDate = printDate;
   }
   public int getTotalAmount() {
     return this.totalAmount;
   }
   public void setTotalAmount(int totalAmount) {
     this.totalAmount = totalAmount;
   }
   public float getTotalSum() {
     return this.totalSum;
   }
   public void setTotalSum(float totalSum) {
     this.totalSum = totalSum;
   }
   public float getTotalSumWithoutTax() {
     return this.totalSumWithoutTax;
   }
   public void setTotalSumWithoutTax(float totalSumWithoutTax) {
     this.totalSumWithoutTax = totalSumWithoutTax;
   }
   public float getTotalTaxAmount() {
     return this.totalTaxAmount;
   }
   public void setTotalTaxAmount(float totalTaxAmount) {
     this.totalTaxAmount = totalTaxAmount;
   }
   public Employee getSocChecker() {
     return this.socChecker;
   }
   public void setSocChecker(Employee socChecker) {
     this.socChecker = socChecker;
   }
   public Date getSocChecker_createTime() {
     return this.socChecker_createTime;
   }
   public void setSocChecker_createTime(Date socCheckerCreateTime) {
     this.socChecker_createTime = socCheckerCreateTime;
   }
   public Set<StorageOutcomingItem> getSocItems() {
     return this.socItems;
   }
   public void setSocItems(Set<StorageOutcomingItem> socItems) {
     this.socItems = socItems;
   }
 }

