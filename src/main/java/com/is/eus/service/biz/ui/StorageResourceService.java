package com.is.eus.service.biz.ui;

import com.is.eus.pojo.basic.Product;
import com.is.eus.pojo.storage.StorageResource;
import com.is.eus.service.exception.InvalidOperationException;

public abstract interface StorageResourceService
{
  public abstract void add(StorageResource paramStorageResource)
    throws InvalidOperationException;

  public abstract void udpate(StorageResource paramStorageResource)
    throws InvalidOperationException;

  public abstract void delete(StorageResource paramStorageResource)
    throws InvalidOperationException;

  public abstract StorageResource findStorageResource(Product paramProduct)
    throws InvalidOperationException;
}
