 package com.is.eus.web.action.management.biz;

 import com.is.eus.model.search.Search;
 import com.is.eus.model.search.SearchResult;
 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.schedule.ScheduleSummeryView;
 import com.is.eus.service.SearchService;
 import com.is.eus.service.biz.ui.ScheduleService;
 import com.is.eus.util.JsonHelper;
 import com.is.eus.web.action.EntityBaseAction;
 import java.io.IOException;
 import java.text.ParseException;
 import java.text.SimpleDateFormat;
 import java.util.Date;
 import java.util.List;
 import org.apache.commons.lang.xwork.StringUtils;

 public class scheduleSummeryViewAction extends EntityBaseAction
 {
   private ScheduleService scheduleService;
   private String productCombination;
   private String productCode;
   private String errorLevel;
   private String voltage;
   private String capacity;
   private String productType;
   private String humidity;
   private String usageType;

   public void setScheduleService(ScheduleService scheduleService)
   {
     this.scheduleService = scheduleService;
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

   protected void fillEntity(Entity entity) throws ParseException
   {
   }

   protected Class<ScheduleSummeryView> getEntityClass()
   {
     return ScheduleSummeryView.class;
   }

   protected Class<?> getEntityStateClass()
   {
     return null;
   }

   public String query() throws ParseException {
     if (!StringUtils.isEmpty(getHQL()))
       this.HQLCondition = getHQL();
     else {
       this.HQLCondition = "";
     }
     Search search = createSearch(getEntityClass(), getEntityStateClass(), this.search, this.states, this.status, this.start, this.limit, this.HQLCondition, "queryScheduleSummeryView");
     SearchResult result = this.searchService.search(search);
     this.resultJson = JsonHelper.fromCollection(result.get(), result.getResultClass(), result.getTotalCount(), 3);
     return "success";
   }

   public String printQuery() throws ParseException
   {
     if (!StringUtils.isEmpty(getHQL()))
       this.HQLCondition = getHQL();
     else {
       this.HQLCondition = "";
     }

     String tempStart = ""; String tempEnd = ""; String strDuration = ""; String strTitle = "销售订货欠交汇总表"; String strConn = " 至 ";
     if (tempStart.trim().equalsIgnoreCase("")) {
       tempStart = "截止";
       strConn = "";
     }

     if (tempEnd.trim().equalsIgnoreCase("")) {
       SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
       Date date = new Date();
       tempEnd = format.format(date);
     }

     Search search = createSearch(getEntityClass(), getEntityStateClass(), this.search, this.states, this.status, this.start, this.limit, this.HQLCondition, "queryScheduleSummeryView");
     SearchResult result = this.searchService.search(search);
     List items = result.get();
     try {
       this.scheduleService.printSummeryView(items, strTitle, strDuration);
     } catch (IOException e) {
       result(false, e.getMessage());
     }
     return null;
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

     if (strClause.indexOf(strConnection) != -1) {
       strClause.delete(strClause.lastIndexOf(strConnection), strClause.length());
     }

     return strClause.toString();
   }
 }

