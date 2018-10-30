 package com.is.eus.service.basic.impl;

 import com.is.eus.pojo.basic.UsageType;
 import com.is.eus.service.basic.ui.UsageTypeService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.service.support.ObservableServiceBase;
 import com.is.eus.type.DataStatus;

 public class UsageTypeServiceImpl extends ObservableServiceBase
   implements UsageTypeService
 {
   public void add(UsageType usageType)
     throws InvalidOperationException
   {
     usageType.setState(DataStatus.Using.ordinal());
     super.add(usageType);
   }

   public void remove(String id) throws InvalidOperationException
   {
     UsageType usageType = (UsageType)super.get(UsageType.class, id);
     super.remove(usageType);
   }

   public void udpate(UsageType usageType) throws InvalidOperationException
   {
     if (usageType.getState() != DataStatus.Using.ordinal()) {
       throw new InvalidOperationException("修改失败");
     }
     super.update(usageType);
   }
 }

