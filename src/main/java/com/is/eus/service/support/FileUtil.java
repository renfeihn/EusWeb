 package com.is.eus.service.support;

 public class FileUtil
 {
   public static String tmpdir()
   {
     String property = "java.io.tmpdir";
     return System.getProperty(property);
   }
 }


