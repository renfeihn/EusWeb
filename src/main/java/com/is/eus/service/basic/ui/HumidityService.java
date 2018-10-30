package com.is.eus.service.basic.ui;

import com.is.eus.pojo.basic.Humidity;
import com.is.eus.service.exception.InvalidOperationException;

public abstract interface HumidityService
{
  public abstract void add(Humidity paramHumidity)
    throws InvalidOperationException;

  public abstract void udpate(Humidity paramHumidity)
    throws InvalidOperationException;

  public abstract void remove(String paramString)
    throws InvalidOperationException;
}

