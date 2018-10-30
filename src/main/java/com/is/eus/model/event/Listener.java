package com.is.eus.model.event;

import com.is.eus.service.exception.InvalidOperationException;

public abstract interface Listener
{
  public abstract void notice(Event paramEvent)
    throws InvalidOperationException;
}



