//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.is.eus.service.biz.impl;

import com.is.eus.model.search.SearchResult;
import com.is.eus.pojo.basic.Company;
import com.is.eus.pojo.basic.Product;
import com.is.eus.pojo.basic.ProductCode;
import com.is.eus.pojo.basic.Unit;
import com.is.eus.pojo.basic.UsageType;
import com.is.eus.pojo.contract.Contract;
import com.is.eus.pojo.storage.StorageOutcoming;
import com.is.eus.pojo.storage.StorageOutcomingItem;
import com.is.eus.pojo.storage.StorageOutcomingPrint;
import com.is.eus.pojo.system.Sequence;
import com.is.eus.service.biz.ui.StorageOutcomingService;
import com.is.eus.service.exception.InvalidOperationException;
import com.is.eus.service.print.StorageOutcomingDataSource;
import com.is.eus.service.support.FileUtil;
import com.is.eus.service.support.ObservableServiceBase;
import com.is.eus.type.DataStatus;
import com.is.eus.type.StorageOutcomingState;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.format.Colour;
import jxl.format.PageOrientation;
import jxl.format.PaperSize;
import jxl.format.VerticalAlignment;
import jxl.write.Label;
import jxl.write.Number;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperRunManager;
import org.apache.commons.lang.StringUtils;
import org.apache.struts2.ServletActionContext;

public class StorageOutcomingServiceImpl extends ObservableServiceBase implements StorageOutcomingService {
    public StorageOutcomingServiceImpl() {
    }

    public void add(StorageOutcoming soc) throws InvalidOperationException {
        soc.setStatus(DataStatus.Using.ordinal());
        soc.setState(StorageOutcomingState.Checking.ordinal());
        soc.setSocNo("");
        super.add(soc);
        this.fire("Update_Contract_And_Storage_FromStorageOutcoming", soc);
    }

    public void update(StorageOutcoming soc) throws InvalidOperationException {
        if(StringUtils.isEmpty(soc.getPrintDate())) {
            SimpleDateFormat SequenceNo = new SimpleDateFormat("yyyy-MM-dd");
            Date sequence = new Date();
            String strDate = SequenceNo.format(sequence);
            soc.setPrintDate(strDate);
        }

        if(StringUtils.isEmpty(soc.getSocNo()) && soc.getState() != StorageOutcomingState.Failed.ordinal()) {
            String SequenceNo1 = this.sequenceService.acquire("SOC", true, 1);
            if(StringUtils.isEmpty(SequenceNo1)) {
                Sequence sequence1 = new Sequence();
                sequence1.setType("SOC");
                sequence1.setHead("");
                sequence1.setPrefix("");
                sequence1.setMiddle("1");
                sequence1.setPostfix("");
                sequence1.setTail("5");
                sequence1.setSequence(1);
                this.entityService.add(sequence1);
                SequenceNo1 = this.sequenceService.acquire("SOC", true, 1);
            }

            SequenceNo1 = SequenceNo1.substring(1, SequenceNo1.length());
            soc.setSocNo(SequenceNo1);
        }

        super.update(soc);
    }

    public void checkFailed(StorageOutcoming soc) throws InvalidOperationException {
        if(soc.getStatus() != DataStatus.Using.ordinal()) {
            throw new InvalidOperationException("该出库单已删除");
        } else if(soc.getState() != StorageOutcomingState.Checking.ordinal()) {
            throw new InvalidOperationException("该出库单的状态不是待审核状态");
        } else {
            soc.setState(StorageOutcomingState.Failed.ordinal());
            soc.setStatus(DataStatus.Deleted.ordinal());
            soc.setUpdateTime(new Date());
            soc.setSocChecker_createTime(new Date());
            super.update(soc);
            this.fire("RollBack_Contract_And_Storage_FromStorageOutcoming", soc);
        }
    }

    public void checkSuccess(StorageOutcoming soc) throws InvalidOperationException {
        if(soc.getStatus() != DataStatus.Using.ordinal()) {
            throw new InvalidOperationException("该出库单已删除");
        } else if(soc.getState() != StorageOutcomingState.Checking.ordinal()) {
            throw new InvalidOperationException("该出库单的状态不是待审核状态");
        } else {
            soc.setState(StorageOutcomingState.Success.ordinal());
            soc.setUpdateTime(new Date());
            soc.setSocChecker_createTime(new Date());
            super.update(soc);
            this.fire("Update_Contract_FromStorageOutcoming_AduitSuccess", soc);
        }
    }

    public SearchResult findByContract(Object[] values) throws InvalidOperationException {
        return this.searchService.search("com.is.eus.pojo.storage.StorageOutcoming.findByContract", values);
    }

    public void print(String id, boolean isPreview) throws IOException {
        StorageOutcoming soc = (StorageOutcoming)this.entityService.get(StorageOutcoming.class, id);
        if(!isPreview) {
            this.update(soc);
        }

        Contract contract = (Contract)this.entityService.get(Contract.class, soc.getContract().getId());
        Company company = (Company)this.entityService.get(Company.class, contract.getCompany().getId());
        ArrayList storageOutcomingPrint = new ArrayList();
        HashMap parameters = new HashMap();
        parameters.put("No", " No：" + soc.getSocNo());
        String strCompanyName = company.getName();
        if(!StringUtils.isEmpty(company.getDelegatee().trim())) {
            strCompanyName = strCompanyName + "(" + company.getDelegatee() + ")";
        }

        parameters.put("contractNo", contract.getContractNo());
        parameters.put("companyName", strCompanyName);
        parameters.put("tax", company.getTax());
        parameters.put("address", company.getAddress());
        parameters.put("commAddress", company.getCommAddress());
        parameters.put("contract", company.getContract() + "         " + contract.getContractNo());
        parameters.put("tele", company.getTele());
        parameters.put("bank", company.getBank());
        parameters.put("account", company.getAccount());
        parameters.put("zipCode", company.getZipCode());
        String totalAmount = this.FloatToString(Float.valueOf(soc.getTotalSum()));
        String sumWithoutTax = this.FloatToString(Float.valueOf(soc.getTotalSumWithoutTax()));
        String totalTaxAmount = this.FloatToString(Float.valueOf(soc.getTotalTaxAmount()));
        String strChinese = this.convertMoney(totalAmount, "0") + "  ￥" + totalAmount;
        parameters.put("totalAmount", totalAmount);
        parameters.put("sumWithoutTax", sumWithoutTax);
        parameters.put("totalTaxAmount", totalTaxAmount);
        parameters.put("strChinese", strChinese);
        parameters.put("strPrintDate", soc.getPrintDate());
        String[][] socItemID = new String[soc.getSocItems().size()][2];
        int iRow = 0;

        for(Iterator tempTotal = soc.getSocItems().iterator(); tempTotal.hasNext(); ++iRow) {
            StorageOutcomingItem tempTotalWithoutTax = (StorageOutcomingItem)tempTotal.next();
            socItemID[iRow][0] = Integer.toString(tempTotalWithoutTax.getSocItemNo());
            socItemID[iRow][1] = tempTotalWithoutTax.getId();
        }

        for(int var38 = 0; var38 < soc.getSocItems().size() - 1; ++var38) {
            for(int var40 = var38 + 1; var40 < soc.getSocItems().size(); ++var40) {
                if(Integer.parseInt(socItemID[var38][0]) > Integer.parseInt(socItemID[var40][0])) {
                    String tempTaxAmount = "";
                    String blankDS = "";
                    tempTaxAmount = socItemID[var38][0];
                    blankDS = socItemID[var38][1];
                    socItemID[var38][0] = socItemID[var40][0];
                    socItemID[var38][1] = socItemID[var40][1];
                    socItemID[var40][0] = tempTaxAmount;
                    socItemID[var40][1] = blankDS;
                }
            }
        }

        Float var39 = new Float(0.0F);
        Float var42 = new Float(0.0F);
        Float var43 = new Float(0.0F);

        ServletOutputStream ouputStream;
        int var44;
        for(var44 = 0; var44 < soc.getSocItems().size(); ++var44) {
            StorageOutcomingItem socDS = (StorageOutcomingItem)this.entityService.get(StorageOutcomingItem.class, socItemID[var44][1]);
            Product strPath = (Product)this.entityService.get(Product.class, socDS.getProduct().getId());
            Unit e = (Unit)this.entityService.get(Unit.class, strPath.getUnit().getId());
            UsageType var10000 = (UsageType)this.entityService.get(UsageType.class, strPath.getUsageType().getId());
            ouputStream = null;
            if(strPath.getProductCode() != null) {
                ProductCode var41 = (ProductCode)this.entityService.get(ProductCode.class, strPath.getProductCode().getId());
            }

            Integer amount = new Integer(socDS.getAmount());
            Float subTotalWithoutTax = new Float(socDS.getSubTotalWithoutTax());
            Float price = new Float(socDS.getPrice());
            Float priceWithoutTax = new Float(socDS.getPriceWithoutTax());
            Float subTotal = new Float(socDS.getSubTotal());
            Float taxAmount = new Float(socDS.getTaxAmount());
            StorageOutcomingPrint socItemPrint = new StorageOutcomingPrint();
            String strName = strPath.getProductCombination().trim();
            String strStandard = strPath.getStandard();
            if(!StringUtils.isEmpty(strStandard)) {
                strName = strName.substring(2, strName.length());
                strStandard = strStandard.trim();
            }

            socItemPrint.setPC(strName);
            socItemPrint.setUnit(e.getName());
            socItemPrint.setAmount(amount.toString());
            socItemPrint.setPrice(this.FloatToString(price));
            socItemPrint.setPriceWithoutTax(priceWithoutTax.toString());
            socItemPrint.setSubTotal(this.FloatToString(subTotal));
            socItemPrint.setSubTotalWithoutTax(this.FloatToString(subTotalWithoutTax));
            socItemPrint.setTax((new Integer(socDS.getTax())).toString() + "%");
            socItemPrint.setTaxAmount(this.FloatToString(taxAmount));
            socItemPrint.setMemo(strStandard);
            storageOutcomingPrint.add(socItemPrint);
            var39 = Float.valueOf(var39.floatValue() + subTotal.floatValue());
            var42 = Float.valueOf(var42.floatValue() + subTotalWithoutTax.floatValue());
            var43 = Float.valueOf(var43.floatValue() + taxAmount.floatValue());
            if((var44 + 1) % 6 == 0) {
                StorageOutcomingPrint socItemSubPrint = new StorageOutcomingPrint();
                socItemSubPrint.setPC("");
                socItemSubPrint.setUnit("");
                socItemSubPrint.setAmount("");
                socItemSubPrint.setPrice("");
                socItemSubPrint.setPriceWithoutTax("小计");
                socItemSubPrint.setSubTotal(this.FloatToString(var39));
                socItemSubPrint.setSubTotalWithoutTax(this.FloatToString(var42));
                socItemSubPrint.setTax("");
                socItemSubPrint.setTaxAmount(this.FloatToString(var43));
                socItemSubPrint.setMemo("");
                storageOutcomingPrint.add(socItemSubPrint);
                var39 = Float.valueOf(0.0F);
                var42 = Float.valueOf(0.0F);
                var43 = Float.valueOf(0.0F);
            }
        }

        var44 = 6 - soc.getSocItems().size() % 6;
        if(var44 > 0 && var44 < 6) {
            for(int var45 = 0; var45 < var44; ++var45) {
                StorageOutcomingPrint var48 = new StorageOutcomingPrint();
                var48.setPC("");
                var48.setUnit("");
                var48.setAmount("");
                var48.setPrice("");
                var48.setPriceWithoutTax("");
                var48.setSubTotal("");
                var48.setSubTotalWithoutTax("");
                var48.setTax("");
                var48.setTaxAmount("");
                var48.setMemo("");
                storageOutcomingPrint.add(var48);
            }

            StorageOutcomingPrint var46 = new StorageOutcomingPrint();
            var46.setPC("");
            var46.setUnit("");
            var46.setAmount("");
            var46.setPrice("");
            var46.setPriceWithoutTax("小计");
            var46.setSubTotal(this.FloatToString(var39));
            var46.setSubTotalWithoutTax(this.FloatToString(var42));
            var46.setTax("");
            var46.setTaxAmount(this.FloatToString(var43));
            var46.setMemo("");
            storageOutcomingPrint.add(var46);
        }

        StorageOutcomingDataSource var47 = new StorageOutcomingDataSource();
        var47.setStorageOutcomingPrint(storageOutcomingPrint);
        String var49 = ServletActionContext.getServletContext().getRealPath("/jasper");
        var49 = var49 + "/StorageOutcoming.jasper";

        try {
            byte[] var50 = JasperRunManager.runReportToPdf(var49, parameters, var47);
            HttpServletResponse response = ServletActionContext.getResponse();
            response.setContentType("application/pdf");
            response.setContentLength(var50.length);
            ouputStream = response.getOutputStream();

            try {
                ouputStream.write(var50, 0, var50.length);
                ouputStream.close();
                ouputStream.flush();
            } finally {
                if(ouputStream != null) {
                    ouputStream.close();
                }

            }
        } catch (JRException var37) {
            var37.printStackTrace();
        }

    }

    public File print2(String id) throws WriteException, IOException {
        String dir = FileUtil.tmpdir();
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HHmmss");
        Date date = new Date();
        String strDateTime = format.format(date);
        String filename = dir + "\\" + "出库单(" + strDateTime + ").xls";
        File file = new File(filename);
        if(file.exists()) {
            file.delete();

            try {
                file.createNewFile();
            } catch (IOException var38) {
                var38.printStackTrace();
                this.logger.warn("导出Excel文件失败!");
                return null;
            }
        }

        try {
            WritableWorkbook e = Workbook.createWorkbook(file);
            WritableSheet ws = e.createSheet("出库单", 0);
            ws.getSettings().setPaperSize(PaperSize.A4);
            ws.getSettings().setOrientation(PageOrientation.LANDSCAPE);
            ws.setColumnView(0, 10);
            ws.setColumnView(1, 10);
            ws.setColumnView(2, 10);
            ws.setColumnView(3, 10);
            ws.setColumnView(4, 10);
            ws.setColumnView(5, 10);
            ws.setColumnView(6, 10);
            ws.setColumnView(7, 10);
            ws.setColumnView(8, 10);
            ws.setColumnView(9, 10);
            ws.setColumnView(10, 10);
            ws.setRowView(0, 600);
            ws.mergeCells(0, 0, 10, 0);
            WritableFont wFont = new WritableFont(WritableFont.createFont("宋体"), 18, WritableFont.BOLD);
            WritableCellFormat wcf = new WritableCellFormat(wFont);
            wcf.setAlignment(Alignment.CENTRE);
            wcf.setVerticalAlignment(VerticalAlignment.CENTRE);
            ws.addCell(new Label(0, 0, "销售单(代出库单)", wcf));
            StorageOutcoming soc = (StorageOutcoming)this.entityService.get(StorageOutcoming.class, id);
            Contract contract = (Contract)this.entityService.get(Contract.class, soc.getContract().getId());
            Company company = (Company)this.entityService.get(Company.class, contract.getCompany().getId());
            WritableFont wFont2 = new WritableFont(WritableFont.createFont("宋体"), 10);
            WritableCellFormat wcf2 = new WritableCellFormat(wFont2);
            wcf2.setBorder(Border.ALL, BorderLineStyle.THIN, Colour.BLACK);
            wcf2.setAlignment(Alignment.CENTRE);
            wcf2.setVerticalAlignment(VerticalAlignment.CENTRE);
            wcf2.setWrap(true);
            WritableFont wFont2c = new WritableFont(WritableFont.createFont("宋体"), 10);
            WritableCellFormat wcf2c = new WritableCellFormat(wFont2c);
            wcf2c.setBorder(Border.ALL, BorderLineStyle.THIN, Colour.BLACK);
            wcf2c.setAlignment(Alignment.LEFT);
            wcf2c.setVerticalAlignment(VerticalAlignment.CENTRE);
            wcf2c.setWrap(true);
            byte row = 1;
            WritableFont wFontw = new WritableFont(WritableFont.createFont("宋体"), 10);
            WritableCellFormat wcfw = new WritableCellFormat(wFontw);
            wcfw.setAlignment(Alignment.CENTRE);
            wcfw.setVerticalAlignment(VerticalAlignment.CENTRE);
            SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd");
            String strDateTime2 = format2.format(date);
            ws.mergeCells(0, row, 2, row);
            ws.addCell(new Label(0, row, "开票日期:" + strDateTime2, wcfw));
            ws.addCell(new Label(8, row, "No:" + soc.getSocNo(), wcfw));
            int var41 = row + 1;
            ws.mergeCells(0, var41, 0, var41 + 4);
            ws.addCell(new Label(0, var41, "购货单位", wcf2));
            ws.addCell(new Label(1, var41, "名称", wcf2c));
            ws.mergeCells(2, var41, 10, var41);
            String strCompanyName = company.getName();
            if(!StringUtils.isEmpty(company.getDelegatee().trim())) {
                strCompanyName = strCompanyName + "(" + company.getDelegatee() + ")";
            }

            ws.addCell(new Label(2, var41, strCompanyName, wcf2c));
            ++var41;
            ws.addCell(new Label(1, var41, "税号", wcf2c));
            ws.mergeCells(2, var41, 5, var41);
            ws.addCell(new Label(2, var41, company.getTax(), wcf2c));
            ws.addCell(new Label(6, var41, "合同号", wcf2c));
            ws.mergeCells(7, var41, 10, var41);
            ws.addCell(new Label(7, var41, company.getContract(), wcf2c));
            ++var41;
            ws.addCell(new Label(1, var41, "开票地址", wcf2c));
            ws.mergeCells(2, var41, 5, var41);
            ws.addCell(new Label(2, var41, company.getAddress(), wcf2c));
            ws.addCell(new Label(6, var41, "电话", wcf2c));
            ws.mergeCells(7, var41, 10, var41);
            ws.addCell(new Label(7, var41, company.getTele(), wcf2c));
            ++var41;
            ws.addCell(new Label(1, var41, "开户行", wcf2c));
            ws.mergeCells(2, var41, 5, var41);
            ws.addCell(new Label(2, var41, company.getBank(), wcf2c));
            ws.addCell(new Label(6, var41, "收货地址", wcf2c));
            ws.mergeCells(7, var41, 10, var41);
            ws.addCell(new Label(7, var41, company.getCommAddress(), wcf2c));
            ++var41;
            ws.addCell(new Label(1, var41, "帐号", wcf2c));
            ws.mergeCells(2, var41, 5, var41);
            ws.addCell(new Label(2, var41, company.getAccount(), wcf2c));
            ws.addCell(new Label(6, var41, "邮编", wcf2c));
            ws.mergeCells(7, var41, 10, var41);
            ws.addCell(new Label(7, var41, company.getZipCode(), wcf2c));
            ++var41;
            ws.mergeCells(0, var41, 1, var41);
            ws.addCell(new Label(0, var41, "产品名称及型号", wcf2));
            ws.addCell(new Label(2, var41, "单位", wcf2));
            ws.addCell(new Label(3, var41, "数量", wcf2));
            ws.addCell(new Label(4, var41, "单价", wcf2));
            ws.addCell(new Label(5, var41, "不含税单价", wcf2));
            ws.addCell(new Label(6, var41, "金额", wcf2));
            ws.addCell(new Label(7, var41, "不含税金额", wcf2));
            ws.addCell(new Label(8, var41, "税率", wcf2));
            ws.addCell(new Label(9, var41, "税额", wcf2));
            ws.addCell(new Label(10, var41, "备注", wcf2));
            WritableFont wFonti = new WritableFont(WritableFont.createFont("宋体"), 10);
            WritableCellFormat wcfi = new WritableCellFormat(wFonti);
            wcfi.setBorder(Border.ALL, BorderLineStyle.THIN, Colour.BLACK);
            wcfi.setAlignment(Alignment.CENTRE);
            wcfi.setVerticalAlignment(VerticalAlignment.CENTRE);
            wcfi.setWrap(true);
            Iterator sumWithoutTax = soc.getSocItems().iterator();

            while(sumWithoutTax.hasNext()) {
                StorageOutcomingItem totalAmount = (StorageOutcomingItem)sumWithoutTax.next();
                ++var41;
                StorageOutcomingItem totalTaxAmount = (StorageOutcomingItem)this.entityService.get(StorageOutcomingItem.class, totalAmount.getId());
                Product strChinese = (Product)this.entityService.get(Product.class, totalTaxAmount.getProduct().getId());
                Unit strInfo = (Unit)this.entityService.get(Unit.class, strChinese.getUnit().getId());
                Float amount = new Float((float)totalTaxAmount.getAmount());
                Float subTotalWithoutTax = new Float(totalTaxAmount.getSubTotalWithoutTax());
                Float price = new Float(totalTaxAmount.getPrice());
                Float priceWithoutTax = new Float(totalTaxAmount.getPriceWithoutTax());
                Float subTotal = new Float(totalTaxAmount.getSubTotal());
                Float taxAmount = new Float(totalTaxAmount.getTaxAmount());
                ws.mergeCells(0, var41, 1, var41);
                ws.addCell(new Label(0, var41, strChinese.getProductCombination(), wcfi));
                ws.addCell(new Label(2, var41, strInfo.getName(), wcfi));
                ws.addCell(new Label(3, var41, amount.toString(), wcfi));
                ws.addCell(new Label(4, var41, price.toString(), wcfi));
                ws.addCell(new Label(5, var41, priceWithoutTax.toString(), wcfi));
                ws.addCell(new Label(6, var41, subTotal.toString(), wcfi));
                ws.addCell(new Label(7, var41, subTotalWithoutTax.toString(), wcfi));
                ws.addCell(new Number(8, var41, (double)totalTaxAmount.getTax(), wcfi));
                ws.addCell(new Label(9, var41, taxAmount.toString(), wcfi));
                ws.addCell(new Label(10, var41, totalTaxAmount.getMemo(), wcfi));
            }

            ++var41;
            ws.addCell(new Label(0, var41, "合计", wcfi));
            ws.mergeCells(1, var41, 5, var41);
            String var42 = (new Float(soc.getTotalSum())).toString();
            String var43 = (new Float(soc.getTotalSumWithoutTax())).toString();
            String var44 = (new Float(soc.getTotalTaxAmount())).toString();
            ws.addCell(new Label(1, var41, "", wcfi));
            ws.addCell(new Label(6, var41, var42, wcfi));
            ws.addCell(new Label(7, var41, var43, wcfi));
            ws.addCell(new Label(8, var41, "", wcfi));
            ws.addCell(new Label(9, var41, var44, wcfi));
            ws.addCell(new Label(10, var41, "", wcfi));
            ++var41;
            ws.addCell(new Label(0, var41, "价税合计", wcfi));
            ws.mergeCells(1, var41, 10, var41);
            String var45 = this.convertMoney(var42, "0") + "  ￥" + var42;
            ws.addCell(new Label(1, var41, var45, wcfi));
            ++var41;
            ws.addCell(new Label(0, var41, "单位名称", wcfi));
            ws.mergeCells(1, var41, 4, var41);
            ws.addCell(new Label(1, var41, "西安创联电容器有限责任公司（四三二零厂）", wcfi));
            ws.addCell(new Label(5, var41, "开票人", wcfi));
            ws.addCell(new Label(6, var41, "", wcfi));
            ws.addCell(new Label(7, var41, "", wcfi));
            ws.addCell(new Label(8, var41, "提货人", wcfi));
            ws.addCell(new Label(9, var41, "", wcfi));
            ws.addCell(new Label(10, var41, "", wcfi));
            ++var41;
            ws.mergeCells(0, var41, 10, var41);
            String var46 = "通讯：西安市100号信箱201分箱  电话：029-88243979  传真：029-88224471  邮编：710065";
            ws.addCell(new Label(0, var41, var46, wcfi));
            e.write();
            e.close();
            return file;
        } catch (WriteException var39) {
            var39.printStackTrace();
            return null;
        } catch (IOException var40) {
            var40.printStackTrace();
            return null;
        }
    }

    public String convertMoney(String num, String prec) {
        if(prec == null) {
            prec = "0";
        }

        if(prec.trim().equals("")) {
            prec = "0";
        }

        if(num == null) {
            return num;
        } else {
            String tmpM = num.trim();
            if(tmpM.equals("")) {
                return num;
            } else {
                tmpM = tmpM.replaceAll(",", "");
                boolean flag = false;
                boolean flag1 = false;
                String retval = "";
                String ch1 = "";
                int i;
                String ch;
                char tmp;
                if(prec.equals("0")) {
                    if(tmpM.indexOf(".") == -1) {
                        flag = true;
                    } else if(tmpM.substring(tmpM.indexOf(".")).length() == 2) {
                        flag1 = true;
                    }

                    tmpM = tmpM.replaceAll("\\.", "");
                    if(flag) {
                        tmpM = tmpM + "00";
                    }

                    if(flag1) {
                        tmpM = tmpM + "0";
                    }

                    for(i = 0; i < tmpM.length(); ++i) {
                        ch = "";
                        tmp = tmpM.charAt(tmpM.length() - i - 1);
                        if(tmp == 49) {
                            ch1 = "壹";
                        } else if(tmp == 50) {
                            ch1 = "贰";
                        } else if(tmp == 51) {
                            ch1 = "叁";
                        } else if(tmp == 52) {
                            ch1 = "肆";
                        } else if(tmp == 53) {
                            ch1 = "伍";
                        } else if(tmp == 54) {
                            ch1 = "陆";
                        } else if(tmp == 55) {
                            ch1 = "柒";
                        } else if(tmp == 56) {
                            ch1 = "捌";
                        } else if(tmp == 57) {
                            ch1 = "玖";
                        }

                        if(tmp == 48) {
                            if(i == 0) {
                                ch = "零分";
                            } else if(i == 1) {
                                ch = "零角";
                            } else if(i == 2) {
                                ch = "元";
                            } else if(i == 6) {
                                ch = "万";
                            } else if(i == 10) {
                                ch = "亿";
                            } else if(i != tmpM.length() - 1) {
                                ch = "零";
                            }
                        } else {
                            if(i == 0) {
                                ch = ch1 + "分";
                            }

                            if(i == 1) {
                                ch = ch1 + "角";
                            }

                            if(i == 2) {
                                ch = ch1 + "元";
                            }

                            if(i == 3 || i == 7 || i == 11) {
                                ch = ch1 + "拾";
                            }

                            if(i == 4 || i == 8) {
                                ch = ch1 + "佰";
                            }

                            if(i == 5 || i == 9) {
                                ch = ch1 + "仟";
                            }

                            if(i == 6) {
                                ch = ch1 + "万";
                            }

                            if(i == 10) {
                                ch = ch1 + "亿";
                            }
                        }

                        retval = ch + retval;
                    }
                } else if(prec.equals("1")) {
                    if(tmpM.indexOf(".") == -1) {
                        flag = true;
                    }

                    tmpM = tmpM.replaceAll("\\.", "");
                    if(flag) {
                        tmpM = tmpM + "0";
                    }

                    for(i = 0; i < tmpM.length(); ++i) {
                        ch = "";
                        tmp = tmpM.charAt(tmpM.length() - i - 1);
                        if(tmp == 49) {
                            ch1 = "壹";
                        } else if(tmp == 50) {
                            ch1 = "贰";
                        } else if(tmp == 51) {
                            ch1 = "叁";
                        } else if(tmp == 52) {
                            ch1 = "肆";
                        } else if(tmp == 53) {
                            ch1 = "伍";
                        } else if(tmp == 54) {
                            ch1 = "陆";
                        } else if(tmp == 55) {
                            ch1 = "柒";
                        } else if(tmp == 56) {
                            ch1 = "捌";
                        } else if(tmp == 57) {
                            ch1 = "玖";
                        }

                        if(tmp == 48) {
                            if(i == 0) {
                                ch = "零角";
                            } else if(i == 1) {
                                ch = "元";
                            } else if(i == 5) {
                                ch = "万";
                            } else if(i == 10) {
                                ch = "亿";
                            } else if(i != tmpM.length() - 1) {
                                ch = "零";
                            }
                        } else {
                            if(i == 0) {
                                ch = ch1 + "角";
                            }

                            if(i == 1) {
                                ch = ch1 + "元";
                            }

                            if(i == 2 || i == 6 || i == 10) {
                                ch = ch1 + "拾";
                            }

                            if(i == 3 || i == 7) {
                                ch = ch1 + "佰";
                            }

                            if(i == 4 || i == 8) {
                                ch = ch1 + "仟";
                            }

                            if(i == 5) {
                                ch = ch1 + "万";
                            }

                            if(i == 9) {
                                ch = ch1 + "亿";
                            }
                        }

                        retval = ch + retval;
                    }
                } else {
                    for(i = 0; i < tmpM.length(); ++i) {
                        ch = "";
                        tmp = tmpM.charAt(tmpM.length() - i - 1);
                        if(tmp == 49) {
                            ch1 = "壹";
                        } else if(tmp == 50) {
                            ch1 = "贰";
                        } else if(tmp == 51) {
                            ch1 = "叁";
                        } else if(tmp == 52) {
                            ch1 = "肆";
                        } else if(tmp == 53) {
                            ch1 = "伍";
                        } else if(tmp == 54) {
                            ch1 = "陆";
                        } else if(tmp == 55) {
                            ch1 = "柒";
                        } else if(tmp == 56) {
                            ch1 = "捌";
                        } else if(tmp == 57) {
                            ch1 = "玖";
                        }

                        if(tmp == 48) {
                            if(i == 0) {
                                ch = "元";
                            } else if(i == 4) {
                                ch = "万";
                            } else if(i == 9) {
                                ch = "亿";
                            } else if(i != tmpM.length() - 1) {
                                ch = "零";
                            }
                        } else {
                            if(i == 0) {
                                ch = ch1 + "元";
                            }

                            if(i == 1 || i == 5 || i == 9) {
                                ch = ch1 + "拾";
                            }

                            if(i == 2 || i == 6) {
                                ch = ch1 + "佰";
                            }

                            if(i == 3 || i == 7) {
                                ch = ch1 + "仟";
                            }

                            if(i == 4) {
                                ch = ch1 + "万";
                            }

                            if(i == 8) {
                                ch = ch1 + "亿";
                            }
                        }

                        retval = ch + retval;
                    }
                }

                retval = retval.replaceAll("零角零分", "");
                retval = retval.replaceAll("零分", "零");
                retval = retval.replaceAll("零角", "零");
                retval = retval.replaceAll("零拾", "零");
                retval = retval.replaceAll("零佰", "零");
                retval = retval.replaceAll("零仟", "零");
                retval = retval.replaceAll("零亿", "");
                retval = retval.replaceAll("零零", "零");
                retval = retval.replaceAll("零零元", "元");
                retval = retval.replaceAll("零元", "元");
                retval = retval.replaceAll("零零万", "万");
                retval = retval.replaceAll("零万", "万");
                retval = retval.replaceAll("亿万", "亿零");
                retval = retval.replaceAll("零零", "零");
                if(retval.substring(retval.length() - 1).equals("零")) {
                    retval = retval.substring(0, retval.length() - 1);
                }

                return retval;
            }
        }
    }

    private String FloatToString(Float inputFloat) {
        String result = inputFloat.toString().trim();
        String[] strParts = result.split("\\.");
        if(strParts.length == 2 && strParts[1].length() == 1) {
            result = result + "0";
        }

        return result;
    }
}
