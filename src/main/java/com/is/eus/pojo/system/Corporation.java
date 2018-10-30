 package com.is.eus.pojo.system;

 import com.is.eus.pojo.Entity;

 public class Corporation extends Entity
 {
   private String code;
   private String name;
   private String factory;
   private String shortname;
   private String address;
   private String tel;
   private String manager;
   private String mobil;

   public String getShortname()
   {
     return this.shortname;
   }
   public void setShortname(String shortname) {
     this.shortname = shortname;
   }
   public String getCode() {
     return this.code;
   }
   public void setCode(String code) {
     this.code = code;
   }
   public String getFactory() {
     return this.factory;
   }
   public void setFactory(String factory) {
     this.factory = factory;
   }
   public String getName() {
     return this.name;
   }
   public void setName(String name) {
     this.name = name;
   }
   public String getAddress() {
     return this.address;
   }
   public void setAddress(String address) {
     this.address = address;
   }
   public String getTel() {
     return this.tel;
   }
   public void setTel(String tel) {
     this.tel = tel;
   }
   public String getManager() {
     return this.manager;
   }
   public void setManager(String manager) {
     this.manager = manager;
   }
   public String getMobil() {
     return this.mobil;
   }
   public void setMobil(String mobil) {
     this.mobil = mobil;
   }
 }
