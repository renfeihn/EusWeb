 package com.is.eus.pojo.dac;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.system.Department;
 import java.util.Set;

 public class Group extends Entity
 {
   private Set<Department> departments;
   private Set<User> users;
   private String name;
   private String description;
   private Role role;

   public Set<Department> getDepartments()
   {
     return this.departments;
   }
   public void setDepartments(Set<Department> departments) {
     this.departments = departments;
   }
   public Set<User> getUsers() {
     return this.users;
   }
   public void setUsers(Set<User> users) {
     this.users = users;
   }
   public String getName() {
     return this.name;
   }
   public void setName(String name) {
     this.name = name;
   }
   public String getDescription() {
     return this.description;
   }
   public void setDescription(String description) {
     this.description = description;
   }
   public Role getRole() {
     return this.role;
   }
   public void setRole(Role role) {
     this.role = role;
   }
 }
