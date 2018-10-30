 package com.is.eus.service.basic.impl;

 import com.is.eus.pojo.basic.ProductCode;
 import com.is.eus.service.basic.ui.ProductCodeService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.service.support.ObservableServiceBase;
 import com.is.eus.type.DataStatus;

 public class ProductCodeServiceImpl extends ObservableServiceBase
   implements ProductCodeService
 {
   public void add(ProductCode productCode)
     throws InvalidOperationException
   {
     productCode.setState(DataStatus.Using.ordinal());
     super.add(productCode);
   }

   public void remove(String id) throws InvalidOperationException
   {
     ProductCode productCode = (ProductCode)super.get(ProductCode.class, id);
     super.remove(productCode);
   }

   public void udpate(ProductCode productCode) throws InvalidOperationException
   {
     if (productCode.getState() != DataStatus.Using.ordinal()) {
       throw new InvalidOperationException("修改失败");
     }
     super.update(productCode);
   }
 }

