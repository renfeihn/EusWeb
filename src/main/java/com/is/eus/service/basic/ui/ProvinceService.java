package com.is.eus.service.basic.ui;

import com.is.eus.model.search.SearchResult;
import com.is.eus.pojo.basic.Province;
import com.is.eus.service.exception.InvalidOperationException;

public abstract interface ProvinceService
{
  public abstract void add(Province paramProvince)
    throws InvalidOperationException;

  public abstract void udpate(Province paramProvince)
    throws InvalidOperationException;

  public abstract void remove(String paramString)
    throws InvalidOperationException;

  public abstract SearchResult findUsing()
    throws InvalidOperationException;

  public abstract SearchResult findDeleted(Object[] paramArrayOfObject)
    throws InvalidOperationException;
}
