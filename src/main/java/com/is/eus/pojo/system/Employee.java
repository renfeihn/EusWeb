 package com.is.eus.pojo.system;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.dac.User;
 import java.util.Date;

 public class Employee extends Entity
 {
   private String code;
   private String name;
   private Position position;
   private String tel;
   private Date birthday;
   private String sex;
   private int status;
   private User user;

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
   public int getStatus() {
     return this.status;
   }
   public void setStatus(int status) {
     this.status = status;
   }
   public User getUser() {
     return this.user;
   }
   public void setUser(User user) {
     this.user = user;
   }
   public Position getPosition() {
     return this.position;
   }
   public void setPosition(Position position) {
     this.position = position;
   }
   public String getTel() {
     return this.tel;
   }
   public void setTel(String tel) {
     this.tel = tel;
   }
   public Date getBirthday() {
     return this.birthday;
   }
   public void setBirthday(Date birthday) {
     this.birthday = birthday;
   }
   public String getSex() {
     return this.sex;
   }
   public void setSex(String sex) {
     this.sex = sex;
   }
 }

