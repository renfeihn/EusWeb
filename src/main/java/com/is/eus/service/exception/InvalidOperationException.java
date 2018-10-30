 package com.is.eus.service.exception;

 public class InvalidOperationException extends RuntimeException
 {
   private static final long serialVersionUID = 2066753085485672345L;

   public InvalidOperationException(String message)
   {
     super(message);
   }

   public InvalidOperationException(String message, Throwable cause) {
     super(message, cause);
   }
 }

