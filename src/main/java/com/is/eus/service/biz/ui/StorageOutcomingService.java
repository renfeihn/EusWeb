package com.is.eus.service.biz.ui;

import com.is.eus.model.search.SearchResult;
import com.is.eus.pojo.storage.StorageOutcoming;
import com.is.eus.service.exception.InvalidOperationException;
import java.io.File;
import java.io.IOException;
import jxl.write.WriteException;

public abstract interface StorageOutcomingService
{
  public abstract void add(StorageOutcoming paramStorageOutcoming)
    throws InvalidOperationException;

  public abstract void update(StorageOutcoming paramStorageOutcoming)
    throws InvalidOperationException;

  public abstract void checkFailed(StorageOutcoming paramStorageOutcoming)
    throws InvalidOperationException;

  public abstract void checkSuccess(StorageOutcoming paramStorageOutcoming)
    throws InvalidOperationException;

  public abstract SearchResult findByContract(Object[] paramArrayOfObject)
    throws InvalidOperationException;

  public abstract void print(String paramString, boolean paramBoolean)
    throws IOException;

  public abstract File print2(String paramString)
    throws WriteException, IOException;
}
