 package com.is.eus.service.basic.impl;

 import com.is.eus.pojo.basic.Unit;
 import com.is.eus.service.basic.ui.UnitService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.service.support.ObservableServiceBase;
 import com.is.eus.type.DataStatus;

 public class UnitServiceImpl extends ObservableServiceBase
   implements UnitService
 {
   public void add(Unit unit)
     throws InvalidOperationException
   {
     unit.setState(DataStatus.Using.ordinal());
     super.add(unit);
   }

   public void remove(String id) throws InvalidOperationException
   {
     Unit unit = (Unit)super.get(Unit.class, id);
     super.remove(unit);
   }

   public void udpate(Unit unit) throws InvalidOperationException
   {
     if (unit.getState() != DataStatus.Using.ordinal()) {
       throw new InvalidOperationException("修改失败");
     }
     super.update(unit);
   }
 }
