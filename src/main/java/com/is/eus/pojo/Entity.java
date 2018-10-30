 package com.is.eus.pojo;

 import com.is.eus.pojo.system.Employee;
 import java.util.Date;

 public abstract class Entity
 {
   private String id;
   private Date createTime;
   private Employee creator;
   private Date updateTime;
   private Employee updater;
   private int status;
   private int state;

   public String getId()
   {
     return this.id;
   }
   public void setId(String id) {
     this.id = id;
   }
   public Date getCreateTime() {
     return this.createTime;
   }
   public void setCreateTime(Date createTime) {
     this.createTime = createTime;
   }
   public Employee getCreator() {
     return this.creator;
   }
   public void setCreator(Employee creator) {
     this.creator = creator;
   }
   public Date getUpdateTime() {
     return this.updateTime;
   }
   public void setUpdateTime(Date updateTime) {
     this.updateTime = updateTime;
   }
   public Employee getUpdater() {
     return this.updater;
   }
   public void setUpdater(Employee updater) {
     this.updater = updater;
   }
   public int getStatus() {
     return this.status;
   }
   public void setStatus(int status) {
     this.status = status;
   }
   public int getState() {
     return this.state;
   }
   public void setState(int state) {
     this.state = state;
   }
 }

