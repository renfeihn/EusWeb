 package com.is.eus.type;

 public enum RoleDataAccessStatus
 {
   Private("个人"),
   Group("团体"),
   All("所有");

   private String description;

   private RoleDataAccessStatus(String description) { this.description = description; }

   public String getDescription() {
     return this.description;
   }
   public static RoleDataAccessStatus parse(int i) {
     for (RoleDataAccessStatus status : values()) {
       if (status.ordinal() == i) {
         return status;
       }
     }
     return All;
   }
 }
