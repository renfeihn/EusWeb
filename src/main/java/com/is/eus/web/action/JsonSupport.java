package com.is.eus.web.action;

public abstract interface JsonSupport
{
  public static final String JSON = "json";
  public static final String OPENFLASHCHART = "openflashchart";
  public static final String PIE = "pie";
  public static final String BAR = "bar";
  public static final String LINE = "line";
  public static final String MULTILINES = "multilines";
  public static final String BARS_N_LINES = "barsNlines";
  public static final String JSON_VARIALBE_NAME = "json";
  public static final String EXTGRID = "extgrid";

  public abstract String getJson();
}


