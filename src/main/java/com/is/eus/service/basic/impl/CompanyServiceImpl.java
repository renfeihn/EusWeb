 package com.is.eus.service.basic.impl;

 import com.is.eus.pojo.basic.Company;
 import com.is.eus.service.basic.ui.CompanyService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.service.support.ObservableServiceBase;
 import com.is.eus.type.DataStatus;

 public class CompanyServiceImpl extends ObservableServiceBase
   implements CompanyService
 {
   public void add(Company company)
     throws InvalidOperationException
   {
     company.setState(DataStatus.Using.ordinal());
     super.add(company);
   }

   public void remove(String id) throws InvalidOperationException
   {
     Company company = (Company)super.get(Company.class, id);
     super.remove(company);
   }

   public void udpate(Company company) throws InvalidOperationException
   {
     if (company.getState() != DataStatus.Using.ordinal()) {
       throw new InvalidOperationException("修改失败");
     }
     super.update(company);
   }
 }
