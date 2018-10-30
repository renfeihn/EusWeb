 package com.is.eus.web.action.management.basic;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.StorageLocation;
 import com.is.eus.service.basic.ui.StorageLocationService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.web.action.EntityBaseAction;
 import com.is.eus.web.exception.InvalidPageInformationException;
 import java.text.ParseException;

 public class StorageLocationAction extends EntityBaseAction
 {
   private StorageLocationService storageLocationService;

   public void setStorageLocationService(StorageLocationService storageLocationService)
   {
     this.storageLocationService = storageLocationService;
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

   protected Class<StorageLocation> getEntityClass()
   {
     return StorageLocation.class;
   }

   protected Class<?> getEntityStateClass()
   {
     return null;
   }
 }

