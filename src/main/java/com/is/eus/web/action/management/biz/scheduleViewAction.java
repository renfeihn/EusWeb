 package com.is.eus.web.action.management.biz;

 import com.is.eus.model.search.Search;
 import com.is.eus.model.search.SearchResult;
 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.schedule.ScheduleView;
 import com.is.eus.service.SearchService;
 import com.is.eus.service.biz.ui.ScheduleService;
 import com.is.eus.type.ScheduleState;
 import com.is.eus.type.ScheduleType;
 import com.is.eus.util.JsonHelper;
 import com.is.eus.web.action.EntityBaseAction;
 import java.io.IOException;
 import java.text.ParseException;
 import java.text.SimpleDateFormat;
 import java.util.Date;
 import java.util.List;
 import org.apache.commons.lang.xwork.StringUtils;

 public class scheduleViewAction extends EntityBaseAction
 {
   private String memo;
   private ScheduleService scheduleService;
   private String scheduleNo;
   private String productCombination;
   private String scheduleDateStart;
   private String scheduleDateEnd;
   private String productCode;
   private String errorLevel;
   private String voltage;
   private String capacity;
   private String scheduleSavedDateStart;
   private String scheduleSavedDateEnd;
   private String productType;
   private String humidity;
   private String usageType;
   private String scheduleType;
   private String companyName;

   public void setMemo(String memo)
   {
     this.memo = memo;
   }

   public void setScheduleService(ScheduleService scheduleService) {
     this.scheduleService = scheduleService;
   }

   public void setScheduleNo(String scheduleNo) {
     this.scheduleNo = scheduleNo;
   }

   public void setProductCombination(String productCombination) {
     this.productCombination = productCombination;
   }

   public void setScheduleDateStart(String scheduleDateStart) {
     this.scheduleDateStart = scheduleDateStart;
   }

   public void setScheduleDateEnd(String scheduleDateEnd) {
     this.scheduleDateEnd = scheduleDateEnd;
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

   public void setScheduleSavedDateStart(String scheduleSavedDateStart) {
     this.scheduleSavedDateStart = scheduleSavedDateStart;
   }

   public void setScheduleSavedDateEnd(String scheduleSavedDateEnd) {
     this.scheduleSavedDateEnd = scheduleSavedDateEnd;
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

   public void setScheduleType(String scheduleType) {
     this.scheduleType = scheduleType;
   }

   public void setCompanyName(String companyName) {
     this.companyName = companyName;
   }

   protected void fillEntity(Entity entity) throws ParseException
   {
   }

   protected Class<ScheduleView> getEntityClass()
   {
     return ScheduleView.class;
   }

   protected Class<?> getEntityStateClass()
   {
     return ScheduleState.class;
   }

   public String query() throws ParseException
   {
     if (!StringUtils.isEmpty(getHQL()))
       this.HQLCondition = getHQL();
     else {
       this.HQLCondition = "";
     }
     Search search = createSearch(getEntityClass(), getEntityStateClass(), this.search, this.states, this.status, this.start, this.limit, this.HQLCondition, "querySchedule");
     SearchResult result = this.searchService.search(search);
     this.resultJson = JsonHelper.fromCollection(result.get(), result.getResultClass(), result.getTotalCount(), 3);
     return "success";
   }

   public String printQuery()
     throws ParseException
   {
     if (!StringUtils.isEmpty(getHQL()))
       this.HQLCondition = getHQL();
     else {
       this.HQLCondition = "";
     }

     String tempStart = ""; String tempEnd = ""; String strDuration = ""; String strTitle = "销售订货明细规格汇总表"; String strConn = " 至 ";
     if (!StringUtils.isEmpty(this.scheduleSavedDateStart)) {
       tempStart = this.scheduleSavedDateStart.substring(0, 10);
     }

     if (!StringUtils.isEmpty(this.scheduleSavedDateEnd)) {
       tempEnd = this.scheduleSavedDateEnd.substring(0, 10);
     }

     if (tempStart.trim().equalsIgnoreCase("")) {
       tempStart = "截止";
       strConn = "";
     }

     if (tempEnd.trim().equalsIgnoreCase("")) {
       SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
       Date date = new Date();
       tempEnd = format.format(date);
     }

     strDuration = tempStart + strConn + tempEnd;
     if ((this.states != null) &&
       (this.states.length == 2)) {
       strTitle = "销售订货欠交明细表";
     }

     Search search = createSearch(getEntityClass(), getEntityStateClass(), this.search, this.states, this.status, this.start, this.limit, this.HQLCondition, "querySchedule");
     SearchResult result = this.searchService.search(search);
     List items = result.get();
     try {
       this.scheduleService.printView(items, strTitle, strDuration);
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

     if (!StringUtils.isEmpty(this.scheduleNo)) {
       strHQL = "scheduleNo like '%" + this.scheduleNo + "%'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.productCombination)) {
       strHQL = "p.productCombination like '%" + this.productCombination + "%'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.scheduleDateStart)) {
       this.scheduleDateStart = (this.scheduleDateStart.substring(0, 10) + " 00:00:00.000");
       strHQL = "s.scheduleDate >= '" + this.scheduleDateStart + "'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.scheduleDateEnd)) {
       this.scheduleDateEnd = (this.scheduleDateEnd.substring(0, 10) + " 23:59:59.999");
       strHQL = "s.scheduleDate <= '" + this.scheduleDateEnd + "'" + strConnection;
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

     if (!StringUtils.isEmpty(this.scheduleSavedDateStart)) {
       this.scheduleSavedDateStart = (this.scheduleSavedDateStart.substring(0, 10) + " 00:00:00.000");
       strHQL = "s.createTime >= '" + this.scheduleSavedDateStart + "'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.scheduleSavedDateEnd)) {
       this.scheduleSavedDateEnd = (this.scheduleSavedDateEnd.substring(0, 10) + " 23:59:59.999");
       strHQL = "s.createTime <= '" + this.scheduleSavedDateEnd + "'" + strConnection;
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

     if (!StringUtils.isEmpty(this.scheduleType)) {
       int type = 0;
       if (this.scheduleType.equalsIgnoreCase(ScheduleType.ContractType.name().trim())) {
         type = 1;
       }
       strHQL = "s.scheduleType = '" + type + "'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.memo)) {
       strHQL = "contractNo like '%" + this.memo + "%'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.companyName)) {
       strHQL = "c.name like '%" + this.companyName + "%'" + strConnection;
       strClause.append(strHQL);
     }

     if (strClause.indexOf(strConnection) != -1) {
       strClause.delete(strClause.lastIndexOf(strConnection), strClause.length());
     }

     return strClause.toString();
   }
 }

