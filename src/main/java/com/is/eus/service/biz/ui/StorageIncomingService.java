package com.is.eus.service.biz.ui;

import com.is.eus.pojo.storage.StorageIncoming;
import com.is.eus.service.exception.InvalidOperationException;

public abstract interface StorageIncomingService
{
  public abstract void add(StorageIncoming paramStorageIncoming)
    throws InvalidOperationException;

  public abstract void udpate(StorageIncoming paramStorageIncoming)
    throws InvalidOperationException;

  public abstract void remove(String paramString)
    throws InvalidOperationException;

  public abstract void updateCheckerOrManager(StorageIncoming paramStorageIncoming, boolean paramBoolean1, boolean paramBoolean2)
    throws InvalidOperationException;

  public abstract void addBySchedule(StorageIncoming paramStorageIncoming)
    throws InvalidOperationException;
}
