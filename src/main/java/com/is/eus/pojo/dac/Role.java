 package com.is.eus.pojo.dac;

 import com.is.eus.pojo.Entity;
 import java.util.Set;

 public class Role extends Entity
 {
   private String code;
   private String name;
   private String description;
   private Set<User> users;
   private Set<RoleFunction> functions;
   private Set<RoleDataAccess> datas;

   public String getName()
   {
     return this.name;
   }
   public void setName(String name) {
     this.name = name;
   }
   public String getCode() {
     return this.code;
   }
   public void setCode(String code) {
     this.code = code;
   }
   public Set<User> getUsers() {
     return this.users;
   }
   public void setUsers(Set<User> users) {
     this.users = users;
   }
   public Set<RoleFunction> getFunctions() {
     return this.functions;
   }
   public void setFunctions(Set<RoleFunction> functions) {
     this.functions = functions;
   }
   public String getDescription() {
     return this.description;
   }
   public void setDescription(String description) {
     this.description = description;
   }
   public Set<RoleDataAccess> getDatas() {
     return this.datas;
   }
   public void setDatas(Set<RoleDataAccess> datas) {
     this.datas = datas;
   }
 }

