 package com.is.eus.web.action.management.biz;

 import com.is.eus.model.search.Search;
 import com.is.eus.model.search.SearchResult;
 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.storage.StorageItem;
 import com.is.eus.service.SearchService;
 import com.is.eus.service.biz.ui.StorageItemService;
 import com.is.eus.util.JsonHelper;
 import com.is.eus.web.action.EntityBaseAction;
 import java.io.File;
 import java.io.FileInputStream;
 import java.io.FileNotFoundException;
 import java.io.IOException;
 import java.io.InputStream;
 import java.io.UnsupportedEncodingException;
 import java.text.ParseException;
 import jxl.write.WriteException;
 import org.apache.commons.lang.xwork.StringUtils;

 public class storageItemAction extends EntityBaseAction
 {
   private String warehouseItemSearch;
   private String productCombination;
   private String productCode;
   private String errorLevel;
   private String voltage;
   private String capacity;
   private String productType;
   private String humidity;
   private String usageType;
   private String storageItemDateStart;
   private String storageItemDateEnd;
   private int[] state;
   private StorageItemService storageItemService;
   private File downloadFile;

   public void setWarehouseItemSearch(String warehouseItemSearch)
   {
     this.warehouseItemSearch = warehouseItemSearch;
   }

   public void setProductCombination(String productCombination) {
     this.productCombination = productCombination;
   }

   public void setProductCode(String productCode) {
     this.productCode = productCode;
   }

   public void setErrorLevel(String errorLevel) {
     this.errorLevel = errorLevel;
   }

   public void setVoltage(String voltage) {
     this.voltage = voltage;
   }

   public void setCapacity(String capacity) {
     this.capacity = capacity;
   }

   public void setProductType(String productType) {
     this.productType = productType;
   }

   public void setHumidity(String humidity) {
     this.humidity = humidity;
   }

   public void setUsageType(String usageType) {
     this.usageType = usageType;
   }

   public void setStorageItemDateStart(String storageItemDateStart) {
     this.storageItemDateStart = storageItemDateStart;
   }

   public void setStorageItemDateEnd(String storageItemDateEnd) {
     this.storageItemDateEnd = storageItemDateEnd;
   }

   public void setDownloadFile(File downloadFile) {
     this.downloadFile = downloadFile;
   }

   public int[] getState()
   {
     return this.state;
   }

   public void setState(int[] state) {
     this.state = state;
   }

   public void setStorageItemService(StorageItemService storageItemService) {
     this.storageItemService = storageItemService;
   }

   protected Class<StorageItem> getEntityClass()
   {
     return StorageItem.class;
   }

   protected Class<?> getEntityStateClass()
   {
     return null;
   }

   public String get()
   {
     this.digDepth = 4;
     return super.get();
   }

   public String find()
   {
     this.digDepth = 4;
     return super.find();
   }

   private String getHQL()
   {
     String strHQL = "";
     StringBuilder strClause = new StringBuilder();
     String strConnection = " and ";

     if ((this.warehouseItemSearch == null) || (!this.warehouseItemSearch.equalsIgnoreCase("1"))) {
       return "";
     }

     if (!StringUtils.isEmpty(this.productCombination)) {
       strHQL = "product.productCombination like '%" + this.productCombination + "%'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.productCode)) {
       strHQL = "pc.id = '" + this.productCode + "'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.errorLevel)) {
       strHQL = "e.id = '" + this.errorLevel + "'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.voltage)) {
       strHQL = "product.voltage like '%" + this.voltage + "%'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.capacity)) {
       strHQL = "product.capacity like '%" + this.capacity + "%'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.productType)) {
       strHQL = "pt.id = '" + this.productType + "'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.humidity)) {
       strHQL = "h.id = '" + this.humidity + "'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.usageType)) {
       strHQL = "ut.id = '" + this.usageType + "'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.storageItemDateStart)) {
       this.storageItemDateStart = (this.storageItemDateStart.substring(0, 10) + " 00:00:00.000");
       strHQL = "s.productionDate >= '" + this.storageItemDateStart + "'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.storageItemDateEnd)) {
       this.storageItemDateEnd = (this.storageItemDateEnd.substring(0, 10) + " 23:59:59.999");
       strHQL = "s.productionDate <= '" + this.storageItemDateEnd + "'" + strConnection;
       strClause.append(strHQL);
     }

     if (strClause.indexOf(strConnection) != -1) {
       strClause.delete(strClause.lastIndexOf(strConnection), strClause.length());
     }

     return strClause.toString();
   }

   public String query()
   {
     if (!StringUtils.isEmpty(getHQL()))
       this.HQLCondition = getHQL();
     else {
       this.HQLCondition = "";
     }
     Search search = createSearch(getEntityClass(), getEntityStateClass(), this.search, this.states, this.status, this.start, this.limit, this.HQLCondition, "queryStorageItem");
     SearchResult result = this.searchService.search(search);
     this.resultJson = JsonHelper.fromCollection(result.get(), result.getResultClass(), result.getTotalCount(), 4);
     return "success";
   }

   protected void fillEntity(Entity entity) throws ParseException
   {
   }

   public String getFileName()
   {
     String downFileName = this.downloadFile.getName();
     try {
       downFileName = new String(downFileName.getBytes(), "ISO8859-1");
     } catch (UnsupportedEncodingException e) {
       e.printStackTrace();
     }
     return downFileName;
   }

   public InputStream getInputStream() throws FileNotFoundException {
     return new FileInputStream(this.downloadFile);
   }

   public String print() {
     try {
       this.downloadFile = this.storageItemService.print();
     } catch (WriteException e) {
       result(false, e.getMessage());
     } catch (IOException e) {
       result(false, e.getMessage());
     }
     return "success";
   }
 }

