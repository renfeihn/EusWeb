 package com.is.eus.pojo.contract;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.Company;
 import java.util.Date;
 import java.util.Set;

 public class Contract extends Entity
 {
   private String contractNo;
   private Company company;
   private Date contractDate;
   private int totalAmount;
   private int totalFinishedAmount;
   private int totalCheckingAmount;
   private float totalSum;
   private Set<ContractItem> items;

   public String getContractNo()
   {
     return this.contractNo;
   }
   public void setContractNo(String contractNo) {
     this.contractNo = contractNo;
   }
   public Company getCompany() {
     return this.company;
   }
   public void setCompany(Company company) {
     this.company = company;
   }
   public Date getContractDate() {
     return this.contractDate;
   }
   public void setContractDate(Date contractDate) {
     this.contractDate = contractDate;
   }
   public int getTotalAmount() {
     return this.totalAmount;
   }
   public void setTotalAmount(int totalAmount) {
     this.totalAmount = totalAmount;
   }
   public int getTotalFinishedAmount() {
     return this.totalFinishedAmount;
   }
   public void setTotalFinishedAmount(int totalFinishedAmount) {
     this.totalFinishedAmount = totalFinishedAmount;
   }
   public int getTotalCheckingAmount() {
     return this.totalCheckingAmount;
   }
   public void setTotalCheckingAmount(int totalCheckingAmount) {
     this.totalCheckingAmount = totalCheckingAmount;
   }
   public float getTotalSum() {
     return this.totalSum;
   }
   public void setTotalSum(float totalSum) {
     this.totalSum = totalSum;
   }
   public Set<ContractItem> getItems() {
     return this.items;
   }
   public void setItems(Set<ContractItem> items) {
     this.items = items;
   }
   public ContractItem getItem(String id) {
     for (ContractItem item : this.items) {
       if (item.getId().equals(id)) {
         return item;
       }
     }
     return null;
   }
 }
