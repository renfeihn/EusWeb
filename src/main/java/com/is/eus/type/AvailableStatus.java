 package com.is.eus.type;

 public enum AvailableStatus
 {
   Using("使用中"),
   Suspended("禁用");

   private String description;

   private AvailableStatus(String description) { this.description = description; }

   public String getDescription()
   {
     return this.description;
   }
 }



