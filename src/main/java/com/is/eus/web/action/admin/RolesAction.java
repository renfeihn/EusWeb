




package com.is.eus.web.action.admin;

import com.is.eus.pojo.Entity;
import com.is.eus.pojo.dac.DataAccess;
import com.is.eus.pojo.dac.Role;
import com.is.eus.pojo.dac.RoleDataAccess;
import com.is.eus.pojo.dac.RoleFunction;
import com.is.eus.service.exception.InvalidOperationException;
import com.is.eus.type.DataStatus;
import com.is.eus.util.JsonHelper;
import com.is.eus.util.RoleDataAccessUtil;
import com.is.eus.web.action.EntityBaseAction;
import java.text.ParseException;
import java.util.Collection;
import java.util.HashSet;
import java.util.Iterator;
import org.apache.commons.lang.StringUtils;

public class RolesAction extends EntityBaseAction {
    private static final long serialVersionUID = 2214073279501416046L;
    private String code;
    private String name;
    private String description;
    private String[] functions;
    private String[] names;
    private String[] access;
    private String role;
    private int[] states;

    public RolesAction() {
    }

    public void setRole(String role) {
        this.role = role;
    }

    public void setNames(String[] names) {
        this.names = names;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setDescription(String desc) {
        this.description = desc;
    }

    public void setAccess(String[] access) {
        this.access = access;
    }

    public void setFunctions(String[] functions) {
        this.functions = functions;
    }

    public void setStates(int[] states) {
        this.states = states;
    }

    protected Class<Role> getEntityClass() {
        return Role.class;
    }

    protected Class<?> getEntityStateClass() {
        return DataStatus.class;
    }

    protected void fillEntity(Entity entity) throws ParseException {
        Role role = (Role)entity;
        role.setCode(this.code);
        role.setName(this.name);
        role.setDescription(this.description);
        HashSet rfs = new HashSet();

        for(int function = 0; function < this.functions.length; ++function) {
            RoleFunction roleFunc = new RoleFunction();
            roleFunc.setFunctionId(this.functions[function]);
            roleFunc.setName(this.names[function]);
            roleFunc.setState(DataStatus.Using.ordinal());
            roleFunc.setStatus(DataStatus.Using.ordinal());
            roleFunc.setRole(role);
            rfs.add(roleFunc);
        }

        if(role.getFunctions() == null) {
            role.setFunctions(rfs);
        } else {
            role.getFunctions().clear();
            Iterator var6 = rfs.iterator();

            while(var6.hasNext()) {
                RoleFunction var7 = (RoleFunction)var6.next();
                role.getFunctions().add(var7);
            }
        }

    }

    public String add() {
        try {
            Role e = new Role();
            this.fillEntity(e);
            this.dataAccessControlService.addRole(e);
            this.simpleResult(true);
        } catch (InvalidOperationException var2) {
            this.result(false, var2.getMessage());
        } catch (ParseException var3) {
            this.result(false, var3.getMessage());
        }

        return "success";
    }

    public String update() {
        try {
            Role e = this.dataAccessControlService.fetchRole(this.id);
            this.fillEntity(e);
            this.dataAccessControlService.updateRole(e);
            this.simpleResult(true);
        } catch (InvalidOperationException var2) {
            this.result(false, var2.getMessage());
        } catch (ParseException var3) {
            this.result(false, var3.getMessage());
        }

        return "success";
    }

    public String getRoleDataAccess() {
        Collection access = this.dataAccessControlService.listDataAccess();
        if(StringUtils.isEmpty(this.id)) {
            this.resultJson = JsonHelper.fromCollection(access, DataAccess.class, (long)access.size());
        } else {
            Role role = this.dataAccessControlService.fetchRole(this.id);
            this.resultJson = RoleDataAccessUtil.getJson(access, role.getDatas());
        }

        return "success";
    }

    public String updateRoleDataAccess() {
        try {
            if(StringUtils.isEmpty(this.role)) {
                this.simpleResult(false);
            } else {
                Role e = this.dataAccessControlService.fetchRole(this.role);
                e.getDatas().clear();

                for(int i = 0; i < this.access.length; ++i) {
                    DataAccess da = this.dataAccessControlService.fetchDataAccess(this.access[i]);
                    RoleDataAccess rda = new RoleDataAccess();
                    rda.setCode(da.getCode());
                    rda.setName(da.getName());
                    rda.setState(this.states[i]);
                    rda.setRole(e);
                    e.getDatas().add(rda);
                }

                this.dataAccessControlService.updateRole(e);
                this.simpleResult(true);
            }
        } catch (InvalidOperationException var5) {
            this.result(false, var5.getMessage());
        }

        return "success";
    }
}
