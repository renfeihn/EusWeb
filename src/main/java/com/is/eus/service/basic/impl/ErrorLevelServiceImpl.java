 package com.is.eus.service.basic.impl;

 import com.is.eus.pojo.basic.ErrorLevel;
 import com.is.eus.service.basic.ui.ErrorLevelService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.service.support.ObservableServiceBase;
 import com.is.eus.type.DataStatus;

 public class ErrorLevelServiceImpl extends ObservableServiceBase
   implements ErrorLevelService
 {
   public void add(ErrorLevel errorLevel)
     throws InvalidOperationException
   {
     errorLevel.setState(DataStatus.Using.ordinal());
     super.add(errorLevel);
   }

   public void remove(String id) throws InvalidOperationException
   {
     ErrorLevel errorLevel = (ErrorLevel)super.get(ErrorLevel.class, id);
     super.remove(errorLevel);
   }

   public void udpate(ErrorLevel errorLevel) throws InvalidOperationException
   {
     if (errorLevel.getState() != DataStatus.Using.ordinal()) {
       throw new InvalidOperationException("修改失败");
     }
     super.update(errorLevel);
   }
 }
