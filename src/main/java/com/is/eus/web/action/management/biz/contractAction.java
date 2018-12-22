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
import com.is.eus.service.basic.ui.CompanyService;
import com.is.eus.service.biz.ui.ContractService;
import com.is.eus.service.exception.InvalidOperationException;
import com.is.eus.service.support.FileUtil;
import com.is.eus.type.ContractState;
import com.is.eus.util.BusiUtil;
import com.is.eus.util.DateUtil;
import com.is.eus.util.JsonHelper;
import com.is.eus.web.action.EntityBaseAction;
import com.is.eus.web.exception.InvalidPageInformationException;

import java.io.*;
import java.net.URLDecoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.PageOrientation;
import jxl.format.PaperSize;
import jxl.format.VerticalAlignment;
import jxl.write.*;
import org.apache.commons.lang.xwork.StringUtils;

public class contractAction extends EntityBaseAction {
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
    private File downloadFile;

    public File getDownloadFile() {
        return downloadFile;
    }

    public void setDownloadFile(File downloadFile) {
        this.downloadFile = downloadFile;
    }

    public void setMin(String min) {
        this.min = min;
    }

    public void setMax(String max) {
        this.max = max;
    }

    public void setContractItemNo(String[] contractItemNo) {
        this.contractItemNo = contractItemNo;
    }

    public void setCompanyName(String companyName) {
        this.companyName = BusiUtil.decode(companyName);
    }

    public void setCompanyCode(String companyCode) {
        this.companyCode = BusiUtil.decode(companyCode);
    }

    public void setCompanyAddress(String companyAddress) {
        this.companyAddress = BusiUtil.decode(companyAddress);
    }

    public void setCompanyCommAddress(String companyCommAddress) {
        this.companyCommAddress = BusiUtil.decode(companyCommAddress);
    }

    public void setCompanyBank(String companyBank) {
        this.companyBank = BusiUtil.decode(companyBank);
    }

    public void setCompanyTax(String companyTax) {
        this.companyTax = BusiUtil.decode(companyTax);
    }

    public void setCompanyZipCode(String companyZipCode) {
        this.companyZipCode = BusiUtil.decode(companyZipCode);
    }

    public void setCompanyTele(String companyTele) {
        this.companyTele = BusiUtil.decode(companyTele);
    }

    public void setCompanyDelegatee(String companyDelegatee) {
        this.companyDelegatee = BusiUtil.decode(companyDelegatee);
    }

    public void setCompanyProvince(String companyProvince) {
        this.companyProvince = BusiUtil.decode(companyProvince);
    }

    public void setCompanyCity(String companyCity) {
        this.companyCity = BusiUtil.decode(companyCity);
    }

    public void setContractNo(String contractNo) {
        this.contractNo = BusiUtil.decode(contractNo);
    }

    public void setContractDateStart(String contractDateStart) {
        this.contractDateStart = BusiUtil.decode(contractDateStart);
    }

    public void setContractDateEnd(String contractDateEnd) {
        this.contractDateEnd = BusiUtil.decode(contractDateEnd);
    }

    public void setContractSavedDateStart(String contractSavedDateStart) {
        this.contractSavedDateStart = BusiUtil.decode(contractSavedDateStart);
    }

    public void setContractSavedDateEnd(String contractSavedDateEnd) {
        this.contractSavedDateEnd = BusiUtil.decode(contractSavedDateEnd);
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
            Product product = (Product) this.entityService.get(Product.class, this.productIDs[i]);
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

    protected void fillEntity(Entity entity) throws ParseException {
        Contract contract = (Contract) entity;
        Company company = (Company) this.entityService.get(Company.class, this.companyID);
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

    public String add() {
        User user = getUserFromSession();
        Contract contract = new Contract();
        try {
            check();
            fillEntity(contract);
            contract.setCreator(user.getEmployee());
            contract.setCreateTime(new Date());
            this.contractService.add(contract);
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

    protected void check()
            throws InvalidOperationException, InvalidPageInformationException {
        super.check();
    }

    public String remove() {
        Contract contract = (Contract) this.entityService.get(Contract.class, this.id);
        try {
            this.contractService.udpateByBiz(contract, 4);
            simpleResult(true);
        } catch (InvalidOperationException e) {
            result(false, e.getMessage());
        }
        return "success";
    }

    public String update() {
        User user = getUserFromSession();
        Contract contract = (Contract) this.entityService.get(Contract.class, this.id);
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

    public String submit() {
        Contract contract = (Contract) this.entityService.get(Contract.class, this.id);
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

    public String terminate() {
        Contract contract = (Contract) this.entityService.get(Contract.class, this.id);
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

    public String aduitFailed() {
        Contract contract = (Contract) this.entityService.get(Contract.class, this.id);
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

    public String aduitSuccess() {
        Contract contract = (Contract) this.entityService.get(Contract.class, this.id);
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

    protected Class<Contract> getEntityClass() {
        return Contract.class;
    }

    protected Class<?> getEntityStateClass() {
        return ContractState.class;
    }

    public String find() {
        this.digDepth = 6;
        return super.find();
    }

    public String get() {
        this.digDepth = 6;
        return super.get();
    }

    public String query() throws ParseException {
        if (!StringUtils.isEmpty(getHQL()))
            this.HQLCondition = getHQL();
        else {
            this.HQLCondition = "";
        }
        Search search = createSearch(getEntityClass(), getEntityStateClass(), this.search, this.states, this.status, this.start, this.limit, this.HQLCondition, "queryContract");
        SearchResult result = this.searchService.search(search);
        List<Contract> list = result.get();
        Contract sum = new Contract();
        sum.setContractNo("合计");
//        sum.setContractDate();
        sum.setStatus(-1);
        sum.setState(-1);
        for (Contract contract : list) {
            sum.setTotalAmount(sum.getTotalAmount() + contract.getTotalAmount());
            sum.setTotalFinishedAmount(sum.getTotalFinishedAmount() + contract.getTotalFinishedAmount());
            sum.setTotalCheckingAmount(sum.getTotalCheckingAmount() + contract.getTotalCheckingAmount());
            sum.setTotalSum(sum.getTotalSum() + contract.getTotalSum());
        }

        list.add(sum);

        this.resultJson = JsonHelper.fromCollection(list, result.getResultClass(), result.getTotalCount(), 6);
        return "success";
    }

    public String print()
            throws ParseException {
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

    private String getHQL() throws ParseException {
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

    private String getHQLForSoc() throws ParseException {
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

    private CompanyService companyService;

    public void setCompanyService(CompanyService companyService) {
        this.companyService = companyService;
    }

    public String getReport() {
        try {
            if (!StringUtils.isEmpty(getHQL()))
                this.HQLCondition = getHQL();
            else {
                this.HQLCondition = "";
            }
        } catch (Exception e) {
            e.printStackTrace();
            this.HQLCondition = "";
        }

        Search search = createSearch(getEntityClass(), getEntityStateClass(), this.search, this.states, this.status, this.start, 0, this.HQLCondition, "queryContract");
        SearchResult result = this.searchService.search(search);
        List<Contract> list = result.get();
        Contract sum = new Contract();
        sum.setContractNo("合计");
        sum.setStatus(-1);
        sum.setState(-1);
        for (Contract contract : list) {
            sum.setTotalAmount(sum.getTotalAmount() + contract.getTotalAmount());
            sum.setTotalFinishedAmount(sum.getTotalFinishedAmount() + contract.getTotalFinishedAmount());
            sum.setTotalCheckingAmount(sum.getTotalCheckingAmount() + contract.getTotalCheckingAmount());
            sum.setTotalSum(sum.getTotalSum() + contract.getTotalSum());
        }

        list.add(sum);

        this.downloadFile = this.createExcel(list);
        return "success";
    }


    public String getFileName() {
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

    /**
     * 导出厂商信息
     *
     * @return
     */
    private File createExcel(List items) {
        String dir = FileUtil.tmpdir();
//        SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd");
//        Date date2 = new Date();
        String strDate = DateUtil.formatDate(new Date(), DateUtil.PATTERN_ISO_DATE);
        String filename = dir + "\\" + "合同查询(" + strDate + ").xls";
        File file = new File(filename);
        if (file.exists()) {
            file.delete();

            try {
                file.createNewFile();
            } catch (IOException var30) {
                var30.printStackTrace();
                this.logger.warn("导出Excel文件失败!");
                return null;
            }
        }

        try {
            WritableWorkbook e = Workbook.createWorkbook(file);
            WritableSheet ws = e.createSheet("厂商信息", 0);
            ws.getSettings().setPaperSize(PaperSize.A4);
            ws.getSettings().setOrientation(PageOrientation.LANDSCAPE);
            ws.setRowView(0, 600);
            ws.mergeCells(0, 0, 8, 0);
            WritableFont wFont = new WritableFont(WritableFont.createFont("宋体"), 18, WritableFont.BOLD);
            WritableCellFormat wcf = new WritableCellFormat(wFont);
            wcf.setAlignment(Alignment.CENTRE);
            wcf.setVerticalAlignment(VerticalAlignment.CENTRE);
            ws.addCell(new Label(0, 0, "合同查询", wcf));
            WritableFont wFonti = new WritableFont(WritableFont.createFont("宋体"), 10);
            WritableCellFormat wcfi = new WritableCellFormat(wFonti);
            wcfi.setBorder(jxl.format.Border.ALL, jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
            wcfi.setAlignment(Alignment.CENTRE);
            wcfi.setVerticalAlignment(VerticalAlignment.CENTRE);
            wcfi.setWrap(false);
            WritableFont wFonti2 = new WritableFont(WritableFont.createFont("宋体"), 10);
            WritableCellFormat wcfi2 = new WritableCellFormat(wFonti2);
            wcfi2.setBorder(jxl.format.Border.ALL, jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
            wcfi2.setAlignment(Alignment.LEFT);
            wcfi2.setVerticalAlignment(VerticalAlignment.CENTRE);
            wcfi2.setWrap(false);
            ws.setColumnView(0, 30);
            ws.setColumnView(1, 50);
            ws.setColumnView(8, 15);
            ws.setColumnView(9, 15);
            ws.setColumnView(10, 15);
            ws.addCell(new Label(0, 1, "合同号", wcfi));
            ws.addCell(new Label(1, 1, "合同厂商", wcfi));
            ws.addCell(new Label(2, 1, "数量总计", wcfi));
            ws.addCell(new Label(3, 1, "完成总计", wcfi));
            ws.addCell(new Label(4, 1, "审核总计", wcfi));
            ws.addCell(new Label(5, 1, "金额总计", wcfi));
            ws.addCell(new Label(6, 1, "交货期", wcfi));
            ws.addCell(new Label(7, 1, "有效", wcfi));
            ws.addCell(new Label(8, 1, "状态", wcfi));
            Integer row = new Integer(2);

            for (Iterator var22 = items.iterator(); var22.hasNext(); row = Integer.valueOf(row.intValue() + 1)) {
                Contract item = (Contract) var22.next();
                ws.addCell(new Label(0, row.intValue(), item.getContractNo(), wcfi2));
                ws.addCell(new Label(1, row.intValue(), null == item.getCompany() ? "" : item.getCompany().getName(), wcfi2));
                ws.addCell(new Label(2, row.intValue(), BusiUtil.nvlToString(item.getTotalAmount(), ""), wcfi2));
                ws.addCell(new Label(3, row.intValue(), BusiUtil.nvlToString(item.getTotalFinishedAmount(), ""), wcfi2));
                ws.addCell(new Label(4, row.intValue(), BusiUtil.nvlToString(item.getTotalCheckingAmount(), ""), wcfi2));
                ws.addCell(new Label(5, row.intValue(), BusiUtil.nvlToString(item.getTotalSum(), ""), wcfi2));
                ws.addCell(new Label(6, row.intValue(), DateUtil.formatDate(BusiUtil.nvl(item.getContractDate(), new Date()), DateUtil.PATTERN_ISO_DATE), wcfi2));
                ws.addCell(new Label(7, row.intValue(), getStatus(item.getStatus()), wcfi2));
                ws.addCell(new Label(8, row.intValue(), getState(item.getState()), wcfi2));
            }

            e.write();
            e.close();
            return file;
        } catch (WriteException var28) {
            var28.printStackTrace();
            return null;
        } catch (IOException var29) {
            var29.printStackTrace();
            return null;
        }
    }


    /**
     * 获取有效状态
     *
     * @param value
     * @return
     */
    private String getStatus(Integer value) {
        switch (value) {
            case 0:
                return "有效";
            case 1:
                return "禁用";
            case 2:
                return "作废";
            default:
                return "未知";
        }
    }

    /**
     * 获取有效状态
     *
     * @param value
     * @return
     */
    private String getState(Integer value) {
        switch (value) {
            case 0:
                return "已保存";
            case 1:
                return "待审核";
            case 2:
                return "审核失败";
            case 3:
                return "未完成";
            case 4:
                return "部分完成";
            case 5:
                return "全部完成";
            case 6:
                return "终止";
            default:
                return "未知";
        }
    }
}
