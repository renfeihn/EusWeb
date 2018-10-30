 package com.is.eus.web.action.management.basic;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.system.Corporation;
 import com.is.eus.pojo.system.Department;
 import com.is.eus.service.EntityService;
 import com.is.eus.type.DataStatus;
 import com.is.eus.web.action.EntityBaseAction;
 import com.is.eus.web.exception.InvalidPageInformationException;
 import java.text.ParseException;
 import java.text.SimpleDateFormat;
 import org.apache.commons.lang.xwork.StringUtils;

 public class DepartmentAction extends EntityBaseAction
 {
   private static final long serialVersionUID = -6484336480798771723L;
   private String code;
   private String name;
   private String startdate;
   private String enddate;
   private String parent;
   private String corporation;

   protected Class<Department> getEntityClass()
   {
     return Department.class;
   }

   protected Class<?> getEntityStateClass() {
     return DataStatus.class;
   }

   public void setName(String name)
   {
     this.name = name;
   }
   public void setCode(String code) {
     this.code = code;
   }
   public void setStartdate(String startdate) {
     this.startdate = startdate;
   }
   public void setEnddate(String enddate) {
     this.enddate = enddate;
   }
   public void setParent(String parent) {
     this.parent = parent;
   }
   public void setCorporation(String corporation) {
     this.corporation = corporation;
   }

   protected void check() throws InvalidPageInformationException
   {
     if ((StringUtils.isEmpty(this.code)) || (StringUtils.isEmpty(this.name)))
       throw new InvalidPageInformationException("编码和名字为必须填写项目.");
   }

   protected void fillEntity(Entity entity) throws ParseException
   {
     Department department = (Department)entity;
     department.setName(this.name);
     department.setCode(this.code);
     department.setCorporation((Corporation)this.entityService.get(Corporation.class, this.corporation));
     department.setEnddate(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(this.enddate));
     department.setStartdate(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(this.startdate));

     if (!StringUtils.isEmpty(this.parent))
       department.setParent((Department)this.entityService.get(Department.class, this.parent));
   }
 }


