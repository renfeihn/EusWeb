package com.is.eus.service;

import com.is.eus.pojo.dac.User;

public abstract interface VerificationService
{
  public abstract User getUserByName(String paramString);

  public abstract User getUserById(String paramString);
}

