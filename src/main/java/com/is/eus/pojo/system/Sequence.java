 package com.is.eus.pojo.system;

 import com.is.eus.pojo.Entity;
 import java.util.Date;

 public class Sequence extends Entity
 {
   private String type;
   private String head;
   private String prefix;
   private String middle;
   private String postfix;
   private String tail;
   private int sequence;
   private Date lastUpdate;

   public String getHead()
   {
     return this.head;
   }
   public void setHead(String head) {
     this.head = head;
   }
   public String getPrefix() {
     return this.prefix;
   }
   public void setPrefix(String prefix) {
     this.prefix = prefix;
   }
   public String getMiddle() {
     return this.middle;
   }
   public void setMiddle(String middle) {
     this.middle = middle;
   }
   public String getPostfix() {
     return this.postfix;
   }
   public void setPostfix(String postfix) {
     this.postfix = postfix;
   }
   public String getTail() {
     return this.tail;
   }
   public void setTail(String tail) {
     this.tail = tail;
   }
   public String getType() {
     return this.type;
   }
   public void setType(String type) {
     this.type = type;
   }
   public int getSequence() {
     return this.sequence;
   }
   public void setSequence(int sequence) {
     this.sequence = sequence;
   }
   public Date getLastUpdate() {
     return this.lastUpdate;
   }
   public void setLastUpdate(Date lastUpdate) {
     this.lastUpdate = lastUpdate;
   }
 }

