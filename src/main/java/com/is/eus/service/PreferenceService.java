package com.is.eus.service;

import com.is.eus.pojo.system.Preference;

public abstract interface PreferenceService
{
  public static final int PREFERENCE_DIG_DEPATH = 1;
  public static final String CONTRACT_EXPIRE_TIME = "Contract Expire Time";
  public static final String CONTRACT_AUDIT_PASS_EXPIRE_TIME = "Contract Audit Past Expire Time";
  public static final String CONTRACT_AUDIT_FAIL_EXPIRE_TIME = "Contract Audit Fail Expire Time";

  public abstract Preference get(String paramString);

  public abstract void init();

  public abstract void reload();
}


