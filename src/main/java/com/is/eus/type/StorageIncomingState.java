 package com.is.eus.type;

 public enum StorageIncomingState
 {
   CheckerAduit("待检验审核"),
   CheckerFailed("检验失败"),
   ManagerAduit("待成品库检验"),
   ManagerFaild("成品库检验失败"),
   AduitSuccess("审核成功");

   private String description;

   private StorageIncomingState(String description) { this.description = description; }

   public String getDescription()
   {
     return this.description;
   }
 }


