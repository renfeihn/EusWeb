package com.is.eus.service;

import com.is.eus.model.ui.FunctionTree;
import com.is.eus.model.ui.SystemFunction;
import com.is.eus.pojo.dac.Role;
import java.util.Collection;

public abstract interface SystemFunctionsService
{
  public abstract Collection<SystemFunction> getSystemFunctionCategories(Collection<Role> paramCollection);

  public abstract FunctionTree getSystemFuntions(String paramString, Collection<Role> paramCollection);
}
