 package com.is.eus.dao;

 import org.springframework.dao.DataAccessException;

 public class InitializeException extends DataAccessException
 {
   private static final long serialVersionUID = 4541811039792932569L;

   public InitializeException(String msg)
   {
     super(msg);
   }

   public InitializeException(String msg, Throwable cause) {
     super(msg, cause);
   }
 }



