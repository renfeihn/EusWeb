 package com.is.eus.web.action.management.basic;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.ProductCode;
 import com.is.eus.service.basic.ui.ProductCodeService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.web.action.EntityBaseAction;
 import com.is.eus.web.exception.InvalidPageInformationException;
 import java.text.ParseException;

 public class ProductCodeAction extends EntityBaseAction
 {
   private ProductCodeService productCodeService;

   public void setProductCodeService(ProductCodeService productCodeService)
   {
     this.productCodeService = productCodeService;
   }

   protected void fillEntity(Entity entity)
     throws ParseException
   {
   }

   public String add()
   {
     return super.add();
   }

   public String remove()
   {
     return super.remove();
   }

   public String update()
   {
     return super.update();
   }

   protected void check()
     throws InvalidOperationException, InvalidPageInformationException
   {
     super.check();
   }

   protected Class<ProductCode> getEntityClass()
   {
     return ProductCode.class;
   }

   protected Class<?> getEntityStateClass()
   {
     return null;
   }
 }

