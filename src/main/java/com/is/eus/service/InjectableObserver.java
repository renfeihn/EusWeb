package com.is.eus.service;

import com.is.eus.model.event.Listener;
import java.util.Map;
import java.util.Set;

public abstract interface InjectableObserver
{
  public abstract void setEvents(String paramString);

  public abstract void setListeners(Map<String, Set<Listener>> paramMap);
}

