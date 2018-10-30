 package com.is.eus.pojo.storage;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.Product;
 import com.is.eus.pojo.basic.StorageLocation;
 import java.util.Date;

 public class StorageItem extends Entity
 {
   private Product product;
   private StorageLocation storageLocation;
   private int amount;
   private Date productionDate;

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
   public int getAmount() {
     return this.amount;
   }
   public void setAmount(int amount) {
     this.amount = amount;
   }
   public Date getProductionDate() {
     return this.productionDate;
   }
   public void setProductionDate(Date productionDate) {
     this.productionDate = productionDate;
   }
 }