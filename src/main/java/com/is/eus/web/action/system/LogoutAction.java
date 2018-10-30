 package com.is.eus.web.action.system;

 import com.is.eus.web.action.AbstractSessionAwareAction;
 import java.util.Map;

 public class LogoutAction extends AbstractSessionAwareAction
 {
   private static final long serialVersionUID = 866062221089995805L;

   public String logout()
   {
     if (this.session.containsKey("user")) {
       String user = (String)this.session.get("user");
       removeUserFromSession(user);
       this.session.remove("user");
     }
     return "success";
   }
 }


