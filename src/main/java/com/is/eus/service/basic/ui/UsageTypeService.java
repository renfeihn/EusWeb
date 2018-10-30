package com.is.eus.service.basic.ui;

import com.is.eus.pojo.basic.UsageType;
import com.is.eus.service.exception.InvalidOperationException;

public abstract interface UsageTypeService
{
  public abstract void add(UsageType paramUsageType)
    throws InvalidOperationException;

  public abstract void udpate(UsageType paramUsageType)
    throws InvalidOperationException;

  public abstract void remove(String paramString)
    throws InvalidOperationException;
}

