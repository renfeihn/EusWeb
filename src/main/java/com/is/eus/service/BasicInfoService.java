package com.is.eus.service;

import com.is.eus.pojo.Entity;
import com.is.eus.pojo.system.Employee;
import com.is.eus.service.exception.InvalidOperationException;

public abstract interface BasicInfoService
{
  public abstract void add(String paramString1, String paramString2, String paramString3, String paramString4, Employee paramEmployee)
    throws InvalidOperationException;

  public abstract void update(String paramString1, String paramString2, String paramString3, String paramString4, Employee paramEmployee)
    throws InvalidOperationException;

  public abstract void remove(String paramString1, String paramString2, Employee paramEmployee)
    throws InvalidOperationException;

  public abstract Entity get(String paramString1, String paramString2);

  public abstract Class<?> getTargetClass(String paramString);

  public abstract void change(String paramString1, String paramString2, String paramString3, Employee paramEmployee)
    throws InvalidOperationException;
}


