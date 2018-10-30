package com.is.eus.service;

import com.is.eus.pojo.Entity;
import com.is.eus.service.exception.InvalidOperationException;

public abstract interface EntityService
{
  public abstract Entity get(Class<?> paramClass, String paramString);

  public abstract void add(Entity paramEntity);

  public abstract void add(Entity[] paramArrayOfEntity);

  public abstract void update(Entity paramEntity);

  public abstract void update(Entity[] paramArrayOfEntity);

  public abstract void change(Entity paramEntity, Class<?> paramClass, String paramString)
    throws InvalidOperationException;

  public abstract void delete(Entity[] paramArrayOfEntity);

  public abstract void delete(Entity paramEntity);

  public abstract void refresh(Entity paramEntity);

  public abstract void remove(Entity paramEntity);

  public abstract void remove(Entity[] paramArrayOfEntity);
}

