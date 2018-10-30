 package com.is.eus.service.biz.impl;

 import com.is.eus.pojo.storage.InWarehouse;
 import com.is.eus.service.biz.ui.InWarehouseService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.service.support.ObservableServiceBase;

 public class InWarehouseServiceImpl extends ObservableServiceBase
   implements InWarehouseService
 {
   public void add(InWarehouse inWarehouse)
     throws InvalidOperationException
   {
     super.add(inWarehouse);
     fire("Storage_FromInWarehouse", inWarehouse);
   }

   public void addOut(InWarehouse inWarehouse) throws InvalidOperationException
   {
     super.add(inWarehouse);
     fire("Storage_FromOutWarehouse", inWarehouse);
   }
 }

