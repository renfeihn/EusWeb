 package com.is.eus.pojo.dac;

 import com.is.eus.pojo.Entity;

 public class RoleFunction extends Entity
 {
   private String name;
   private String functionId;
   private Role role;

   public String getFunctionId()
   {
     return this.functionId;
   }
   public void setFunctionId(String function) {
     this.functionId = function;
   }
   public String getName() {
     return this.name;
   }
   public void setName(String name) {
     this.name = name;
   }
   public Role getRole() {
     return this.role;
   }
   public void setRole(Role role) {
     this.role = role;
   }
 }
