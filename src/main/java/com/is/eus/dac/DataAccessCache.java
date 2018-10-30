 package com.is.eus.dac;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.dac.Group;
 import com.is.eus.pojo.dac.Role;
 import com.is.eus.pojo.dac.RoleDataAccess;
 import com.is.eus.pojo.dac.RoleFunction;
 import com.is.eus.pojo.dac.User;
 import java.util.Collection;
 import java.util.Collections;
 import java.util.HashSet;
 import java.util.LinkedHashMap;
 import java.util.Map;
 import java.util.Map.Entry;
 import java.util.Set;
 import org.apache.log4j.Logger;

 public class DataAccessCache
 {
   private static final Logger logger = Logger.getLogger(DataAccessCache.class);
   private static final long serialVersionUID = 6715132685917829886L;
   private Cache<String, User> usersData = new Cache();
   private Cache<String, Group> groupsData = new Cache();
   private Cache<String, Role> rolesData = new Cache();
   private Cache<String, RoleFunction> roleFunctionData = new Cache(500);
   private Cache<String, RoleDataAccess> roleDataAccess = new Cache();

   private Map<String, User> users = Collections.synchronizedMap(this.usersData);
   private Map<String, Group> groups = Collections.synchronizedMap(this.groupsData);
   private Map<String, Role> roles = Collections.synchronizedMap(this.rolesData);
   private Map<String, RoleFunction> roleFunctions = Collections.synchronizedMap(this.roleFunctionData);
   private Map<String, RoleDataAccess> roleDatas = Collections.synchronizedMap(this.roleDataAccess);

   private Set<DacConfigurationListener> listeners = new HashSet();

   public void setCapcity(int cap)
   {
     this.usersData.setCapcity(cap);
     this.groupsData.setCapcity(cap);
     this.rolesData.setCapcity(cap);
     this.roleFunctionData.setCapcity(cap);
     this.roleDataAccess.setCapcity(cap);
   }

   public void addListener(DacConfigurationListener listener)
   {
     this.listeners.add(listener);
   }

   public User getUser(String id) {
     return (User)this.users.get(id);
   }

   public Collection<User> getUsers() {
     return this.users.values();
   }

   public Collection<Group> getGroups() {
     return this.groups.values();
   }

   public Collection<Role> getRoles() {
     return this.roles.values();
   }

   public void addUser(User user) {
     this.users.put(user.getId(), user);
     for (Role role : user.getRoles())
       addRole(role);
   }

   public Collection<RoleFunction> getRoleFunctions()
   {
     return this.roleFunctions.values();
   }

   void addRoleFunction(RoleFunction function) {
     this.roleFunctions.put(function.getId(), function);
   }

   public void addRole(Role role) {
     logger.isDebugEnabled();
     this.roles.put(role.getId(), role);
     for (RoleFunction function : role.getFunctions()) {
       addRoleFunction(function);
     }
     for (RoleDataAccess rda : role.getDatas())
       addRoleDataAccess(rda);
   }

   void addRoleDataAccess(RoleDataAccess rda)
   {
     this.roleDataAccess.put(rda.getId(), rda);
   }

   public Collection<RoleDataAccess> getRoleDataAccess() {
     return this.roleDatas.values();
   }

   public void updateUser(User user) {
     this.users.remove(user.getId());
     addUser(user);
   }

   public Role getRole(String role) {
     return (Role)this.roles.get(role);
   }

   public void removeRole(Role role)
   {
     this.roles.remove(role);
   }

   class Cache<K, V extends Entity> extends LinkedHashMap<K, V>
   {
     private static final long serialVersionUID = -1650752531092139964L;
     private int capcity = 100;

     Cache()
     {
     }

     Cache(int capcity)
     {
       this.capcity = capcity;
     }

     public void setCapcity(int cap)
     {
       this.capcity = cap;
     }

     protected boolean removeEldestEntry(Map.Entry<K, V> entry)
     {
       if (size() > this.capcity) {
         for (DacConfigurationListener listener : DataAccessCache.this.listeners) {
           listener.configurationRemoved((Entity)entry.getValue());
         }
         return true;
       }
       return false;
     }
   }
 }

