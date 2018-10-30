 package com.is.eus.service.support;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.system.Employee;
 import com.is.eus.service.BasicInfoService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.type.AvailableStatus;
 import com.is.eus.type.DataStatus;
 import java.lang.reflect.Method;
 import java.util.HashMap;
 import java.util.Map;

 public class BasicInfoServiceImpl extends EntityServiceImpl
   implements BasicInfoService
 {
   private Map<String, String> mapping;
   public Map<String, Class> classMapping;

   public void setMapping(Map<String, String> map)
   {
     this.mapping = map;
   }

   public void init()
   {
     this.classMapping = new HashMap();
     for (String key : this.mapping.keySet())
       try {
         this.classMapping.put(key, Class.forName((String)this.mapping.get(key)));
       }
       catch (ClassNotFoundException localClassNotFoundException)
       {
       }
   }

   public void add(String type, String id, String code, String name, Employee creator)
     throws InvalidOperationException
   {
     if (this.classMapping.containsKey(type)) {
       Class cls = (Class)this.classMapping.get(type);
       try {
         Entity entity = (Entity)cls.newInstance();
         cls.getMethod("setCode", new Class[] { String.class }).invoke(entity, new Object[] { code });
         cls.getMethod("setName", new Class[] { String.class }).invoke(entity, new Object[] { name });
         cls.getMethod("setStatus", new Class[] { Integer.TYPE }).invoke(entity, new Object[] { Integer.valueOf(DataStatus.Using.ordinal()) });
         super.add(entity);
       } catch (Exception e) {
         e.printStackTrace();
         throw new InvalidOperationException("无法反射到实体.", e);
       }
     }
   }

   public Class<?> getTargetClass(String type)
   {
     return (Class)this.classMapping.get(type);
   }

   public void remove(String type, String id, Employee remover) throws InvalidOperationException
   {
     super.remove(super.get((Class)this.classMapping.get(type), id));
   }

   public void update(String type, String id, String code, String name, Employee updater)
     throws InvalidOperationException
   {
     try
     {
       Class cls = (Class)this.classMapping.get(type);
       Entity entity = super.get(cls, id);
       cls.getMethod("setCode", new Class[] { String.class }).invoke(entity, new Object[] { code });
       cls.getMethod("setName", new Class[] { String.class }).invoke(entity, new Object[] { name });
       super.update(entity);
     } catch (Exception e) {
       throw new InvalidOperationException("无法反射成功", e);
     }
   }

   public Entity get(String type, String id)
   {
     Class cls = (Class)this.classMapping.get(type);
     return super.get(cls, id);
   }

   public void change(String type, String id, String state, Employee changer)
     throws InvalidOperationException
   {
     Class cls = (Class)this.classMapping.get(type);
     Entity entity = super.get(cls, id);
     super.change(entity, AvailableStatus.class, state);
   }
 }

