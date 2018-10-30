 package com.is.eus.pojo.storage;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.Product;
 import com.is.eus.pojo.basic.StorageLocation;
 import java.util.Date;

 public class InWarehouse extends Entity
 {
   private Product product;
   private StorageLocation storageLocation;
   private Date productionDate;
   private int totalAmount;
   private String memo;
   private int flag;

   public Product getProduct()
   {
     return this.product;
   }
   public void setProduct(Product product) {
     this.product = product;
   }
   public StorageLocation getStorageLocation() {
     return this.storageLocation;
   }
   public void setStorageLocation(StorageLocation storageLocation) {
     this.storageLocation = storageLocation;
   }
   public Date getProductionDate() {
     return this.productionDate;
   }
   public void setProductionDate(Date productionDate) {
     this.productionDate = productionDate;
   }
   public int getTotalAmount() {
     return this.totalAmount;
   }
   public void setTotalAmount(int totalAmount) {
     this.totalAmount = totalAmount;
   }
   public String getMemo() {
     return this.memo;
   }
   public void setMemo(String memo) {
     this.memo = memo;
   }
   public int getFlag() {
     return this.flag;
   }
   public void setFlag(int flag) {
     this.flag = flag;
   }
 }
