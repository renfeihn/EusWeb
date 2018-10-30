 package com.is.eus.service.basic.impl;

 import com.is.eus.model.search.SearchResult;
 import com.is.eus.pojo.basic.Province;
 import com.is.eus.service.SearchService;
 import com.is.eus.service.basic.ui.ProvinceService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.service.support.ObservableServiceBase;
 import com.is.eus.type.DataStatus;

 public class ProvinceServiceImpl extends ObservableServiceBase
   implements ProvinceService
 {
   private SearchService searchService;

   public void setSearchService(SearchService searchService)
   {
     this.searchService = searchService;
   }

   public void add(Province province) throws InvalidOperationException
   {
     province.setState(DataStatus.Using.ordinal());
     super.add(province);
   }

   public void remove(String id) throws InvalidOperationException
   {
     Province province = (Province)super.get(Province.class, id);
     super.remove(province);
   }

   public void udpate(Province province) throws InvalidOperationException
   {
     if (province.getState() != DataStatus.Using.ordinal()) {
       throw new InvalidOperationException("修改失败");
     }
     super.update(province);
   }

   public SearchResult findDeleted(Object[] values) throws InvalidOperationException
   {
     return this.searchService.search("com.is.eus.pojo.basic.Province.findDeleted", values);
   }

   public SearchResult findUsing() throws InvalidOperationException
   {
     return this.searchService.search("com.is.eus.pojo.basic.Province.findUsing");
   }
 }
