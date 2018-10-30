 package com.is.eus.model.event;

 public class EventNotFoundException extends Exception
 {
   private static final long serialVersionUID = 1938501704045772225L;

   public EventNotFoundException(String message)
   {
     super(message);
   }

   public EventNotFoundException(Throwable cause) {
     super(cause);
   }
 }


