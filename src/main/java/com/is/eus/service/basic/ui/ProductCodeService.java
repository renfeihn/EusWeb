package com.is.eus.service.basic.ui;

import com.is.eus.pojo.basic.ProductCode;
import com.is.eus.service.exception.InvalidOperationException;

public abstract interface ProductCodeService
{
  public abstract void add(ProductCode paramProductCode)
    throws InvalidOperationException;

  public abstract void udpate(ProductCode paramProductCode)
    throws InvalidOperationException;

  public abstract void remove(String paramString)
    throws InvalidOperationException;
}

