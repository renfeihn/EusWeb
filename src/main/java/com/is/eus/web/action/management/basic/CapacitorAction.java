 package com.is.eus.web.action.management.basic;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.Capacitor;
 import com.is.eus.pojo.basic.ErrorLevel;
 import com.is.eus.pojo.basic.Humidity;
 import com.is.eus.pojo.basic.ProductCode;
 import com.is.eus.pojo.basic.ProductType;
 import com.is.eus.pojo.basic.Unit;
 import com.is.eus.pojo.basic.UsageType;
 import com.is.eus.pojo.dac.User;
 import com.is.eus.service.EntityService;
 import com.is.eus.service.basic.ui.CapacitorService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.type.DataStatus;
 import com.is.eus.web.action.EntityBaseAction;
 import com.is.eus.web.exception.InvalidPageInformationException;
 import java.text.ParseException;
 import java.util.Date;
 import org.apache.commons.lang.xwork.StringUtils;

 public class CapacitorAction extends EntityBaseAction
 {
   private String productCode;
   private String productType;
   private String humidity;
   private String errorLevel;
   private String unit;
   private String usageType;
   private String productName;
   private String voltage;
   private String capacity;
   private float price;
   private String standard;
   private String protocol;
   private String project;
   private String memo;
   private String productCombination;
   private CapacitorService capacitorService;

   public void setProductCode(String productCode)
   {
     this.productCode = productCode;
   }

   public void setProductType(String productType) {
     this.productType = productType;
   }
   public void setHumidity(String humidity) {
     this.humidity = humidity;
   }

   public void setErrorLevel(String errorLevel) {
     this.errorLevel = errorLevel;
   }

   public void setUnit(String unit) {
     this.unit = unit;
   }

   public void setUsageType(String usageType) {
     this.usageType = usageType;
   }

   public void setProductName(String productName) {
     this.productName = productName;
   }

   public void setVoltage(String voltage) {
     this.voltage = voltage;
   }

   public void setCapacity(String capacity) {
     this.capacity = capacity;
   }

   public void setPrice(float price) {
     this.price = price;
   }

   public void setStandard(String standard) {
     this.standard = standard;
   }

   public void setProtocol(String protocol) {
     this.protocol = protocol;
   }

   public void setProject(String project) {
     this.project = project;
   }

   public void setMemo(String memo) {
     this.memo = memo;
   }

   public void setProductCombination(String productCombination) {
     this.productCombination = productCombination;
   }

   public void setCapacitorService(CapacitorService capacitorService) {
     this.capacitorService = capacitorService;
   }

   public String add()
   {
     User user = getUserFromSession();
     Capacitor capacitor = new Capacitor();
     try {
       check();
       fillEntity(capacitor);
       capacitor.setCreator(user.getEmployee());
       capacitor.setCreateTime(new Date());
       this.capacitorService.add(capacitor);
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

   protected void check()
     throws InvalidOperationException, InvalidPageInformationException
   {
     super.check();
   }

   public String remove()
   {
     try {
       Capacitor capacitor = (Capacitor)this.entityService.get(Capacitor.class, this.id);
       capacitor.setStatus(DataStatus.Deleted.ordinal());
       this.capacitorService.udpate(capacitor);
       simpleResult(true);
     } catch (InvalidOperationException e) {
       result(false, e.getMessage());
     }
     return "success";
   }

   public String update()
   {
     Capacitor capacitor = (Capacitor)this.entityService.get(Capacitor.class, this.id);
     User user = getUserFromSession();
     try {
       check();
       fillEntity(capacitor);
       capacitor.setUpdater(user.getEmployee());
       capacitor.setUpdateTime(new Date());
       this.capacitorService.udpate(capacitor);
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

   protected void fillEntity(Entity entity) throws ParseException
   {
     Capacitor capacitor = (Capacitor)entity;
     ProductCode productCode = null;
     if (!StringUtils.isEmpty(this.productCode)) {
       productCode = (ProductCode)this.entityService.get(ProductCode.class, this.productCode);
     }

     ProductType productType = (ProductType)this.entityService.get(ProductType.class, this.productType);

     Humidity humidity = null;
     ErrorLevel errorLevel = null;

     if (!StringUtils.isEmpty(this.humidity)) {
       humidity = (Humidity)this.entityService.get(Humidity.class, this.humidity);
     }

     if (!StringUtils.isEmpty(this.errorLevel)) {
       errorLevel = (ErrorLevel)this.entityService.get(ErrorLevel.class, this.errorLevel);
     }

     Unit unit = (Unit)this.entityService.get(Unit.class, this.unit);
     UsageType usageType = (UsageType)this.entityService.get(UsageType.class, this.usageType);

     capacitor.setProductCode(productCode);
     capacitor.setProductType(productType);
     capacitor.setHumidity(humidity);
     capacitor.setErrorLevel(errorLevel);
     capacitor.setUnit(unit);
     capacitor.setUsageType(usageType);
     capacitor.setProductName(this.productName);
     capacitor.setMemo(this.memo);
     capacitor.setPrice(this.price);
     capacitor.setProject(this.project);
     capacitor.setProtocol(this.protocol);
     capacitor.setStandard(this.standard);
     capacitor.setCapacity(this.capacity);
     capacitor.setVoltage(this.voltage);
   }

   protected Class<Capacitor> getEntityClass()
   {
     return Capacitor.class;
   }

   protected Class<?> getEntityStateClass()
   {
     return null;
   }

   public String find()
   {
     if (!StringUtils.isEmpty(getHQL()))
       this.HQLCondition = getHQL();
     else {
       this.HQLCondition = "";
     }
     return super.find();
   }

   public String getProductID() {
     try {
       String productInfo = this.capacitorService.getProductIDByProductCombination(this.productCombination);
       if (StringUtils.isEmpty(productInfo)) {
         result(false, "");
       }
       else {
         StringBuilder builder = new StringBuilder();
         boolean success = true;
         builder.append("{success:").append(success ? "true" : "false").append(", msg:").append(productInfo).append("}");
         this.resultJson = builder.toString();
       }
     }
     catch (InvalidOperationException e) {
       result(false, e.getMessage());
     }
     return "success";
   }

   private String getHQL()
   {
     String strHQL = "";
     StringBuilder strClause = new StringBuilder();
     String strConnection = " and ";
     if (!StringUtils.isEmpty(this.productCode)) {
       strHQL = "cap.productCode.id='" + this.productCode + "'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.unit)) {
       strHQL = "cap.unit.id='" + this.unit + "'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.usageType)) {
       strHQL = "cap.usageType.id='" + this.usageType + "'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.productType)) {
       strHQL = "cap.productType.id='" + this.productType + "'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.humidity)) {
       strHQL = "cap.humidity.id='" + this.humidity + "'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.errorLevel)) {
       strHQL = "cap.errorLevel.id='" + this.errorLevel + "'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.productName)) {
       strHQL = "cap.productName like '%" + this.productName + "%'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.voltage)) {
       strHQL = "cap.voltage like '%" + this.voltage + "%'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.capacity)) {
       strHQL = "cap.capacity like '%" + this.capacity + "%'" + strConnection;
       strClause.append(strHQL);
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.standard)) {
       strHQL = "cap.standard like '%" + this.standard + "%'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.protocol)) {
       strHQL = "cap.protocol like '%" + this.protocol + "%'" + strConnection;
       strClause.append(strHQL);
     }

     if (strClause.indexOf(strConnection) != -1) {
       strClause.delete(strClause.lastIndexOf(strConnection), strClause.length());
     }
     if (this.price > 0.0F) {
       strHQL = "cap.price =" + this.price + strConnection;
       strClause.append(strHQL);
     }
     return strClause.toString();
   }
 }

