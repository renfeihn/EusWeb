 package com.is.eus.web.action.management.basic;

 import com.is.eus.model.search.SearchResult;
 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.Province;
 import com.is.eus.service.basic.ui.ProvinceService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.util.JsonHelper;
 import com.is.eus.web.action.EntityBaseAction;
 import com.is.eus.web.exception.InvalidPageInformationException;
 import java.text.ParseException;

 public class ProvinceAction extends EntityBaseAction
 {
   private ProvinceService provinceService;

   public void setProvinceService(ProvinceService provinceService)
   {
     this.provinceService = provinceService;
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

   protected Class<Province> getEntityClass()
   {
     return Province.class;
   }

   protected Class<?> getEntityStateClass()
   {
     return null;
   }

   public String findDeleted() {
     try {
       Integer[] values = { Integer.valueOf(1) };
       SearchResult result = this.provinceService.findDeleted(values);

       this.resultJson = JsonHelper.fromCollection(result.get(), Province.class, result.getTotalCount(), this.digDepth);
     } catch (InvalidOperationException e) {
       result(false, e.getMessage());
     }
     return "success";
   }

   public String findUsing() {
     try {
       SearchResult result = this.provinceService.findUsing();
       this.resultJson = JsonHelper.fromCollection(result.get(), Province.class, result.getTotalCount(), this.digDepth);
     }
     catch (InvalidOperationException e) {
       e.printStackTrace();
     }
     return "success";
   }
 }

