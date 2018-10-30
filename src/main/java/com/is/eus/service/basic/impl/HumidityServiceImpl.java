 package com.is.eus.service.basic.impl;

 import com.is.eus.pojo.basic.Humidity;
 import com.is.eus.service.basic.ui.HumidityService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.service.support.ObservableServiceBase;
 import com.is.eus.type.DataStatus;

 public class HumidityServiceImpl extends ObservableServiceBase
   implements HumidityService
 {
   public void add(Humidity humidity)
     throws InvalidOperationException
   {
     humidity.setState(DataStatus.Using.ordinal());
     super.add(humidity);
   }

   public void remove(String id) throws InvalidOperationException
   {
     Humidity humidity = (Humidity)super.get(Humidity.class, id);
     super.remove(humidity);
   }

   public void udpate(Humidity humidity) throws InvalidOperationException
   {
     if (humidity.getState() != DataStatus.Using.ordinal()) {
       throw new InvalidOperationException("修改失败");
     }
     super.update(humidity);
   }
 }

