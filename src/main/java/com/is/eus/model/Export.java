package com.is.eus.model;

import java.io.File;

public abstract interface Export<T>
{
  public abstract File export();

  public abstract File exportAll();
}
