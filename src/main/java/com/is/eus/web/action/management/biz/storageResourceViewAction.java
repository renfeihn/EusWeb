package com.is.eus.web.action.management.biz;

import com.is.eus.model.search.Search;
import com.is.eus.model.search.SearchResult;
import com.is.eus.pojo.Entity;
import com.is.eus.pojo.basic.Capacitor;
import com.is.eus.pojo.basic.Product;
import com.is.eus.pojo.storage.InWarehouse;
import com.is.eus.pojo.storage.StorageResourceView;
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
import java.util.List;

/**
 * 库存资源查询
 */
public class storageResourceViewAction extends EntityBaseAction {
    private String productCombination;
    private String productCode;
    private String errorLevel;
    private String voltage;
    private String capacity;
    private String productType;
    private String humidity;
    private String usageType;
    private int[] state;

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

    public int[] getState() {
        return this.state;
    }

    public void setState(int[] state) {
        this.state = state;
    }

    protected Class<StorageResourceView> getEntityClass() {
        return StorageResourceView.class;
    }

    protected Class<?> getEntityStateClass() {
        return null;
    }

    public String query() {
        this.digDepth = 4;
        if (!StringUtils.isEmpty(getHQL()))
            this.HQLCondition = getHQL();
        else {
            this.HQLCondition = "";
        }
        Search search = createSearch(getEntityClass(), getEntityStateClass(), this.search, this.states, this.status, this.start, this.limit, this.HQLCondition, "query");
        SearchResult result = this.searchService.search(search);
        List list = getSum(result.get());
        this.resultJson = JsonHelper.fromCollection(list, result.getResultClass(), result.getTotalCount(), 4);
        return "success";
    }

    public String printQuery() {
        return null;
    }

    protected void fillEntity(Entity entity) throws ParseException {
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

        if (strClause.indexOf(strConnection) != -1) {
            strClause.delete(strClause.lastIndexOf(strConnection), strClause.length());
        }

        return strClause.toString();
    }


    private List<StorageResourceView> getSum(List<StorageResourceView> list) {
        StorageResourceView sum = new StorageResourceView();
        Product product = new Capacitor();
        product.setProductCombination("合计");
        sum.setProduct(product);
        for (StorageResourceView item : list) {
            sum.setTotalAmount(sum.getTotalAmount() + item.getTotalAmount());
            sum.setAdvancedAmount(sum.getAdvancedAmount() + item.getAdvancedAmount());
            sum.setRestAmount(sum.getRestAmount() + item.getRestAmount());
            sum.setAmount(sum.getAmount() + item.getAmount());

            sum.getProduct().setMemo(BusiUtil.addInteget(sum.getProduct().getMemo(), item.getProduct().getMemo()).toString());
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
        List<StorageResourceView> list = getSum(result.get());

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
        String filename = dir + "\\" + "库存资源查询(" + strDate + ").xls";
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
            WritableSheet ws = e.createSheet("库存资源查询", 0);
            ws.getSettings().setPaperSize(PaperSize.A4);
            ws.getSettings().setOrientation(PageOrientation.LANDSCAPE);
            ws.setRowView(0, 600);
            ws.mergeCells(0, 0, 8, 0);
            WritableFont wFont = new WritableFont(WritableFont.createFont("宋体"), 18, WritableFont.BOLD);
            WritableCellFormat wcf = new WritableCellFormat(wFont);
            wcf.setAlignment(Alignment.CENTRE);
            wcf.setVerticalAlignment(VerticalAlignment.CENTRE);
            ws.addCell(new Label(0, 0, "库存资源查询", wcf));
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
            ws.addCell(new Label(0, 1, "产品名称及型号", wcfi));
            ws.addCell(new Label(1, 1, "库存数量", wcfi));
            ws.addCell(new Label(2, 1, "待发数量	", wcfi));
            ws.addCell(new Label(3, 1, "结余数量	", wcfi));
            ws.addCell(new Label(4, 1, "资源数量	", wcfi));
            ws.addCell(new Label(5, 1, "最低资源数量	", wcfi));
            ws.addCell(new Label(6, 1, "产品代号	", wcfi));
            ws.addCell(new Label(7, 1, "产品品种", wcfi));
            ws.addCell(new Label(8, 1, "误差", wcfi));

            for (Integer row = 2; row < items.size() + 2; row++) {
                StorageResourceView item = (StorageResourceView) items.get(row - 2);
                Capacitor product = (Capacitor) item.getProduct();
                ws.addCell(new Label(0, row.intValue(), BusiUtil.nvlToString(product.getProductCombination(), ""), wcfi2));
                ws.addCell(new Label(1, row.intValue(), BusiUtil.nvlToString(item.getTotalAmount(), ""), wcfi2));
                ws.addCell(new Label(2, row.intValue(), BusiUtil.nvlToString(item.getAdvancedAmount(), ""), wcfi2));
                ws.addCell(new Label(3, row.intValue(), BusiUtil.nvlToString(item.getRestAmount(), ""), wcfi2));
                ws.addCell(new Label(4, row.intValue(), BusiUtil.nvlToString(item.getAmount(), ""), wcfi2));
                ws.addCell(new Label(5, row.intValue(), BusiUtil.nvlToString(product.getMemo(), ""), wcfi2));
                ws.addCell(new Label(6, row.intValue(), null != product.getProductCode() ? product.getProductCode().getName() : "", wcfi2));
                ws.addCell(new Label(7, row.intValue(), null != product.getUsageType() ? product.getUsageType().getName() : "", wcfi2));
                ws.addCell(new Label(8, row.intValue(), null != product.getErrorLevel() ? product.getErrorLevel().getName() : "", wcfi2));
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
