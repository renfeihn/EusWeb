package com.is.eus.dac;

import com.is.eus.pojo.Entity;

public abstract interface DacConfigurationListener
{
  public abstract <T extends Entity> void configurationRemoved(T paramT);
}



