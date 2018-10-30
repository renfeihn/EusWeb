 package com.is.eus.pojo.dac;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.system.Employee;
 import java.util.Set;

 public class User extends Entity
 {
   private String name;
   private String password;
   private Employee employee;
   private String secret;
   private Set<Role> roles;

   public String getName()
   {
     return this.name;
   }
   public void setName(String name) {
     this.name = name;
   }
   public String getPassword() {
     return this.password;
   }
   public void setPassword(String password) {
     this.password = password;
   }
   public Employee getEmployee() {
     return this.employee;
   }
   public void setEmployee(Employee employee) {
     this.employee = employee;
   }
   public Set<Role> getRoles() {
     return this.roles;
   }
   public void setRoles(Set<Role> roles) {
     this.roles = roles;
   }
   public String getSecret() {
     return this.secret;
   }
   public void setSecret(String secret) {
     this.secret = secret;
   }
 }

