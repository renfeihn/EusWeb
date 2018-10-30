package com.is.eus.service;

import com.is.eus.pojo.dac.DataAccess;
import com.is.eus.pojo.dac.Role;
import com.is.eus.pojo.dac.RoleDataAccess;
import com.is.eus.pojo.dac.RoleFunction;
import com.is.eus.pojo.dac.User;
import com.is.eus.service.exception.InvalidOperationException;
import java.util.Collection;
import java.util.Set;

public abstract interface DataAccessControlService
{
  public abstract User fetchUserByName(String paramString);

  public abstract User fetchUser(String paramString);

  public abstract void updateUser(User paramUser);

  public abstract void addRoleFunctions(Set<RoleFunction> paramSet);

  public abstract Role fetchRole(String paramString);

  public abstract void addUser(User paramUser);

  public abstract void addRole(Role paramRole)
    throws InvalidOperationException;

  public abstract Collection<RoleDataAccess> listRoleDataAccess();

  public abstract DataAccess fetchDataAccess(String paramString);

  public abstract void updateDataAccess(DataAccess paramDataAccess)
    throws InvalidOperationException;

  public abstract void addDataAccess(DataAccess paramDataAccess)
    throws InvalidOperationException;

  public abstract RoleDataAccess fetchRoleDataAccess(Collection<Role> paramCollection, String paramString);

  public abstract void updateRole(Role paramRole)
    throws InvalidOperationException;

  public abstract void evictUser(String paramString);

  public abstract Collection<DataAccess> listDataAccess();
}

