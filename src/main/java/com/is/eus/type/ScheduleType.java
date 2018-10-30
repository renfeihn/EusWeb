 package com.is.eus.type;

 public enum ScheduleType
 {
   SchduleType("预投计划"),
   ContractType("合同计划");

   private String description;

   private ScheduleType(String description) { this.description = description; }

   public String getDescription()
   {
     return this.description;
   }
 }
