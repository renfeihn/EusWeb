package com.is.eus.service.basic.ui;

import com.is.eus.pojo.basic.City;
import com.is.eus.service.exception.InvalidOperationException;

public abstract interface CityService
{
  public abstract void add(City paramCity)
    throws InvalidOperationException;

  public abstract void udpate(City paramCity)
    throws InvalidOperationException;

  public abstract void remove(String paramString)
    throws InvalidOperationException;
}
