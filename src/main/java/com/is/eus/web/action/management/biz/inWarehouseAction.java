package com.is.eus.web.action.management.biz;

import com.is.eus.model.search.Search;
import com.is.eus.model.search.SearchResult;
import com.is.eus.pojo.Entity;
import com.is.eus.pojo.basic.Capacitor;
import com.is.eus.pojo.basic.Product;
import com.is.eus.pojo.basic.StorageLocation;
import com.is.eus.pojo.contract.ContractItem;
import com.is.eus.pojo.dac.User;
import com.is.eus.pojo.storage.InWarehouse;
import com.is.eus.pojo.storage.StorageOutcoming;
import com.is.eus.pojo.storage.StorageOutcomingItem;
import com.is.eus.service.EntityService;
import com.is.eus.service.SearchService;
import com.is.eus.service.biz.ui.InWarehouseService;
import com.is.eus.service.exception.InvalidOperationException;
import com.is.eus.service.support.FileUtil;
import com.is.eus.util.BusiUtil;
import com.is.eus.util.DateUtil;
import com.is.eus.util.JsonHelper;
import com.is.eus.web.action.EntityBaseAction;
import com.is.eus.web.exception.InvalidPageInformationException;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.util.Date;
import java.util.List;

import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.PageOrientation;
import jxl.format.PaperSize;
import jxl.format.VerticalAlignment;
import jxl.write.*;
import org.apache.commons.lang.xwork.StringUtils;

/**
 * 直接出入库查询
 */
public class inWarehouseAction extends EntityBaseAction {
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

    public void setInWarehouseService(InWarehouseService inWarehouseService) {
        this.inWarehouseService = inWarehouseService;
    }

    protected void fillEntity(Entity entity) throws ParseException {
        InWarehouse iw = (InWarehouse) entity;
        User user = getUserFromSession();
        Product product = (Product) this.entityService.get(Product.class, this.product);

        StorageLocation storageLocation = null;

        if (this.storageLocation.trim().isEmpty())
            storageLocation = (StorageLocation) this.entityService.get(StorageLocation.class, "66B79F13-6918-4A95-B424-DC0ACCE3E497");
        else {
            storageLocation = (StorageLocation) this.entityService.get(StorageLocation.class, this.storageLocation);
        }

        iw.setProduct(product);
        iw.setStorageLocation(storageLocation);
        iw.setTotalAmount(this.amount);
        iw.setMemo(this.memo);
        iw.setProductionDate(this.productionDate);
        iw.setCreator(user.getEmployee());
        iw.setCreateTime(new Date());
    }

    public String add() {
        InWarehouse iw = new InWarehouse();
        try {
            check();
            fillEntity(iw);
            iw.setFlag(0);
            this.inWarehouseService.add(iw);
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

    public String addOut() {
        InWarehouse iw = new InWarehouse();
        try {
            check();
            fillEntity(iw);
            iw.setFlag(1);
            this.inWarehouseService.addOut(iw);
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

    protected Class<InWarehouse> getEntityClass() {
        return InWarehouse.class;
    }

    protected Class<?> getEntityStateClass() {
        return null;
    }

    public String get() {
        this.digDepth = 4;
        return super.get();
    }

    public String query() throws ParseException {
        if (!StringUtils.isEmpty(getHQL()))
            this.HQLCondition = getHQL();
        else {
            this.HQLCondition = "";
        }
        Search search = createSearch(getEntityClass(), getEntityStateClass(), this.search, this.states, this.status, this.start, this.limit, this.HQLCondition, "query");
        SearchResult result = this.searchService.search(search);
        List list = getSum(result.get());
        this.resultJson = JsonHelper.fromCollection(list, result.getResultClass(), result.getTotalCount(), 3);
        return "success";
    }

    private String getHQL() {
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


    private List<InWarehouse> getSum(List<InWarehouse> list) {
        InWarehouse sum = new InWarehouse();
        Product product = new Capacitor();
        product.setProductCombination("合计");
        sum.setProduct(product);
        for (InWarehouse item : list) {
            sum.setTotalAmount(sum.getTotalAmount() + item.getTotalAmount());
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

        Search search = createSearch(getEntityClass(), getEntityStateClass(), this.search, this.states, this.status, this.start, this.limit, this.HQLCondition, "query");
        SearchResult result = this.searchService.search(search);
        List<InWarehouse> list = getSum(result.get());

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
        String filename = dir + "\\" + "出库明细(" + strDate + ").xls";
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
            WritableSheet ws = e.createSheet("出库明细", 0);
            ws.getSettings().setPaperSize(PaperSize.A4);
            ws.getSettings().setOrientation(PageOrientation.LANDSCAPE);
            ws.setRowView(0, 600);
            ws.mergeCells(0, 0, 8, 0);
            WritableFont wFont = new WritableFont(WritableFont.createFont("宋体"), 18, WritableFont.BOLD);
            WritableCellFormat wcf = new WritableCellFormat(wFont);
            wcf.setAlignment(Alignment.CENTRE);
            wcf.setVerticalAlignment(VerticalAlignment.CENTRE);
            ws.addCell(new Label(0, 0, "出库明细", wcf));
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
            ws.setColumnView(8, 15);
            ws.setColumnView(9, 20);
            ws.addCell(new Label(0, 1, "产品名称及型号", wcfi));
            ws.addCell(new Label(1, 1, "产品代号", wcfi));
            ws.addCell(new Label(2, 1, "产品品种", wcfi));
            ws.addCell(new Label(3, 1, "电压	", wcfi));
            ws.addCell(new Label(4, 1, "容量	", wcfi));
            ws.addCell(new Label(5, 1, "湿度	", wcfi));
            ws.addCell(new Label(6, 1, "误差	", wcfi));
            ws.addCell(new Label(7, 1, "数量	", wcfi));
            ws.addCell(new Label(8, 1, "状态", wcfi));
            ws.addCell(new Label(9, 1, "时间", wcfi));

            for (Integer row = 2; row < items.size() + 2; row++) {
                InWarehouse item = (InWarehouse) items.get(row - 2);
                Capacitor product = (Capacitor) item.getProduct();
                ws.addCell(new Label(0, row.intValue(), BusiUtil.nvlToString(product.getProductCombination(), ""), wcfi2));
                ws.addCell(new Label(1, row.intValue(), null != product.getProductCode() ? product.getProductCode().getName() : "", wcfi2));
                ws.addCell(new Label(2, row.intValue(), null != product.getUsageType() ? product.getUsageType().getName() : "", wcfi2));
                ws.addCell(new Label(3, row.intValue(), null != product.getVoltage() ? product.getVoltage() : "", wcfi2));
                ws.addCell(new Label(4, row.intValue(), BusiUtil.nvlToString(product.getCapacity(), ""), wcfi2));
                ws.addCell(new Label(5, row.intValue(), null != product.getHumidity() ? product.getHumidity().getName() : "", wcfi2));
                ws.addCell(new Label(6, row.intValue(), null != product.getErrorLevel() ? product.getErrorLevel().getName() : "", wcfi2));
                ws.addCell(new Label(7, row.intValue(), BusiUtil.nvlToString(item.getTotalAmount(), ""), wcfi2));
                ws.addCell(new Label(8, row.intValue(), BusiUtil.getInWarehouseFlag(item.getFlag()), wcfi2));
                ws.addCell(new Label(9, row.intValue(), DateUtil.formatDate(BusiUtil.nvl(item.getCreateTime(), new Date()), DateUtil.PATTERN_ISO_DATETIME), wcfi2));
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


