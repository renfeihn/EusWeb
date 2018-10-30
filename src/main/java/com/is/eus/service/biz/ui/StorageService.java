package com.is.eus.service.biz.ui;

import com.is.eus.pojo.storage.Storage;
import com.is.eus.service.exception.InvalidOperationException;
import java.io.File;
import java.io.IOException;
import jxl.write.WriteException;

public abstract interface StorageService
{
  public abstract void add(Storage paramStorage)
    throws InvalidOperationException;

  public abstract void udpate(Storage paramStorage)
    throws InvalidOperationException;

  public abstract void remove(Storage paramStorage)
    throws InvalidOperationException;

  public abstract String findStorage(Object[] paramArrayOfObject)
    throws InvalidOperationException;

  public abstract File print()
    throws WriteException, IOException;
}
