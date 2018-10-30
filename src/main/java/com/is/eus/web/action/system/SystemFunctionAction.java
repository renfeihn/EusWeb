




package com.is.eus.web.action.system;

import com.is.eus.model.ui.FunctionTree;
import com.is.eus.model.ui.SystemFunction;
import com.is.eus.pojo.dac.Role;
import com.is.eus.pojo.dac.User;
import com.is.eus.service.SystemFunctionsService;
import com.is.eus.util.SystemFunctionTreeUtil;
import com.is.eus.web.action.AbstractSessionAwareAction;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;
import org.apache.commons.lang.StringUtils;

public class SystemFunctionAction extends AbstractSessionAwareAction {
    private static final long serialVersionUID = -8444431090728804454L;
    private String category;
    private String role;
    private SystemFunctionsService systemFunctionsService;

    public SystemFunctionAction() {
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public void setSystemFunctionsService(SystemFunctionsService sfService) {
        this.systemFunctionsService = sfService;
    }

    public String functions() {
        User user = this.getUserFromSession();
        Set roles = user.getRoles();
        FunctionTree tree = this.systemFunctionsService.getSystemFuntions(this.category, roles);
        this.resultJson = SystemFunctionTreeUtil.treeJson(tree);
        return "success";
    }

    public String categories() {
        this.resultJson = new String();
        User user = this.getUserFromSession();
        Set roles = user.getRoles();
        Iterator var4 = roles.iterator();

        while(var4.hasNext()) {
            Role r = (Role)var4.next();
            this.logger.info("User role:" + r.getName());
        }

        this.resultJson = SystemFunctionTreeUtil.categoriesJson(this.systemFunctionsService.getSystemFunctionCategories(roles));
        return "success";
    }

    public String systemFunctions() {
        boolean isAdmin = StringUtils.isEmpty(this.role);
        HashSet roles = new HashSet();
        Role categories;
        if(isAdmin) {
            categories = new Role();
            categories.setCode("admin");
            roles.add(categories);
        } else {
            categories = this.dataAccessControlService.fetchRole(this.role);
            roles.add(categories);
        }

        Collection categories1 = this.systemFunctionsService.getSystemFunctionCategories(roles);
        ArrayList trees = new ArrayList();
        Iterator var6 = categories1.iterator();

        while(var6.hasNext()) {
            SystemFunction category = (SystemFunction)var6.next();
            FunctionTree tree = this.systemFunctionsService.getSystemFuntions(category.getId(), roles);
            trees.add(tree);
        }

        this.resultJson = SystemFunctionTreeUtil.treeJson(trees, isAdmin);
        return "success";
    }
}
