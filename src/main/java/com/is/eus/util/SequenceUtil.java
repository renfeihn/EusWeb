 package com.is.eus.util;

 import com.is.eus.pojo.system.Sequence;
 import java.text.DecimalFormat;
 import java.text.SimpleDateFormat;
 import java.util.Calendar;
 import org.apache.commons.lang.xwork.StringUtils;

 public class SequenceUtil
 {
   private static StringBuilder createHead(String head)
   {
     return null;
   }

   private static StringBuilder createPrefix(String prefix)
   {
     if (!StringUtils.isEmpty(prefix)) {
       return new StringBuilder(prefix);
     }
     return null;
   }

   private static StringBuilder createTail(String tail, int sequence)
   {
     if (tail.equals("3")) {
       DecimalFormat format = new DecimalFormat("000");
       return new StringBuilder(format.format(sequence));
     }if (tail.equals("5")) {
       DecimalFormat format = new DecimalFormat("00000");
       return new StringBuilder(format.format(sequence));
     }
     return null;
   }

   private static StringBuilder createPostfix(String postfix)
   {
     if (!StringUtils.isEmpty(postfix)) {
       return new StringBuilder(postfix);
     }
     return null;
   }

   private static StringBuilder createMiddle(String middle)
   {
     StringBuilder builder = new StringBuilder();
     if (middle.equals("1")) {
       Calendar calendar = Calendar.getInstance();
       builder.append(new SimpleDateFormat("yyyyMMdd").format(calendar.getTime()));
     }
     return builder;
   }

   private static void concat(StringBuilder builder, StringBuilder another)
   {
     if (another != null)
       builder.append(another);
   }

   public static String create(Sequence sequence)
   {
     StringBuilder builder = new StringBuilder();
     StringBuilder sbSplit = new StringBuilder();
     sbSplit.append("-");

     concat(builder, createMiddle(sequence.getMiddle()));
     concat(builder, sbSplit);
     concat(builder, createPrefix(sequence.getPrefix()));
     concat(builder, sbSplit);
     concat(builder, createTail(sequence.getTail(), sequence.getSequence()));

     return builder.toString();
   }

   public static String createFront(Sequence sequence) {
     StringBuilder builder = new StringBuilder();
     StringBuilder sbSplit = new StringBuilder();
     sbSplit.append("-");

     concat(builder, createPrefix(sequence.getPrefix()));
     concat(builder, sbSplit);
     concat(builder, createMiddle(sequence.getMiddle()));
     concat(builder, sbSplit);
     concat(builder, createTail(sequence.getTail(), sequence.getSequence()));

     return builder.toString();
   }
 }

