 package com.is.eus.web.action.management.biz;

 import com.is.eus.model.search.Search;
 import com.is.eus.model.search.SearchResult;
 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.Company;
 import com.is.eus.pojo.basic.Product;
 import com.is.eus.pojo.contract.Contract;
 import com.is.eus.pojo.contract.ContractItem;
 import com.is.eus.pojo.dac.User;
 import com.is.eus.service.EntityService;
 import com.is.eus.service.SearchService;
 import com.is.eus.service.biz.ui.ContractService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.type.ContractState;
 import com.is.eus.util.JsonHelper;
 import com.is.eus.web.action.EntityBaseAction;
 import com.is.eus.web.exception.InvalidPageInformationException;
 import java.io.IOException;
 import java.text.ParseException;
 import java.text.SimpleDateFormat;
 import java.util.Date;
 import java.util.HashSet;
 import java.util.List;
 import java.util.Set;
 import org.apache.commons.lang.xwork.StringUtils;

 public class contractAction extends EntityBaseAction
 {
   private String companyID;
   private String contractDate;
   private String[] contractItemNo;
   private String[] productTypes;
   private String[] productIDs;
   private float[] prices;
   private String[] amounts;
   private float[] subTotals;
   private String[] durations;
   private String[] memoes;
   private ContractService contractService;
   private String companyName;
   private String companyCode;
   private String companyAddress;
   private String companyCommAddress;
   private String companyBank;
   private String companyTax;
   private String companyZipCode;
   private String companyTele;
   private String companyDelegatee;
   private String companyProvince;
   private String companyCity;
   private String contractNo;
   private String contractDateStart;
   private String contractDateEnd;
   private String contractSavedDateStart;
   private String contractSavedDateEnd;
   private String productCombination;
   private String productCode;
   private String errorLevel;
   private String voltage;
   private String capacity;
   private String productType;
   private String humidity;
   private String min;
   private String max;

   public void setMin(String min)
   {
     this.min = min;
   }

   public void setMax(String max) {
     this.max = max;
   }

   public void setContractItemNo(String[] contractItemNo) {
     this.contractItemNo = contractItemNo;
   }

   public void setCompanyName(String companyName) {
     this.companyName = companyName;
   }

   public void setCompanyCode(String companyCode) {
     this.companyCode = companyCode;
   }

   public void setCompanyAddress(String companyAddress) {
     this.companyAddress = companyAddress;
   }

   public void setCompanyCommAddress(String companyCommAddress) {
     this.companyCommAddress = companyCommAddress;
   }

   public void setCompanyBank(String companyBank) {
     this.companyBank = companyBank;
   }

   public void setCompanyTax(String companyTax) {
     this.companyTax = companyTax;
   }

   public void setCompanyZipCode(String companyZipCode) {
     this.companyZipCode = companyZipCode;
   }

   public void setCompanyTele(String companyTele) {
     this.companyTele = companyTele;
   }

   public void setCompanyDelegatee(String companyDelegatee) {
     this.companyDelegatee = companyDelegatee;
   }

   public void setCompanyProvince(String companyProvince) {
     this.companyProvince = companyProvince;
   }

   public void setCompanyCity(String companyCity) {
     this.companyCity = companyCity;
   }

   public void setContractNo(String contractNo) {
     this.contractNo = contractNo;
   }

   public void setContractDateStart(String contractDateStart) {
     this.contractDateStart = contractDateStart;
   }

   public void setContractDateEnd(String contractDateEnd) {
     this.contractDateEnd = contractDateEnd;
   }

   public void setContractSavedDateStart(String contractSavedDateStart) {
     this.contractSavedDateStart = contractSavedDateStart;
   }

   public void setContractSavedDateEnd(String contractSavedDateEnd) {
     this.contractSavedDateEnd = contractSavedDateEnd;
   }

   public String getCompanyID() {
     return this.companyID;
   }

   public void setCompanyID(String companyID) {
     this.companyID = companyID;
   }

   public String getContractDate() {
     return this.contractDate;
   }

   public void setContractDate(String contractDate) {
     this.contractDate = contractDate;
   }

   public String[] getProductTypes() {
     return this.productTypes;
   }

   public void setProductTypes(String[] productTypes) {
     this.productTypes = productTypes;
   }

   public String[] getProductIDs() {
     return this.productIDs;
   }

   public void setProductIDs(String[] productIDs) {
     this.productIDs = productIDs;
   }

   public float[] getPrices() {
     return this.prices;
   }

   public void setPrices(float[] prices) {
     this.prices = prices;
   }

   public String[] getAmounts() {
     return this.amounts;
   }

   public void setAmounts(String[] amounts) {
     this.amounts = amounts;
   }

   public float[] getSubTotals() {
     return this.subTotals;
   }

   public void setSubTotals(float[] subTotals) {
     this.subTotals = subTotals;
   }

   public String[] getDurations() {
     return this.durations;
   }

   public void setDurations(String[] durations) {
     this.durations = durations;
   }

   public String[] getMemoes() {
     return this.memoes;
   }

   public void setMemoes(String[] memoes) {
     this.memoes = memoes;
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

   public void setContractService(ContractService contractService) {
     this.contractService = contractService;
   }

   private Set<ContractItem> getContractItems(Contract contract, boolean isAdd) throws ParseException {
     User user = getUserFromSession();
     Set contractItem = new HashSet();
     int iTotalAmount = 0;
     float fTotalSum = 0.0F;

     for (int i = 0; i < this.productIDs.length; i++) {
       ContractItem item = new ContractItem();
       item.setContractItemNo(Integer.parseInt(this.contractItemNo[i]));
       Product product = (Product)this.entityService.get(Product.class, this.productIDs[i]);
       item.setProduct(product);
       item.setAmount(Integer.parseInt(this.amounts[i]));
       if (StringUtils.isEmpty(this.durations[i])) {
         this.durations[i] = "0";
       }
       item.setDuration(Integer.parseInt(this.durations[i]));
       item.setPrice(this.prices[i]);
       item.setOriginalPrice(product.getPrice());

       item.setSubTotal(Integer.parseInt(this.amounts[i]) * this.prices[i]);
       item.setMemo(this.memoes[i]);

       if (isAdd) {
         item.setCreator(user.getEmployee());
         item.setCreateTime(new Date());
       } else {
         item.setUpdater(user.getEmployee());
         item.setUpdateTime(new Date());
       }

       iTotalAmount += Integer.parseInt(this.amounts[i]);
       fTotalSum += Integer.parseInt(this.amounts[i]) * this.prices[i];

       item.setContract(contract);
       contractItem.add(item);
     }

     contract.setTotalAmount(iTotalAmount);
     contract.setTotalSum(fTotalSum);
     return contractItem;
   }

   protected void fillEntity(Entity entity) throws ParseException
   {
     Contract contract = (Contract)entity;
     Company company = (Company)this.entityService.get(Company.class, this.companyID);
     contract.setCompany(company);
     contract.setContractDate(new SimpleDateFormat("yyyy-MM-dd").parse(this.contractDate));
     contract.setContractNo(this.contractNo);

     Set items = getContractItems(contract, true);
     if (contract.getItems() == null) {
       contract.setItems(items);
     } else {
       contract.getItems().clear();
       contract.getItems().addAll(items);
     }
   }

   public String add()
   {
     User user = getUserFromSession();
     Contract contract = new Contract();
     try {
       check();
       fillEntity(contract);
       contract.setCreator(user.getEmployee());
       contract.setCreateTime(new Date());
       this.contractService.add(contract);
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
     Contract contract = (Contract)this.entityService.get(Contract.class, this.id);
     try {
       this.contractService.udpateByBiz(contract, 4);
       simpleResult(true);
     } catch (InvalidOperationException e) {
       result(false, e.getMessage());
     }
     return "success";
   }

   public String update()
   {
     User user = getUserFromSession();
     Contract contract = (Contract)this.entityService.get(Contract.class, this.id);
     try {
       check();
       fillEntity(contract);
       contract.setUpdater(user.getEmployee());
       contract.setUpdateTime(new Date());
       this.contractService.udpateByBiz(contract, 3);
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
     Contract contract = (Contract)this.entityService.get(Contract.class, this.id);
     User user = getUserFromSession();
     try {
       contract.setUpdater(user.getEmployee());
       contract.setUpdateTime(new Date());
       this.contractService.udpateByBiz(contract, 0);
       simpleResult(true);
     } catch (InvalidOperationException e) {
       result(false, e.getMessage());
     }
     return "success";
   }

   public String terminate()
   {
     Contract contract = (Contract)this.entityService.get(Contract.class, this.id);
     User user = getUserFromSession();
     try {
       contract.setUpdater(user.getEmployee());
       contract.setUpdateTime(new Date());
       this.contractService.udpateByBiz(contract, 5);
       simpleResult(true);
     } catch (InvalidOperationException e) {
       result(false, e.getMessage());
     }
     return "success";
   }

   public String aduitFailed()
   {
     Contract contract = (Contract)this.entityService.get(Contract.class, this.id);
     User user = getUserFromSession();
     try {
       contract.setUpdater(user.getEmployee());
       contract.setUpdateTime(new Date());
       this.contractService.udpateByBiz(contract, 1);
       simpleResult(true);
     } catch (InvalidOperationException e) {
       result(false, e.getMessage());
     }
     return "success";
   }

   public String aduitSuccess()
   {
     Contract contract = (Contract)this.entityService.get(Contract.class, this.id);
     User user = getUserFromSession();
     try {
       contract.setUpdater(user.getEmployee());
       contract.setUpdateTime(new Date());
       this.contractService.udpateByBiz(contract, 2);
       simpleResult(true);
     } catch (InvalidOperationException e) {
       result(false, e.getMessage());
     }
     return "success";
   }

   protected Class<Contract> getEntityClass()
   {
     return Contract.class;
   }

   protected Class<?> getEntityStateClass()
   {
     return ContractState.class;
   }

   public String find()
   {
     this.digDepth = 6;
     return super.find();
   }

   public String get()
   {
     this.digDepth = 6;
     return super.get();
   }

   public String query() throws ParseException
   {
     if (!StringUtils.isEmpty(getHQL()))
       this.HQLCondition = getHQL();
     else {
       this.HQLCondition = "";
     }
     Search search = createSearch(getEntityClass(), getEntityStateClass(), this.search, this.states, this.status, this.start, this.limit, this.HQLCondition, "queryContract");
     SearchResult result = this.searchService.search(search);
     this.resultJson = JsonHelper.fromCollection(result.get(), result.getResultClass(), result.getTotalCount(), 6);
     return "success";
   }

   public String print()
     throws ParseException
   {
     if (!StringUtils.isEmpty(getHQL()))
       this.HQLCondition = getHQL();
     else {
       this.HQLCondition = "";
     }

     Search search = createSearch(getEntityClass(), getEntityStateClass(), this.search, this.states, this.status, 0, 0, this.HQLCondition, "printContract");
     SearchResult result = this.searchService.search(search);
     List items = result.get();
     try {
       this.contractService.printContract(items, 0);
     } catch (IOException e) {
       e.printStackTrace();
       result(false, e.getMessage());
     }
     return null;
   }

   public String queryForSoc() throws ParseException {
     this.digDepth = 6;
     if (!StringUtils.isEmpty(getHQLForSoc()))
       this.HQLCondition = getHQLForSoc();
     else {
       this.HQLCondition = "";
     }

     Search search = createSearch(getEntityClass(), getEntityStateClass(), this.search, this.states, this.status, this.start, 0, this.HQLCondition, "queryCountForSoc");
     SearchResult result = this.searchService.search(search);

     Search search2 = createSearch(getEntityClass(), getEntityStateClass(), this.search, this.states, this.status, this.start, this.limit, this.HQLCondition, "queryForSoc");
     SearchResult result2 = this.searchService.search(search2);

     this.resultJson = JsonHelper.fromCollection(result2.get(), result2.getResultClass(), result.getTotalCount(), 6);

     return "success";
   }

   private String getHQL() throws ParseException
   {
     String strHQL = "";
     StringBuilder strClause = new StringBuilder();
     String strConnection = " and ";

     if (!StringUtils.isEmpty(this.companyName)) {
       strHQL = "co.name like '%" + this.companyName + "%'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.companyCode)) {
       strHQL = "co.code like '%" + this.companyCode + "%'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.contractDateStart)) {
       this.contractDateStart = (this.contractDateStart.substring(0, 10) + " 00:00:00.000");
       strHQL = "c.contractDate >= '" + this.contractDateStart + "'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.contractDateEnd)) {
       this.contractDateEnd = (this.contractDateEnd.substring(0, 10) + " 23:59:59.999");
       strHQL = "c.contractDate <= '" + this.contractDateEnd + "'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.companyProvince)) {
       strHQL = "p.id = '" + this.companyProvince + "'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.companyCity)) {
       strHQL = "ci.id = '" + this.companyCity + "'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.companyAddress)) {
       strHQL = "co.address like '%" + this.companyAddress + "%'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.companyCommAddress)) {
       strHQL = "co.commAddresslike '%" + this.companyCommAddress + "%'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.contractSavedDateStart)) {
       this.contractSavedDateStart = (this.contractSavedDateStart.substring(0, 10) + " 00:00:00.000");
       strHQL = "c.createTime >= '" + this.contractSavedDateStart + "'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.contractSavedDateEnd)) {
       this.contractSavedDateEnd = (this.contractSavedDateEnd.substring(0, 10) + " 23:59:59.999");
       strHQL = "c.createTime <= '" + this.contractSavedDateEnd + "'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.companyBank)) {
       strHQL = "co.bank like '%" + this.companyBank + "%'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.companyTax)) {
       strHQL = "co.tax like '%" + this.companyTax + "%'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.companyZipCode)) {
       strHQL = "co.zipCode like '%" + this.companyZipCode + "%'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.companyTele)) {
       strHQL = "co.tele like '%" + this.companyTele + "%'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.companyDelegatee)) {
       strHQL = "co.delegatee like '%" + this.companyDelegatee + "%'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.contractNo)) {
       strHQL = "c.contractNo like '%" + this.contractNo + "%'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.min)) {
       strHQL = "c.totalSum >=" + this.min + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.max)) {
       strHQL = "c.totalSum <=" + this.max + strConnection;
       strClause.append(strHQL);
     }

     if (strClause.indexOf(strConnection) != -1) {
       strClause.delete(strClause.lastIndexOf(strConnection), strClause.length());
     }

     return strClause.toString();
   }

   private String getHQLForSoc() throws ParseException
   {
     String strHQL = "";
     StringBuilder strClause = new StringBuilder();
     String strConnection = " and ";

     if (!StringUtils.isEmpty(this.companyName)) {
       strHQL = "company.name like '%" + this.companyName + "%'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.contractSavedDateStart)) {
       this.contractSavedDateStart = (this.contractSavedDateStart.substring(0, 10) + " 00:00:00.000");
       strHQL = "c.contractDate >= '" + this.contractSavedDateStart + "'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.contractSavedDateEnd)) {
       this.contractSavedDateEnd = (this.contractSavedDateEnd.substring(0, 10) + " 23:59:59.999");
       strHQL = "c.contractDate <= '" + this.contractSavedDateEnd + "'" + strConnection;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.contractNo)) {
       strHQL = "c.contractNo like '%" + this.contractNo + "%'" + strConnection;
       strClause.append(strHQL);
     }

     boolean isSearchProduct = false;

     if (!StringUtils.isEmpty(this.productCombination)) {
       strHQL = "p.productCombination = '" + this.productCombination + "'" + strConnection;
       isSearchProduct = true;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.productCode)) {
       strHQL = "pc.id = '" + this.productCode + "'" + strConnection;
       isSearchProduct = true;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.productType)) {
       strHQL = "pt.id = '" + this.productType + "'" + strConnection;
       isSearchProduct = true;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.errorLevel)) {
       strHQL = "e.id = '" + this.errorLevel + "'" + strConnection;
       isSearchProduct = true;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.voltage)) {
       strHQL = "p.voltage ='" + this.voltage + "'" + strConnection;
       isSearchProduct = true;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.capacity)) {
       strHQL = "p.capacity ='" + this.capacity + "'" + strConnection;
       isSearchProduct = true;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.productType)) {
       strHQL = "pt.id = '" + this.productType + "'" + strConnection;
       isSearchProduct = true;
       strClause.append(strHQL);
     }

     if (!StringUtils.isEmpty(this.humidity)) {
       strHQL = "h.id = '" + this.humidity + "'" + strConnection;
       isSearchProduct = true;
       strClause.append(strHQL);
     }

     if (isSearchProduct) {
       strHQL = "items.amount <> items.finishedAmount " + strConnection;
       strClause.append(strHQL);
     }

     if (strClause.indexOf(strConnection) != -1) {
       strClause.delete(strClause.lastIndexOf(strConnection), strClause.length());
     }

     return strClause.toString();
   }
 }
