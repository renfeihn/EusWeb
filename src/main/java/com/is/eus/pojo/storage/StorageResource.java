 package com.is.eus.pojo.storage;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.Product;

 public class StorageResource extends Entity
 {
   private Product product;
   private int amount;

   public Product getProduct()
   {
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
 }
