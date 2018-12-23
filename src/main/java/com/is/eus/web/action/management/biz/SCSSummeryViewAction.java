package com.is.eus.web.action.management.biz;

import com.is.eus.model.search.Search;
import com.is.eus.model.search.SearchResult;
import com.is.eus.pojo.Entity;
import com.is.eus.pojo.basic.Capacitor;
import com.is.eus.pojo.basic.Product;
import com.is.eus.pojo.storage.SCSSumery;
import com.is.eus.pojo.storage.SCSSummeryView;
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
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

/**
 * 资源汇总查询
 */
public class SCSSummeryViewAction extends EntityBaseAction {
    private String productCombination;
    private String productCode;
    private String errorLevel;
    private String voltage;
    private String capacity;
    private String productType;
    private String humidity;
    private String usageType;
    private String varAmount;
    private String srAmount;
    private String minAmount;
    private String maxAmount;

    public SCSSummeryViewAction() {
    }

    public void setSrAmount(String srAmount) {
        this.srAmount = srAmount;
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

    public void setVarAmount(String varAmount) {
        this.varAmount = varAmount;
    }

    public void setMinAmount(String minAmount) {
        this.minAmount = minAmount;
    }

    public void setMaxAmount(String maxAmount) {
        this.maxAmount = maxAmount;
    }

    protected void fillEntity(Entity entity) throws ParseException {
    }

    protected Class<SCSSummeryView> getEntityClass() {
        return SCSSummeryView.class;
    }

    protected Class<?> getEntityStateClass() {
        return null;
    }

    public String query() throws ParseException {
        if (!StringUtils.isEmpty(this.getHQL())) {
            this.HQLCondition = this.getHQL();
        } else {
            this.HQLCondition = "";
        }

        Search search = this.createSearch(this.getEntityClass(), this.getEntityStateClass(), this.search, this.states, this.status, this.start, this.limit, this.HQLCondition, "query");
        SearchResult result = this.searchService.search(search);
        this.resultJson = JsonHelper.fromCollection(result.get(), result.getResultClass(), result.getTotalCount(), 3);
        return "success";
    }

    public String querySummery() throws ParseException {
        if (!StringUtils.isEmpty(this.getHQL())) {
            this.HQLCondition = this.getHQL();
        } else {
            this.HQLCondition = "";
        }

        Search search = this.createSearch(this.getEntityClass(), this.getEntityStateClass(), this.search, this.states, this.status, this.start, -1, this.HQLCondition, "query");
        SearchResult result = this.searchService.search(search);
        int srTotalAmount = 0;
        int srAmount = 0;
        int coCheckingAmount = 0;
        int coUnfinishedAmount = 0;
        int coOwnedAmount = 0;
        int ssRestAmount = 0;
        int varAmount = 0;
        List items = result.get();

        SCSSummeryView sum;
        for (Iterator sumList = items.iterator(); sumList.hasNext(); varAmount += sum.getVarAmount()) {
            sum = (SCSSummeryView) sumList.next();
            srTotalAmount += sum.getSrTotalAmount();
            srAmount += sum.getSrAmount();
            coCheckingAmount += sum.getCoCheckingAmount();
            coUnfinishedAmount += sum.getCoUnfinishedAmount();
            coOwnedAmount += sum.getCoOwnedAmount();
            ssRestAmount += sum.getSsRestAmount();
        }

        SCSSumery sum1 = new SCSSumery();
        sum1.setSrTotalAmount(srTotalAmount);
        sum1.setSrAmount(srAmount);
        sum1.setCoCheckingAmount(coCheckingAmount);
        sum1.setCoUnfinishedAmount(coUnfinishedAmount);
        sum1.setCoOwnedAmount(coOwnedAmount);
        sum1.setSsRestAmount(ssRestAmount);
        sum1.setVarAmount(varAmount);
        ArrayList sumList1 = new ArrayList();
        sumList1.add(sum1);
        this.resultJson = JsonHelper.fromCollection(sumList1, SCSSumery.class, 1L, this.digDepth);
        return "success";
    }

    private String getHQL() {
        String strHQL = "";
        StringBuilder strClause = new StringBuilder();
        String strConnection = " and ";
        if (!StringUtils.isEmpty(this.varAmount)) {
            String strSymbol = "";
            int iVar = Integer.parseInt(this.varAmount);
            if (iVar > 0) {
                if (iVar == 1) {
                    strSymbol = "=";
                }

                if (iVar == 2) {
                    strSymbol = ">";
                }

                if (iVar == 3) {
                    strSymbol = "<";
                }

                strHQL = "s.varAmount " + strSymbol + " 0 " + strConnection;
                if (StringUtils.isEmpty(this.minAmount) && StringUtils.isEmpty(this.maxAmount)) {
                    strClause.append(strHQL);
                }
            }
        }

        if (!StringUtils.isEmpty(this.srAmount)) {
            String strSymbol = "";
            int iVar = Integer.parseInt(this.srAmount);
            if (iVar > 0) {
                if (iVar == 1) {
                    strSymbol = "=";
                }

                if (iVar == 2) {
                    strSymbol = ">";
                }

                if (iVar == 3) {
                    strSymbol = "<";
                }

                strHQL = "s.srAmount " + strSymbol + " 0 " + strConnection;
                strClause.append(strHQL);
            }
        }

        if (!StringUtils.isEmpty(this.minAmount)) {
            strHQL = "s.varAmount >=" + this.minAmount + strConnection;
            strClause.append(strHQL);
        }

        if (!StringUtils.isEmpty(this.maxAmount)) {
            strHQL = "s.varAmount <=" + this.maxAmount + strConnection;
            strClause.append(strHQL);
        }

        if (!StringUtils.isEmpty(this.productCombination)) {
            strHQL = "p.productCombination like \'%" + this.productCombination + "%\'" + strConnection;
            strClause.append(strHQL);
        }

        if (!StringUtils.isEmpty(this.productCode)) {
            strHQL = "pc.id = \'" + this.productCode + "\'" + strConnection;
            strClause.append(strHQL);
        }

        if (!StringUtils.isEmpty(this.errorLevel)) {
            strHQL = "e.id = \'" + this.errorLevel + "\'" + strConnection;
            strClause.append(strHQL);
        }

        if (!StringUtils.isEmpty(this.voltage)) {
            strHQL = "p.voltage like \'%" + this.voltage + "%\'" + strConnection;
            strClause.append(strHQL);
        }

        if (!StringUtils.isEmpty(this.capacity)) {
            strHQL = "p.capacity like \'%" + this.capacity + "%\'" + strConnection;
            strClause.append(strHQL);
        }

        if (!StringUtils.isEmpty(this.productType)) {
            strHQL = "pt.id = \'" + this.productType + "\'" + strConnection;
            strClause.append(strHQL);
        }

        if (!StringUtils.isEmpty(this.humidity)) {
            strHQL = "h.id = \'" + this.humidity + "\'" + strConnection;
            strClause.append(strHQL);
        }

        if (!StringUtils.isEmpty(this.usageType)) {
            strHQL = "ut.id = \'" + this.usageType + "\'" + strConnection;
            strClause.append(strHQL);
        }

        if (strClause.indexOf(strConnection) != -1) {
            strClause.delete(strClause.lastIndexOf(strConnection), strClause.length());
        }

        return strClause.toString();
    }


    private List<SCSSummeryView> getSum(List<SCSSummeryView> list) {
        SCSSummeryView sum = new SCSSummeryView();
        Product product = new Capacitor();
        product.setProductCombination("合计");
        sum.setProduct(product);
        for (SCSSummeryView item : list) {
            sum.setSrTotalAmount(sum.getSrTotalAmount() + item.getSrTotalAmount());
            sum.setSrAmount(sum.getSrAmount() + item.getSrAmount());
            sum.setCoCheckingAmount(sum.getCoCheckingAmount() + item.getCoCheckingAmount());
            sum.setCoUnfinishedAmount(sum.getCoUnfinishedAmount() + item.getCoUnfinishedAmount());
            sum.setCoOwnedAmount(sum.getCoOwnedAmount() + item.getCoOwnedAmount());
            sum.setSsRestAmount(sum.getSsRestAmount() + item.getSsRestAmount());
            sum.setVarAmount(sum.getVarAmount() + item.getVarAmount());

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

        Search search = this.createSearch(this.getEntityClass(), this.getEntityStateClass(), this.search, this.states, this.status, this.start, this.limit, this.HQLCondition, "query");
        SearchResult result = this.searchService.search(search);
        List<SCSSummeryView> list = getSum(result.get());

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
        String filename = dir + "\\" + "资源汇总查询(" + strDate + ").xls";
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
            WritableSheet ws = e.createSheet("资源汇总查询", 0);
            ws.getSettings().setPaperSize(PaperSize.A4);
            ws.getSettings().setOrientation(PageOrientation.LANDSCAPE);
            ws.setRowView(0, 600);
            ws.mergeCells(0, 0, 8, 0);
            WritableFont wFont = new WritableFont(WritableFont.createFont("宋体"), 18, WritableFont.BOLD);
            WritableCellFormat wcf = new WritableCellFormat(wFont);
            wcf.setAlignment(Alignment.CENTRE);
            wcf.setVerticalAlignment(VerticalAlignment.CENTRE);
            ws.addCell(new Label(0, 0, "资源汇总查询", wcf));
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
            ws.addCell(new Label(1, 1, "库存数", wcfi));
            ws.addCell(new Label(2, 1, "资源数	", wcfi));
            ws.addCell(new Label(3, 1, "合同审核数	", wcfi));
            ws.addCell(new Label(4, 1, "合同欠交数	", wcfi));
            ws.addCell(new Label(5, 1, "合同对库欠交数	", wcfi));
            ws.addCell(new Label(6, 1, "计划欠交数	", wcfi));
            ws.addCell(new Label(7, 1, "差额", wcfi));
            ws.addCell(new Label(8, 1, "产品代号", wcfi));
            ws.addCell(new Label(9, 1, "产品品种", wcfi));
            ws.addCell(new Label(10, 1, "电压", wcfi));
            ws.addCell(new Label(11, 1, "容量", wcfi));
            ws.addCell(new Label(12, 1, "湿度", wcfi));
            ws.addCell(new Label(13, 1, "误差", wcfi));
            ws.addCell(new Label(14, 1, "单位", wcfi));

            for (Integer row = 2; row < items.size() + 2; row++) {
                SCSSummeryView item = (SCSSummeryView) items.get(row - 2);
                Capacitor product = (Capacitor) item.getProduct();
                ws.addCell(new Label(0, row.intValue(), BusiUtil.nvlToString(product.getProductCombination(), ""), wcfi2));
                ws.addCell(new Label(1, row.intValue(), BusiUtil.nvlToString(item.getSrTotalAmount(), ""), wcfi2));
                ws.addCell(new Label(2, row.intValue(), BusiUtil.nvlToString(item.getSrAmount(), ""), wcfi2));
                ws.addCell(new Label(3, row.intValue(), BusiUtil.nvlToString(item.getCoCheckingAmount(), ""), wcfi2));
                ws.addCell(new Label(4, row.intValue(), BusiUtil.nvlToString(item.getCoUnfinishedAmount(), ""), wcfi2));

                ws.addCell(new Label(5, row.intValue(), BusiUtil.nvlToString(item.getCoOwnedAmount(), ""), wcfi2));
                ws.addCell(new Label(6, row.intValue(), BusiUtil.nvlToString(item.getSsRestAmount(), ""), wcfi2));
                ws.addCell(new Label(7, row.intValue(), BusiUtil.nvlToString(item.getVarAmount(), ""), wcfi2));

                ws.addCell(new Label(8, row.intValue(), null != product.getProductCode() ? product.getProductCode().getName() : "", wcfi2));
                ws.addCell(new Label(9, row.intValue(), null != product.getUsageType() ? product.getUsageType().getName() : "", wcfi2));
                ws.addCell(new Label(10, row.intValue(), BusiUtil.nvlToString(product.getVoltage(), ""), wcfi2));
                ws.addCell(new Label(11, row.intValue(), BusiUtil.nvlToString(product.getCapacity(), ""), wcfi2));
                ws.addCell(new Label(12, row.intValue(), null != product.getHumidity() ? product.getHumidity().getName() : "", wcfi2));
                ws.addCell(new Label(13, row.intValue(), null != product.getErrorLevel() ? product.getErrorLevel().getName() : "", wcfi2));
                ws.addCell(new Label(14, row.intValue(), null != product.getUnit() ? product.getUnit().getName() : "", wcfi2));
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
