 package com.is.eus.util;

 import com.is.eus.pojo.dac.DataAccess;
 import com.is.eus.pojo.dac.RoleDataAccess;
 import java.util.Collection;

 public class RoleDataAccessUtil
 {
   public static String getJson(Collection<DataAccess> all, Collection<RoleDataAccess> access)
   {
     StringBuilder builder = new StringBuilder();
     builder.append("{success: true, results:").append(all.size()).append(", RoleDataAccessList:[");
     for (DataAccess da : all) {
       builder.append("{id:'").append(da.getId()).append("', code:'").append(da.getCode()).append("'");
       builder.append(", name:'").append(da.getName()).append("', state:").append(da.getState());
       boolean found = false;
       for (RoleDataAccess rda : access) {
         if (da.getCode().equals(rda.getCode())) {
           found = true;
           builder.append(", value:").append(rda.getState());
           break;
         }
       }
       if (!found) {
         builder.append(", value: -1");
       }
       builder.append("},");
     }
     if (builder.charAt(builder.length() - 1) == ',') {
       builder.delete(builder.length() - 1, builder.length());
     }
     builder.append("]}");
     return builder.toString();
   }
 }


