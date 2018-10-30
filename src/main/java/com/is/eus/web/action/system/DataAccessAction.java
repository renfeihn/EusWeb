




package com.is.eus.web.action.system;

import com.is.eus.pojo.dac.DataAccess;
import com.is.eus.service.exception.InvalidOperationException;
import com.is.eus.type.DataStatus;
import com.is.eus.util.JsonHelper;
import com.is.eus.web.action.AbstractSessionAwareAction;
import java.util.Collection;
import java.util.Iterator;

public class DataAccessAction extends AbstractSessionAwareAction {
    private static final long serialVersionUID = -6609140566468608655L;
    private String[] items;
    private String[] names;
    private int[] states;

    public DataAccessAction() {
    }

    public void setItems(String[] items) {
        this.items = items;
    }

    public void setNames(String[] names) {
        this.names = names;
    }

    public void setStates(int[] states) {
        this.states = states;
    }

    public String get() {
        Collection access = this.dataAccessControlService.listDataAccess();
        this.resultJson = JsonHelper.fromCollection(access, DataAccess.class, (long)access.size());
        return "success";
    }

    public String update() {
        try {
            Collection e = this.dataAccessControlService.listDataAccess();
            Iterator found = e.iterator();

            while(found.hasNext()) {
                DataAccess i = (DataAccess)found.next();
                boolean da = false;
                int state = DataStatus.Suspended.ordinal();
                int i1 = 0;

                while(true) {
                    if(i1 < this.items.length) {
                        if(!i.getCode().equals(this.items[i1])) {
                            ++i1;
                            continue;
                        }

                        state = this.states[i1];
                        da = true;
                    }

                    i.setState(da?state:DataStatus.Using.ordinal());
                    this.dataAccessControlService.updateDataAccess(i);
                    break;
                }
            }

            for(int var8 = 0; var8 < this.items.length; ++var8) {
                boolean var9 = false;
                Iterator var11 = e.iterator();

                DataAccess var10;
                while(var11.hasNext()) {
                    var10 = (DataAccess)var11.next();
                    if(var10.getCode().equals(this.items[var8])) {
                        var9 = true;
                        break;
                    }
                }

                if(!var9) {
                    var10 = new DataAccess();
                    var10.setCode(this.items[var8]);
                    var10.setName(this.names[var8]);
                    var10.setState(this.states[var8]);
                    this.dataAccessControlService.addDataAccess(var10);
                }
            }

            this.simpleResult(true);
        } catch (InvalidOperationException var7) {
            this.result(false, var7.getMessage());
        }

        return "success";
    }
}
