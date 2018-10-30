 package com.is.eus.web.action.management.biz;

 import com.is.eus.model.search.Search;
 import com.is.eus.model.search.SearchResult;
 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.Product;
 import com.is.eus.pojo.basic.StorageLocation;
 import com.is.eus.pojo.dac.User;
 import com.is.eus.pojo.storage.InWarehouse;
 import com.is.eus.service.EntityService;
 import com.is.eus.service.SearchService;
 import com.is.eus.service.biz.ui.InWarehouseService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.util.JsonHelper;
 import com.is.eus.web.action.EntityBaseAction;
 import com.is.eus.web.exception.InvalidPageInformationException;
 import java.text.ParseException;
 import java.util.Date;
 import org.apache.commons.lang.xwork.StringUtils;

 public class inWarehouseAction extends EntityBaseAction
 {
   private String productCombination;
   private String productCode;
   private String errorLevel;
   private String voltage;
   private String capacity;
   private String productType;
   private String humidity;
   private String usageType;
   private String SavedDateStart;
   private String SavedDateEnd;
   private String flag;
   private String product;
   private String storageLocation;
   private Date productionDate;
   private int amount;
   private String memo;
   private int[] state;
   private InWarehouseService inWarehouseService;

   public void setProductCombination(String productCombination)
   {
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

   public void setSavedDateStart(String savedDateStart) {
     this.SavedDateStart = savedDateStart;
   }

   public void setSavedDateEnd(String savedDateEnd) {
     this.SavedDateEnd = savedDateEnd;
   }

   public void setFlag(String flag) {
     this.flag = flag;
   }

   public void setProductionDate(Date productionDate) {
     this.productionDate = productionDate;
   }

   public void setProduct(String product) {
     this.product = product;
   }

   public void setStorageLocation(String storageLocation) {
     this.storageLocation = storageLocation;
   }

   public void setAmount(int amount) {
     this.amount = amount;
   }

   public void setMemo(String memo) {
     this.memo = memo;
   }

   public int[] getState() {
     return this.state;
   }

   public void setState(int[] state) {
     this.state = state;
   }

   public void setInWarehouseService(InWarehouseService inWarehouseService)
   {
     this.inWarehouseService = inWarehouseService;
   }

   protected void fillEntity(Entity entity) throws ParseException
   {
     InWarehouse iw = (InWarehouse)entity;
     User user = getUserFromSession();
     Product product = (Product)this.entityService.get(Product.class, this.product);

     StorageLocation storageLocation = null;

     if (this.storageLocation.trim().isEmpty())
       storageLocation = (StorageLocation)this.entityService.get(StorageLocation.class, "66B79F13-6918-4A95-B424-DC0ACCE3E497");
     else {
       storageLocation = (StorageLocation)this.entityService.get(StorageLocation.class, this.storageLocation);
     }

     iw.setProduct(product);
     iw.setStorageLocation(storageLocation);
     iw.setTotalAmount(this.amount);
     iw.setMemo(this.memo);
     iw.setProductionDate(this.productionDate);
     iw.setCreator(user.getEmployee());
     iw.setCreateTime(new Date());
   }

   public String add()
   {
     InWarehouse iw = new InWarehouse();
     try {
       check();
       fillEntity(iw);
       iw.setFlag(0);
       this.inWarehouseService.add(iw);
       simpleResult(true);
     }
     catch (InvalidPageInformationException e) {
       result(false, e.getMessage());
     } catch (InvalidOperationException e) {
       result(false, e.getMessage());
     } catch (ParseException e) {
       result(false, e.getMessage());
     }
     return "success";
   }

   public String addOut()
   {
     InWarehouse iw = new InWarehouse();
     try {
       check();
       fillEntity(iw);
       iw.setFlag(1);
       this.inWarehouseService.addOut(iw);
       simpleResult(true);
     }
     catch (InvalidPageInformationException e) {
       result(false, e.getMessage());
     } catch (InvalidOperationException e) {
       result(false, e.getMessage());
     } catch (ParseException e) {
       result(false, e.getMessage());
     }
     return "success";
   }

   protected Class<InWarehouse> getEntityClass()
   {
     return InWarehouse.class;
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

   public String query() throws ParseException
   {
     if (!StringUtils.isEmpty(getHQL()))
       this.HQLCondition = getHQL();
     else {
       this.HQLCondition = "";
     }
     Search search = createSearch(getEntityClass(), getEntityStateClass(), this.search, this.states, this.status, this.start, this.limit, this.HQLCondition, "query");
     SearchResult result = this.searchService.search(search);
     this.resultJson = JsonHelper.fromCollection(result.get(), result.getResultClass(), result.getTotalCount(), 3);
     return "success";
   }

   private String getHQL() throws ParseException
   {
     String strHQL = "";
     StringBuilder strClause = new StringBuilder();
     String strConnection = " and ";

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

     if (!StringUtils.isEmpty(this.SavedDateStart)) {
       this.SavedDateStart = (this.SavedDateStart.substring(0, 10) + " 00:00:00.000");
       strHQL = "iw.createTime >= '" + this.SavedDateStart + "'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.SavedDateEnd)) {
       this.SavedDateEnd = (this.SavedDateEnd.substring(0, 10) + " 23:59:59.999");
       strHQL = "iw.createTime <= '" + this.SavedDateEnd + "'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.flag)) {
       strHQL = "iw.flag = " + this.flag + strConnection;
       strClause.append(strHQL);
     }

     if (strClause.indexOf(strConnection) != -1) {
       strClause.delete(strClause.lastIndexOf(strConnection), strClause.length());
     }

     return strClause.toString();
   }
 }


