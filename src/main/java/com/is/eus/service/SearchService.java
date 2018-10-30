package com.is.eus.service;

import com.is.eus.model.search.Search;
import com.is.eus.model.search.SearchResult;

public abstract interface SearchService
{
  public abstract SearchResult search(Search paramSearch);

  public abstract SearchResult search(String paramString, Object[] paramArrayOfObject);

  public abstract SearchResult search(String paramString);
}
