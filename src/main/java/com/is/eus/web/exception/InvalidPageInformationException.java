 package com.is.eus.web.exception;

 public class InvalidPageInformationException extends Exception
 {
   private static final long serialVersionUID = 1152108119406302564L;

   public InvalidPageInformationException(String message)
   {
     super(message);
   }
   public InvalidPageInformationException(String message, Throwable cause) {
     super(message, cause);
   }
 }


