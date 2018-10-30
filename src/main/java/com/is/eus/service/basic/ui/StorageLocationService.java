package com.is.eus.service.basic.ui;

import com.is.eus.pojo.basic.StorageLocation;
import com.is.eus.service.exception.InvalidOperationException;

public abstract interface StorageLocationService
{
  public abstract void add(StorageLocation paramStorageLocation)
    throws InvalidOperationException;

  public abstract void udpate(StorageLocation paramStorageLocation)
    throws InvalidOperationException;

  public abstract void remove(String paramString)
    throws InvalidOperationException;
}
