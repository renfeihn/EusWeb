 package com.is.eus.service.basic.impl;

 import com.is.eus.model.search.SearchResult;
 import com.is.eus.pojo.basic.Capacitor;
 import com.is.eus.pojo.basic.ErrorLevel;
 import com.is.eus.pojo.basic.Humidity;
 import com.is.eus.pojo.basic.Product;
 import com.is.eus.pojo.basic.ProductCode;
 import com.is.eus.pojo.basic.ProductType;
 import com.is.eus.service.EntityService;
 import com.is.eus.service.SearchService;
 import com.is.eus.service.basic.ui.CapacitorService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.service.support.ObservableServiceBase;
 import com.is.eus.type.DataStatus;
 import java.util.List;
 import org.apache.commons.lang.xwork.StringUtils;

 public class CapacitorServiceImpl extends ObservableServiceBase
   implements CapacitorService
 {
   public String getProductIDByProductCombination(String productCombination)
     throws InvalidOperationException
   {
     String[] values = { productCombination };
     SearchResult sr = this.searchService.search("com.is.eus.pojo.basic.Capacitor.getProductCombinationForAdd", values);
     if (sr.get().size() != 0)
     {
       Capacitor capacitor = (Capacitor)sr.get().get(0);
       Product product = (Product)this.entityService.get(Product.class, capacitor.getId());
       String result = "{'productID':'" + product.getId() + "','productType':'" + product.getProductType().getId() + "'}";
       return result;
     }
     return "";
   }

   public void add(Capacitor capacitor) throws InvalidOperationException
   {
     capacitor.setState(DataStatus.Using.ordinal());
     capacitor.setProductCombination(getProductCombination(capacitor, true));
     capacitor.setProductCombinationPrint(getProductCombination(capacitor, false));
     if (isExistForAdd(capacitor.getProductCombination())) {
       throw new InvalidOperationException("产品已存在");
     }
     super.add(capacitor);
   }

   public void remove(String id) throws InvalidOperationException
   {
     Capacitor capacitor = (Capacitor)super.get(Capacitor.class, id);
     super.remove(capacitor);
   }

   public void udpate(Capacitor capacitor) throws InvalidOperationException
   {
     if (capacitor.getState() != DataStatus.Using.ordinal()) {
       throw new InvalidOperationException("修改失败");
     }
     capacitor.setProductCombination(getProductCombination(capacitor, true));
     capacitor.setProductCombinationPrint(getProductCombination(capacitor, false));

     if (isExistForUpdate(capacitor.getProductCombination(), capacitor.getId())) {
       throw new InvalidOperationException("产品已存在");
     }
     super.update(capacitor);
   }

   private final String getProductCombination(Capacitor capacitor, boolean hasProductCode) {
     String strSplit = "-";
     String strStyle = "";
     if ((hasProductCode) &&
       (capacitor.getProductCode() != null)) {
       strStyle = strStyle + capacitor.getProductCode().getCode().trim();
     }

     if (!StringUtils.isEmpty(capacitor.getProductName())) {
       strStyle = strStyle + capacitor.getProductName().trim() + strSplit;
     }
     if (!StringUtils.isEmpty(capacitor.getVoltage())) {
       strStyle = strStyle + capacitor.getVoltage().trim() + strSplit;
     }

     if (capacitor.getHumidity() != null)
     {
       strStyle = strStyle + capacitor.getHumidity().getCode().trim() + strSplit;
     }

     if (!StringUtils.isEmpty(capacitor.getCapacity())) {
       strStyle = strStyle + capacitor.getCapacity().trim() + strSplit;
     }

     if (capacitor.getErrorLevel() != null) {
       strStyle = strStyle + capacitor.getErrorLevel().getCode().trim() + strSplit;
     }

     strStyle = strStyle.substring(0, strStyle.length() - 1);
     return strStyle.trim();
   }

   private boolean isExistForAdd(String strProductCombination) {
     String[] values = { strProductCombination };
     SearchResult sr = this.searchService.search("com.is.eus.pojo.basic.Capacitor.getProductCombinationForAdd", values);

     return sr.get().size() != 0;
   }

   private boolean isExistForUpdate(String strProductCombination, String id)
   {
     String[] values = { strProductCombination, id };
     SearchResult sr = this.searchService.search("com.is.eus.pojo.basic.Capacitor.getProductCombinationForUpdate", values);

     return sr.get().size() != 0;
   }
 }
