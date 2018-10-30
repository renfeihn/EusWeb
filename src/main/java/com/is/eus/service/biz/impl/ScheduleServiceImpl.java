//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.is.eus.service.biz.impl;

import com.is.eus.model.event.Event;
import com.is.eus.model.event.Listener;
import com.is.eus.model.search.SearchResult;
import com.is.eus.pojo.Entity;
import com.is.eus.pojo.basic.Capacitor;
import com.is.eus.pojo.basic.Product;
import com.is.eus.pojo.contract.Contract;
import com.is.eus.pojo.contract.ContractItem;
import com.is.eus.pojo.schedule.Schedule;
import com.is.eus.pojo.schedule.SchedulePrint;
import com.is.eus.pojo.schedule.ScheduleSummeryView;
import com.is.eus.pojo.schedule.ScheduleView;
import com.is.eus.pojo.storage.InWarehouse;
import com.is.eus.pojo.storage.StorageIncoming;
import com.is.eus.pojo.storage.StorageIncomingItem;
import com.is.eus.pojo.storage.StorageResource;
import com.is.eus.pojo.system.Employee;
import com.is.eus.pojo.system.Sequence;
import com.is.eus.service.biz.ui.ScheduleService;
import com.is.eus.service.biz.ui.StorageResourceService;
import com.is.eus.service.exception.InvalidOperationException;
import com.is.eus.service.print.ScheduleDataSource;
import com.is.eus.service.support.FileUtil;
import com.is.eus.service.support.ObservableServiceBase;
import com.is.eus.type.DataStatus;
import com.is.eus.type.ScheduleState;
import com.is.eus.type.ScheduleType;
import com.is.eus.type.StorageIncomingState;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
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
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperRunManager;
import org.apache.commons.lang.StringUtils;
import org.apache.struts2.ServletActionContext;

public class ScheduleServiceImpl extends ObservableServiceBase implements ScheduleService, Listener {
    private StorageResourceService storageResourceService;

    public ScheduleServiceImpl() {
    }

    public void setStorageResourceService(StorageResourceService storageResourceService) {
        this.storageResourceService = storageResourceService;
    }

    public void add(Schedule schedule) throws InvalidOperationException {
        schedule.setStatus(DataStatus.Using.ordinal());
        String SequenceNo = this.sequenceService.acquire("Schedule", true, 2);
        if(StringUtils.isEmpty(SequenceNo)) {
            Sequence strSNo = new Sequence();
            strSNo.setType("Schedule");
            strSNo.setHead("");
            strSNo.setPrefix("");
            strSNo.setMiddle("1");
            strSNo.setPostfix("");
            strSNo.setTail("5");
            strSNo.setSequence(1);
            this.entityService.add(strSNo);
            SequenceNo = this.sequenceService.acquire("Schedule", true, 2);
        }

        SequenceNo = SequenceNo.substring(1, SequenceNo.length());
        String[] strSNo1 = SequenceNo.split("-");
        SequenceNo = strSNo1[0].substring(0, 6) + "-" + strSNo1[1];
        schedule.setScheduleNo(SequenceNo);
        Calendar cal = Calendar.getInstance();
        int iQuarter = cal.get(2) / 3 + 1;
        if(1 == iQuarter) {
            schedule.setQ1(1);
        } else {
            schedule.setQ1(0);
        }

        if(2 == iQuarter) {
            schedule.setQ2(1);
        } else {
            schedule.setQ2(0);
        }

        if(3 == iQuarter) {
            schedule.setQ3(1);
        } else {
            schedule.setQ3(0);
        }

        if(4 == iQuarter) {
            schedule.setQ4(1);
        } else {
            schedule.setQ4(0);
        }

        schedule.setFinishedAmount(0);
        if(StringUtils.isEmpty(schedule.getContractNo())) {
            schedule.setState(ScheduleState.Saved.ordinal());
        } else {
            schedule.setState(ScheduleState.None.ordinal());
        }

        super.add(schedule);
    }

    public void remove(String id) throws InvalidOperationException {
        Schedule schedule = (Schedule)super.get(Schedule.class, id);
        super.remove(schedule);
    }

    public void udpate(Schedule schedule) throws InvalidOperationException {
        if(schedule.getStatus() != DataStatus.Using.ordinal()) {
            throw new InvalidOperationException("计划修改失败!");
        } else {
            super.update(schedule);
        }
    }

    public void udpateByBiz(Schedule schedule, int iType) throws InvalidOperationException {
        if(iType != 5 && !StringUtils.isEmpty(schedule.getContractNo())) {
            throw new InvalidOperationException("审核的计划不是预投计划");
        } else {
            if(iType == 0) {
                if(schedule.getState() != ScheduleState.Saved.ordinal() && schedule.getState() != ScheduleState.AduitFailed.ordinal()) {
                    throw new InvalidOperationException("计划状态不为[已保存]或[审核失败]状态");
                }

                schedule.setState(ScheduleState.WaitForAduilt.ordinal());
            }

            if(iType == 1) {
                if(schedule.getState() != ScheduleState.WaitForAduilt.ordinal()) {
                    throw new InvalidOperationException("计划状态不为[待审核]状态");
                }

                schedule.setState(ScheduleState.AduitFailed.ordinal());
            }

            if(iType == 2) {
                if(schedule.getState() != ScheduleState.WaitForAduilt.ordinal()) {
                    throw new InvalidOperationException("计划状态不为[待审核]状态");
                }

                schedule.setScheduleType(ScheduleType.SchduleType.ordinal());
                schedule.setState(ScheduleState.None.ordinal());
            }

            if(iType == 3 && schedule.getState() == ScheduleState.WaitForAduilt.ordinal()) {
                throw new InvalidOperationException("计划状态为[待审核]状态,不能进行修改");
            } else {
                if(iType == 4) {
                    if(schedule.getState() != ScheduleState.Saved.ordinal() && schedule.getState() != ScheduleState.AduitFailed.ordinal()) {
                        throw new InvalidOperationException("计划状态不为[已保存]或[审核失败]状态");
                    }

                    schedule.setStatus(DataStatus.Deleted.ordinal());
                }

                if(iType == 5) {
                    if(schedule.getState() != ScheduleState.None.ordinal() && schedule.getState() != ScheduleState.Part.ordinal()) {
                        throw new InvalidOperationException("计划状态不为[未完成]或[部分完成]状态");
                    }

                    schedule.setStatus(DataStatus.Deleted.ordinal());
                    schedule.setState(ScheduleState.Terminated.ordinal());
                }

                this.update(schedule);
            }
        }
    }

    public SearchResult findProduct(Object[] values) throws InvalidOperationException {
        return this.searchService.search("com.is.eus.pojo.schedule.Schedule.findProduct", values);
    }

    public void notice(Event event) throws InvalidOperationException {
        String name = event.getName();
        Entity entity = event.getEntity();
        if(name.equals("ScheduleFromContract")) {
            this.ScheduleFromContract(entity);
        }

        if(name.equals("Schedule_FromStorageIncoming")) {
            this.ScheduleFromStorageIncoming(entity);
        }

        if(name.equals("Schedule_RollBack_FromStorageIncoming")) {
            this.ScheduleRollBackFromStorageIncoming(entity);
        }

    }

    private void ScheduleFromContract(Entity entity) throws InvalidOperationException {
        Contract contract = (Contract)entity;
        Set items = contract.getItems();
        Iterator var5 = items.iterator();

        while(var5.hasNext()) {
            ContractItem item = (ContractItem)var5.next();
            Schedule schedule = new Schedule();
            Product product = (Product)this.entityService.get(Product.class, item.getProduct().getId());
            Employee creator = (Employee)this.entityService.get(Employee.class, item.getCreator().getId());
            schedule.setContractNo(contract.getContractNo());
            schedule.setProduct(product);
            schedule.setAmount(item.getAmount());
            schedule.setMemo(item.getMemo());
            schedule.setScheduleDate(contract.getContractDate());
            schedule.setCreateTime(new Date());
            schedule.setCreator(creator);
            schedule.setScheduleType(ScheduleType.ContractType.ordinal());
            StorageResource storageResource = this.storageResourceService.findStorageResource(product);
            int minAmount = Integer.parseInt(product.getMemo());
            if(storageResource == null) {
                schedule.setAmount(schedule.getAmount() + minAmount);
                this.add(schedule);
            } else {
                int amount = schedule.getAmount();
                int srAmount = storageResource.getAmount();
                int restAmount = srAmount - amount;
                if(restAmount < 0) {
                    if(srAmount < 0) {
                        schedule.setAmount(amount);
                    }

                    if(srAmount > 0) {
                        if(srAmount < amount) {
                            schedule.setAmount(0 - restAmount + minAmount);
                        } else {
                            schedule.setAmount(0 - restAmount);
                        }
                    }

                    if(srAmount == 0) {
                        schedule.setAmount(schedule.getAmount() + minAmount);
                    }

                    this.add(schedule);
                }
            }
        }

    }

    private void ScheduleFromStorageIncoming(Entity entity) {
        StorageIncoming sic = (StorageIncoming)entity;
        Set items = sic.getItems();
        Iterator var5 = items.iterator();

        while(var5.hasNext()) {
            StorageIncomingItem item = (StorageIncomingItem)var5.next();
            Schedule schedule = (Schedule)this.entityService.get(Schedule.class, item.getSchedule().getId());
            int finishedAmount = schedule.getFinishedAmount() + item.getAmount();
            if(finishedAmount > schedule.getAmount()) {
                boolean overAmount = false;
                int overAmount1;
                if(schedule.getState() != ScheduleState.Complete.ordinal()) {
                    overAmount1 = finishedAmount - schedule.getAmount();
                } else {
                    overAmount1 = item.getAmount();
                }

                schedule.setState(ScheduleState.Complete.ordinal());
                InWarehouse iw = new InWarehouse();
                iw.setProduct(item.getProduct());
                iw.setCreateTime(new Date());
                iw.setCreator(sic.getCreator());
                iw.setTotalAmount(overAmount1);
                iw.setMemo(schedule.getScheduleNo());
                iw.setStorageLocation(item.getStorageLocation());
                iw.setFlag(2);
                this.entityService.add(iw);
            }

            if(finishedAmount > 0 && finishedAmount < schedule.getAmount()) {
                schedule.setState(ScheduleState.Part.ordinal());
            }

            if(finishedAmount == schedule.getAmount()) {
                schedule.setState(ScheduleState.Complete.ordinal());
            }

            schedule.setFinishedAmount(finishedAmount);
            schedule.setUpdater(sic.getCreator());
            schedule.setUpdateTime(new Date());
            this.update(schedule);
        }

    }

    private void ScheduleRollBackFromStorageIncoming(Entity entity) {
        StorageIncoming sic = (StorageIncoming)entity;
        boolean isFailed = false;
        if(sic.getState() == StorageIncomingState.CheckerFailed.ordinal() || sic.getState() == StorageIncomingState.ManagerFaild.ordinal()) {
            isFailed = true;
        }

        if(isFailed) {
            Set items = sic.getItems();
            Iterator var6 = items.iterator();

            while(var6.hasNext()) {
                StorageIncomingItem item = (StorageIncomingItem)var6.next();
                Schedule schedule = (Schedule)this.entityService.get(Schedule.class, item.getSchedule().getId());
                int finishedAmount = schedule.getFinishedAmount() - item.getAmount();
                if(finishedAmount < 0) {
                    throw new InvalidOperationException("完成数量小于0");
                }

                if(finishedAmount == 0) {
                    schedule.setState(ScheduleState.None.ordinal());
                }

                if(finishedAmount > 0) {
                    schedule.setState(ScheduleState.Part.ordinal());
                }

                schedule.setFinishedAmount(finishedAmount);
                schedule.setUpdater(sic.getCreator());
                schedule.setUpdateTime(new Date());
                this.update(schedule);
            }

        }
    }

    public File getReport() {
        String dir = FileUtil.tmpdir();
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HHmmss");
        Date date = new Date();
        String strDateTime = format.format(date);
        SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd");
        Date date2 = new Date();
        String strDate = format2.format(date2);
        String filename = dir + "\\" + "计划(" + strDateTime + ").xls";
        File file = new File(filename);
        if(file.exists()) {
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
            WritableSheet ws = e.createSheet("计划", 0);
            ws.getSettings().setPaperSize(PaperSize.A4);
            ws.getSettings().setOrientation(PageOrientation.LANDSCAPE);
            ws.setRowView(0, 600);
            ws.mergeCells(0, 0, 8, 0);
            WritableFont wFont = new WritableFont(WritableFont.createFont("宋体"), 18, WritableFont.BOLD);
            WritableCellFormat wcf = new WritableCellFormat(wFont);
            wcf.setAlignment(Alignment.CENTRE);
            wcf.setVerticalAlignment(VerticalAlignment.CENTRE);
            ws.addCell(new Label(0, 0, "计划 " + strDate, wcf));
            WritableFont wFonti = new WritableFont(WritableFont.createFont("宋体"), 10);
            WritableCellFormat wcfi = new WritableCellFormat(wFonti);
            wcfi.setBorder(Border.ALL, BorderLineStyle.THIN, Colour.BLACK);
            wcfi.setAlignment(Alignment.CENTRE);
            wcfi.setVerticalAlignment(VerticalAlignment.CENTRE);
            wcfi.setWrap(false);
            WritableFont wFonti2 = new WritableFont(WritableFont.createFont("宋体"), 10);
            WritableCellFormat wcfi2 = new WritableCellFormat(wFonti2);
            wcfi2.setBorder(Border.ALL, BorderLineStyle.THIN, Colour.BLACK);
            wcfi2.setAlignment(Alignment.LEFT);
            wcfi2.setVerticalAlignment(VerticalAlignment.CENTRE);
            wcfi2.setWrap(false);
            ws.setColumnView(0, 20);
            ws.setColumnView(1, 50);
            ws.setColumnView(8, 15);
            ws.setColumnView(9, 20);
            ws.setColumnView(10, 15);
            ws.addCell(new Label(0, 1, "计划编号", wcfi));
            ws.addCell(new Label(1, 1, "产品名称及型号", wcfi));
            ws.addCell(new Label(2, 1, "计划数量", wcfi));
            ws.addCell(new Label(3, 1, "完成数量", wcfi));
            ws.addCell(new Label(4, 1, "一季", wcfi));
            ws.addCell(new Label(5, 1, "二季", wcfi));
            ws.addCell(new Label(6, 1, "三季", wcfi));
            ws.addCell(new Label(7, 1, "四季", wcfi));
            ws.addCell(new Label(8, 1, "交货期", wcfi));
            ws.addCell(new Label(9, 1, "合同号", wcfi));
            ws.addCell(new Label(10, 1, "备注", wcfi));
            SearchResult sr = this.searchService.search("com.is.eus.pojo.schedule.Schedule.findUnfinished");
            List items = sr.get();
            Integer row = new Integer(2);

            for(Iterator var22 = items.iterator(); var22.hasNext(); row = Integer.valueOf(row.intValue() + 1)) {
                Schedule item = (Schedule)var22.next();
                Capacitor capacitor = (Capacitor)this.entityService.get(Product.class, item.getProduct().getId());
                String strQ1 = item.getQ1() == 0?"":"√";
                String strQ2 = item.getQ2() == 0?"":"√";
                String strQ3 = item.getQ3() == 0?"":"√";
                String strQ4 = item.getQ4() == 0?"":"√";
                ws.addCell(new Label(0, row.intValue(), item.getScheduleNo(), wcfi));
                ws.addCell(new Label(1, row.intValue(), capacitor.getProductCombination(), wcfi2));
                ws.addCell(new Label(2, row.intValue(), (new Integer(item.getAmount())).toString(), wcfi));
                ws.addCell(new Label(3, row.intValue(), (new Integer(item.getFinishedAmount())).toString(), wcfi));
                ws.addCell(new Label(4, row.intValue(), strQ1, wcfi));
                ws.addCell(new Label(5, row.intValue(), strQ2, wcfi));
                ws.addCell(new Label(6, row.intValue(), strQ3, wcfi));
                ws.addCell(new Label(7, row.intValue(), strQ4, wcfi));
                ws.addCell(new Label(8, row.intValue(), format2.format(item.getScheduleDate()), wcfi));
                ws.addCell(new Label(9, row.intValue(), item.getContractNo(), wcfi));
                ws.addCell(new Label(10, row.intValue(), item.getMemo(), wcfi));
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

    public void printView(List<ScheduleView> scheduleViewList, String title, String duration) throws IOException {
        HashMap parameters = new HashMap();
        ArrayList schedulePrint = new ArrayList();
        parameters.put("Title", title);
        Integer i = Integer.valueOf(1);
        int allAmount = 0;
        int allFinishedAmount = 0;
        int allUnfinishedAmount = 0;
        Iterator blankDS = scheduleViewList.iterator();

        String strPath;
        while(blankDS.hasNext()) {
            ScheduleView spTotal = (ScheduleView)blankDS.next();
            Product scheduleDS = (Product)this.entityService.get(Product.class, spTotal.getProduct().getId());
            strPath = spTotal.getQ1() == 0?"":"√";
            String e = spTotal.getQ2() == 0?"":"√";
            String response = spTotal.getQ3() == 0?"":"√";
            String ouputStream = spTotal.getQ4() == 0?"":"√";
            SchedulePrint sp = new SchedulePrint();
            sp.setItemNo(i.toString());
            String strStandard = scheduleDS.getStandard();
            if(StringUtils.isEmpty(strStandard)) {
                sp.setPC(scheduleDS.getProductCombination().trim());
            } else {
                sp.setPC(scheduleDS.getProductCombination().substring(2, scheduleDS.getProductCombination().trim().length()) + "(" + strStandard.trim() + ")");
            }

            sp.setAmount(String.valueOf(spTotal.getAmount()));
            sp.setFinishedAmount(String.valueOf(spTotal.getFinishedAmount()));
            int unfinishedAmount = 0;
            if(spTotal.getAmount() > spTotal.getFinishedAmount()) {
                unfinishedAmount = spTotal.getAmount() - spTotal.getFinishedAmount();
            }

            sp.setUnfinishedAmount(String.valueOf(unfinishedAmount));
            sp.setQ1(spTotal.getScheduleDate().toString());
            sp.setQ2(e);
            sp.setQ3(response);
            sp.setQ4(ouputStream);
            sp.setMemo(spTotal.getScheduleNo());
            allAmount += spTotal.getAmount();
            allFinishedAmount += spTotal.getFinishedAmount();
            allUnfinishedAmount += unfinishedAmount;
            i = Integer.valueOf(i.intValue() + 1);
            schedulePrint.add(sp);
        }

        SchedulePrint var24 = new SchedulePrint();
        var24.setItemNo("");
        var24.setPC("合计:");
        var24.setAmount(String.valueOf(allAmount));
        var24.setFinishedAmount(String.valueOf(allFinishedAmount));
        var24.setUnfinishedAmount(String.valueOf(allUnfinishedAmount));
        var24.setQ1("");
        var24.setQ2("");
        var24.setQ3("");
        var24.setQ4("");
        var24.setMemo("");
        schedulePrint.add(var24);
        parameters.put("Duration", duration);
        int var25 = 16 - (scheduleViewList.size() + 1) % 16;
        if(var25 > 0 && var25 < 16) {
            for(int var26 = 0; var26 < var25; ++var26) {
                SchedulePrint var28 = new SchedulePrint();
                var28.setItemNo("");
                var28.setPC("");
                var28.setAmount("");
                var28.setFinishedAmount("");
                var28.setUnfinishedAmount("");
                var28.setQ1("");
                var28.setQ2("");
                var28.setQ3("");
                var28.setQ4("");
                var28.setMemo("");
                schedulePrint.add(var28);
            }
        }

        ScheduleDataSource var27 = new ScheduleDataSource();
        var27.setSchedulePrint(schedulePrint);
        strPath = ServletActionContext.getServletContext().getRealPath("/jasper");
        strPath = strPath + "/Schedule.jasper";

        try {
            byte[] var29 = JasperRunManager.runReportToPdf(strPath, parameters, var27);
            HttpServletResponse var30 = ServletActionContext.getResponse();
            var30.setContentType("application/pdf");
            var30.setContentLength(var29.length);
            ServletOutputStream var31 = var30.getOutputStream();

            try {
                var31.write(var29, 0, var29.length);
                var31.close();
                var31.flush();
            } finally {
                if(var31 != null) {
                    var31.close();
                }

            }
        } catch (JRException var23) {
            var23.printStackTrace();
        }

    }

    public void print(List<Schedule> scheduleList, String title, String duration) throws IOException {
        HashMap parameters = new HashMap();
        ArrayList schedulePrint = new ArrayList();
        parameters.put("Title", title);
        Integer i = Integer.valueOf(1);
        int allAmount = 0;
        int allFinishedAmount = 0;
        int allUnfinishedAmount = 0;
        Iterator scheduleDS = scheduleList.iterator();

        while(scheduleDS.hasNext()) {
            Schedule blankDS = (Schedule)scheduleDS.next();
            Product strPath = (Product)this.entityService.get(Product.class, blankDS.getProduct().getId());
            String e = blankDS.getQ1() == 0?"":"√";
            String response = blankDS.getQ2() == 0?"":"√";
            String ouputStream = blankDS.getQ3() == 0?"":"√";
            String strQ4 = blankDS.getQ4() == 0?"":"√";
            int unfinishedAmount = 0;
            if(blankDS.getAmount() > blankDS.getFinishedAmount()) {
                unfinishedAmount = blankDS.getAmount() - blankDS.getFinishedAmount();
            }

            SchedulePrint sp = new SchedulePrint();
            sp.setItemNo(i.toString());
            sp.setPC(strPath.getProductCombination());
            sp.setAmount(String.valueOf(blankDS.getAmount()));
            sp.setFinishedAmount(String.valueOf(blankDS.getFinishedAmount()));
            sp.setUnfinishedAmount(String.valueOf(unfinishedAmount));
            sp.setQ1(blankDS.getScheduleDate().toString());
            sp.setQ2(response);
            sp.setQ3(ouputStream);
            sp.setQ4(strQ4);
            sp.setMemo(blankDS.getScheduleNo());
            allAmount += blankDS.getAmount();
            allFinishedAmount += blankDS.getFinishedAmount();
            allUnfinishedAmount += unfinishedAmount;
            i = Integer.valueOf(i.intValue() + 1);
            schedulePrint.add(sp);
        }

        duration = duration + "  计划合计:" + allAmount + " 已交合计:" + allFinishedAmount + " 欠交合计:" + allUnfinishedAmount;
        parameters.put("Duration", duration);
        int var23 = 16 - scheduleList.size() % 16;
        if(var23 > 0 && var23 < 16) {
            for(int var24 = 0; var24 < var23; ++var24) {
                SchedulePrint var26 = new SchedulePrint();
                var26.setItemNo("");
                var26.setPC("");
                var26.setAmount("");
                var26.setFinishedAmount("");
                var26.setUnfinishedAmount("");
                var26.setQ1("");
                var26.setQ2("");
                var26.setQ3("");
                var26.setQ4("");
                var26.setMemo("");
                schedulePrint.add(var26);
            }
        }

        ScheduleDataSource var25 = new ScheduleDataSource();
        var25.setSchedulePrint(schedulePrint);
        String var27 = ServletActionContext.getServletContext().getRealPath("/jasper");
        var27 = var27 + "/Schedule.jasper";

        try {
            byte[] var28 = JasperRunManager.runReportToPdf(var27, parameters, var25);
            HttpServletResponse var29 = ServletActionContext.getResponse();
            var29.setContentType("application/pdf");
            var29.setContentLength(var28.length);
            ServletOutputStream var30 = var29.getOutputStream();

            try {
                var30.write(var28, 0, var28.length);
                var30.close();
                var30.flush();
            } finally {
                if(var30 != null) {
                    var30.close();
                }

            }
        } catch (JRException var22) {
            var22.printStackTrace();
        }

    }

    public void printSummeryView(List<ScheduleSummeryView> scheduleSummeryViewList, String title, String duration) throws IOException {
        HashMap parameters = new HashMap();
        ArrayList schedulePrint = new ArrayList();
        parameters.put("Title", title);
        Integer i = Integer.valueOf(1);
        int allAmount = 0;
        int allFinishedAmount = 0;
        int allRestAmount = 0;
        Iterator scheduleDS = scheduleSummeryViewList.iterator();

        while(scheduleDS.hasNext()) {
            ScheduleSummeryView blankDS = (ScheduleSummeryView)scheduleDS.next();
            Product strPath = (Product)this.entityService.get(Product.class, blankDS.getProduct().getId());
            SchedulePrint e = new SchedulePrint();
            e.setItemNo(i.toString());
            String response = strPath.getStandard();
            if(StringUtils.isEmpty(response)) {
                e.setPC(strPath.getProductCombination().trim());
            } else {
                e.setPC(strPath.getProductCombination().substring(2, strPath.getProductCombination().trim().length()) + "(" + response.trim() + ")");
            }

            e.setAmount(String.valueOf(blankDS.getAmount()));
            e.setFinishedAmount(String.valueOf(blankDS.getFinishedAmount()));
            e.setUnfinishedAmount(String.valueOf(blankDS.getRestAmount()));
            e.setQ1("");
            e.setQ2("");
            e.setQ3("");
            e.setQ4("");
            e.setMemo("");
            allAmount += blankDS.getAmount();
            allFinishedAmount += blankDS.getFinishedAmount();
            allRestAmount += blankDS.getRestAmount();
            i = Integer.valueOf(i.intValue() + 1);
            schedulePrint.add(e);
        }

        duration = "计划数量总计:" + allAmount + " 已交数量总计:" + allFinishedAmount + " 欠交数量总计:" + allRestAmount;
        parameters.put("Duration", duration);
        int var21 = 16 - scheduleSummeryViewList.size() % 16;
        if(var21 > 0 && var21 < 16) {
            for(int var22 = 0; var22 < var21; ++var22) {
                SchedulePrint var24 = new SchedulePrint();
                var24.setItemNo("");
                var24.setPC("");
                var24.setAmount("");
                var24.setFinishedAmount("");
                var24.setUnfinishedAmount("");
                var24.setQ1("");
                var24.setQ2("");
                var24.setQ3("");
                var24.setQ4("");
                var24.setMemo("");
                schedulePrint.add(var24);
            }
        }

        ScheduleDataSource var23 = new ScheduleDataSource();
        var23.setSchedulePrint(schedulePrint);
        String var25 = ServletActionContext.getServletContext().getRealPath("/jasper");
        var25 = var25 + "/ScheduleSummeryView.jasper";

        try {
            byte[] var26 = JasperRunManager.runReportToPdf(var25, parameters, var23);
            HttpServletResponse var27 = ServletActionContext.getResponse();
            var27.setContentType("application/pdf");
            var27.setContentLength(var26.length);
            ServletOutputStream ouputStream = var27.getOutputStream();

            try {
                ouputStream.write(var26, 0, var26.length);
                ouputStream.close();
                ouputStream.flush();
            } finally {
                if(ouputStream != null) {
                    ouputStream.close();
                }

            }
        } catch (JRException var20) {
            var20.printStackTrace();
        }

    }
}
