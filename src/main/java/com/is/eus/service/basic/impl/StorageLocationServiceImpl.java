 package com.is.eus.service.basic.impl;

 import com.is.eus.pojo.basic.StorageLocation;
 import com.is.eus.service.basic.ui.StorageLocationService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.service.support.ObservableServiceBase;
 import com.is.eus.type.DataStatus;

 public class StorageLocationServiceImpl extends ObservableServiceBase
   implements StorageLocationService
 {
   public void add(StorageLocation storageLocation)
     throws InvalidOperationException
   {
     storageLocation.setState(DataStatus.Using.ordinal());
     super.add(storageLocation);
   }

   public void remove(String id) throws InvalidOperationException
   {
     StorageLocation storageLocation = (StorageLocation)super.get(StorageLocation.class, id);
     super.remove(storageLocation);
   }

   public void udpate(StorageLocation storageLocation) throws InvalidOperationException
   {
     if (storageLocation.getState() != DataStatus.Using.ordinal()) {
       throw new InvalidOperationException("修改失败");
     }
     super.update(storageLocation);
   }
 }

