package com.is.eus.dao;

import com.is.eus.pojo.dac.RoleDataAccess;
import java.util.List;

public abstract interface SearchDao
{
  public abstract long count(RoleDataAccess paramRoleDataAccess, String paramString1, Class<?> paramClass, List<String> paramList, String paramString2, Integer[] paramArrayOfInteger1, Integer[] paramArrayOfInteger2, String paramString3, String paramString4);

  public abstract List find(RoleDataAccess paramRoleDataAccess, String paramString1, Class<?> paramClass, List<String> paramList, String paramString2, Integer[] paramArrayOfInteger1, Integer[] paramArrayOfInteger2, int paramInt1, int paramInt2, String paramString3, String paramString4);

  public abstract List find(String paramString, Object[] paramArrayOfObject);

  public abstract List find(String paramString);
}


