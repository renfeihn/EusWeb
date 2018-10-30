package com.is.eus.service.basic.ui;

import com.is.eus.pojo.basic.ProductType;
import com.is.eus.service.exception.InvalidOperationException;

public abstract interface ProductTypeService
{
  public abstract void add(ProductType paramProductType)
    throws InvalidOperationException;

  public abstract void udpate(ProductType paramProductType)
    throws InvalidOperationException;

  public abstract void remove(String paramString)
    throws InvalidOperationException;
}
