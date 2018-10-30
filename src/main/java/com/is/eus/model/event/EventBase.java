 package com.is.eus.model.event;

 import com.is.eus.pojo.Entity;
 import java.util.Collection;

 public class EventBase
   implements Event
 {
   protected String name;
   protected Entity entity;
   protected Entity[] entities;
   protected Collection<Entity> collection;

   public EventBase(String name, Entity entity)
   {
     this.name = name;
     this.entity = entity;
   }
   public EventBase(String name, Entity[] entities) {
     this.name = name;
     this.entities = entities;
   }
   public EventBase(String name, Collection<Entity> entities) {
     this.name = name;
     this.collection = entities;
   }

   public final Entity getEntity() {
     return this.entity;
   }

   public final String getName()
   {
     return this.name;
   }

   public Entity[] getEntities() {
     return this.entities;
   }

   public Collection<Entity> getCollection() {
     return this.collection;
   }
 }

