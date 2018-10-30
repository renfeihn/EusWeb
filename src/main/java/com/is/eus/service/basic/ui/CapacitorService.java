package com.is.eus.service.basic.ui;

import com.is.eus.pojo.basic.Capacitor;
import com.is.eus.service.exception.InvalidOperationException;

public abstract interface CapacitorService
{
  public abstract void add(Capacitor paramCapacitor)
    throws InvalidOperationException;

  public abstract void udpate(Capacitor paramCapacitor)
    throws InvalidOperationException;

  public abstract void remove(String paramString)
    throws InvalidOperationException;

  public abstract String getProductIDByProductCombination(String paramString)
    throws InvalidOperationException;
}
