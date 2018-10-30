 package com.is.eus.web.action;

 public abstract class AbstractEntityAction extends AbstractSessionAwareAction
 {
   private static final long serialVersionUID = -1609123816921695970L;
   protected int start = -1;

   protected int limit = -1;
   protected String search;
   protected String[] status;
   protected String[] states;
   protected String state;
   protected int digDepth = 2;
   protected String HQLCondition;
   protected String queryName;
   protected String id;

   public final void setId(String id)
   {
     this.id = id;
   }

   public final void setStart(int start) {
     this.start = start;
   }

   public final void setLimit(int limit) {
     this.limit = limit;
   }

   public final void setSearch(String search) {
     this.search = search;
   }

   public final void setStatus(String[] status) {
     this.status = status;
   }

   public final void setStates(String[] states) {
     this.states = states;
   }

   public final void setState(String state) {
     this.state = state;
   }

   public final void setDigDepth(int dep) {
     this.digDepth = dep;
   }

   public abstract String get();

   public abstract String add();

   public abstract String update();

   public abstract String remove();

   public abstract String find();

   public abstract String list();

   public abstract String change();
 }

