 package com.is.eus.util;

 import com.is.eus.model.ui.FunctionTree;
 import com.is.eus.model.ui.SystemFunction;
 import java.util.Collection;
 import org.apache.commons.lang.StringUtils;
 import org.apache.log4j.Logger;

 public class SystemFunctionTreeUtil
 {
   private static final Logger log = Logger.getLogger(SystemFunctionTreeUtil.class);

   public static String treeJson(FunctionTree tree)
   {
     if (tree == null) {
       return "[{}]";
     }
     StringBuilder builder = new StringBuilder();
     StringBuilder items = buildJsonString(tree.getRoot(), false, false);
     items.delete(items.length() - 1, items.length());
     builder.append("[").append(items).append("]");

     return builder.toString();
   }

   private static StringBuilder buildJsonString(SystemFunction function, boolean needCheckbox, boolean checked)
   {
     StringBuilder builder = new StringBuilder();
     builder.append("{");
     builder.append("text:'" + function.getTitle() + "',");
     if (needCheckbox) {
       builder.append("checked:").append(checked ? "true" : "false").append(",");
     }
     builder.append("id:'" + function.getId() + "'");
     if ((function.getUrl() != null) && (!needCheckbox)) {
       builder.append(",url:'").append(StringUtils.trimToEmpty(function.getUrl())).append("'");
     }
     if (function.hasChildren()) {
       builder.append(",children:[");
       for (SystemFunction child : function.getChildren()) {
         builder.append(buildJsonString(child, needCheckbox, checked));
       }
       builder.replace(builder.length() - 1, builder.length(), "]");
     } else {
       builder.append(",leaf:true");
     }
     builder.append("},");
     return builder;
   }

   public static String treeJson(Collection<FunctionTree> trees, boolean checkbox)
   {
     StringBuilder builder = new StringBuilder();
     builder.append("[{text:'所有权限', id:'root', children:[");
     for (FunctionTree tree : trees) {
       builder.append(buildJsonString(tree.getRoot(), checkbox, false));
     }
     if (builder.charAt(builder.length() - 1) == ',') {
       builder.delete(builder.length() - 1, builder.length());
     }
     builder.append("]}]");

     return builder.toString();
   }

   public static String categoriesJson(Collection<SystemFunction> categories)
   {
     if ((categories == null) || (categories.isEmpty())) {
       log.info("user does NOT have any operatable category.");
       return "{success:false}";
     }
     StringBuilder builder = new StringBuilder();
     builder.append("{success:true, categories:[");
     for (SystemFunction category : categories) {
       builder.append("{id:'").append(category.getId()).append("', title:'").append(category.getTitle()).append("'},");
     }
     if (builder.charAt(builder.length() - 1) == ',') {
       builder.delete(builder.length() - 1, builder.length());
     }
     builder.append("]}");
     return builder.toString();
   }
 }

