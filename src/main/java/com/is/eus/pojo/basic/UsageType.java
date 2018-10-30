 package com.is.eus.pojo.basic;

 import com.is.eus.pojo.Entity;

 public class UsageType extends Entity
 {
   private String name;
   private String code;
   private String description;

   public String getName()
   {
     return this.name;
   }
   public void setName(String name) {
     this.name = name;
   }
   public String getDescription() {
     return this.description;
   }
   public void setDescription(String description) {
     this.description = description;
   }
   public String getCode() {
     return this.code;
   }
   public void setCode(String code) {
     this.code = code;
   }
 }
