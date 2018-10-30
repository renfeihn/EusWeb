//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.is.eus.web.action.system;

import com.is.eus.web.action.system.LoginValidation;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.Result;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts2.ServletActionContext;

public class LoginValidationResult implements Result {
    private static final long serialVersionUID = -3038321543874315517L;

    public LoginValidationResult() {
    }

    public void execute(ActionInvocation invocation) throws Exception {
        LoginValidation lv = (LoginValidation)invocation.getAction();
        HttpServletResponse response = ServletActionContext.getResponse();
        response.setHeader("Pragma", "no-cache");
        response.setContentType("image/jpeg");
        response.setContentLength(lv.getOutput().toByteArray().length);
        response.getOutputStream().write(lv.getOutput().toByteArray());
    }
}
