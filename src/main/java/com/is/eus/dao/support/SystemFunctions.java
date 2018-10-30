 package com.is.eus.dao.support;

 import com.is.eus.model.ui.FunctionTree;
 import com.is.eus.model.ui.SystemFunction;
 import java.util.ArrayList;
 import java.util.Collection;
 import java.util.Collections;
 import java.util.List;
 import java.util.Map;
 import java.util.TreeMap;
 import org.apache.log4j.Logger;

 public class SystemFunctions
 {
   private static final Logger log = Logger.getLogger(SystemFunctions.class);

   List<String> categoryIds = Collections.synchronizedList(new ArrayList());

   Map<String, FunctionTree> categories = Collections.synchronizedMap(new TreeMap());

   public void addFunctionTree(FunctionTree tree) {
     String id = tree.getId();
     this.categories.put(id, tree);
     this.categoryIds.add(id);
   }

   public FunctionTree lookup(String category)
   {
     for (String cate : this.categories.keySet()) {
       if (cate.equalsIgnoreCase(category)) {
         log.info("found Match:" + category);
         FunctionTree tree = (FunctionTree)this.categories.get(cate);

         return tree;
       }
     }

     return null;
   }

   public Collection<SystemFunction> getAllCategories()
   {
     List categories = new ArrayList();
     for (String id : this.categoryIds) {
       if (this.categories.containsKey(id)) {
         categories.add(((FunctionTree)this.categories.get(id)).getRoot());
       }
     }
     return categories;
   }
 }

