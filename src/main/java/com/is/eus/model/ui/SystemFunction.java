 package com.is.eus.model.ui;

 import java.util.ArrayList;
 import java.util.Collections;
 import java.util.List;

 public class SystemFunction
 {
   private boolean hasChildren = false;
   private String title;
   private String id;
   private String url;
   private SystemFunction parent;
   List<SystemFunction> children = Collections.synchronizedList(new ArrayList());

   public List<SystemFunction> getChildren() {
     return this.children;
   }

   public SystemFunction getParent() {
     return this.parent;
   }

   public void setParent(SystemFunction parent) {
     this.parent = parent;
   }

   public String getId() {
     return this.id;
   }

   public void setId(String id) {
     this.id = id;
   }

   public String getUrl() {
     return this.url;
   }

   public void setUrl(String url) {
     this.url = url;
   }

   public String getTitle() {
     return this.title;
   }

   public void setTitle(String title) {
     this.title = title;
   }

   public String toString()
   {
     return this.title;
   }

   public void addChild(SystemFunction function)
   {
     this.hasChildren = true;
     function.setParent(this);
     this.children.add(function);
   }

   public boolean hasChildren() {
     return this.hasChildren;
   }

   public SystemFunction next() {
     if (this.parent == null) {
       return null;
     }

     boolean found = false;
     for (SystemFunction f : this.parent.getChildren()) {
       if (found)
         return f;
       if (f.getId().equalsIgnoreCase(this.id)) {
         found = true;
       }
     }

     return null;
   }

   public SystemFunction getChildById(String id) {
     for (SystemFunction function : this.children) {
       if (function.getId().equalsIgnoreCase(id)) {
         return function;
       }
     }

     return null;
   }
 }



