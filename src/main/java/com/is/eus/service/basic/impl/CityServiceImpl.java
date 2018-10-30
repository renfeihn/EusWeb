 package com.is.eus.service.basic.impl;

 import com.is.eus.pojo.basic.City;
 import com.is.eus.service.basic.ui.CityService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.service.support.ObservableServiceBase;
 import com.is.eus.type.DataStatus;

 public class CityServiceImpl extends ObservableServiceBase
   implements CityService
 {
   public void add(City City)
     throws InvalidOperationException
   {
     City.setState(DataStatus.Using.ordinal());
     super.add(City);
   }

   public void remove(String id) throws InvalidOperationException
   {
     City usageType = (City)super.get(City.class, id);
     super.remove(usageType);
   }

   public void udpate(City city) throws InvalidOperationException
   {
     if (city.getState() != DataStatus.Using.ordinal()) {
       throw new InvalidOperationException("修改失败");
     }
     super.update(city);
   }
 }

