 package com.is.eus.pojo.system;

 import com.is.eus.pojo.Entity;

 public class Level extends Entity
 {
   private String name;
   private String code;

   public String getName()
   {
     return this.name;
   }
   public void setName(String name) {
     this.name = name;
   }
   public String getCode() {
     return this.code;
   }
   public void setCode(String code) {
     this.code = code;
   }
 }
