 package com.is.eus.web.action;

 import com.is.eus.pojo.dac.User;
 import com.is.eus.service.DataAccessControlService;
 import com.opensymphony.xwork2.ActionSupport;
 import java.util.Map;
 import org.apache.commons.lang.StringUtils;
 import org.apache.log4j.Logger;
 import org.apache.struts2.interceptor.SessionAware;

 public abstract class AbstractSessionAwareAction extends ActionSupport
   implements SessionAware, JsonSupport
 {
   private static final long serialVersionUID = -290706823929868611L;
   protected final Logger logger = Logger.getLogger(getClass());
   protected String resultJson;
   protected Map<String, Object> session;
   protected DataAccessControlService dataAccessControlService;

   public void setDataAccessControlService(DataAccessControlService service)
   {
     this.dataAccessControlService = service;
   }

   public final void setSession(Map<String, Object> session)
   {
     this.session = session;
   }

   protected User getUserFromSession() {
     String id = (String)this.session.get("user");
     if (StringUtils.isEmpty(id)) {
       return null;
     }
     return this.dataAccessControlService.fetchUser(id);
   }

   protected void removeUserFromSession(String id) {
     this.dataAccessControlService.evictUser(id);
   }

   public final String getJson()
   {
     return this.resultJson;
   }

   protected final String simpleResult(boolean success)
   {
     this.resultJson = (success ? "{success:true}" : "{success:false}");
     return this.resultJson;
   }

   protected final String result(boolean success, String message)
   {
     StringBuilder builder = new StringBuilder();
     builder.append("{success:").append(success ? "true" : "false").append(", msg:'").append(message).append("'}");
     this.resultJson = builder.toString();
     return this.resultJson;
   }
 }

