 package com.is.eus.type;

 public enum StorageOutcomingState
 {
   Checking("待审核"),
   Failed("审核失败"),
   Success("审核成功");

   private String description;

   private StorageOutcomingState(String description) { this.description = description; }

   public String getDescription()
   {
     return this.description;
   }
 }

