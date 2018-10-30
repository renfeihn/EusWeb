 package com.is.eus.web.action.management.basic;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.UsageType;
 import com.is.eus.service.basic.ui.UsageTypeService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.web.action.EntityBaseAction;
 import com.is.eus.web.exception.InvalidPageInformationException;
 import java.text.ParseException;

 public class UsageTypeAction extends EntityBaseAction
 {
   private UsageTypeService usageTypeService;

   public void setUsageTypeService(UsageTypeService usageTypeService)
   {
     this.usageTypeService = usageTypeService;
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

   protected Class<UsageType> getEntityClass()
   {
     return UsageType.class;
   }

   protected Class<?> getEntityStateClass()
   {
     return null;
   }
 }

