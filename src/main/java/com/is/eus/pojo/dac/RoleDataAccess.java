 package com.is.eus.pojo.dac;

 import com.is.eus.pojo.Entity;

 public class RoleDataAccess extends Entity
 {
   private String code;
   private String name;
   private String category;
   private Role role;

   public String getName()
   {
     return this.name;
   }
   public void setName(String name) {
     this.name = name;
   }
   public String getCategory() {
     return this.category;
   }
   public void setCategory(String category) {
     this.category = category;
   }
   public String getCode() {
     return this.code;
   }
   public void setCode(String code) {
     this.code = code;
   }
   public Role getRole() {
     return this.role;
   }
   public void setRole(Role role) {
     this.role = role;
   }
 }

