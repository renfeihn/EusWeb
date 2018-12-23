package com.is.eus.web.action.management.biz;

import com.is.eus.model.search.Search;
import com.is.eus.model.search.SearchResult;
import com.is.eus.pojo.Entity;
import com.is.eus.pojo.basic.Capacitor;
import com.is.eus.pojo.basic.Product;
import com.is.eus.pojo.contract.ContractItem;
import com.is.eus.pojo.storage.StorageIncomingItem;
import com.is.eus.pojo.storage.StorageOutcoming;
import com.is.eus.pojo.storage.StorageOutcomingItem;
import com.is.eus.service.support.FileUtil;
import com.is.eus.util.BusiUtil;
import com.is.eus.util.DateUtil;
import com.is.eus.util.JsonHelper;
import com.is.eus.web.action.EntityBaseAction;
import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.PageOrientation;
import jxl.format.PaperSize;
import jxl.format.VerticalAlignment;
import jxl.write.*;
import org.apache.commons.lang.xwork.StringUtils;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

public class storageOutcomingItemAction extends EntityBaseAction {
    private String socNo;
    private String companyName;
    private String contractNo;
    private String productCombination;
    private String productCode;
    private String errorLevel;
    private String voltage;
    private String capacity;
    private String productType;
    private String humidity;
    private String usageType;
    private String dateStartForSocItemSearch;
    private String dateEndForSocItemSearch;
    private String socState;

    public void setSocState(String socState) {
        this.socState = socState;
    }

    public void setSocNo(String socNo) {
        this.socNo = BusiUtil.decode(socNo);
    }

    public void setCompanyName(String companyName) {
        this.companyName = BusiUtil.decode(companyName);
    }

    public void setContractNo(String contractNo) {
        this.contractNo = BusiUtil.decode(contractNo);
    }

    public void setDateStartForSocItemSearch(String dateStartForSocItemSearch) {
        this.dateStartForSocItemSearch = dateStartForSocItemSearch;
    }

    public void setDateEndForSocItemSearch(String dateEndForSocItemSearch) {
        this.dateEndForSocItemSearch = dateEndForSocItemSearch;
    }

    public void setProductCombination(String productCombination) {
        this.productCombination = BusiUtil.decode(productCombination);
    }

    public void setProductCode(String productCode) {
        this.productCode = productCode;
    }

    public void setErrorLevel(String errorLevel) {
        this.errorLevel = errorLevel;
    }

    public void setVoltage(String voltage) {
        this.voltage = BusiUtil.decode(voltage);
    }

    public void setCapacity(String capacity) {
        this.capacity = BusiUtil.decode(capacity);
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

    protected Class<StorageOutcomingItem> getEntityClass() {
        return StorageOutcomingItem.class;
    }

    protected Class<?> getEntityStateClass() {
        return null;
    }

    public String find() {
        this.digDepth = 5;
        return super.find();
    }

    public String get() {
        this.digDepth = 5;
        return super.get();
    }

    public String query() throws ParseException {
        if (!StringUtils.isEmpty(getHQL()))
            this.HQLCondition = getHQL();
        else {
            this.HQLCondition = "";
        }
        Search search = createSearch(getEntityClass(), getEntityStateClass(), this.search, this.states, this.status, this.start, this.limit, this.HQLCondition, "queryStorageOutcomingItem");
        SearchResult result = this.searchService.search(search);
//        List list = getSum(result.get());
        this.resultJson = JsonHelper.fromCollection(result.get(), result.getResultClass(), result.getTotalCount(), 5);
        return "success";
    }

    private String getHQL() {
        String strHQL = "";
        StringBuilder strClause = new StringBuilder();
        String strConnection = " and ";

        if (!StringUtils.isEmpty(this.socNo)) {
            strHQL = "sc.socNo like '%" + this.socNo + "%'" + strConnection;
            strClause.append(strHQL);
        }

        if (!StringUtils.isEmpty(this.contractNo)) {
            strHQL = "co.contractNo like '%" + this.contractNo + "%'" + strConnection;
            strClause.append(strHQL);
        }

        if (!StringUtils.isEmpty(this.companyName)) {
            strHQL = "cp.name like '%" + this.companyName + "%'" + strConnection;
            strClause.append(strHQL);
        }

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

        if (!StringUtils.isEmpty(this.dateStartForSocItemSearch)) {
            this.dateStartForSocItemSearch = (this.dateStartForSocItemSearch.substring(0, 10) + " 00:00:00.000");
            strHQL = "s.createTime >= '" + this.dateStartForSocItemSearch + "'" + strConnection;
            strClause.append(strHQL);
        }

        if (!StringUtils.isEmpty(this.socState)) {
            int tempState = 0;
            if (this.socState.equalsIgnoreCase("Checking")) tempState = 0;
            if (this.socState.equalsIgnoreCase("Failed")) tempState = 1;
            if (this.socState.equalsIgnoreCase("Success")) tempState = 2;

            strHQL = "sc.state = " + tempState + strConnection;
            strClause.append(strHQL);
        }

        if (!StringUtils.isEmpty(this.dateEndForSocItemSearch)) {
            this.dateEndForSocItemSearch = (this.dateEndForSocItemSearch.substring(0, 10) + " 23:59:59.999");
            strHQL = "s.createTime <= '" + this.dateEndForSocItemSearch + "'" + strConnection;
            strClause.append(strHQL);
        }

        if (strClause.indexOf(strConnection) != -1) {
            strClause.delete(strClause.lastIndexOf(strConnection), strClause.length());
        }

        return strClause.toString();
    }

    protected void fillEntity(Entity entity)
            throws ParseException {
    }


    private List<StorageOutcomingItem> getSum(List<StorageOutcomingItem> list) {
        StorageOutcomingItem sum = new StorageOutcomingItem();
        StorageOutcoming so = new StorageOutcoming();
        so.setSocNo("合计");
        sum.setSoc(so);
        sum.setProduct(new Capacitor());
        sum.setContractItem(new ContractItem());
        for (StorageOutcomingItem item : list) {
            sum.setAmount(sum.getAmount() + item.getAmount());
//            sum.setFinishedAmount(sum.getFinishedAmount() + item.getFinishedAmount());
//            sum.setRestAmount(sum.getRestAmount() + item.getRestAmount());
        }
        list.add(sum);

        return list;
    }

    public String getReport() {
        if (!StringUtils.isEmpty(getHQL()))
            this.HQLCondition = getHQL();
        else {
            this.HQLCondition = "";
        }

        Search search = createSearch(getEntityClass(), getEntityStateClass(), this.search, this.states, this.status, this.start, this.limit, this.HQLCondition, "queryStorageOutcomingItem");
        SearchResult result = this.searchService.search(search);
        List<StorageOutcomingItem> list = getSum(result.get());

        this.downloadFile = this.createExcel(list);
        return "success";
    }


    /**
     * 导出厂商信息
     *
     * @return
     */
    private File createExcel(List items) {
        String dir = FileUtil.tmpdir();
        String strDate = DateUtil.formatDate(new Date(), DateUtil.PATTERN_ISO_DATE);
        String filename = dir + "\\" + "入库查询(" + strDate + ").xls";
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
            WritableSheet ws = e.createSheet("入库查询", 0);
            ws.getSettings().setPaperSize(PaperSize.A4);
            ws.getSettings().setOrientation(PageOrientation.LANDSCAPE);
            ws.setRowView(0, 600);
            ws.mergeCells(0, 0, 14, 0);
            WritableFont wFont = new WritableFont(WritableFont.createFont("宋体"), 18, WritableFont.BOLD);
            WritableCellFormat wcf = new WritableCellFormat(wFont);
            wcf.setAlignment(Alignment.CENTRE);
            wcf.setVerticalAlignment(VerticalAlignment.CENTRE);
            ws.addCell(new Label(0, 0, "入库查询", wcf));
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
            ws.setColumnView(2, 30);
            ws.setColumnView(11, 50);
            ws.setColumnView(12, 50);
            ws.addCell(new Label(0, 1, "出库单号", wcfi));
            ws.addCell(new Label(1, 1, "序号", wcfi));
            ws.addCell(new Label(2, 1, "产品名称及型号", wcfi));
            ws.addCell(new Label(3, 1, "单位	", wcfi));
            ws.addCell(new Label(4, 1, "数量	", wcfi));
            ws.addCell(new Label(5, 1, "单价	", wcfi));
            ws.addCell(new Label(6, 1, "不含税单价	", wcfi));
            ws.addCell(new Label(7, 1, "金额	", wcfi));
            ws.addCell(new Label(8, 1, "不含税金额", wcfi));
            ws.addCell(new Label(9, 1, "税率", wcfi));
            ws.addCell(new Label(10, 1, "税额", wcfi));
            ws.addCell(new Label(11, 1, "合同厂商", wcfi));
            ws.addCell(new Label(12, 1, "合同号", wcfi));
            ws.addCell(new Label(13, 1, "状态", wcfi));
            ws.addCell(new Label(14, 1, "备注", wcfi));

            for (Integer row = 2; row < items.size() + 2; row++) {
                StorageOutcomingItem item = (StorageOutcomingItem) items.get(row - 2);
                Capacitor product = (Capacitor) item.getProduct();
                StorageOutcoming so = item.getSoc();
                ContractItem contractItem = item.getContractItem();
                ws.addCell(new Label(0, row.intValue(), null != so ? so.getSocNo() : "", wcfi2));
                ws.addCell(new Label(1, row.intValue(), BusiUtil.nvlToString(item.getSocItemNo(), ""), wcfi2));
                ws.addCell(new Label(2, row.intValue(), BusiUtil.nvlToString(product.getProductCombination(), ""), wcfi2));
                ws.addCell(new Label(3, row.intValue(), null != product.getUnit() ? product.getUnit().getName() : "", wcfi2));
                ws.addCell(new Label(4, row.intValue(), BusiUtil.nvlToString(item.getAmount(), ""), wcfi2));
                ws.addCell(new Label(5, row.intValue(), BusiUtil.nvlToString(item.getPrice(), ""), wcfi2));
                ws.addCell(new Label(6, row.intValue(), BusiUtil.nvlToString(item.getPriceWithoutTax(), ""), wcfi2));
                ws.addCell(new Label(7, row.intValue(), BusiUtil.nvlToString(item.getSubTotal(), ""), wcfi2));
                ws.addCell(new Label(8, row.intValue(), BusiUtil.nvlToString(item.getSubTotalWithoutTax(), ""), wcfi2));
                ws.addCell(new Label(9, row.intValue(), BusiUtil.nvlToString(item.getTax(), ""), wcfi2));
                ws.addCell(new Label(10, row.intValue(), BusiUtil.nvlToString(item.getTaxAmount(), ""), wcfi2));
                ws.addCell(new Label(11, row.intValue(), null != contractItem.getContract() ? contractItem.getContract().getCompany().getName() : "", wcfi2));
                ws.addCell(new Label(12, row.intValue(), null != contractItem.getContract() ? contractItem.getContract().getContractNo() : "", wcfi2));
                ws.addCell(new Label(13, row.intValue(), BusiUtil.getOutcomingState(so.getState()), wcfi2));
                ws.addCell(new Label(14, row.intValue(), BusiUtil.nvlToString(item.getMemo(), ""), wcfi2));
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
}


