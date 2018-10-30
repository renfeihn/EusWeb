 package com.is.eus.web.action.management.biz;

 import com.is.eus.model.search.Search;
 import com.is.eus.model.search.SearchResult;
 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.Product;
 import com.is.eus.pojo.dac.User;
 import com.is.eus.pojo.schedule.Schedule;
 import com.is.eus.service.EntityService;
 import com.is.eus.service.SearchService;
 import com.is.eus.service.biz.ui.ScheduleService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.type.ScheduleState;
 import com.is.eus.type.ScheduleType;
 import com.is.eus.util.JsonHelper;
 import com.is.eus.web.action.EntityBaseAction;
 import com.is.eus.web.exception.InvalidPageInformationException;
 import java.io.File;
 import java.io.FileInputStream;
 import java.io.FileNotFoundException;
 import java.io.IOException;
 import java.io.InputStream;
 import java.io.UnsupportedEncodingException;
 import java.text.ParseException;
 import java.text.SimpleDateFormat;
 import java.util.Date;
 import java.util.List;
 import jxl.write.WriteException;
 import org.apache.commons.lang.xwork.StringUtils;

 public class scheduleAction extends EntityBaseAction
 {
   private String contractNo;
   private String productID;
   private int amount;
   private String memo;
   private String scheduleDate;
   private ScheduleService scheduleService;
   private File downloadFile;
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

   public void setScheduleType(String scheduleType)
   {
     this.scheduleType = scheduleType;
   }

   public void setDownloadFile(File downloadFile) {
     this.downloadFile = downloadFile;
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

   public String getContractID() {
     return this.contractNo;
   }

   public void setContractNo(String contractNo) {
     this.contractNo = contractNo;
   }

   public String getProductID() {
     return this.productID;
   }

   public void setProductID(String productID) {
     this.productID = productID;
   }

   public int getAmount() {
     return this.amount;
   }

   public void setAmount(int amount) {
     this.amount = amount;
   }

   public String getMemo() {
     return this.memo;
   }

   public void setMemo(String memo) {
     this.memo = memo;
   }

   public String getScheduleDate() {
     return this.scheduleDate;
   }

   public void setScheduleDate(String scheduleDate) {
     this.scheduleDate = scheduleDate;
   }

   public void setScheduleService(ScheduleService scheduleService) {
     this.scheduleService = scheduleService;
   }

   protected void fillEntity(Entity entity) throws ParseException
   {
     new SimpleDateFormat("yyyy-MM-dd").parse(this.scheduleDate);
     Schedule schedule = (Schedule)entity;
     schedule.setContractNo(this.contractNo);
     schedule.setAmount(this.amount);
     schedule.setMemo(this.memo);
     schedule.setScheduleDate(new SimpleDateFormat("yyyy-MM-dd").parse(this.scheduleDate));
     schedule.setProduct((Product)this.entityService.get(Product.class, this.productID));
   }

   protected Class<Schedule> getEntityClass()
   {
     return Schedule.class;
   }

   public String add()
   {
     User user = getUserFromSession();
     Schedule schedule = new Schedule();
     try {
       check();
       fillEntity(schedule);
       schedule.setCreator(user.getEmployee());
       schedule.setCreateTime(new Date());
       this.scheduleService.add(schedule);
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
     Schedule schedule = (Schedule)this.entityService.get(Schedule.class, this.id);
     try {
       this.scheduleService.udpateByBiz(schedule, 4);
       simpleResult(true);
     } catch (InvalidOperationException e) {
       result(false, e.getMessage());
     }
     return "success";
   }

   public String update()
   {
     User user = getUserFromSession();
     Schedule schedule = (Schedule)this.entityService.get(Schedule.class, this.id);
     try {
       check();
       fillEntity(schedule);
       schedule.setUpdater(user.getEmployee());
       schedule.setUpdateTime(new Date());
       this.scheduleService.udpateByBiz(schedule, 3);
       simpleResult(true);
     } catch (InvalidPageInformationException e) {
       result(false, e.getMessage());
     } catch (InvalidOperationException e) {
       result(false, e.getMessage());
     } catch (ParseException e) {
       result(false, e.getMessage());
     }
     return "success";
   }

   public String submit()
   {
     Schedule schedule = (Schedule)this.entityService.get(Schedule.class, this.id);
     User user = getUserFromSession();
     try {
       schedule.setUpdater(user.getEmployee());
       schedule.setUpdateTime(new Date());
       this.scheduleService.udpateByBiz(schedule, 0);
       simpleResult(true);
     } catch (InvalidOperationException e) {
       result(false, e.getMessage());
     }
     return "success";
   }

   public String aduitFailed()
   {
     Schedule schedule = (Schedule)this.entityService.get(Schedule.class, this.id);
     User user = getUserFromSession();
     try {
       schedule.setUpdater(user.getEmployee());
       schedule.setUpdateTime(new Date());
       this.scheduleService.udpateByBiz(schedule, 1);
       simpleResult(true);
     } catch (InvalidOperationException e) {
       result(false, e.getMessage());
     }
     return "success";
   }

   public String aduitSuccess()
   {
     Schedule schedule = (Schedule)this.entityService.get(Schedule.class, this.id);
     User user = getUserFromSession();
     try {
       schedule.setUpdater(user.getEmployee());
       schedule.setUpdateTime(new Date());
       this.scheduleService.udpateByBiz(schedule, 2);
       simpleResult(true);
     } catch (InvalidOperationException e) {
       result(false, e.getMessage());
     }
     return "success";
   }

   public String terminate()
   {
     Schedule schedule = (Schedule)this.entityService.get(Schedule.class, this.id);
     User user = getUserFromSession();
     try {
       schedule.setUpdater(user.getEmployee());
       schedule.setUpdateTime(new Date());
       this.scheduleService.udpateByBiz(schedule, 5);
       simpleResult(true);
     } catch (InvalidOperationException e) {
       result(false, e.getMessage());
     }
     return "success";
   }

   protected Class<?> getEntityStateClass()
   {
     return ScheduleState.class;
   }

   public String findProduct() {
     try {
       String[] values = { getProductID() };
       SearchResult result = this.scheduleService.findProduct(values);

       this.resultJson = JsonHelper.fromCollection(result.get(), Schedule.class, result.getTotalCount(), this.digDepth);
     } catch (InvalidOperationException e) {
       result(false, e.getMessage());
     }
     return "success";
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

   public String getReport() {
     try {
       this.downloadFile = this.scheduleService.getReport();
     } catch (WriteException e) {
       result(false, e.getMessage());
     } catch (IOException e) {
       result(false, e.getMessage());
     }
     return "success";
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
       this.scheduleService.print(items, strTitle, strDuration);
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
       strHQL = "scheduleNo like '%" + this.scheduleNo + "'%" + strConnection;
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

     if (strClause.indexOf(strConnection) != -1) {
       strClause.delete(strClause.lastIndexOf(strConnection), strClause.length());
     }

     return strClause.toString();
   }
 }

