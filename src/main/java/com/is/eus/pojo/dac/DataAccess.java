 package com.is.eus.pojo.dac;

 import com.is.eus.pojo.Entity;

 public class DataAccess extends Entity
 {
   private String code;
   private String name;

   public String getCode()
   {
     return this.code;
   }
   public void setCode(String code) {
     this.code = code;
   }
   public String getName() {
     return this.name;
   }
   public void setName(String name) {
     this.name = name;
   }
 }

