 package com.is.eus.pojo.storage;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.Product;
 import com.is.eus.pojo.basic.StorageLocation;
 import java.util.Date;

 public class StorageItemLog extends Entity
 {
   private Product product;
   private StorageLocation storageLocation;
   private int amount;
   private StorageOutcomingItem storageOutcomingItem;
   private StorageIncomingItem storageIncomingItem;
   private Date productionDate;

   public StorageIncomingItem getStorageIncomingItem()
   {
     return this.storageIncomingItem;
   }
   public void setStorageIncomingItem(StorageIncomingItem storageIncomingItem) {
     this.storageIncomingItem = storageIncomingItem;
   }
   public Product getProduct() {
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
   public StorageOutcomingItem getStorageOutcomingItem() {
     return this.storageOutcomingItem;
   }
   public void setStorageOutcomingItem(StorageOutcomingItem storageOutcomingItem) {
     this.storageOutcomingItem = storageOutcomingItem;
   }
   public Date getProductionDate() {
     return this.productionDate;
   }
   public void setProductionDate(Date productionDate) {
     this.productionDate = productionDate;
   }
 }
