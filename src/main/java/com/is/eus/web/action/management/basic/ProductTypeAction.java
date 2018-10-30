 package com.is.eus.web.action.management.basic;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.ProductType;
 import com.is.eus.service.basic.ui.ProductTypeService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.web.action.EntityBaseAction;
 import com.is.eus.web.exception.InvalidPageInformationException;
 import java.text.ParseException;

 public class ProductTypeAction extends EntityBaseAction
 {
   private ProductTypeService productTypeService;

   public void setProductTypeService(ProductTypeService productTypeService)
   {
     this.productTypeService = productTypeService;
   }

   public String add()
   {
     return super.add();
   }

   protected void check()
     throws InvalidOperationException, InvalidPageInformationException
   {
     super.check();
   }

   public String remove()
   {
     return super.remove();
   }

   public String update()
   {
     return super.update();
   }

   protected void fillEntity(Entity entity)
     throws ParseException
   {
   }

   protected Class<ProductType> getEntityClass()
   {
     return ProductType.class;
   }

   protected Class<?> getEntityStateClass()
   {
     return null;
   }
 }

