 package com.is.eus.service.support;

 import com.is.eus.pojo.dac.Role;
 import com.is.eus.pojo.dac.User;
 import com.is.eus.pojo.system.Employee;
 import com.is.eus.service.DataAccessControlService;
 import com.is.eus.service.UserService;
 import com.is.eus.service.exception.InvalidOperationException;
 import java.util.Set;
 import org.apache.log4j.Logger;

 public class UserServiceImpl extends EntityServiceImpl
   implements UserService
 {
   private DataAccessControlService dataAccessControlService;

   public void setDataAccessControlService(DataAccessControlService service)
   {
     this.dataAccessControlService = service;
   }

   public void add(User user) throws InvalidOperationException
   {
     Employee employee = user.getEmployee();
     if (employee == null) {
       throw new InvalidOperationException("新建用户必须对应唯一的员工.");
     }

     User euser = employee.getUser();
     if (euser != null) {
       throw new InvalidOperationException("该员工已经存在用户. 登录名为:" + euser.getName());
     }

     employee.setUser(user);
     super.add(user);
     this.logger.info("DAC user roles:" + user.getRoles().size());
     for (Role role : user.getRoles()) {
       this.logger.info("Role name:" + role.getName());
     }
     this.dataAccessControlService.addUser(user);
   }

   public void update(User user) throws InvalidOperationException
   {
     super.update(user);
     this.dataAccessControlService.updateUser(user);
   }
 }

