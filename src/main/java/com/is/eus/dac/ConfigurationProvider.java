package com.is.eus.dac;

import com.is.eus.pojo.Entity;
import com.is.eus.pojo.dac.Role;
import com.is.eus.pojo.dac.User;
import java.util.Collection;

public abstract interface ConfigurationProvider
{
  public abstract void reload();

  public abstract void init();

  public abstract User getUser(String paramString);

  public abstract void update(Entity paramEntity);

  public abstract User getUserByName(String paramString);

  public abstract Role getRole(String paramString);

  public abstract <T> Collection<T> list(Class<T> paramClass);

  public abstract <T> T get(Class<T> paramClass, String paramString);
}


