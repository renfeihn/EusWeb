 package com.is.eus.pojo.system;

 import com.is.eus.pojo.Entity;

 public class Position extends Entity
 {
   private String code;
   private String name;
   private Department department;
   private Level level;

   public String getCode()
   {
     return this.code;
   }
   public void setCode(String code) {
     this.code = code;
   }
   public String getName() {
     return this.name;
   }
   public void setName(String name) {
     this.name = name;
   }
   public Department getDepartment() {
     return this.department;
   }
   public void setDepartment(Department department) {
     this.department = department;
   }
   public Level getLevel() {
     return this.level;
   }
   public void setLevel(Level level) {
     this.level = level;
   }
 }

