 package com.is.eus.web.action.management.basic;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.ErrorLevel;
 import com.is.eus.service.basic.ui.ErrorLevelService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.web.action.EntityBaseAction;
 import com.is.eus.web.exception.InvalidPageInformationException;
 import java.text.ParseException;

 public class ErrorLevelAction extends EntityBaseAction
 {
   private ErrorLevelService errorLevelService;

   public void setErrorLevelService(ErrorLevelService errorLevelService)
   {
     this.errorLevelService = errorLevelService;
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

   protected Class<ErrorLevel> getEntityClass()
   {
     return ErrorLevel.class;
   }

   protected Class<?> getEntityStateClass()
   {
     return null;
   }
 }

