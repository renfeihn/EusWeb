 package com.is.eus.pojo.system;

 import com.is.eus.pojo.Entity;

 public class Preference extends Entity
 {
   private String code;
   private String name;
   private String value;

   public String getName()
   {
     return this.name;
   }
   public void setName(String name) {
     this.name = name;
   }
   public String getValue() {
     return this.value;
   }
   public void setValue(String value) {
     this.value = value;
   }
   public String getCode() {
     return this.code;
   }
   public void setCode(String code) {
     this.code = code;
   }
 }

