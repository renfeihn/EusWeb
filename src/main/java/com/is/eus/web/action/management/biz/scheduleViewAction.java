package com.is.eus.web.action.management.biz;

import com.is.eus.model.search.Search;
import com.is.eus.model.search.SearchResult;
import com.is.eus.pojo.Entity;
import com.is.eus.pojo.basic.Capacitor;
import com.is.eus.pojo.basic.Product;
import com.is.eus.pojo.contract.ContractItemOwnedSummeryView;
import com.is.eus.pojo.schedule.ScheduleView;
import com.is.eus.service.SearchService;
import com.is.eus.service.biz.ui.ScheduleService;
import com.is.eus.service.support.FileUtil;
import com.is.eus.type.ScheduleState;
import com.is.eus.type.ScheduleType;
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

/**
 * 计划查询action
 */
public class scheduleViewAction extends EntityBaseAction {
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

    public void setMemo(String memo) {
        this.memo = memo;
    }

    public void setScheduleService(ScheduleService scheduleService) {
        this.scheduleService = scheduleService;
    }

    public void setScheduleNo(String scheduleNo) {
        this.scheduleNo = scheduleNo;
    }

    public void setProductCombination(String productCombination) {
        this.productCombination = BusiUtil.decode(productCombination);
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
        this.companyName = BusiUtil.decode(companyName);
    }

    protected void fillEntity(Entity entity) throws ParseException {
    }

    protected Class<ScheduleView> getEntityClass() {
        return ScheduleView.class;
    }

    protected Class<?> getEntityStateClass() {
        return ScheduleState.class;
    }

    public String query() throws ParseException {
        if (!StringUtils.isEmpty(getHQL()))
            this.HQLCondition = getHQL();
        else {
            this.HQLCondition = "";
        }
        Search search = createSearch(getEntityClass(), getEntityStateClass(), this.search, this.states, this.status, this.start, this.limit, this.HQLCondition, "querySchedule");
        SearchResult result = this.searchService.search(search);

        List<ScheduleView> list = result.get();
        ScheduleView sum = new ScheduleView();
        sum.setScheduleNo("合计");
        sum.setState(-1);
        for (ScheduleView contractItem : list) {
            sum.setAmount(sum.getAmount() + contractItem.getAmount());
            sum.setFinishedAmount(sum.getFinishedAmount() + contractItem.getFinishedAmount());
        }
//        list.add(sum);

        this.resultJson = JsonHelper.fromCollection(list, result.getResultClass(), result.getTotalCount(), 3);
        return "success";
    }

    public String printQuery()
            throws ParseException {
        if (!StringUtils.isEmpty(getHQL()))
            this.HQLCondition = getHQL();
        else {
            this.HQLCondition = "";
        }

        String tempStart = "";
        String tempEnd = "";
        String strDuration = "";
        String strTitle = "销售订货明细规格汇总表";
        String strConn = " 至 ";
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

    private String getHQL() {
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


    public String getReport() {
        if (!StringUtils.isEmpty(getHQL()))
            this.HQLCondition = getHQL();
        else {
            this.HQLCondition = "";
        }

        Search search = createSearch(getEntityClass(), getEntityStateClass(), this.search, this.states, this.status, this.start, this.limit, this.HQLCondition, "querySchedule");
        SearchResult result = this.searchService.search(search);
        List<ScheduleView> list = result.get();
        ScheduleView sum = new ScheduleView();
        sum.setScheduleNo("合计");
        sum.setState(-1);
        for (ScheduleView contractItem : list) {
            sum.setAmount(sum.getAmount() + contractItem.getAmount());
            sum.setFinishedAmount(sum.getFinishedAmount() + contractItem.getFinishedAmount());
        }
        list.add(sum);

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
        String filename = dir + "\\" + "计划查询(" + strDate + ").xls";
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
            WritableSheet ws = e.createSheet("计划查询", 0);
            ws.getSettings().setPaperSize(PaperSize.A4);
            ws.getSettings().setOrientation(PageOrientation.LANDSCAPE);
            ws.setRowView(0, 600);
            ws.mergeCells(0, 0, 8, 0);
            WritableFont wFont = new WritableFont(WritableFont.createFont("宋体"), 18, WritableFont.BOLD);
            WritableCellFormat wcf = new WritableCellFormat(wFont);
            wcf.setAlignment(Alignment.CENTRE);
            wcf.setVerticalAlignment(VerticalAlignment.CENTRE);
            ws.addCell(new Label(0, 0, "计划查询", wcf));
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
            ws.setColumnView(0, 20);
            ws.setColumnView(1, 30);
            ws.setColumnView(2, 15);
            ws.setColumnView(3, 15);
            ws.setColumnView(4, 15);
            ws.setColumnView(5, 50);
            ws.setColumnView(6, 30);
            ws.addCell(new Label(0, 1, "计划编号", wcfi));
            ws.addCell(new Label(1, 1, "产品名称及型号", wcfi));
            ws.addCell(new Label(2, 1, "计划数量", wcfi));
            ws.addCell(new Label(3, 1, "完成数量", wcfi));
            ws.addCell(new Label(4, 1, "交货日期", wcfi));
            ws.addCell(new Label(5, 1, "合同厂商", wcfi));
            ws.addCell(new Label(6, 1, "合同号", wcfi));
            ws.addCell(new Label(7, 1, "状态", wcfi));
            ws.addCell(new Label(8, 1, "类型", wcfi));

            Integer row = new Integer(2);

            for (Iterator var22 = items.iterator(); var22.hasNext(); row = Integer.valueOf(row.intValue() + 1)) {
                ScheduleView item = (ScheduleView) var22.next();
                ws.addCell(new Label(0, row.intValue(), BusiUtil.nvlToString(item.getScheduleNo(), ""), wcfi2));
                ws.addCell(new Label(1, row.intValue(), null == item.getProduct() ? "" : item.getProduct().getProductCombination(), wcfi2));
                ws.addCell(new Label(2, row.intValue(), BusiUtil.nvlToString(item.getAmount(), ""), wcfi2));
                ws.addCell(new Label(3, row.intValue(), BusiUtil.nvlToString(item.getFinishedAmount(), ""), wcfi2));
                ws.addCell(new Label(4, row.intValue(), DateUtil.formatDate(BusiUtil.nvl(item.getScheduleDate(), new
                        Date()), DateUtil.PATTERN_ISO_DATE), wcfi2));
                ws.addCell(new Label(5, row.intValue(), null == item.getCompany() ? "" : item.getCompany().getName(),
                        wcfi2));
                ws.addCell(new Label(6, row.intValue(), BusiUtil.nvlToString(item.getContractNo(), ""), wcfi2));
                ws.addCell(new Label(7, row.intValue(), BusiUtil.getState(item.getState()), wcfi2));
                ws.addCell(new Label(8, row.intValue(), BusiUtil.getScheduleType(item.getScheduleType()), wcfi2));
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

