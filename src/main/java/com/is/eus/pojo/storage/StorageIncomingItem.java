 package com.is.eus.pojo.storage;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.Product;
 import com.is.eus.pojo.basic.StorageLocation;
 import com.is.eus.pojo.schedule.Schedule;
 import java.util.Date;

 public class StorageIncomingItem extends Entity
 {
   private int sicItemNo;
   private Product product;
   private Date productionDate;
   private String jobCmdNo;
   private int amount;
   private Schedule schedule;
   private StorageLocation storageLocation;
   private StorageIncoming sic;

   public int getSicItemNo()
   {
     return this.sicItemNo;
   }
   public void setSicItemNo(int sicItemNo) {
     this.sicItemNo = sicItemNo;
   }
   public Date getProductionDate() {
     return this.productionDate;
   }
   public void setProductionDate(Date productionDate) {
     this.productionDate = productionDate;
   }
   public Product getProduct() {
     return this.product;
   }
   public void setProduct(Product product) {
     this.product = product;
   }
   public String getJobCmdNo() {
     return this.jobCmdNo;
   }
   public void setJobCmdNo(String jobCmdNo) {
     this.jobCmdNo = jobCmdNo;
   }
   public int getAmount() {
     return this.amount;
   }
   public void setAmount(int amount) {
     this.amount = amount;
   }
   public Schedule getSchedule() {
     return this.schedule;
   }
   public void setSchedule(Schedule schedule) {
     this.schedule = schedule;
   }
   public StorageLocation getStorageLocation() {
     return this.storageLocation;
   }
   public void setStorageLocation(StorageLocation storageLocation) {
     this.storageLocation = storageLocation;
   }
   public StorageIncoming getSic() {
     return this.sic;
   }
   public void setSic(StorageIncoming sic) {
     this.sic = sic;
   }
 }

