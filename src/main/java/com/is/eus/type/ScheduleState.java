 package com.is.eus.type;

 public enum ScheduleState
 {
   Saved("已保存"),
   WaitForAduilt("待审核"),
   AduitFailed("审核失败"),
   None("未完成"),
   Part("部分完成"),
   Complete("全部完成"),
   Terminated("终止");

   private String description;

   private ScheduleState(String description) { this.description = description; }

   public String getDescription()
   {
     return this.description;
   }
 }


