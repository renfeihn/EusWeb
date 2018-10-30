package com.is.eus.service.basic.ui;

import com.is.eus.pojo.basic.Unit;
import com.is.eus.service.exception.InvalidOperationException;

public abstract interface UnitService
{
  public abstract void add(Unit paramUnit)
    throws InvalidOperationException;

  public abstract void udpate(Unit paramUnit)
    throws InvalidOperationException;

  public abstract void remove(String paramString)
    throws InvalidOperationException;
}

