 package com.is.eus.service.support;

 import com.is.eus.dao.EntityDao;
 import com.is.eus.pojo.Entity;
 import com.is.eus.service.EntityService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.type.DataStatus;
 import com.is.eus.util.StateUtil;
 import org.apache.log4j.Logger;

 public class EntityServiceImpl
   implements EntityService
 {
   protected final Logger logger = Logger.getLogger(getClass());
   private EntityDao entityDao;

   public void setEntityDao(EntityDao dao)
   {
     this.entityDao = dao;
   }

   public void add(Entity entity)
   {
     entity.setStatus(DataStatus.Using.ordinal());
     this.entityDao.add(entity);
   }

   public void update(Entity entity)
   {
     this.entityDao.update(entity);
   }

   public Entity get(Class<?> cls, String id)
   {
     return (Entity)this.entityDao.get(cls, id);
   }

   public void change(Entity entity, Class<?> stateClass, String state)
     throws InvalidOperationException
   {
     int iStatus = StateUtil.parse(stateClass, state).ordinal();
     entity.setState(iStatus);
     this.entityDao.update(entity);
   }

   public void add(Entity[] entities)
   {
     this.entityDao.add(entities);
   }

   public void delete(Entity[] entities)
   {
     this.entityDao.delete(entities);
   }

   public void delete(Entity entity)
   {
     this.entityDao.delete(entity);
   }

   public void refresh(Entity entity)
   {
     this.entityDao.refresh(entity);
   }

   public void remove(Entity entity)
   {
     entity.setStatus(DataStatus.Deleted.ordinal());
     this.entityDao.update(entity);
   }

   public void remove(Entity[] entities)
   {
     for (Entity entity : entities) {
       entity.setStatus(DataStatus.Deleted.ordinal());
     }
     this.entityDao.update(entities);
   }

   public void update(Entity[] entities)
   {
     this.entityDao.update(entities);
   }
 }


