 package com.is.eus.dac.support;

 import com.is.eus.dac.ConfigurationProvider;
 import com.is.eus.dao.DataAccessControlDao;
 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.dac.Role;
 import com.is.eus.pojo.dac.User;
 import java.util.Collection;

 public class DbConfigurationProvider
   implements ConfigurationProvider
 {
   private DataAccessControlDao dataAccessControlDao;

   public void setDataAccessControlDao(DataAccessControlDao dao)
   {
     this.dataAccessControlDao = dao;
   }

   public void update(Entity entity) {
     this.dataAccessControlDao.update(entity);
   }

   public void init()
   {
   }

   public void reload()
   {
   }

   public User getUser(String id)
   {
     return this.dataAccessControlDao.getUser(id);
   }

   public User getUserByName(String name)
   {
     return this.dataAccessControlDao.findUserByName(name);
   }

   public Role getRole(String role) {
     return this.dataAccessControlDao.getRole(role);
   }

   public <T> Collection<T> list(Class<T> cls)
   {
     return this.dataAccessControlDao.list(cls);
   }

   public <T> T get(Class<T> cls, String id)
   {
     return this.dataAccessControlDao.get(cls, id);
   }
 }

