 package com.is.eus.pojo.basic;

 import com.is.eus.pojo.Entity;

 public class City extends Entity
 {
   private String name;
   private int ord;
   private Province province;
   private String description;

   public String getName()
   {
     return this.name;
   }
   public void setName(String name) {
     this.name = name;
   }
   public int getOrd() {
     return this.ord;
   }
   public void setOrd(int ord) {
     this.ord = ord;
   }
   public Province getProvince() {
     return this.province;
   }
   public void setProvince(Province province) {
     this.province = province;
   }
   public String getDescription() {
     return this.description;
   }
   public void setDescription(String description) {
     this.description = description;
   }
 }


