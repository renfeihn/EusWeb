 package com.is.eus.web.action.management.basic;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.system.Employee;
 import com.is.eus.pojo.system.Position;
 import com.is.eus.service.EntityService;
 import com.is.eus.type.DataStatus;
 import com.is.eus.web.action.EntityBaseAction;
 import com.is.eus.web.exception.InvalidPageInformationException;
 import java.text.ParseException;
 import java.util.Date;
 import org.apache.commons.lang.StringUtils;

 public class EmployeeAction extends EntityBaseAction
 {
   private static final long serialVersionUID = -6484336480798771723L;
   private String name;
   private String code;
   private String position;
   private Date birthday;
   private String tel;
   private String sex;

   protected Class<Employee> getEntityClass()
   {
     return Employee.class;
   }

   protected Class<?> getEntityStateClass()
   {
     return DataStatus.class;
   }

   public void setPosition(String position)
   {
     this.position = position;
   }

   public void setName(String name) {
     this.name = name;
   }

   public void setCode(String code) {
     this.code = code;
   }

   public void setBirthday(Date birthday) {
     this.birthday = birthday;
   }

   public void setTel(String tel) {
     this.tel = tel;
   }

   public void setSex(String sex) {
     this.sex = sex;
   }

   protected void check() throws InvalidPageInformationException
   {
     if ((StringUtils.isEmpty(this.code)) || (StringUtils.isEmpty(this.name)))
       throw new InvalidPageInformationException("编码和名字为必须填写项目.");
   }

   protected void fillEntity(Entity entity) throws ParseException
   {
     Employee employee = (Employee)entity;
     employee.setPosition((Position)this.entityService.get(Position.class, this.position));
     employee.setBirthday(this.birthday);
     employee.setTel(this.tel);
     employee.setSex(this.sex);
     employee.setName(this.name);
     employee.setCode(this.code);
   }
 }

