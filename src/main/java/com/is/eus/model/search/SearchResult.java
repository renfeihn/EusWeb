package com.is.eus.model.search;

import java.util.List;

public abstract interface SearchResult
{
  public abstract List get();

  public abstract long getTotalCount();

  public abstract Class<?> getResultClass();
}



