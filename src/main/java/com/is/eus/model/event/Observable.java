package com.is.eus.model.event;

public abstract interface Observable
{
  public abstract boolean addEvent(String paramString);

  public abstract boolean addListener(String paramString, Listener paramListener);
}


