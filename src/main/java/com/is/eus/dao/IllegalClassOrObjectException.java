 package com.is.eus.dao;

 import org.springframework.dao.DataAccessException;

 public class IllegalClassOrObjectException extends DataAccessException
 {
   private static final long serialVersionUID = 8292798272791224744L;

   public IllegalClassOrObjectException(String msg)
   {
     super(msg);
   }

   public IllegalClassOrObjectException(String msg, Throwable cause) {
     super(msg, cause);
   }
 }


