package com.is.eus.web.action.system;

import com.is.eus.pojo.dac.User;
import com.is.eus.pojo.system.Employee;
import com.is.eus.service.DataAccessControlService;
import com.is.eus.type.DataStatus;
import com.is.eus.web.action.AbstractSessionAwareAction;

import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

public class LoginAction extends AbstractSessionAwareAction {
    private static final long serialVersionUID = 2226661974692571027L;
    private String userName;
    private String password;
    private String validate_code;

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setValidate_code(String validate_code) {
        this.validate_code = validate_code;
    }

    public String login() {
        if (StringUtils.isEmpty(this.userName)) {
            this.logger.info("user is NULL, redirect.");
            return "error";
        }

        // TODO 注释验证码
        if (!this.validate_code.equals(this.session.get("validate_code"))) {
            addActionError("提示：验证码不正确");
            return "error";
        }

        this.logger.info("Logging in with name:" + this.userName + " and password:" + this.password);
        User user = this.dataAccessControlService.fetchUserByName(this.userName);
        if (user == null) {
            this.logger.info("user == null");
            addActionError("提示：用户名或密码错误");
            return "error";
        }
        this.logger.info("check user's password.");
        String passwd = user.getPassword().trim();
        if (!passwd.equalsIgnoreCase(this.password)) {
            addActionError("提示：用户名或密码错误");
            return "error";
        }
        if (user.getState() != DataStatus.Using.ordinal()) {
            addActionError("提示：该用户被限制使用");
            return "error";
        }

        this.logger.info("user login succeed.");
        this.session.put("user", user.getId());
        this.session.put("employee", user.getEmployee().getId());

        return "success";
    }
}


