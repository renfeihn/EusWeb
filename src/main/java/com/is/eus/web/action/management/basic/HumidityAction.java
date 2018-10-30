 package com.is.eus.web.action.management.basic;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.Humidity;
 import com.is.eus.service.basic.ui.HumidityService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.web.action.EntityBaseAction;
 import com.is.eus.web.exception.InvalidPageInformationException;
 import java.text.ParseException;

 public class HumidityAction extends EntityBaseAction
 {
   private HumidityService humidityService;

   public void setHumidityService(HumidityService humidityService)
   {
     this.humidityService = humidityService;
   }

   protected void fillEntity(Entity entity)
     throws ParseException
   {
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

   protected Class<Humidity> getEntityClass()
   {
     return Humidity.class;
   }

   protected Class<?> getEntityStateClass()
   {
     return null;
   }
 }

