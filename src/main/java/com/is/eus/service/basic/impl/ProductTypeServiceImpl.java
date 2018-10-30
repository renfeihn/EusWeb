 package com.is.eus.service.basic.impl;

 import com.is.eus.pojo.basic.ProductType;
 import com.is.eus.service.basic.ui.ProductTypeService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.service.support.ObservableServiceBase;
 import com.is.eus.type.DataStatus;

 public class ProductTypeServiceImpl extends ObservableServiceBase
   implements ProductTypeService
 {
   public void add(ProductType productType)
     throws InvalidOperationException
   {
     productType.setState(DataStatus.Using.ordinal());
     super.add(productType);
   }

   public void remove(String id) throws InvalidOperationException
   {
     ProductType productType = (ProductType)super.get(ProductType.class, id);
     super.remove(productType);
   }

   public void udpate(ProductType productType) throws InvalidOperationException
   {
     if (productType.getState() != DataStatus.Using.ordinal()) {
       throw new InvalidOperationException("修改失败");
     }
     super.update(productType);
   }
 }

