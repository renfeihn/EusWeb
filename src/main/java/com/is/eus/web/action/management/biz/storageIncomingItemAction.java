 package com.is.eus.web.action.management.biz;

 import com.is.eus.model.search.Search;
 import com.is.eus.model.search.SearchResult;
 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.storage.StorageIncomingItem;
 import com.is.eus.service.SearchService;
 import com.is.eus.util.JsonHelper;
 import com.is.eus.web.action.EntityBaseAction;
 import java.text.ParseException;
 import org.apache.commons.lang.xwork.StringUtils;

 public class storageIncomingItemAction extends EntityBaseAction
 {
   private String productCombination;
   private String productCode;
   private String errorLevel;
   private String voltage;
   private String capacity;
   private String productType;
   private String humidity;
   private String usageType;
   private String dateStartForSicItemSearch;
   private String dateEndForSicItemSearch;

   public void setDateStartForSicItemSearch(String dateStartForSicItemSearch)
   {
     this.dateStartForSicItemSearch = dateStartForSicItemSearch;
   }

   public void setDateEndForSicItemSearch(String dateEndForSicItemSearch) {
     this.dateEndForSicItemSearch = dateEndForSicItemSearch;
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

   protected Class<StorageIncomingItem> getEntityClass()
   {
     return StorageIncomingItem.class;
   }

   protected Class<?> getEntityStateClass()
   {
     return null;
   }

   public String find()
   {
     this.digDepth = 5;
     return super.find();
   }

   public String get()
   {
     this.digDepth = 5;
     return super.get();
   }

   public String query() throws ParseException
   {
     if (!StringUtils.isEmpty(getHQL()))
       this.HQLCondition = getHQL();
     else {
       this.HQLCondition = "";
     }
     Search search = createSearch(getEntityClass(), getEntityStateClass(), this.search, this.states, this.status, this.start, this.limit, this.HQLCondition, "queryStorageIncomingItem");
     SearchResult result = this.searchService.search(search);
     this.resultJson = JsonHelper.fromCollection(result.get(), result.getResultClass(), result.getTotalCount(), 5);
     return "success";
   }

   private String getHQL() throws ParseException
   {
     String strHQL = "";
     StringBuilder strClause = new StringBuilder();
     String strConnection = " and ";

     if (!StringUtils.isEmpty(this.productCombination)) {
       strHQL = "p.productCombination like '%" + this.productCombination + "%'" + strConnection;
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
       strHQL = "p.voltage like '%" + this.voltage + "%'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.capacity)) {
       strHQL = "p.capacity like '%" + this.capacity + "%'" + strConnection;
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

     if (!StringUtils.isEmpty(this.dateStartForSicItemSearch)) {
       this.dateStartForSicItemSearch = (this.dateStartForSicItemSearch.substring(0, 10) + " 00:00:00.000");
       strHQL = "s.createTime >= '" + this.dateStartForSicItemSearch + "'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.dateEndForSicItemSearch)) {
       this.dateEndForSicItemSearch = (this.dateEndForSicItemSearch.substring(0, 10) + " 23:59:59.999");
       strHQL = "s.createTime <= '" + this.dateEndForSicItemSearch + "'" + strConnection;
       strClause.append(strHQL);
     }
     if (strClause.indexOf(strConnection) != -1) {
       strClause.delete(strClause.lastIndexOf(strConnection), strClause.length());
     }

     return strClause.toString();
   }

   protected void fillEntity(Entity entity)
     throws ParseException
   {
   }
 }

