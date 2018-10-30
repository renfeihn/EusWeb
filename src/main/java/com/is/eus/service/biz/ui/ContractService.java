package com.is.eus.service.biz.ui;

import com.is.eus.pojo.contract.Contract;
import com.is.eus.pojo.contract.ContractItemOwnedSummeryView;
import com.is.eus.service.exception.InvalidOperationException;
import java.io.IOException;
import java.util.List;

public abstract interface ContractService
{
  public abstract void add(Contract paramContract)
    throws InvalidOperationException;

  public abstract void udpate(Contract paramContract)
    throws InvalidOperationException;

  public abstract void udpateByBiz(Contract paramContract, int paramInt)
    throws InvalidOperationException;

  public abstract void remove(String paramString)
    throws InvalidOperationException;

  public abstract void print(List<ContractItemOwnedSummeryView> paramList)
    throws IOException;

  public abstract void printContract(List<Contract> paramList, int paramInt)
    throws IOException;
}

