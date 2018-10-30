package com.is.eus.service;

import com.is.eus.pojo.system.Sequence;
import java.util.Collection;

public abstract interface SequenceService
{
  public static final int SEQUECNE_DIG_DEPTH = 1;

  public abstract String acquire(String paramString);

  public abstract String acquire(String paramString, boolean paramBoolean, int paramInt);

  public abstract Collection<Sequence> list();

  public abstract void load();
}

