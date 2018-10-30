package com.is.eus.model.event;

import com.is.eus.pojo.Entity;
import java.util.Collection;

public abstract interface Event
{
  public abstract String getName();

  public abstract Entity getEntity();

  public abstract Entity[] getEntities();

  public abstract Collection<Entity> getCollection();
}


