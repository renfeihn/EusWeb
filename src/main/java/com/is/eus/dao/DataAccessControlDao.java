package com.is.eus.dao;

import com.is.eus.pojo.Entity;
import com.is.eus.pojo.dac.Role;
import com.is.eus.pojo.dac.User;
import java.util.List;

public abstract interface DataAccessControlDao
{
  public abstract void update(Entity paramEntity);

  public abstract <T> T get(Class<T> paramClass, String paramString);

  public abstract <T> List<T> list(Class<T> paramClass);

  public abstract User findUserByName(String paramString);

  public abstract User getUser(String paramString);

  public abstract Role getRole(String paramString);
}


