package com.is.eus.dao.support;

import com.is.eus.model.ui.FunctionTree;
import com.is.eus.model.ui.SystemFunction;
import java.util.Collection;

public abstract interface SystemFunctionsProvider
{
  public abstract FunctionTree lookup(String paramString);

  public abstract Collection<SystemFunction> categories();
}


