package com.is.eus.model.search;

import com.is.eus.pojo.dac.User;

public abstract interface Search
{
  public abstract Class<?> getEntityClass();

  public abstract Class<?> getStatusClass();

  public abstract int getStart();

  public abstract int getLimit();

  public abstract String getText();

  public abstract String[] getStates();

  public abstract String[] getStatus();

  public abstract User getUser();

  public abstract String getHQLCondition();

  public abstract String getQueryName();
}



