 package com.is.eus.web.action.management.basic;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.system.Corporation;
 import com.is.eus.type.DataStatus;
 import com.is.eus.web.action.EntityBaseAction;
 import com.is.eus.web.exception.InvalidPageInformationException;
 import java.text.ParseException;
 import org.apache.commons.lang.StringUtils;

 public class CorporationAction extends EntityBaseAction
 {
   private static final long serialVersionUID = -6484336480798771723L;
   private String code;
   private String name;
   private String factory;
   private String shortname;
   private String address;
   private String tel;
   private String manager;
   private String mobil;

   protected Class<Corporation> getEntityClass()
   {
     return Corporation.class;
   }

   protected Class<?> getEntityStateClass() {
     return DataStatus.class;
   }

   public void setCode(String code)
   {
     this.code = code;
   }
   public void setName(String name) {
     this.name = name;
   }
   public void setFactory(String factory) {
     this.factory = factory;
   }
   public void setShortname(String shortname) {
     this.shortname = shortname;
   }
   public void setAddress(String address) {
     this.address = address;
   }
   public void setTel(String tel) {
     this.tel = tel;
   }
   public void setManager(String manager) {
     this.manager = manager;
   }
   public void setMobil(String mobil) {
     this.mobil = mobil;
   }

   protected void check() throws InvalidPageInformationException
   {
     if ((StringUtils.isEmpty(this.code)) || (StringUtils.isEmpty(this.name)))
       throw new InvalidPageInformationException("编码和名字为必须填写项目.");
   }

   protected void fillEntity(Entity entity) throws ParseException
   {
     Corporation corporation = (Corporation)entity;
     corporation.setAddress(this.address);
     corporation.setName(this.name);
     corporation.setCode(this.code);
     corporation.setManager(this.manager);
     corporation.setMobil(this.mobil);
     corporation.setTel(this.tel);
     corporation.setShortname(this.shortname);
     corporation.setFactory(this.factory);
   }
 }
