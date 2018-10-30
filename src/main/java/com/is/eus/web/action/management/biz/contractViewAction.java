 package com.is.eus.web.action.management.biz;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.contract.ContractView;
 import com.is.eus.web.action.EntityBaseAction;
 import java.text.ParseException;

 public class contractViewAction extends EntityBaseAction
 {
   protected Class<ContractView> getEntityClass()
   {
     return ContractView.class;
   }

   protected Class<?> getEntityStateClass()
   {
     return null;
   }

   public String find()
   {
     this.digDepth = 6;
     return super.find();
   }

   public String get()
   {
     this.digDepth = 6;
     return super.get();
   }

   protected void fillEntity(Entity entity)
     throws ParseException
   {
   }
 }


