 package com.is.eus.service.support;

 import com.is.eus.model.event.Event;
 import com.is.eus.model.event.EventBase;
 import com.is.eus.model.event.EventNotFoundException;
 import com.is.eus.model.event.Listener;
 import com.is.eus.model.event.ObservableBase;
 import com.is.eus.pojo.Entity;
 import com.is.eus.service.EntityService;
 import com.is.eus.service.InjectableObserver;
 import com.is.eus.service.SearchService;
 import com.is.eus.service.SequenceService;
 import com.is.eus.service.exception.InvalidOperationException;
 import java.util.List;
 import java.util.Map;
 import java.util.Set;
 import org.apache.log4j.Logger;

 public class ObservableServiceBase extends ObservableBase
   implements InjectableObserver
 {
   protected EntityService entityService;
   protected SearchService searchService;
   protected SequenceService sequenceService;
   protected Logger logger = Logger.getLogger(getClass());

   public void setSequenceService(SequenceService service)
   {
     this.sequenceService = service;
   }

   public void setEntityService(EntityService entityService) {
     this.entityService = entityService;
   }

   public void setSearchService(SearchService searchService) {
     this.searchService = searchService;
   }

   public void setEvents(String events)
   {
     for (String event : events.split(","))
       super.addEvent(event);
   }

   private void fire(Event event) throws InvalidOperationException
   {
     try {
       super.fireEvent(event);
     } catch (EventNotFoundException e) {
       throw new InvalidOperationException(e.getMessage());
     }
   }

   protected void fire(String name, Entity entity) throws InvalidOperationException {
     fire(new EventBase(name, entity));
   }

   protected void fire(String name, Entity[] entities) throws InvalidOperationException {
     fire(new EventBase(name, entities));
   }

   protected void fire(String name, List<Entity> entities) throws InvalidOperationException {
     fire(new EventBase(name, entities));
   }

   public void setListeners(Map<String, Set<Listener>> listeners)
   {
     super.addListeners(listeners);
   }

   protected void add(Entity entity) {
     this.entityService.add(entity);
   }

   protected void update(Entity entity) {
     this.entityService.update(entity);
   }

   protected void remove(Entity entity) {
     this.entityService.remove(entity);
   }

   protected void delete(Entity entity) {
     this.entityService.delete(entity);
   }

   protected Entity get(Class<?> cls, String id) {
     return this.entityService.get(cls, id);
   }

   protected void add(Entity[] entities) {
     this.entityService.add(entities);
   }

   protected void delete(Entity[] entities) {
     this.entityService.delete(entities);
   }

   protected void remove(Entity[] entities) {
     this.entityService.remove(entities);
   }

   public void update(Entity[] entities) {
     this.entityService.update(entities);
   }
 }

