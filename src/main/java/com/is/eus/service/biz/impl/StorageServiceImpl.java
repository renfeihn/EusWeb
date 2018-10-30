




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
import com.is.eus.pojo.storage.Storage;
import com.is.eus.pojo.storage.StorageIncoming;
import com.is.eus.pojo.storage.StorageIncomingItem;
import com.is.eus.pojo.storage.StorageOutcoming;
import com.is.eus.pojo.storage.StorageOutcomingItem;
import com.is.eus.service.biz.ui.StorageService;
import com.is.eus.service.exception.InvalidOperationException;
import com.is.eus.service.support.FileUtil;
import com.is.eus.service.support.ObservableServiceBase;
import com.is.eus.type.DataStatus;
import com.is.eus.type.StorageIncomingState;
import com.is.eus.type.StorageOutcomingState;
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

public class StorageServiceImpl extends ObservableServiceBase implements StorageService, Listener {
    public StorageServiceImpl() {
    }

    public String findStorage(Object[] values) throws InvalidOperationException {
        SearchResult sr = this.searchService.search("com.is.eus.pojo.storage.Storage.findStorage", values);
        List items = sr.get();
        if(items.size() > 0) {
            Storage storage = (Storage)items.get(0);
            return storage.getState() == DataStatus.Using.ordinal()?storage.getId():"";
        } else {
            return "";
        }
    }

    public void add(Storage storage) throws InvalidOperationException {
        storage.setStatus(DataStatus.Using.ordinal());
        super.add(storage);
    }

    public void remove(Storage storage) throws InvalidOperationException {
        storage.setStatus(DataStatus.Deleted.ordinal());
        storage.setUpdateTime(new Date());
        super.update(storage);
    }

    public void udpate(Storage storage) throws InvalidOperationException {
        if(storage.getStatus() != DataStatus.Using.ordinal()) {
            throw new InvalidOperationException("修改失败");
        } else {
            super.update(storage);
        }
    }

    public void notice(Event event) throws InvalidOperationException {
        String name = event.getName();
        Entity entity = event.getEntity();
        if(name.equals("Storage_FromStorageIncoming")) {
            this.StorageFromStorageIncoming(entity);
        }

        if(name.equals("Update_Contract_And_Storage_FromStorageOutcoming")) {
            this.StorageFromStorageOutcoming(entity);
        }

        if(name.equals("RollBack_Contract_And_Storage_FromStorageOutcoming")) {
            this.RollbackFromStorageOutcoming(entity);
        }

        if(name.equals("Storage_FromInWarehouse")) {
            this.StorageFromInWarehouse(entity);
        }

        if(name.equals("Storage_FromOutWarehouse")) {
            this.StorageFromOutWarehouse(entity);
        }

    }

    private void StorageFromStorageIncoming(Entity entity) {
        StorageIncoming sic = (StorageIncoming)entity;
        if(sic.getState() == StorageIncomingState.AduitSuccess.ordinal()) {
            Set items = sic.getItems();
            Iterator var5 = items.iterator();

            while(var5.hasNext()) {
                StorageIncomingItem item = (StorageIncomingItem)var5.next();
                Product product = (Product)this.entityService.get(Product.class, item.getProduct().getId());
                StorageLocation storageLocation = item.getStorageLocation();
                String[] values = new String[]{product.getId(), storageLocation.getId()};
                String strStorageID = this.findStorage(values);
                Storage updateStorage;
                if(strStorageID.isEmpty()) {
                    updateStorage = new Storage();
                    updateStorage.setProduct(product);
                    updateStorage.setStorageLocation(storageLocation);
                    updateStorage.setTotalAmount(item.getAmount());
                    updateStorage.setCreator(sic.getCreator());
                    updateStorage.setCreateTime(new Date());
                    this.add(updateStorage);
                } else {
                    updateStorage = (Storage)this.entityService.get(Storage.class, strStorageID);
                    int totalAmount = updateStorage.getTotalAmount() + item.getAmount();
                    updateStorage.setTotalAmount(totalAmount);
                    updateStorage.setUpdater(sic.getCreator());
                    updateStorage.setUpdateTime(new Date());
                    this.update(updateStorage);
                }
            }

        }
    }

    private void StorageFromStorageOutcoming(Entity entity) {
        StorageOutcoming soc = (StorageOutcoming)entity;
        Iterator var4 = soc.getSocItems().iterator();

        while(var4.hasNext()) {
            StorageOutcomingItem socItem = (StorageOutcomingItem)var4.next();
            Product product = (Product)this.entityService.get(Product.class, socItem.getProduct().getId());
            StorageLocation storageLocation = socItem.getStorageLocation();
            String[] values = new String[]{product.getId(), storageLocation.getId()};
            String strStorageID = this.findStorage(values);
            String quickInfo = "产品[" + product.getProductCombination() + "], ";
            if(strStorageID.isEmpty()) {
                throw new InvalidOperationException(quickInfo + "没有可以出库的产品");
            }

            Storage updateStorage = (Storage)this.entityService.get(Storage.class, strStorageID);
            int totalAmount = updateStorage.getTotalAmount() - socItem.getAmount();
            if(totalAmount < 0) {
                throw new InvalidOperationException(quickInfo + "出库数量大于产品库存数量");
            }

            updateStorage.setTotalAmount(totalAmount);
            updateStorage.setUpdater(soc.getCreator());
            updateStorage.setUpdateTime(soc.getCreateTime());
            if(totalAmount == 0) {
                super.delete(updateStorage);
            } else {
                this.update(updateStorage);
            }
        }

    }

    private void RollbackFromStorageOutcoming(Entity entity) {
        StorageOutcoming soc = (StorageOutcoming)entity;
        if(soc.getState() != StorageOutcomingState.Failed.ordinal()) {
            throw new InvalidOperationException("该出库单不是审核失败状态");
        } else {
            Iterator var4 = soc.getSocItems().iterator();

            while(var4.hasNext()) {
                StorageOutcomingItem socItem = (StorageOutcomingItem)var4.next();
                Product product = (Product)this.entityService.get(Product.class, socItem.getProduct().getId());
                StorageLocation storageLocation = socItem.getStorageLocation();
                String[] values = new String[]{product.getId(), storageLocation.getId()};
                String strStorageID = this.findStorage(values);
                Storage updateStorage;
                if(strStorageID.isEmpty()) {
                    updateStorage = new Storage();
                    updateStorage.setProduct(product);
                    updateStorage.setStorageLocation(storageLocation);
                    updateStorage.setTotalAmount(socItem.getAmount());
                    updateStorage.setCreator(soc.getCreator());
                    updateStorage.setCreateTime(soc.getCreateTime());
                    this.add(updateStorage);
                } else {
                    updateStorage = (Storage)this.entityService.get(Storage.class, strStorageID);
                    int totalAmount = updateStorage.getTotalAmount() + socItem.getAmount();
                    updateStorage.setTotalAmount(totalAmount);
                    updateStorage.setUpdater(soc.getCreator());
                    updateStorage.setUpdateTime(soc.getCreateTime());
                    this.update(updateStorage);
                }
            }

        }
    }

    private void StorageFromInWarehouse(Entity entity) {
        InWarehouse iw = (InWarehouse)entity;
        Product product = (Product)this.entityService.get(Product.class, iw.getProduct().getId());
        StorageLocation storageLocation = (StorageLocation)this.entityService.get(StorageLocation.class, iw.getStorageLocation().getId());
        String[] values = new String[]{product.getId(), storageLocation.getId()};
        String strStorageID = this.findStorage(values);
        Storage updateStorage;
        if(strStorageID.isEmpty()) {
            updateStorage = new Storage();
            updateStorage.setProduct(product);
            updateStorage.setStorageLocation(storageLocation);
            updateStorage.setTotalAmount(iw.getTotalAmount());
            updateStorage.setCreator(iw.getCreator());
            updateStorage.setCreateTime(new Date());
            this.add(updateStorage);
        } else {
            updateStorage = (Storage)this.entityService.get(Storage.class, strStorageID);
            int totalAmount = updateStorage.getTotalAmount() + iw.getTotalAmount();
            updateStorage.setTotalAmount(totalAmount);
            updateStorage.setUpdater(iw.getCreator());
            updateStorage.setUpdateTime(new Date());
            this.update(updateStorage);
        }

    }

    private void StorageFromOutWarehouse(Entity entity) {
        InWarehouse iw = (InWarehouse)entity;
        Product product = (Product)this.entityService.get(Product.class, iw.getProduct().getId());
        StorageLocation storageLocation = (StorageLocation)this.entityService.get(StorageLocation.class, iw.getStorageLocation().getId());
        String[] values = new String[]{product.getId(), storageLocation.getId()};
        String strStorageID = this.findStorage(values);
        if(strStorageID.isEmpty()) {
            throw new InvalidOperationException("库位上没有可以出库的产品");
        } else {
            Storage updateStorage = (Storage)this.entityService.get(Storage.class, strStorageID);
            int totalAmount = updateStorage.getTotalAmount() - iw.getTotalAmount();
            if(totalAmount < 0) {
                throw new InvalidOperationException("出库数量大于产品库存数量");
            } else {
                updateStorage.setTotalAmount(totalAmount);
                updateStorage.setUpdater(iw.getCreator());
                updateStorage.setUpdateTime(iw.getCreateTime());
                if(totalAmount == 0) {
                    super.delete(updateStorage);
                } else {
                    this.update(updateStorage);
                }

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
        String filename = dir + "\\" + "库存总览(" + strDateTime + ").xls";
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
            WritableSheet ws = e.createSheet("库存总览", 0);
            ws.getSettings().setPaperSize(PaperSize.A4);
            ws.getSettings().setOrientation(PageOrientation.LANDSCAPE);
            ws.setRowView(0, 600);
            ws.mergeCells(0, 0, 8, 0);
            WritableFont wFont = new WritableFont(WritableFont.createFont("宋体"), 18, WritableFont.BOLD);
            WritableCellFormat wcf = new WritableCellFormat(wFont);
            wcf.setAlignment(Alignment.CENTRE);
            wcf.setVerticalAlignment(VerticalAlignment.CENTRE);
            ws.addCell(new Label(0, 0, "库存总览 " + strDate, wcf));
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
            ws.setColumnView(1, 50);
            ws.addCell(new Label(0, 1, "序号", wcfi));
            ws.addCell(new Label(1, 1, "产品名称及型号", wcfi));
            ws.addCell(new Label(2, 1, "名称", wcfi));
            ws.addCell(new Label(3, 1, "电压", wcfi));
            ws.addCell(new Label(4, 1, "容量", wcfi));
            ws.addCell(new Label(5, 1, "湿度", wcfi));
            ws.addCell(new Label(6, 1, "误差", wcfi));
            ws.addCell(new Label(7, 1, "单位", wcfi));
            ws.addCell(new Label(8, 1, "库存数量", wcfi));
            SearchResult sr = this.searchService.search("com.is.eus.pojo.storage.Storage.find");
            List items = sr.get();
            Integer row = new Integer(2);

            for(Iterator var22 = items.iterator(); var22.hasNext(); row = Integer.valueOf(row.intValue() + 1)) {
                Storage item = (Storage)var22.next();
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

                Integer rowNo = new Integer(row.intValue() - 1);
                ws.addCell(new Label(0, row.intValue(), rowNo.toString(), wcfi));
                ws.addCell(new Label(1, row.intValue(), capacitor.getProductCombination(), wcfi2));
                ws.addCell(new Label(2, row.intValue(), capacitor.getProductName(), wcfi));
                ws.addCell(new Label(3, row.intValue(), capacitor.getVoltage().isEmpty()?"":capacitor.getVoltage(), wcfi));
                ws.addCell(new Label(4, row.intValue(), capacitor.getCapacity().isEmpty()?"":capacitor.getVoltage(), wcfi));
                ws.addCell(new Label(5, row.intValue(), humidity == null?"":humidity.getCode(), wcfi));
                ws.addCell(new Label(6, row.intValue(), errorLevel == null?"":errorLevel.getCode(), wcfi));
                ws.addCell(new Label(7, row.intValue(), unit == null?"":unit.getName(), wcfi));
                ws.addCell(new Label(8, row.intValue(), (new Integer(item.getTotalAmount())).toString(), wcfi));
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
