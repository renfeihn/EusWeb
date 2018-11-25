package com.is.eus.service.basic.impl;

import com.is.eus.model.search.SearchResult;
import com.is.eus.pojo.basic.Capacitor;
import com.is.eus.pojo.basic.Company;
import com.is.eus.pojo.basic.Product;
import com.is.eus.pojo.schedule.Schedule;
import com.is.eus.service.basic.ui.CompanyService;
import com.is.eus.service.exception.InvalidOperationException;
import com.is.eus.service.support.FileUtil;
import com.is.eus.service.support.ObservableServiceBase;
import com.is.eus.type.DataStatus;
import com.sun.corba.se.impl.presentation.rmi.IDLTypeException;
import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.PageOrientation;
import jxl.format.PaperSize;
import jxl.format.VerticalAlignment;
import jxl.write.*;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

public class CompanyServiceImpl extends ObservableServiceBase
        implements CompanyService {
    public void add(Company company)
            throws InvalidOperationException {
        company.setState(DataStatus.Using.ordinal());
        super.add(company);
    }

    public void remove(String id) throws InvalidOperationException {
        Company company = (Company) super.get(Company.class, id);
        super.remove(company);
    }

    public void udpate(Company company) throws InvalidOperationException {
        if (company.getState() != DataStatus.Using.ordinal()) {
            throw new InvalidOperationException("修改失败");
        }
        super.update(company);
    }

    /**
     * 导出厂商信息
     *
     * @return
     */
    public File getReport() {
        String dir = FileUtil.tmpdir();
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HHmmss");
        Date date = new Date();
        String strDateTime = format.format(date);
        SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd");
        Date date2 = new Date();
        String strDate = format2.format(date2);
        String filename = dir + "\\" + "厂商信息(" + strDate + ").xls";
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
            ws.mergeCells(0, 0, 5, 0);
            WritableFont wFont = new WritableFont(WritableFont.createFont("宋体"), 18, WritableFont.BOLD);
            WritableCellFormat wcf = new WritableCellFormat(wFont);
            wcf.setAlignment(Alignment.CENTRE);
            wcf.setVerticalAlignment(VerticalAlignment.CENTRE);
            ws.addCell(new Label(0, 0, "厂商信息", wcf));
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
            ws.setColumnView(0, 50);
            ws.setColumnView(1, 20);
            ws.setColumnView(8, 15);
            ws.setColumnView(9, 15);
            ws.setColumnView(10, 15);
            ws.addCell(new Label(0, 1, "厂商名称", wcfi));
            ws.addCell(new Label(1, 1, "代表人", wcfi));
            ws.addCell(new Label(2, 1, "合同号", wcfi));
            ws.addCell(new Label(3, 1, "厂商地址", wcfi));
            ws.addCell(new Label(4, 1, "省", wcfi));
            ws.addCell(new Label(5, 1, "市", wcfi));
            SearchResult sr = this.searchService.search("com.is.eus.pojo.basic.Company.find");
            List items = sr.get();
            Integer row = new Integer(2);

            for (Iterator var22 = items.iterator(); var22.hasNext(); row = Integer.valueOf(row.intValue() + 1)) {
                Company item = (Company) var22.next();
                ws.addCell(new Label(0, row.intValue(), item.getName(), wcfi2));
                ws.addCell(new Label(1, row.intValue(), item.getDelegatee(), wcfi2));
                ws.addCell(new Label(2, row.intValue(), item.getContract(), wcfi2));
                ws.addCell(new Label(3, row.intValue(), item.getAddress(), wcfi2));
                ws.addCell(new Label(4, row.intValue(), item.getProvince().getName(), wcfi2));
                ws.addCell(new Label(5, row.intValue(), item.getCity().getName(), wcfi2));
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
