 package com.is.eus.pojo.basic;

 public class Capacitor extends Product
 {
   private Humidity humidity;
   private ErrorLevel errorLevel;
   private String voltage;
   private String capacity;
   private String zgf;
   private String xxgf;
   private String fzxs;
   private String wxcc;

   public Humidity getHumidity()
   {
     return this.humidity;
   }
   public void setHumidity(Humidity humidity) {
     this.humidity = humidity;
   }
   public ErrorLevel getErrorLevel() {
     return this.errorLevel;
   }
   public void setErrorLevel(ErrorLevel errorLevel) {
     this.errorLevel = errorLevel;
   }
   public String getVoltage() {
     return this.voltage;
   }
   public void setVoltage(String voltage) {
     this.voltage = voltage;
   }
   public String getCapacity() {
     return this.capacity;
   }
   public void setCapacity(String capacity) {
     this.capacity = capacity;
   }
   public String getZgf() {
     return this.zgf;
   }
   public void setZgf(String zgf) {
     this.zgf = zgf;
   }
   public String getXxgf() {
     return this.xxgf;
   }
   public void setXxgf(String xxgf) {
     this.xxgf = xxgf;
   }
   public String getFzxs() {
     return this.fzxs;
   }
   public void setFzxs(String fzxs) {
     this.fzxs = fzxs;
   }
   public String getWxcc() {
     return this.wxcc;
   }
   public void setWxcc(String wxcc) {
     this.wxcc = wxcc;
   }
 }



