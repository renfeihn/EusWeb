package com.is.eus.service.biz.ui;

import com.is.eus.pojo.storage.StorageView;
import java.io.IOException;
import java.util.List;

public abstract interface StorageViewService
{
  public abstract void print(List<StorageView> paramList)
    throws IOException;
}

