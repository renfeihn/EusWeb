package com.is.eus.dao;

import com.is.eus.pojo.Entity;

public abstract interface EntityDao
{
  public abstract void add(Object paramObject);

  public abstract void update(Object paramObject);

  public abstract void remove(Class<?> paramClass, String paramString);

  public abstract <T> T get(Class<T> paramClass, String paramString);

  public abstract void delete(Object paramObject);

  public abstract void add(Object[] paramArrayOfObject);

  public abstract void delete(Object[] paramArrayOfObject);

  public abstract void refresh(Entity paramEntity);

  public abstract void update(Object[] paramArrayOfObject);
}



