package com.is.eus.web.action.management.biz;

import com.is.eus.model.search.Search;
import com.is.eus.model.search.SearchResult;
import com.is.eus.pojo.Entity;
import com.is.eus.pojo.basic.Capacitor;
import com.is.eus.pojo.basic.Product;
import com.is.eus.pojo.schedule.ScheduleSummeryView;
import com.is.eus.pojo.schedule.ScheduleView;
import com.is.eus.pojo.storage.SCSSummeryView;
import com.is.eus.service.SearchService;
import com.is.eus.service.biz.ui.ScheduleService;
import com.is.eus.service.support.FileUtil;
import com.is.eus.util.BusiUtil;
import com.is.eus.util.DateUtil;
import com.is.eus.util.JsonHelper;
import com.is.eus.web.action.EntityBaseAction;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.PageOrientation;
import jxl.format.PaperSize;
import jxl.format.VerticalAlignment;
import jxl.write.*;
import org.apache.commons.lang.xwork.StringUtils;
import org.apache.poi.hssf.record.formula.functions.T;

/**
 * 计划欠交汇总 action
 */
public class scheduleSummeryViewAction extends EntityBaseAction {
    private ScheduleService scheduleService;
    private String productCombination;
    private String productCode;
    private String errorLevel;
    private String voltage;
    private String capacity;
    private String productType;
    private String humidity;
    private String usageType;

    public void setScheduleService(ScheduleService scheduleService) {
        this.scheduleService = scheduleService;
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

    protected void fillEntity(Entity entity) throws ParseException {
    }

    protected Class<ScheduleSummeryView> getEntityClass() {
        return ScheduleSummeryView.class;
    }

    protected Class<?> getEntityStateClass() {
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

        List list = getSum(result.get());

        this.resultJson = JsonHelper.fromCollection(list, result.getResultClass(), result.getTotalCount(), 3);
        return "success";
    }

    public String printQuery() throws ParseException {
        if (!StringUtils.isEmpty(getHQL()))
            this.HQLCondition = getHQL();
        else {
            this.HQLCondition = "";
        }

        String tempStart = "";
        String tempEnd = "";
        String strDuration = "";
        String strTitle = "销售订货欠交汇总表";
        String strConn = " 至 ";
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

    private String getHQL() {
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


    private List<ScheduleSummeryView> getSum(List<ScheduleSummeryView> list) {
        ScheduleSummeryView sum = new ScheduleSummeryView();
        Product product = new Capacitor();
        product.setProductCombination("合计");
        sum.setProduct(product);
        for (ScheduleSummeryView item : list) {
            sum.setAmount(sum.getAmount() + item.getAmount());
            sum.setFinishedAmount(sum.getFinishedAmount() + item.getFinishedAmount());
            sum.setRestAmount(sum.getRestAmount() + item.getRestAmount());
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

        Search search = createSearch(getEntityClass(), getEntityStateClass(), this.search, this.states, this.status, this.start, this.limit, this.HQLCondition, "queryScheduleSummeryView");
        SearchResult result = this.searchService.search(search);
        List<ScheduleSummeryView> list = getSum(result.get());

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
        String filename = dir + "\\" + "计划欠交汇总(" + strDate + ").xls";
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
            WritableSheet ws = e.createSheet("计划欠交汇总", 0);
            ws.getSettings().setPaperSize(PaperSize.A4);
            ws.getSettings().setOrientation(PageOrientation.LANDSCAPE);
            ws.setRowView(0, 600);
            ws.mergeCells(0, 0, 10, 0);
            WritableFont wFont = new WritableFont(WritableFont.createFont("宋体"), 18, WritableFont.BOLD);
            WritableCellFormat wcf = new WritableCellFormat(wFont);
            wcf.setAlignment(Alignment.CENTRE);
            wcf.setVerticalAlignment(VerticalAlignment.CENTRE);
            ws.addCell(new Label(0, 0, "计划欠交汇总", wcf));
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
            ws.setColumnView(1, 30);
            ws.setColumnView(2, 10);
            ws.setColumnView(3, 10);
            ws.addCell(new Label(0, 1, "产品名称及型号", wcfi));
            ws.addCell(new Label(1, 1, "产品代号", wcfi));
            ws.addCell(new Label(2, 1, "产品品种", wcfi));
            ws.addCell(new Label(3, 1, "电压	", wcfi));
            ws.addCell(new Label(4, 1, "容量	", wcfi));
            ws.addCell(new Label(5, 1, "湿度	", wcfi));
            ws.addCell(new Label(6, 1, "误差	", wcfi));
            ws.addCell(new Label(7, 1, "单位	", wcfi));
            ws.addCell(new Label(8, 1, "计划数量合计", wcfi));
            ws.addCell(new Label(9, 1, "完成数量合计", wcfi));
            ws.addCell(new Label(10, 1, "欠交数量合计", wcfi));

            Integer row = new Integer(2);

            for (Iterator var22 = items.iterator(); var22.hasNext(); row = Integer.valueOf(row.intValue() + 1)) {
                ScheduleSummeryView item = (ScheduleSummeryView) var22.next();
                Capacitor product = (Capacitor) item.getProduct();
                ws.addCell(new Label(0, row.intValue(), BusiUtil.nvlToString(product.getProductCombination(), ""), wcfi2));
                ws.addCell(new Label(1, row.intValue(), null != product.getProductCode() ? product.getProductCode().getName() : "", wcfi2));
                ws.addCell(new Label(2, row.intValue(), null != product.getUsageType() ? product.getUsageType().getName() : "", wcfi2));
                ws.addCell(new Label(3, row.intValue(), BusiUtil.nvlToString(product.getVoltage(), ""), wcfi2));
                ws.addCell(new Label(4, row.intValue(), BusiUtil.nvlToString(product.getCapacity(), ""), wcfi2));
                ws.addCell(new Label(5, row.intValue(), null != product.getHumidity() ? product.getHumidity().getName() : "", wcfi2));
                ws.addCell(new Label(6, row.intValue(), null != product.getErrorLevel() ? product.getErrorLevel().getName() : "", wcfi2));
                ws.addCell(new Label(7, row.intValue(), null != product.getUnit() ? product.getUnit().getName() : "", wcfi2));
                ws.addCell(new Label(8, row.intValue(), BusiUtil.nvlToString(item.getAmount(), ""), wcfi2));
                ws.addCell(new Label(9, row.intValue(), BusiUtil.nvlToString(item.getFinishedAmount(), ""), wcfi2));
                ws.addCell(new Label(10, row.intValue(), BusiUtil.nvlToString(item.getRestAmount(), ""), wcfi2));
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

