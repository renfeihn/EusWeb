package com.is.eus.service.biz.ui;

import com.is.eus.model.search.SearchResult;
import com.is.eus.pojo.schedule.Schedule;
import com.is.eus.pojo.schedule.ScheduleSummeryView;
import com.is.eus.pojo.schedule.ScheduleView;
import com.is.eus.service.exception.InvalidOperationException;
import java.io.File;
import java.io.IOException;
import java.util.List;
import jxl.write.WriteException;

public abstract interface ScheduleService
{
  public abstract void add(Schedule paramSchedule)
    throws InvalidOperationException;

  public abstract void udpate(Schedule paramSchedule)
    throws InvalidOperationException;

  public abstract void remove(String paramString)
    throws InvalidOperationException;

  public abstract void udpateByBiz(Schedule paramSchedule, int paramInt)
    throws InvalidOperationException;

  public abstract SearchResult findProduct(Object[] paramArrayOfObject)
    throws InvalidOperationException;

  public abstract void print(List<Schedule> paramList, String paramString1, String paramString2)
    throws IOException;

  public abstract void printView(List<ScheduleView> paramList, String paramString1, String paramString2)
    throws IOException;

  public abstract void printSummeryView(List<ScheduleSummeryView> paramList, String paramString1, String paramString2)
    throws IOException;

  public abstract File getReport()
    throws WriteException, IOException;
}
