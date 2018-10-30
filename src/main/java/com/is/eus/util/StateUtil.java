 package com.is.eus.util;

 import java.util.ArrayList;
 import java.util.List;

 public class StateUtil
 {
   public static Integer[] parse(Class cls, String[] states)
   {
     if (states == null) {
       return null;
     }
     List list = new ArrayList();
     for (String s : states)
       try {
         Enum o = Enum.valueOf(cls, s);
         list.add(Integer.valueOf(o.ordinal()));
       }
       catch (Exception localException) {
       }
     if (list.isEmpty()) {
       return null;
     }

     return (Integer[])list.toArray(new Integer[0]);
   }

   public static Enum parse(Class cls, String value)
   {
     try
     {
       return Enum.valueOf(cls, value); } catch (Exception e) {
     }
     return null;
   }
 }


