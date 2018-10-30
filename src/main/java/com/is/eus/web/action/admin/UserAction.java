 package com.is.eus.web.action.admin;

 import com.is.eus.model.search.Search;
 import com.is.eus.model.search.SearchResult;
 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.dac.Role;
 import com.is.eus.pojo.dac.User;
 import com.is.eus.pojo.system.Employee;
 import com.is.eus.service.DataAccessControlService;
 import com.is.eus.service.EntityService;
 import com.is.eus.service.SearchService;
 import com.is.eus.service.UserService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.type.DataStatus;
 import com.is.eus.util.JsonHelper;
 import com.is.eus.web.action.EntityBaseAction;
 import com.is.eus.web.exception.InvalidPageInformationException;
 import java.text.ParseException;
 import java.util.HashSet;
 import java.util.List;
 import java.util.Set;
 import org.apache.commons.lang.StringUtils;

 public class UserAction extends EntityBaseAction
 {
   private static final long serialVersionUID = 2811415105080738615L;
   private UserService userService;
   private String name;
   private String password;
   private String newPassword;
   private String secret;
   private String employee;
   private String[] roles;

   public void setUserService(UserService service)
   {
     this.userService = service;
   }

   protected Class<User> getEntityClass()
   {
     return User.class;
   }

   protected Class<?> getEntityStateClass()
   {
     return DataStatus.class;
   }

   public void setRoles(String[] roles)
   {
     this.roles = roles;
   }

   public void setName(String name) {
     this.name = name;
   }

   public void setPassword(String password) {
     this.password = password;
   }
   public void setNewPassword(String newPassword) {
     this.newPassword = newPassword;
   }
   public void setSecret(String secret) {
     this.secret = secret;
   }

   public void setEmployee(String employee) {
     this.employee = employee;
   }

   protected void fillEntity(Entity entity) throws ParseException
   {
     User user = (User)entity;
     user.setName(this.name);
     user.setPassword(this.password);
     user.setSecret(this.secret);
     user.setEmployee((Employee)this.entityService.get(Employee.class, this.employee));

     if (this.roles != null) {
       Set userRoles = new HashSet();
       for (String role : this.roles) {
         Role rl = this.dataAccessControlService.fetchRole(role);
         userRoles.add(rl);
       }
       user.setRoles(userRoles);
     }
   }

   public String add()
   {
     try {
       check();
       User user = new User();
       fillEntity(user);
       this.userService.add(user);
       simpleResult(true);
     } catch (ParseException pe) {
       result(false, "数据格式错误");
     } catch (InvalidOperationException e) {
       result(false, e.getMessage());
     } catch (InvalidPageInformationException e) {
       result(false, e.getMessage());
     }
     return "success";
   }

   public String update()
   {
     try {
       check();
       User user = (User)this.entityService.get(User.class, this.id);
       fillEntity(user);
       this.userService.update(user);
       simpleResult(true);
     } catch (ParseException pe) {
       result(false, "数据格式错误");
     } catch (InvalidOperationException e) {
       result(false, e.getMessage());
     } catch (InvalidPageInformationException e) {
       result(false, e.getMessage());
     }
     return "success";
   }

   public String change()
   {
     try {
       User user = (User)this.entityService.get(User.class, this.id);
       user.setState(((DataStatus)Enum.valueOf(DataStatus.class, this.state)).ordinal());
       this.userService.update(user);
       simpleResult(true);
     } catch (InvalidOperationException e) {
       result(false, e.getMessage());
     }
     return "success";
   }

   public String find()
   {
     Search search = createSearch(getEntityClass(), getEntityStateClass(), this.search, this.states, this.status, this.start, this.limit, this.HQLCondition, "");
     SearchResult result = this.searchService.search(search);
     this.resultJson = JsonHelper.fromCollection(result.get(), result.getResultClass(), result.getTotalCount(), 3);
     return "success";
   }

   public String getCurrentEmployee() {
     String emp = getUserFromSession().getEmployee().getId();
     Employee employee = (Employee)this.searchService.search("com.is.eus.pojo.system.Employee.get", new String[] { emp }).get().get(0);
     this.resultJson = JsonHelper.fromObject(employee);
     return "success";
   }

   public String modifyPassword() {
     User user = getUserFromSession();
     if (user == null) {
       result(false, "用户未登录");
       return "success";
     }
     String oldPass = user.getPassword();
     if (!oldPass.equals(this.password)) {
       result(false, "原有密码不正确");
       return "success";
     }

     if (StringUtils.isEmpty(this.newPassword)) {
       result(false, "新的密码不能为空");
       return "success";
     }

     user.setPassword(this.newPassword);
     this.entityService.update(user);
     result(true, "");
     return "success";
   }
 }

