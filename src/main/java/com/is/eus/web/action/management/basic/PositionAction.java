 package com.is.eus.web.action.management.basic;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.system.Department;
 import com.is.eus.pojo.system.Level;
 import com.is.eus.pojo.system.Position;
 import com.is.eus.service.EntityService;
 import com.is.eus.type.DataStatus;
 import com.is.eus.web.action.EntityBaseAction;
 import com.is.eus.web.exception.InvalidPageInformationException;
 import java.text.ParseException;
 import org.apache.commons.lang.StringUtils;

 public class PositionAction extends EntityBaseAction
 {
   private static final long serialVersionUID = -6484336480798771723L;
   private String name;
   private String code;
   private String department;
   private String level;

   protected Class<?> getEntityClass()
   {
     return Position.class;
   }

   protected Class<?> getEntityStateClass()
   {
     return DataStatus.class;
   }

   public void setDepartment(String department)
   {
     this.department = department;
   }

   public void setLevel(String level) {
     this.level = level;
   }
   public void setName(String name) {
     this.name = name;
   }

   public void setCode(String code) {
     this.code = code;
   }

   protected void check() throws InvalidPageInformationException
   {
     if ((StringUtils.isEmpty(this.code)) || (StringUtils.isEmpty(this.name)))
       throw new InvalidPageInformationException("编码和名字为必须填写项目.");
   }

   protected void fillEntity(Entity entity) throws ParseException
   {
     Position position = (Position)entity;
     position.setCode(this.code);
     position.setDepartment((Department)this.entityService.get(Department.class, this.department));
     position.setLevel((Level)this.entityService.get(Level.class, this.level));
     position.setName(this.name);
   }
 }

