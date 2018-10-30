 package com.is.eus.type;

 public enum UserStatus
 {
   Enabled("启用中"),
   Disabled("禁用中"),
   Removed("已删除");

   private String description;

   private UserStatus(String description) { this.description = description; }

   public String getDescription()
   {
     return this.description;
   }
 }

