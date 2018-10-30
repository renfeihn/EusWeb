 package com.is.eus.pojo.basic;

 import com.is.eus.pojo.Entity;

 public class VRoec extends Entity
 {
   private String productName;
   private int count;

   public String getProductName()
   {
     return this.productName;
   }
   public void setProductName(String productName) {
     this.productName = productName;
   }
   public int getCount() {
     return this.count;
   }
   public void setCount(int count) {
     this.count = count;
   }
 }