




package com.is.eus.dac;

import com.is.eus.dac.ConfigurationProvider;
import com.is.eus.dac.DacConfigurationListener;
import com.is.eus.dac.DataAccessCache;
import com.is.eus.pojo.Entity;
import com.is.eus.pojo.dac.Role;
import com.is.eus.pojo.dac.RoleFunction;
import com.is.eus.pojo.dac.User;
import java.util.Collection;
import java.util.Iterator;
import java.util.Set;
import org.apache.log4j.Logger;

public class Configuration implements DacConfigurationListener {
    private static final Logger logger = Logger.getLogger(Configuration.class);
    private ConfigurationProvider provider;
    private DataAccessCache cache;

    public Configuration() {
    }

    public void setProvider(ConfigurationProvider pvd) {
        this.provider = pvd;
    }

    public void init() {
        this.cache = new DataAccessCache();
        this.cache.addListener(this);
    }

    public User getUser(String id) {
        User user = this.cache.getUser(id);
        if(user == null) {
            logger.info("cache not found user, load by provider.");
            user = this.provider.getUser(id);
            if(user != null) {
                this.cache.addUser(user);
            }
        }

        return user;
    }

    public void evictUser(String id) {
        User user = this.cache.getUser(id);
        if(user != null) {
            this.cache.getUsers().remove(user);
        }

    }

    public User getUserByName(String name) {
        Collection users = this.cache.getUsers();
        Iterator var4 = users.iterator();

        User user;
        while(var4.hasNext()) {
            user = (User)var4.next();
            if(user.getName().equals(name)) {
                return user;
            }
        }

        logger.info("cache not found user, load by provider via byName.");
        user = this.provider.getUserByName(name);
        if(user != null) {
            this.cache.addUser(user);
        }

        return user;
    }

    public <T extends Entity> void configurationRemoved(T t) {
        this.provider.update(t);
    }

    public <T extends Entity> Collection<T> list(Class<T> cls) {
        return this.provider.list(cls);
    }

    public void updateUser(User user) {
        this.cache.updateUser(user);
    }

    public Collection<RoleFunction> getRoleFunctions() {
        return this.cache.getRoleFunctions();
    }

    public void addRoleFunctions(Set<RoleFunction> rfs) {
        Iterator var3 = rfs.iterator();

        while(var3.hasNext()) {
            RoleFunction function = (RoleFunction)var3.next();
            this.cache.addRoleFunction(function);
        }

    }

    public Role getRole(String role) {
        Role r = this.cache.getRole(role);
        if(r == null) {
            logger.info("Cache not found role, load from provider.");
            r = this.provider.getRole(role);
            if(r != null) {
                this.cache.addRole(r);
            }
        }

        return r;
    }

    public void addUser(User user) {
        Iterator var3 = user.getRoles().iterator();

        while(var3.hasNext()) {
            Role rl = (Role)var3.next();
            this.provider.get(Role.class, rl.getId());
        }

        this.cache.addUser(user);
    }

    public void removeRole(Role role) {
        this.cache.removeRole(role);
    }

    public void addRole(Role role) {
        this.cache.addRole(role);
    }

    public <T> T get(Class<T> cls, String id) {
        return this.provider.get(cls, id);
    }
}
