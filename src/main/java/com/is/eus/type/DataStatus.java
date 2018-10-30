 package com.is.eus.type;

 public enum DataStatus
 {
   Using("使用中"),
   Suspended("停止使用"),
   Deleted("已删除");

   private String description;

   private DataStatus(String description) { this.description = description; }

   public String getDescription()
   {
     return this.description;
   }
 }
