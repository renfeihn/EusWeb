




package com.is.eus.service.biz.impl;

import com.is.eus.model.event.Event;
import com.is.eus.model.event.Listener;
import com.is.eus.model.search.SearchResult;
import com.is.eus.pojo.Entity;
import com.is.eus.pojo.basic.Capacitor;
import com.is.eus.pojo.basic.ErrorLevel;
import com.is.eus.pojo.basic.Humidity;
import com.is.eus.pojo.basic.Product;
import com.is.eus.pojo.basic.StorageLocation;
import com.is.eus.pojo.basic.Unit;
import com.is.eus.pojo.storage.InWarehouse;
import com.is.eus.pojo.storage.StorageIncoming;
import com.is.eus.pojo.storage.StorageIncomingItem;
import com.is.eus.pojo.storage.StorageItem;
import com.is.eus.pojo.storage.StorageItemLog;
import com.is.eus.pojo.storage.StorageOutcoming;
import com.is.eus.pojo.storage.StorageOutcomingItem;
import com.is.eus.pojo.system.Employee;
import com.is.eus.service.biz.ui.StorageItemService;
import com.is.eus.service.exception.InvalidOperationException;
import com.is.eus.service.support.FileUtil;
import com.is.eus.service.support.ObservableServiceBase;
import com.is.eus.type.DataStatus;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
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

public class StorageItemServiceImpl extends ObservableServiceBase implements StorageItemService, Listener {
    public StorageItemServiceImpl() {
    }

    public void add(StorageItem storageItem) throws InvalidOperationException {
        storageItem.setStatus(DataStatus.Using.ordinal());
        super.add(storageItem);
    }

    public void remove(StorageItem storageItem) throws InvalidOperationException {
        storageItem.setStatus(DataStatus.Deleted.ordinal());
        storageItem.setUpdateTime(new Date());
        super.update(storageItem);
    }

    public void udpate(StorageItem storageItem) throws InvalidOperationException {
        if(storageItem.getStatus() != DataStatus.Using.ordinal()) {
            throw new InvalidOperationException("修改失败");
        } else {
            super.update(storageItem);
        }
    }

    public List<StorageItem> findStorageItem(Object[] values) throws InvalidOperationException {
        SearchResult sr = this.searchService.search("com.is.eus.pojo.storage.StorageItem.findStorageItem", values);
        List items = sr.get();
        return items.size() > 0?items:null;
    }

    public void notice(Event event) throws InvalidOperationException {
        String name = event.getName();
        Entity entity = event.getEntity();
        if(name.equals("StorageItem_FromStorageIncoming")) {
            this.StorageItemFromStorageIncoming(entity);
        }

        if(name.equals("Update_Contract_And_Storage_FromStorageOutcoming")) {
            this.StorageItemFromStorageOutcoming(entity);
        }

        if(name.equals("RollBack_Contract_And_Storage_FromStorageOutcoming")) {
            this.StorageItemRollBackFromStorageOutcoming(entity);
        }

        if(name.equals("Storage_FromInWarehouse")) {
            this.StorageItemFromInWarehouse(entity);
        }

        if(name.equals("Storage_FromOutWarehouse")) {
            this.StorageItemFromOutWarehouse(entity);
        }

    }

    private void StorageItemFromStorageIncoming(Entity entity) {
        StorageIncoming sic = (StorageIncoming)entity;
        Set items = sic.getItems();
        Iterator var5 = items.iterator();

        while(var5.hasNext()) {
            StorageIncomingItem item = (StorageIncomingItem)var5.next();
            StorageItem storageItem = new StorageItem();
            storageItem.setProduct(item.getProduct());
            storageItem.setAmount(item.getAmount());
            storageItem.setStorageLocation(item.getStorageLocation());
            storageItem.setProductionDate(item.getProductionDate());
            storageItem.setCreateTime(new Date());
            storageItem.setCreator(sic.getCreator());
            this.add(storageItem);
        }

    }

    private void StorageItemFromStorageOutcoming(Entity entity) {
        StorageOutcoming soc = (StorageOutcoming)entity;
        Set items = soc.getSocItems();
        Iterator var5 = items.iterator();

        while(true) {
            while(var5.hasNext()) {
                StorageOutcomingItem item = (StorageOutcomingItem)var5.next();
                String[] values = new String[]{item.getProduct().getId(), item.getStorageLocation().getId()};
                List storageItems = this.findStorageItem(values);
                if(storageItems == null) {
                    Product amount1 = (Product)this.entityService.get(Product.class, item.getProduct().getId());
                    String restAmount2 = "产品[" + amount1.getProductCombination() + "], ";
                    throw new InvalidOperationException(restAmount2 + "没有可以出库的产品");
                }

                int amount = item.getAmount();
                boolean restAmount = false;
                Iterator var11 = storageItems.iterator();

                while(var11.hasNext()) {
                    StorageItem siItem = (StorageItem)var11.next();
                    int restAmount1 = amount - siItem.getAmount();
                    StorageItemLog siItemLog;
                    if(restAmount1 < 0) {
                        siItem.setAmount(siItem.getAmount() - amount);
                        this.update(siItem);
                        siItemLog = new StorageItemLog();
                        siItemLog.setAmount(amount);
                        siItemLog.setProductionDate(siItem.getProductionDate());
                        siItemLog.setProduct(siItem.getProduct());
                        siItemLog.setStorageLocation(siItem.getStorageLocation());
                        siItemLog.setStorageOutcomingItem(item);
                        siItemLog.setCreateTime(new Date());
                        siItemLog.setCreator(soc.getCreator());
                        siItemLog.setStatus(DataStatus.Using.ordinal());
                        this.entityService.add(siItemLog);
                        break;
                    }

                    if(restAmount1 == 0) {
                        this.delete(siItem);
                        siItemLog = new StorageItemLog();
                        siItemLog.setAmount(amount);
                        siItemLog.setProductionDate(siItem.getProductionDate());
                        siItemLog.setProduct(siItem.getProduct());
                        siItemLog.setStorageLocation(siItem.getStorageLocation());
                        siItemLog.setStorageOutcomingItem(item);
                        siItemLog.setCreateTime(new Date());
                        siItemLog.setCreator(soc.getCreator());
                        siItemLog.setStatus(DataStatus.Using.ordinal());
                        this.entityService.add(siItemLog);
                        break;
                    }

                    if(restAmount1 > 0) {
                        this.delete(siItem);
                        siItemLog = new StorageItemLog();
                        siItemLog.setAmount(siItem.getAmount());
                        siItemLog.setProductionDate(siItem.getProductionDate());
                        siItemLog.setProduct(siItem.getProduct());
                        siItemLog.setStorageLocation(siItem.getStorageLocation());
                        siItemLog.setStorageOutcomingItem(item);
                        siItemLog.setCreateTime(new Date());
                        siItemLog.setCreator(soc.getCreator());
                        siItemLog.setStatus(DataStatus.Using.ordinal());
                        this.entityService.add(siItemLog);
                        amount = restAmount1;
                    }
                }
            }

            return;
        }
    }

    private List<StorageItemLog> findStorageItemLogBySocItem(Object[] values) throws InvalidOperationException {
        SearchResult sr = this.searchService.search("com.is.eus.pojo.storage.StorageItemLog.findStorageItemLog", values);
        List items = sr.get();
        return items.size() > 0?items:null;
    }

    private void StorageItemRollBackFromStorageOutcoming(Entity entity) {
        StorageOutcoming soc = (StorageOutcoming)entity;
        Set items = soc.getSocItems();
        Iterator var5 = items.iterator();

        while(var5.hasNext()) {
            StorageOutcomingItem item = (StorageOutcomingItem)var5.next();
            String[] values = new String[]{item.getId()};
            List storageItemLogItems = this.findStorageItemLogBySocItem(values);
            Iterator var9 = storageItemLogItems.iterator();

            while(var9.hasNext()) {
                StorageItemLog storageItemLog = (StorageItemLog)var9.next();
                StorageItem storageItem = new StorageItem();
                storageItem.setProduct(storageItemLog.getProduct());
                storageItem.setAmount(storageItemLog.getAmount());
                storageItem.setStorageLocation(storageItemLog.getStorageLocation());
                storageItem.setProductionDate(storageItemLog.getProductionDate());
                storageItem.setStatus(DataStatus.Using.ordinal());
                storageItem.setCreateTime(new Date());
                storageItem.setCreator(storageItemLog.getCreator());
                this.add(storageItem);
            }
        }

    }

    private void StorageItemFromInWarehouse(Entity entity) {
        InWarehouse iw = (InWarehouse)entity;
        StorageItem storageItem = new StorageItem();
        Product product = (Product)this.entityService.get(Product.class, iw.getProduct().getId());
        StorageLocation storageLocation = (StorageLocation)this.entityService.get(StorageLocation.class, iw.getStorageLocation().getId());
        Employee creator = (Employee)this.entityService.get(Employee.class, iw.getCreator().getId());
        storageItem.setProduct(product);
        storageItem.setAmount(iw.getTotalAmount());
        storageItem.setStorageLocation(storageLocation);
        storageItem.setProductionDate(iw.getProductionDate());
        storageItem.setStatus(DataStatus.Using.ordinal());
        storageItem.setCreateTime(new Date());
        storageItem.setCreator(creator);
        this.add(storageItem);
    }

    private void StorageItemFromOutWarehouse(Entity entity) {
        InWarehouse iw = (InWarehouse)entity;
        int amount = iw.getTotalAmount();
        boolean restAmount = false;
        String[] values = new String[]{iw.getProduct().getId(), iw.getStorageLocation().getId()};
        List storageItems = this.findStorageItem(values);
        Iterator var8 = storageItems.iterator();

        while(var8.hasNext()) {
            StorageItem siItem = (StorageItem)var8.next();
            int restAmount1 = amount - siItem.getAmount();
            if(restAmount1 < 0) {
                siItem.setAmount(siItem.getAmount() - amount);
                this.update(siItem);
                return;
            }

            if(restAmount1 == 0) {
                this.delete(siItem);
                return;
            }

            if(restAmount1 > 0) {
                this.delete(siItem);
                amount = restAmount1;
            }
        }

    }

    public File print() throws WriteException, IOException {
        String dir = FileUtil.tmpdir();
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HHmmss");
        Date date = new Date();
        String strDateTime = format.format(date);
        SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd");
        Date date2 = new Date();
        String strDate = format2.format(date2);
        String filename = dir + "\\" + "库存明细(" + strDateTime + ").xls";
        File file = new File(filename);
        if(file.exists()) {
            file.delete();

            try {
                file.createNewFile();
            } catch (IOException var31) {
                var31.printStackTrace();
                this.logger.warn("导出Excel文件失败!");
                return null;
            }
        }

        try {
            WritableWorkbook e = Workbook.createWorkbook(file);
            WritableSheet ws = e.createSheet("库存明细", 0);
            ws.getSettings().setPaperSize(PaperSize.A4);
            ws.getSettings().setOrientation(PageOrientation.LANDSCAPE);
            ws.setColumnView(1, 50);
            ws.setColumnView(10, 15);
            ws.setRowView(0, 600);
            ws.mergeCells(0, 0, 10, 0);
            WritableFont wFont = new WritableFont(WritableFont.createFont("宋体"), 18, WritableFont.BOLD);
            WritableCellFormat wcf = new WritableCellFormat(wFont);
            wcf.setAlignment(Alignment.CENTRE);
            wcf.setVerticalAlignment(VerticalAlignment.CENTRE);
            ws.addCell(new Label(0, 0, "库存明细 " + strDate, wcf));
            WritableFont wFonti = new WritableFont(WritableFont.createFont("宋体"), 10);
            WritableCellFormat wcfi = new WritableCellFormat(wFonti);
            wcfi.setBorder(Border.ALL, BorderLineStyle.THIN, Colour.BLACK);
            wcfi.setAlignment(Alignment.CENTRE);
            wcfi.setVerticalAlignment(VerticalAlignment.CENTRE);
            wcfi.setWrap(true);
            WritableFont wFonti2 = new WritableFont(WritableFont.createFont("宋体"), 10);
            WritableCellFormat wcfi2 = new WritableCellFormat(wFonti2);
            wcfi2.setBorder(Border.ALL, BorderLineStyle.THIN, Colour.BLACK);
            wcfi2.setAlignment(Alignment.LEFT);
            wcfi2.setVerticalAlignment(VerticalAlignment.CENTRE);
            wcfi2.setWrap(false);
            ws.addCell(new Label(0, 1, "序号", wcfi));
            ws.addCell(new Label(1, 1, "产品名称及型号", wcfi));
            ws.addCell(new Label(2, 1, "名称", wcfi));
            ws.addCell(new Label(3, 1, "电压", wcfi));
            ws.addCell(new Label(4, 1, "容量", wcfi));
            ws.addCell(new Label(5, 1, "湿度", wcfi));
            ws.addCell(new Label(6, 1, "误差", wcfi));
            ws.addCell(new Label(7, 1, "单位", wcfi));
            ws.addCell(new Label(8, 1, "库存数量", wcfi));
            ws.addCell(new Label(9, 1, "库位", wcfi));
            ws.addCell(new Label(10, 1, "生产日期", wcfi));
            SearchResult sr = this.searchService.search("com.is.eus.pojo.storage.StorageItem.find");
            List items = sr.get();
            Integer row = new Integer(2);

            for(Iterator var22 = items.iterator(); var22.hasNext(); row = Integer.valueOf(row.intValue() + 1)) {
                StorageItem item = (StorageItem)var22.next();
                Capacitor capacitor = (Capacitor)this.entityService.get(Product.class, item.getProduct().getId());
                Humidity humidity = null;
                if(capacitor.getHumidity() != null) {
                    humidity = (Humidity)this.entityService.get(Humidity.class, capacitor.getHumidity().getId());
                }

                ErrorLevel errorLevel = null;
                if(capacitor.getErrorLevel() != null) {
                    errorLevel = (ErrorLevel)this.entityService.get(ErrorLevel.class, capacitor.getErrorLevel().getId());
                }

                Unit unit = null;
                if(capacitor.getUnit() != null) {
                    unit = (Unit)this.entityService.get(Unit.class, capacitor.getUnit().getId());
                }

                StorageLocation sl = null;
                if(!item.getStorageLocation().getId().isEmpty()) {
                    sl = (StorageLocation)this.entityService.get(StorageLocation.class, item.getStorageLocation().getId());
                }

                Integer rowNo = new Integer(row.intValue() - 1);
                ws.addCell(new Label(0, row.intValue(), rowNo.toString(), wcfi));
                ws.addCell(new Label(1, row.intValue(), capacitor.getProductCombination(), wcfi2));
                ws.addCell(new Label(2, row.intValue(), capacitor.getProductName(), wcfi));
                ws.addCell(new Label(3, row.intValue(), capacitor.getVoltage().isEmpty()?"":capacitor.getVoltage(), wcfi));
                ws.addCell(new Label(4, row.intValue(), capacitor.getCapacity().isEmpty()?"":capacitor.getVoltage(), wcfi));
                ws.addCell(new Label(5, row.intValue(), humidity == null?"":humidity.getCode(), wcfi));
                ws.addCell(new Label(6, row.intValue(), errorLevel == null?"":errorLevel.getCode(), wcfi));
                ws.addCell(new Label(7, row.intValue(), unit == null?"":unit.getName(), wcfi));
                ws.addCell(new Label(8, row.intValue(), (new Integer(item.getAmount())).toString(), wcfi));
                ws.addCell(new Label(9, row.intValue(), sl.getName(), wcfi));
                ws.addCell(new Label(10, row.intValue(), format2.format(item.getCreateTime()), wcfi));
            }

            e.write();
            e.close();
            return file;
        } catch (WriteException var29) {
            var29.printStackTrace();
            return null;
        } catch (IOException var30) {
            var30.printStackTrace();
            return null;
        }
    }
}
