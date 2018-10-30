




package com.is.eus.service.biz.impl;

import com.is.eus.model.event.Event;
import com.is.eus.model.event.Listener;
import com.is.eus.model.search.SearchResult;
import com.is.eus.pojo.Entity;
import com.is.eus.pojo.basic.Product;
import com.is.eus.pojo.contract.Contract;
import com.is.eus.pojo.contract.ContractItem;
import com.is.eus.pojo.storage.InWarehouse;
import com.is.eus.pojo.storage.StorageIncoming;
import com.is.eus.pojo.storage.StorageIncomingItem;
import com.is.eus.pojo.storage.StorageResource;
import com.is.eus.pojo.system.Employee;
import com.is.eus.service.biz.ui.StorageResourceService;
import com.is.eus.service.exception.InvalidOperationException;
import com.is.eus.service.support.ObservableServiceBase;
import com.is.eus.type.ContractState;
import com.is.eus.type.DataStatus;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

public class StorageResourceServiceImpl extends ObservableServiceBase implements StorageResourceService, Listener {
    public StorageResourceServiceImpl() {
    }

    public StorageResource findStorageResource(Product product) throws InvalidOperationException {
        String[] values = new String[]{product.getId()};
        SearchResult sr = this.searchService.search("com.is.eus.pojo.storage.StorageResource.findStorageResource", values);
        List items = sr.get();
        if(items.size() > 0) {
            StorageResource storageResource = (StorageResource)items.get(0);
            return storageResource;
        } else {
            return null;
        }
    }

    public void add(StorageResource storageResource) throws InvalidOperationException {
        storageResource.setStatus(DataStatus.Using.ordinal());
        super.add(storageResource);
    }

    public void delete(StorageResource storageResource) throws InvalidOperationException {
        super.delete(storageResource);
    }

    public void udpate(StorageResource storageResource) throws InvalidOperationException {
        super.update(storageResource);
    }

    public void notice(Event event) throws InvalidOperationException {
        String name = event.getName();
        Entity entity = event.getEntity();
        if(name.equals("ScheduleFromContract")) {
            this.StorageResourceFromContract(entity);
        }

        if(name.equals("RollbackStorageResourceFromContract")) {
            this.RollbackStorageResourceFromContract(entity);
        }

        if(name.equals("StorageResource_FromStorageIncoming")) {
            this.StorageResourceFromStorageIncoming(entity);
        }

        if(name.equals("Storage_FromInWarehouse")) {
            this.StorageResourceFromInWarehouse(entity);
        }

        if(name.equals("Storage_FromOutWarehouse")) {
            this.StorageResourceFromOutWarehouse(entity);
        }

    }

    private void StorageResourceFromContract(Entity entity) {
        Contract contract = (Contract)entity;
        if(contract.getState() != ContractState.None.ordinal()) {
            throw new InvalidOperationException("合同状态错误");
        } else {
            Set items = contract.getItems();
            Iterator var5 = items.iterator();

            while(var5.hasNext()) {
                ContractItem item = (ContractItem)var5.next();
                Product product = (Product)this.entityService.get(Product.class, item.getProduct().getId());
                Employee creator = (Employee)this.entityService.get(Employee.class, item.getCreator().getId());
                StorageResource storageResource = this.findStorageResource(product);
                if(storageResource == null) {
                    new StorageResource();
                    storageResource = new StorageResource();
                    storageResource.setProduct(product);
                    storageResource.setAmount(0 - item.getAmount());
                    storageResource.setCreateTime(new Date());
                    storageResource.setCreator(creator);
                    this.add(storageResource);
                } else {
                    int srAmount = storageResource.getAmount();
                    storageResource.setAmount(srAmount - item.getAmount());
                    storageResource.setUpdater(creator);
                    storageResource.setUpdateTime(new Date());
                    this.update(storageResource);
                }
            }

        }
    }

    private void RollbackStorageResourceFromContract(Entity entity) {
        Contract contract = (Contract)entity;
        if(contract.getState() != ContractState.Terminated.ordinal()) {
            throw new InvalidOperationException("合同状态错误");
        } else {
            Iterator var4 = contract.getItems().iterator();

            while(var4.hasNext()) {
                ContractItem item = (ContractItem)var4.next();
                Product product = (Product)this.entityService.get(Product.class, item.getProduct().getId());
                Employee creator = (Employee)this.entityService.get(Employee.class, contract.getCreator().getId());
                StorageResource storageResource = this.findStorageResource(product);
                if(storageResource == null) {
                    storageResource = new StorageResource();
                    storageResource.setProduct(product);
                    storageResource.setAmount(item.getAmount() - item.getFinishedAmount());
                    storageResource.setCreateTime(contract.getCreateTime());
                    storageResource.setCreator(creator);
                    this.add(storageResource);
                } else {
                    storageResource.setAmount(storageResource.getAmount() + item.getAmount() - item.getFinishedAmount());
                    storageResource.setUpdater(creator);
                    storageResource.setUpdateTime(new Date());
                    this.update(storageResource);
                }
            }

        }
    }

    private void StorageResourceFromStorageIncoming(Entity entity) {
        StorageIncoming sic = (StorageIncoming)entity;
        Set items = sic.getItems();
        Iterator var5 = items.iterator();

        while(var5.hasNext()) {
            StorageIncomingItem item = (StorageIncomingItem)var5.next();
            Product product = (Product)this.entityService.get(Product.class, item.getProduct().getId().trim());
            Employee creator = (Employee)this.entityService.get(Employee.class, sic.getCreator().getId().trim());
            StorageResource storageResource = this.findStorageResource(product);
            if(storageResource == null) {
                storageResource = new StorageResource();
                storageResource.setProduct(product);
                storageResource.setAmount(item.getAmount());
                storageResource.setCreateTime(new Date());
                storageResource.setCreator(creator);
                this.add(storageResource);
            } else {
                storageResource.setAmount(storageResource.getAmount() + item.getAmount());
                storageResource.setUpdater(creator);
                storageResource.setUpdateTime(new Date());
                this.update(storageResource);
            }
        }

    }

    private void StorageResourceFromInWarehouse(Entity entity) {
        InWarehouse inWarehouse = (InWarehouse)entity;
        Product product = (Product)this.entityService.get(Product.class, inWarehouse.getProduct().getId());
        Employee emp = (Employee)this.entityService.get(Employee.class, inWarehouse.getCreator().getId());
        StorageResource storageResource = this.findStorageResource(product);
        if(storageResource == null) {
            storageResource = new StorageResource();
            storageResource.setProduct(product);
            storageResource.setAmount(inWarehouse.getTotalAmount());
            storageResource.setCreateTime(new Date());
            storageResource.setCreator(emp);
            this.add(storageResource);
        } else {
            storageResource.setAmount(storageResource.getAmount() + inWarehouse.getTotalAmount());
            storageResource.setUpdater(emp);
            storageResource.setUpdateTime(new Date());
            this.update(storageResource);
        }

    }

    private void StorageResourceFromOutWarehouse(Entity entity) {
        InWarehouse inWarehouse = (InWarehouse)entity;
        Product product = (Product)this.entityService.get(Product.class, inWarehouse.getProduct().getId().trim());
        StorageResource storageResource = this.findStorageResource(product);
        Employee emp = (Employee)this.entityService.get(Employee.class, inWarehouse.getCreator().getId());
        int restAmount = storageResource.getAmount() - inWarehouse.getTotalAmount();
        storageResource.setAmount(restAmount);
        storageResource.setUpdater(emp);
        storageResource.setUpdateTime(new Date());
        this.update(storageResource);
    }
}
