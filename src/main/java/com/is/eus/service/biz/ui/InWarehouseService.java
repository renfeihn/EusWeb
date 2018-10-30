package com.is.eus.service.biz.ui;

import com.is.eus.pojo.storage.InWarehouse;
import com.is.eus.service.exception.InvalidOperationException;

public abstract interface InWarehouseService
{
  public abstract void add(InWarehouse paramInWarehouse)
    throws InvalidOperationException;

  public abstract void addOut(InWarehouse paramInWarehouse)
    throws InvalidOperationException;
}

