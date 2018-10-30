 package com.is.eus.pojo.basic;

 import com.is.eus.pojo.Entity;

 public class P3 extends Entity
 {
   public String id;
   public String zgf;
   public String productCode;
   public String pc;
   public String fzxs;
   public String voltage;
   public String capacity;
   public float price;

   public String getId()
   {
     return this.id;
   }
   public void setId(String id) {
     this.id = id;
   }
   public String getZgf() {
     return this.zgf;
   }
   public void setZgf(String zgf) {
     this.zgf = zgf;
   }
   public String getProductCode() {
     return this.productCode;
   }
   public void setProductCode(String productCode) {
     this.productCode = productCode;
   }
   public String getPc() {
     return this.pc;
   }
   public void setPc(String pc) {
     this.pc = pc;
   }
   public String getFzxs() {
     return this.fzxs;
   }
   public void setFzxs(String fzxs) {
     this.fzxs = fzxs;
   }
   public String getVoltage() {
     return this.voltage;
   }
   public void setVoltage(String voltage) {
     this.voltage = voltage;
   }
   public String getCapacity() {
     return this.capacity;
   }
   public void setCapacity(String capacity) {
     this.capacity = capacity;
   }
   public float getPrice() {
     return this.price;
   }
   public void setPrice(float price) {
     this.price = price;
   }
 }

