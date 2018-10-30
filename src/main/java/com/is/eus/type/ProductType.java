 package com.is.eus.type;

 public enum ProductType
 {
   Military("军用"),
   Civilian("民用"),
   Etc("其他");

   private String description;

   private ProductType(String description) { this.description = description; }

   public String getDescription()
   {
     return this.description;
   }
 }


