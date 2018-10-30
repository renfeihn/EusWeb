package com.is.eus.service.basic.ui;

import com.is.eus.pojo.basic.ErrorLevel;
import com.is.eus.service.exception.InvalidOperationException;

public abstract interface ErrorLevelService
{
  public abstract void add(ErrorLevel paramErrorLevel)
    throws InvalidOperationException;

  public abstract void udpate(ErrorLevel paramErrorLevel)
    throws InvalidOperationException;

  public abstract void remove(String paramString)
    throws InvalidOperationException;
}