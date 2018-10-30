 package com.is.eus.service.support;

 import com.is.eus.dao.SystemFunctionsDao;
 import com.is.eus.model.ui.FunctionTree;
 import com.is.eus.model.ui.SystemFunction;
 import com.is.eus.pojo.dac.Role;
 import com.is.eus.pojo.dac.RoleFunction;
 import com.is.eus.service.SystemFunctionsService;
 import java.util.ArrayList;
 import java.util.Collection;
 import java.util.List;
 import org.apache.commons.lang.StringUtils;
 import org.apache.log4j.Logger;

 public class SystemFunctionsServiceImpl
   implements SystemFunctionsService
 {
   private static final Logger log = Logger.getLogger(SystemFunctionsServiceImpl.class);
   private SystemFunctionsDao systemFunctionsDao;

   public void setSystemFunctionsDao(SystemFunctionsDao systemFunctionsDao)
   {
     this.systemFunctionsDao = systemFunctionsDao;
   }

   SystemFunction createFunction(SystemFunction function) {
     SystemFunction func = new SystemFunction();
     func.setId(function.getId());
     func.setTitle(function.getTitle());
     func.setUrl(function.getUrl());
     return func;
   }

   void copySystemFunction(SystemFunction source, SystemFunction dest, Collection<Role> roles) {
     for (SystemFunction child : source.getChildren())
       for (Role role : roles)
         if (hasAccess(role, child.getId())) {
           SystemFunction newChild = createFunction(child);
           dest.addChild(newChild);
           copySystemFunction(child, newChild, roles);
         }
   }

   public FunctionTree getSystemFuntions(String category, Collection<Role> roles)
   {
     if (StringUtils.isEmpty(category)) return null;
     log.info("get system funtions, category:" + category);
     FunctionTree tree = this.systemFunctionsDao.getSystemFunction(category);
     SystemFunction root = tree.getRoot();
     for (Role role : roles) {
       if (hasAccess(role, root.getId())) {
         FunctionTree dest = new FunctionTree();
         SystemFunction destRoot = createFunction(root);
         dest.setRoot(destRoot);
         copySystemFunction(root, destRoot, roles);
         return dest;
       }
     }

     return null;
   }

   private boolean hasAccess(Role role, String function) {
     if (role.getCode().equals("admin")) return true;
     for (RoleFunction rf : role.getFunctions()) {
       if (rf.getFunctionId().equals(function)) {
         return true;
       }
     }
     return false;
   }

   public Collection<SystemFunction> getSystemFunctionCategories(Collection<Role> roles)
   {
     log.info("get system function categories.");
     List categories = new ArrayList();
     for (SystemFunction f : this.systemFunctionsDao.getSystemFunctionCategories()) {
       for (Role role : roles) {
         if (hasAccess(role, f.getId())) {
           categories.add(f);
           break;
         }
       }
     }
     return categories;
   }
 }
