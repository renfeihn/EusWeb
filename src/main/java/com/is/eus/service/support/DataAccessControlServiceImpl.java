 package com.is.eus.service.support;

 import com.is.eus.dac.Configuration;
 import com.is.eus.pojo.dac.DataAccess;
 import com.is.eus.pojo.dac.Role;
 import com.is.eus.pojo.dac.RoleDataAccess;
 import com.is.eus.pojo.dac.RoleFunction;
 import com.is.eus.pojo.dac.User;
 import com.is.eus.service.DataAccessControlService;
 import com.is.eus.service.exception.InvalidOperationException;
 import java.util.Collection;
 import java.util.Set;
 import org.springframework.transaction.annotation.Transactional;

 public class DataAccessControlServiceImpl extends EntityServiceImpl
   implements DataAccessControlService
 {
   private Configuration configuration;

   public void setConfiguration(Configuration configuration)
   {
     this.configuration = configuration;
   }
   @Transactional
   public void init() {
     this.configuration.init();
   }

   public User fetchUserByName(String name)
   {
     return this.configuration.getUserByName(name);
   }

   public void evictUser(String id)
   {
     this.configuration.evictUser(id);
   }

   public User fetchUser(String id)
   {
     User user = this.configuration.getUser(id);
     return user;
   }

   public void updateUser(User user)
   {
     this.configuration.updateUser(user);
   }

   public void addRoleFunctions(Set<RoleFunction> rfs)
   {
     this.configuration.addRoleFunctions(rfs);
   }

   public Role fetchRole(String role)
   {
     return this.configuration.getRole(role);
   }

   public void addUser(User user)
   {
     this.configuration.addUser(user);
   }

   public void addRole(Role role) throws InvalidOperationException
   {
     addRoleFunctions(role.getFunctions());
     super.add(role);
   }

   public void updateDataAccess(DataAccess dataAccess) throws InvalidOperationException
   {
     super.update(dataAccess);
   }

   public void addDataAccess(DataAccess dataAccess)
     throws InvalidOperationException
   {
     super.add(dataAccess);
   }

   public RoleDataAccess fetchRoleDataAccess(Collection<Role> roles, String target)
   {
     RoleDataAccess result = null;
     for (Role role : roles) {
       for (RoleDataAccess rda : role.getDatas()) {
         if (rda.getCode().equals(target)) {
           if (result == null) {
             result = rda;
           }
           else if (rda.getState() > result.getState()) {
             result = rda;
           }
         }
       }
     }

     return result;
   }

   public void updateRole(Role role) throws InvalidOperationException
   {
     this.configuration.removeRole(role);
     super.update(role);
     this.configuration.addRole(role);
   }

   public DataAccess fetchDataAccess(String item)
   {
     return (DataAccess)this.configuration.get(DataAccess.class, item);
   }

   public Collection<RoleDataAccess> listRoleDataAccess()
   {
     return this.configuration.list(RoleDataAccess.class);
   }

   public Collection<DataAccess> listDataAccess()
   {
     return this.configuration.list(DataAccess.class);
   }
 }
