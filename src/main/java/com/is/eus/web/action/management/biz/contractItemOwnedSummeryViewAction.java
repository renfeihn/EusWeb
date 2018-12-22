package com.is.eus.web.action.management.biz;

import com.is.eus.model.search.Search;
import com.is.eus.model.search.SearchResult;
import com.is.eus.pojo.Entity;
import com.is.eus.pojo.basic.Capacitor;
import com.is.eus.pojo.basic.Product;
import com.is.eus.pojo.contract.Contract;
import com.is.eus.pojo.contract.ContractItem;
import com.is.eus.pojo.contract.ContractItemOwnedSummeryView;
import com.is.eus.service.SearchService;
import com.is.eus.service.biz.ui.ContractService;
import com.is.eus.service.support.FileUtil;
import com.is.eus.util.BusiUtil;
import com.is.eus.util.DateUtil;
import com.is.eus.util.JsonHelper;
import com.is.eus.web.action.EntityBaseAction;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
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

public class contractItemOwnedSummeryViewAction extends EntityBaseAction {
    private String productCombination;
    private String productCode;
    private String errorLevel;
    private String voltage;
    private String capacity;
    private String productType;
    private String humidity;
    private String usageType;
    private ContractService contractService;
    private int[] state;

    public void setContractService(ContractService contractService) {
        this.contractService = contractService;
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

    public void setUsageType(String usageType) {
        this.usageType = usageType;
    }

    public int[] getState() {
        return this.state;
    }

    public void setState(int[] state) {
        this.state = state;
    }

    protected Class<ContractItemOwnedSummeryView> getEntityClass() {
        return ContractItemOwnedSummeryView.class;
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

        List<ContractItemOwnedSummeryView> list = result.get();
        ContractItemOwnedSummeryView sum = new ContractItemOwnedSummeryView();
        Product product = new Capacitor();
        product.setProductCombination("合计");
        sum.setProduct(product);
        for (ContractItemOwnedSummeryView contractItem : list) {
            sum.setAmount(sum.getAmount() + contractItem.getAmount());
            sum.setFinishedAmount(sum.getFinishedAmount() + contractItem.getFinishedAmount());
            sum.setCheckingAmount(sum.getCheckingAmount() + contractItem.getCheckingAmount());
            sum.setUnfinishedAmount(sum.getUnfinishedAmount() + contractItem.getUnfinishedAmount());
            sum.setRestAmount(sum.getRestAmount() + contractItem.getRestAmount());
            sum.setOwnedAmount(sum.getOwnedAmount() + contractItem.getOwnedAmount());
        }

        list.add(sum);

        this.resultJson = JsonHelper.fromCollection(list, result.getResultClass(), result.getTotalCount(), 4);
        return "success";
    }

    public String printQuery() {
        this.digDepth = 4;
        if (!StringUtils.isEmpty(getHQL()))
            this.HQLCondition = getHQL();
        else {
            this.HQLCondition = "";
        }
        Search search = createSearch(getEntityClass(), getEntityStateClass(), this.search, this.states, this.status, this.start, this.limit, this.HQLCondition, "query");
        SearchResult result = this.searchService.search(search);
        List items = result.get();
        try {
            this.contractService.print(items);
        } catch (IOException e) {
            result(false, e.getMessage());
        }
        return null;
    }

    protected void fillEntity(Entity entity)
            throws ParseException {
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


    public String getReport() {
        if (!StringUtils.isEmpty(getHQL()))
            this.HQLCondition = getHQL();
        else {
            this.HQLCondition = "";
        }

        Search search = createSearch(getEntityClass(), getEntityStateClass(), this.search, this.states, this.status, this.start, this.limit, this.HQLCondition, "query");

        SearchResult result = this.searchService.search(search);
        List<ContractItemOwnedSummeryView> list = result.get();
        ContractItemOwnedSummeryView sum = new ContractItemOwnedSummeryView();
        Product product = new Capacitor();
        product.setProductCombination("合计");
        sum.setProduct(product);
        sum.setProductCombination("合计1");
        for (ContractItemOwnedSummeryView contractItem : list) {
            sum.setAmount(sum.getAmount() + contractItem.getAmount());
            sum.setFinishedAmount(sum.getFinishedAmount() + contractItem.getFinishedAmount());
            sum.setCheckingAmount(sum.getCheckingAmount() + contractItem.getCheckingAmount());
            sum.setUnfinishedAmount(sum.getUnfinishedAmount() + contractItem.getUnfinishedAmount());
            sum.setRestAmount(sum.getRestAmount() + contractItem.getRestAmount());
            sum.setOwnedAmount(sum.getOwnedAmount() + contractItem.getOwnedAmount());
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
        String filename = dir + "\\" + "合同对库欠交汇总(" + strDate + ").xls";
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
            WritableSheet ws = e.createSheet("合同对库欠交汇总", 0);
            ws.getSettings().setPaperSize(PaperSize.A4);
            ws.getSettings().setOrientation(PageOrientation.LANDSCAPE);
            ws.setRowView(0, 600);
            ws.mergeCells(0, 0, 8, 0);
            WritableFont wFont = new WritableFont(WritableFont.createFont("宋体"), 18, WritableFont.BOLD);
            WritableCellFormat wcf = new WritableCellFormat(wFont);
            wcf.setAlignment(Alignment.CENTRE);
            wcf.setVerticalAlignment(VerticalAlignment.CENTRE);
            ws.addCell(new Label(0, 0, "合同对库欠交汇总", wcf));
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
            ws.setColumnView(1, 10);
            ws.setColumnView(8, 15);
            ws.setColumnView(9, 15);
            ws.setColumnView(10, 15);
            ws.addCell(new Label(0, 1, "产品名称及型号", wcfi));
            ws.addCell(new Label(1, 1, "产品代号", wcfi));
            ws.addCell(new Label(2, 1, "产品品种", wcfi));
            ws.addCell(new Label(3, 1, "数量合计", wcfi));
            ws.addCell(new Label(4, 1, "完成合计", wcfi));
            ws.addCell(new Label(5, 1, "审核合计", wcfi));
            ws.addCell(new Label(6, 1, "未完成合计", wcfi));
            ws.addCell(new Label(7, 1, "库存总数", wcfi));
            ws.addCell(new Label(8, 1, "欠交合计", wcfi));

            Integer row = new Integer(2);

            for (Iterator var22 = items.iterator(); var22.hasNext(); row = Integer.valueOf(row.intValue() + 1)) {
                ContractItemOwnedSummeryView item = (ContractItemOwnedSummeryView) var22.next();
                ws.addCell(new Label(0, row.intValue(), null == item.getProduct() ? "" : item.getProduct().getProductCombination(), wcfi2));
                ws.addCell(new Label(1, row.intValue(), null == item.getProduct().getProductCode() ? "" : item.getProduct().getProductCode().getName(), wcfi2));
                ws.addCell(new Label(2, row.intValue(), null == item.getProduct().getUsageType() ? "" : item.getProduct().getUsageType().getName(), wcfi2));
                ws.addCell(new Label(3, row.intValue(), BusiUtil.nvlToString(item.getAmount(), ""), wcfi2));
                ws.addCell(new Label(4, row.intValue(), BusiUtil.nvlToString(item.getFinishedAmount(), ""), wcfi2));
                ws.addCell(new Label(5, row.intValue(), BusiUtil.nvlToString(item.getCheckingAmount(), ""), wcfi2));
                ws.addCell(new Label(6, row.intValue(), BusiUtil.nvlToString(item.getUnfinishedAmount(), ""), wcfi2));
                ws.addCell(new Label(7, row.intValue(), BusiUtil.nvlToString(item.getRestAmount(), ""), wcfi2));
                ws.addCell(new Label(8, row.intValue(), BusiUtil.nvlToString(item.getOwnedAmount(), ""), wcfi2));
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

