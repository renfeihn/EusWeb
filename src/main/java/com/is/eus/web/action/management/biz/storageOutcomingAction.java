//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.is.eus.web.action.management.biz;

import com.is.eus.model.search.SearchResult;
import com.is.eus.pojo.Entity;
import com.is.eus.pojo.basic.Product;
import com.is.eus.pojo.basic.StorageLocation;
import com.is.eus.pojo.contract.Contract;
import com.is.eus.pojo.contract.ContractItem;
import com.is.eus.pojo.dac.User;
import com.is.eus.pojo.storage.StorageOutcoming;
import com.is.eus.pojo.storage.StorageOutcomingItem;
import com.is.eus.service.biz.ui.StorageOutcomingService;
import com.is.eus.service.exception.InvalidOperationException;
import com.is.eus.type.StorageOutcomingState;
import com.is.eus.util.JsonHelper;
import com.is.eus.web.action.EntityBaseAction;
import com.is.eus.web.exception.InvalidPageInformationException;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;
import org.apache.commons.lang.xwork.StringUtils;

public class storageOutcomingAction extends EntityBaseAction {
    private String contractID;
    private Date storageOutcomingDate;
    private String[] contractItemNos;
    private String[] storageLocations;
    private int[] SOCAmounts;
    private String[] memoes;
    private int aduit;
    private StorageOutcomingService storageOutcomingService;
    private File downloadFile;

    public storageOutcomingAction() {
    }

    public void setContractID(String contractID) {
        this.contractID = contractID;
    }

    public void setStorageOutcomingDate(Date storageOutcomingDate) {
        this.storageOutcomingDate = storageOutcomingDate;
    }

    public void setContractItemNos(String[] contractItemNos) {
        this.contractItemNos = contractItemNos;
    }

    public void setStorageLocations(String[] storageLocations) {
        this.storageLocations = storageLocations;
    }

    public void setSOCAmounts(int[] sOCAmounts) {
        this.SOCAmounts = sOCAmounts;
    }

    public void setMemoes(String[] memoes) {
        this.memoes = memoes;
    }

    public void setAduit(int aduit) {
        this.aduit = aduit;
    }

    public void setStorageOutcomingService(StorageOutcomingService storageOutcomingService) {
        this.storageOutcomingService = storageOutcomingService;
    }

    private Set<StorageOutcomingItem> getStorageOutcomingItems(StorageOutcoming storageOutcoming) throws ParseException {
        User user = this.getUserFromSession();
        HashSet storageOutcomingItem = new HashSet();
        int totalAmount = 0;
        float totalSum = 0.0F;
        float totalSumWithoutTax = 0.0F;
        float totalTaxAmount = 0.0F;

        for(int i = 0; i < this.contractItemNos.length; ++i) {
            StorageOutcomingItem item = new StorageOutcomingItem();
            ContractItem contractItem = (ContractItem)this.entityService.get(ContractItem.class, this.contractItemNos[i]);
            Product product = contractItem.getProduct();
            StorageLocation storageLocation = null;
            if(this.storageLocations[i].trim().isEmpty()) {
                storageLocation = (StorageLocation)this.entityService.get(StorageLocation.class, "66B79F13-6918-4A95-B424-DC0ACCE3E497");
            } else {
                storageLocation = (StorageLocation)this.entityService.get(StorageLocation.class, this.storageLocations[i]);
            }

            byte tax = 17;
            int amount = this.SOCAmounts[i];
            float price = contractItem.getPrice();
            double priceWithoutTax = (double)price / 1.17D;
            float subTotal = (float)amount * price;
            float subTotalWithoutTax = (float)((double)subTotal / 1.17D);
            float taxAmount = (float)((double)subTotalWithoutTax * 0.17D);
            item.setContractItem(contractItem);
            item.setSocItemNo(contractItem.getContractItemNo());
            item.setProduct(product);
            item.setStorageLocation(storageLocation);
            item.setAmount(amount);
            item.setPrice(price);
            item.setPriceWithoutTax(priceWithoutTax);
            item.setTax(tax);
            item.setSubTotal(subTotal);
            item.setSubTotalWithoutTax(subTotalWithoutTax);
            item.setTaxAmount(taxAmount);
            item.setMemo(this.memoes[i]);
            item.setCreator(user.getEmployee());
            item.setCreateTime(new Date());
            totalAmount += amount;
            totalSum += subTotal;
            totalSumWithoutTax += subTotalWithoutTax;
            totalTaxAmount += taxAmount;
            item.setSoc(storageOutcoming);
            storageOutcomingItem.add(item);
        }

        storageOutcoming.setTotalAmount(totalAmount);
        storageOutcoming.setTotalSum(totalSum);
        storageOutcoming.setTotalSumWithoutTax(totalSumWithoutTax);
        storageOutcoming.setTotalTaxAmount(totalTaxAmount);
        return storageOutcomingItem;
    }

    protected void fillEntity(Entity entity) throws ParseException {
        StorageOutcoming storageOutcoming = (StorageOutcoming)entity;
        Set items = this.getStorageOutcomingItems(storageOutcoming);
        if(storageOutcoming.getSocItems() == null) {
            storageOutcoming.setSocItems(items);
        } else {
            storageOutcoming.getSocItems().clear();
            storageOutcoming.getSocItems().addAll(items);
        }

        Contract contract = (Contract)this.entityService.get(Contract.class, this.contractID);
        storageOutcoming.setContract(contract);
        storageOutcoming.setSocDate(this.storageOutcomingDate);
        storageOutcoming.setState(StorageOutcomingState.Checking.ordinal());
    }

    public String add() {
        User user = this.getUserFromSession();
        StorageOutcoming storageOutcoming = new StorageOutcoming();

        try {
            this.check();
            this.fillEntity(storageOutcoming);
            storageOutcoming.setCreator(user.getEmployee());
            storageOutcoming.setCreateTime(new Date());
            this.storageOutcomingService.add(storageOutcoming);
            this.simpleResult(true);
        } catch (InvalidPageInformationException var4) {
            this.result(false, var4.getMessage());
        } catch (InvalidOperationException var5) {
            this.result(false, var5.getMessage());
        } catch (ParseException var6) {
            this.result(false, var6.getMessage());
        }

        return "success";
    }

    public String aduitByChecker() {
        User user = this.getUserFromSession();
        StorageOutcoming storageOutcoming = (StorageOutcoming)this.entityService.get(StorageOutcoming.class, this.id);

        try {
            storageOutcoming.setUpdater(user.getEmployee());
            storageOutcoming.setUpdateTime(new Date());
            storageOutcoming.setSocChecker(user.getEmployee());
            storageOutcoming.setSocChecker_createTime(new Date());
            if(this.aduit == StorageOutcomingState.Failed.ordinal()) {
                this.storageOutcomingService.checkFailed(storageOutcoming);
            } else if(this.aduit == StorageOutcomingState.Success.ordinal()) {
                this.storageOutcomingService.checkSuccess(storageOutcoming);
            }

            this.simpleResult(true);
        } catch (InvalidOperationException var4) {
            this.result(false, var4.getMessage());
        }

        return "success";
    }

    protected Class<StorageOutcoming> getEntityClass() {
        return StorageOutcoming.class;
    }

    protected Class<?> getEntityStateClass() {
        return StorageOutcomingState.class;
    }

    public String find() {
        this.digDepth = 4;
        return super.find();
    }

    public String get() {
        this.digDepth = 4;
        return super.get();
    }

    public String findByContract() {
        try {
            String[] e = new String[]{this.contractID};
            SearchResult result = this.storageOutcomingService.findByContract(e);
            this.resultJson = JsonHelper.fromCollection(result.get(), StorageOutcoming.class, result.getTotalCount(), this.digDepth);
        } catch (InvalidOperationException var3) {
            this.result(false, var3.getMessage());
        }

        return "success";
    }

    public String getFileName() {
        String downFileName = this.downloadFile.getName();

        try {
            downFileName = new String(downFileName.getBytes(), "ISO8859-1");
        } catch (UnsupportedEncodingException var3) {
            var3.printStackTrace();
        }

        return downFileName;
    }

    public InputStream getInputStream() throws FileNotFoundException {
        return new FileInputStream(this.downloadFile);
    }

    public String print() {
        String id = this.id;
        if(StringUtils.isEmpty(id)) {
            return "success";
        } else {
            try {
                this.storageOutcomingService.print(id, false);
                return null;
            } catch (IOException var3) {
                this.result(false, var3.getMessage());
                return "success";
            }
        }
    }

    public String printPreview() {
        String id = this.id;
        if(StringUtils.isEmpty(id)) {
            return "success";
        } else {
            try {
                this.storageOutcomingService.print(id, true);
                return null;
            } catch (IOException var3) {
                this.result(false, var3.getMessage());
                return "success";
            }
        }
    }
}
