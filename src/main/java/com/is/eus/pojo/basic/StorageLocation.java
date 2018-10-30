 package com.is.eus.pojo.basic;

 import com.is.eus.pojo.Entity;

 public class StorageLocation extends Entity
 {
   private String code;
   private String name;
   private String description;

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
   public String getDescription() {
     return this.description;
   }
   public void setDescription(String description) {
     this.description = description;
   }
 }

