 package com.is.eus.pojo.system;

 import com.is.eus.pojo.Entity;
 import java.util.Date;

 public class Department extends Entity
 {
   private String code;
   private String name;
   private Date startdate;
   private Date enddate;
   private Department parent;
   private Corporation corporation;

   public Department getParent()
   {
     return this.parent;
   }
   public void setParent(Department parent) {
     this.parent = parent;
   }

   public Corporation getCorporation() {
     return this.corporation;
   }
   public void setCorporation(Corporation corporation) {
     this.corporation = corporation;
   }
   public String getCode() {
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
   public Date getStartdate() {
     return this.startdate;
   }
   public void setStartdate(Date startdate) {
     this.startdate = startdate;
   }
   public Date getEnddate() {
     return this.enddate;
   }
   public void setEnddate(Date enddate) {
     this.enddate = enddate;
   }
 }

