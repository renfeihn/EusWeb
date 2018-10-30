package com.is.eus.dao;

import com.is.eus.model.ui.FunctionTree;
import com.is.eus.model.ui.SystemFunction;
import java.util.Collection;

public abstract interface SystemFunctionsDao
{
  public abstract FunctionTree getSystemFunction(String paramString);

  public abstract Collection<SystemFunction> getSystemFunctionCategories();
}


