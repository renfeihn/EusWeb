package com.is.eus.service.biz.ui;

import com.is.eus.pojo.storage.StorageItem;
import com.is.eus.service.exception.InvalidOperationException;
import java.io.File;
import java.io.IOException;
import java.util.List;
import jxl.write.WriteException;

public abstract interface StorageItemService
{
  public abstract void add(StorageItem paramStorageItem)
    throws InvalidOperationException;

  public abstract void udpate(StorageItem paramStorageItem)
    throws InvalidOperationException;

  public abstract void remove(StorageItem paramStorageItem)
    throws InvalidOperationException;

  public abstract List<StorageItem> findStorageItem(Object[] paramArrayOfObject)
    throws InvalidOperationException;

  public abstract File print()
    throws WriteException, IOException;
}