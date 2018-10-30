




package com.is.eus.model.ui;

import com.is.eus.model.ui.SystemFunction;
import org.apache.log4j.Logger;

public class FunctionTree {
    private static final Logger log = Logger.getLogger(FunctionTree.class);
    String id;
    SystemFunction root;

    public FunctionTree() {
    }

    public String getId() {
        return this.id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public SystemFunction getRoot() {
        return this.root;
    }

    public void setRoot(SystemFunction root) {
        this.root = root;
    }

    public void addFunction(String parentId, SystemFunction function) {
        if(log.isDebugEnabled()) {
            log.debug("Adding function:" + function.getId() + " to tree" + this.id);
        }

        SystemFunction parent = this.getFunctionById(parentId);
        if(parent != null) {
            if(log.isDebugEnabled()) {
                log.debug("finding parent:" + parentId + " GOT:" + parent);
            }

            parent.addChild(function);
        }

    }

    public SystemFunction getFunctionById(String id) {
        if(log.isDebugEnabled()) {
            log.debug("finding parent by id:" + id);
        }

        SystemFunction function = this.root;
        SystemFunction prev = null;

        while(true) {
            while(function != null) {
                while(function.hasChildren()) {
                    function = (SystemFunction)function.getChildren().get(0);
                }

                if(this.match(function, id)) {
                    return function;
                }

                prev = function;
                function = function.next();
            }

            prev = prev.getParent();
            if(prev == null) {
                return null;
            }

            if(this.match(prev, id)) {
                return prev;
            }

            function = prev.next();
        }
    }

    private boolean match(SystemFunction function, String id) {
        if(log.isDebugEnabled()) {
            log.debug("matching function\t:[" + function + "] with id:[" + id + "]");
        }

        return function.getId().equalsIgnoreCase(id);
    }
}
