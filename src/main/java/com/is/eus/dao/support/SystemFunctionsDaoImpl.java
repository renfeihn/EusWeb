 package com.is.eus.dao.support;

 import com.is.eus.dao.SystemFunctionsDao;
 import com.is.eus.model.ui.FunctionTree;
 import com.is.eus.model.ui.SystemFunction;
 import java.util.Collection;

 public class SystemFunctionsDaoImpl
   implements SystemFunctionsDao
 {
   private SystemFunctionsProvider provider;

   public SystemFunctionsProvider getProvider()
   {
     return this.provider;
   }
   public void setProvider(SystemFunctionsProvider provider) {
     this.provider = provider;
   }

   public FunctionTree getSystemFunction(String category)
   {
     return this.provider.lookup(category);
   }

   public Collection<SystemFunction> getSystemFunctionCategories()
   {
     return this.provider.categories();
   }
 }


