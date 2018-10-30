




package com.is.eus.dao.support.hibernate;

import com.is.eus.dao.EntityDao;
import com.is.eus.pojo.Entity;
import java.sql.SQLException;
import org.hibernate.Hibernate;
import org.hibernate.HibernateException;
import org.hibernate.MappingException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

public class EntityDaoHibernateImpl extends HibernateDaoSupport implements EntityDao {
    public EntityDaoHibernateImpl() {
    }

    public void add(Object t) {
        this.getHibernateTemplate().save(t);
    }

    public <T> T get(final Class<T> cls, final String id) {
        return (T) this.getHibernateTemplate().execute(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException, SQLException {
                Object obj;
                try {
                    Query me = session.getNamedQuery(cls.getName() + ".get");
                    me.setParameter(0, id);
                    me.uniqueResult();
                    obj = me.list().get(0);
                    Hibernate.initialize(obj);
                    return obj;
                } catch (MappingException var4) {
                    obj = session.load(cls, id);
                    Hibernate.initialize(obj);
                    return obj;
                }
            }
        });
    }

    public void remove(Class<?> cls, String id) {
        this.getHibernateTemplate().delete(this.get(cls, id));
    }

    public void update(Object t) {
        this.getHibernateTemplate().saveOrUpdate(t);
    }

    public void delete(Object object) {
        this.getHibernateTemplate().delete(object);
    }

    public void add(final Object[] objects) {
        this.getHibernateTemplate().execute(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException, SQLException {
                for(int i = 0; i < objects.length; ++i) {
                    session.save(objects[i]);
                    if(i % 20 == 0) {
                        session.flush();
                        session.clear();
                    }
                }

                return null;
            }
        });
    }

    public void delete(Object[] objects) {
        Object[] var5 = objects;
        int var4 = objects.length;

        for(int var3 = 0; var3 < var4; ++var3) {
            Object obj = var5[var3];
            this.delete(obj);
        }

    }

    public void refresh(Entity entity) {
        this.getHibernateTemplate().refresh(entity);
    }

    public void update(final Object[] objects) {
        this.getHibernateTemplate().execute(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException, SQLException {
                for(int i = 0; i < objects.length; ++i) {
                    session.update(objects[i]);
                    if(i % 20 == 0) {
                        session.flush();
                        session.clear();
                    }
                }

                return null;
            }
        });
    }
}
