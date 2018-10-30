package com.is.eus.service;

import com.is.eus.pojo.dac.User;
import com.is.eus.service.exception.InvalidOperationException;

public abstract interface UserService
{
  public abstract void add(User paramUser)
    throws InvalidOperationException;

  public abstract void update(User paramUser)
    throws InvalidOperationException;
}


