




package com.is.eus.dao.support.hibernate;

import com.is.eus.dao.DataAccessControlDao;
import com.is.eus.dao.IllegalClassOrObjectException;
import com.is.eus.dao.InitializeException;
import com.is.eus.pojo.Entity;
import com.is.eus.pojo.dac.Role;
import com.is.eus.pojo.dac.User;
import java.sql.SQLException;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.MappingException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

public class DataAccessControlDaoHibernateImpl extends HibernateDaoSupport implements DataAccessControlDao {
    public DataAccessControlDaoHibernateImpl() {
    }

    public User findUserByName(String name) {
        List users = this.getHibernateTemplate().findByNamedQuery("com.is.eus.pojo.dac.User.getByName", name);
        return users != null && !users.isEmpty()?(User)users.get(0):null;
    }

    public User getUser(String id) {
        List users = this.getHibernateTemplate().findByNamedQuery("com.is.eus.pojo.dac.User.get", id);
        return users != null && !users.isEmpty()?(User)users.get(0):null;
    }

    public Role getRole(String role) {
        List roles = this.getHibernateTemplate().findByNamedQuery("com.is.eus.pojo.dac.Role.get", role);
        return roles != null && !roles.isEmpty()?(Role)roles.get(0):null;
    }

    private boolean isValidate(Class<?> cls) {
        return cls.getName().contains("com.is.eus.pojo.dac");
    }

    public <T> T get(Class<T> cls, String id) {
        if(!this.isValidate(cls)) {
            throw new IllegalClassOrObjectException("Invalid Class to load through Data Access Control DAO.");
        } else {
            return this.doGet(cls, id);
        }
    }

    private <T> T doGet(Class<T> cls, final String id) throws InitializeException {
        final String name = cls.getName() + ".get";
        Object obj = this.getHibernateTemplate().execute(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException, SQLException {
                try {
                    Query me = session.getNamedQuery(name);
                    me.setParameter(0, id);
                    return me.list().get(0);
                } catch (MappingException var3) {
                    DataAccessControlDaoHibernateImpl.this.logger.info(">>>>>>>>>> Can\'t find named query: " + name);
                    return null;
                }
            }
        });
        if(obj == null) {
            obj = this.getHibernateTemplate().load(cls, id);
        }

        return (T) obj;
    }

    public <T> List<T> list(final Class<T> cls) {
        if(!this.isValidate(cls)) {
            throw new IllegalClassOrObjectException("Invalid Class to load through Data Access Control DAO.");
        } else {
            final String name = cls.getName() + ".list";
            return this.getHibernateTemplate().executeFind(new HibernateCallback() {
                public Object doInHibernate(Session session) throws HibernateException, SQLException {
                    try {
                        Query me = session.getNamedQuery(name);
                        return me.list();
                    } catch (MappingException var3) {
                        return DataAccessControlDaoHibernateImpl.this.getHibernateTemplate().loadAll(cls);
                    }
                }
            });
        }
    }

    public void update(Entity entity) {
        if(!this.isValidate(entity.getClass())) {
            throw new IllegalClassOrObjectException("Invalid Class to load through Data Access Control DAO.");
        } else {
            this.getHibernateTemplate().update(entity);
        }
    }
}
