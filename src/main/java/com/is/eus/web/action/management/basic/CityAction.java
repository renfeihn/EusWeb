 package com.is.eus.web.action.management.basic;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.City;
 import com.is.eus.service.basic.ui.CityService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.web.action.EntityBaseAction;
 import com.is.eus.web.exception.InvalidPageInformationException;
 import java.text.ParseException;

 public class CityAction extends EntityBaseAction
 {
   private CityService cityService;

   public void setCityService(CityService cityService)
   {
     this.cityService = cityService;
   }

   public String add()
   {
     return super.add();
   }

   protected void check()
     throws InvalidOperationException, InvalidPageInformationException
   {
     super.check();
   }

   public String remove()
   {
     return super.remove();
   }

   public String update()
   {
     return super.update();
   }

   protected void fillEntity(Entity entity)
     throws ParseException
   {
   }

   protected Class<City> getEntityClass()
   {
     return City.class;
   }

   protected Class<?> getEntityStateClass()
   {
     return null;
   }

   public String searchInfo()
   {
     StringBuffer sb = new StringBuffer();
     sb.append("province='1'").append(" and ").append("createtime >= '2010-07-01'");
     this.HQLCondition = sb.toString();
     return super.find();
   }
 }

