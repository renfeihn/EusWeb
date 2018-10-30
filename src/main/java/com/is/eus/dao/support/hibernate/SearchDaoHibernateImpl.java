




package com.is.eus.dao.support.hibernate;

import com.is.eus.dao.SearchDao;
import com.is.eus.pojo.dac.RoleDataAccess;
import com.is.eus.type.RoleDataAccessStatus;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang.StringUtils;
import org.hibernate.HibernateException;
import org.hibernate.MappingException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

public class SearchDaoHibernateImpl extends HibernateDaoSupport implements SearchDao {
    private String status;
    private String state;
    private Map<String, String> accessMapping;

    public SearchDaoHibernateImpl() {
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setState(String state) {
        this.state = state;
    }

    public void setAccessMapping(Map<String, String> map) {
        this.accessMapping = map;
    }

    private StringBuilder createInClause(Object[] objects) {
        if(objects == null) {
            return null;
        } else {
            StringBuilder builder = new StringBuilder();
            builder.append("(");

            for(int i = 0; i < objects.length; ++i) {
                builder.append("?,");
            }

            if(builder.charAt(builder.length() - 1) == 44) {
                builder.delete(builder.length() - 1, builder.length());
            }

            builder.append(")");
            return builder;
        }
    }

    private int ahead(String search, String[] elements) {
        int[] pos = new int[elements.length];

        int result;
        for(result = 0; result < elements.length; ++result) {
            pos[result] = search.indexOf(elements[result]);
        }

        result = search.length();
        int[] var8 = pos;
        int var7 = pos.length;

        for(int var6 = 0; var6 < var7; ++var6) {
            int p = var8[var6];
            if(p != -1 && p < result) {
                result = p;
            }
        }

        return result;
    }

    private String getTargetAlias(String query) {
        int from = query.indexOf("from");
        int ahead = this.ahead(query, new String[]{"join", "left", "inner", "right", ",", "where", "order"});
        String target = query.substring(from + "from".length(), ahead).trim();
        return target.contains("as ")?target.substring(target.lastIndexOf("as ") + "as ".length()).trim():(target.contains(" ")?target.substring(target.lastIndexOf(" ")).trim():null);
    }

    private String forTarget(String query, String property) {
        String alias = this.getTargetAlias(query);
        return alias != null?alias + "." + property:property;
    }

    private String createQuery(Session session, boolean count, String access, String name, List<String> searchFields, String text, Integer[] states, Integer[] status, String HQLCondition, String queryName) {
        StringBuilder clause = new StringBuilder();
        String queryString = null;
        StringBuilder orderbyClause = new StringBuilder();
        StringBuilder gruopbyClause = new StringBuilder();

        try {
            if(!StringUtils.isEmpty(queryName)) {
                queryString = session.getNamedQuery(name + (count?".count":"." + queryName)).getQueryString();
            } else {
                queryString = session.getNamedQuery(name + (count?".count":".find")).getQueryString();
            }
        } catch (MappingException var17) {
            queryString = (count?" select count(id) ":"") + " from " + name;
        }

        clause.append(queryString);
        if(clause.indexOf("order by") != -1) {
            orderbyClause.append(clause.substring(clause.indexOf("order by"), clause.length()));
            clause.delete(clause.indexOf("order by"), clause.length());
        }

        if(clause.indexOf("group by") != -1) {
            gruopbyClause.append(clause.substring(clause.indexOf("group by"), clause.length()));
            clause.delete(clause.indexOf("group by"), clause.length());
            queryString = clause.toString();
        }

        clause.append(" where ");
        if(!StringUtils.isEmpty(HQLCondition)) {
            clause.append("(").append(HQLCondition).append(") and ");
        }

        if(!StringUtils.isEmpty(access)) {
            clause.append(access).append(" and ");
        }

        String result;
        if(!StringUtils.isEmpty(text) && searchFields != null) {
            clause.append("(");
            Iterator var16 = searchFields.iterator();

            while(var16.hasNext()) {
                result = (String)var16.next();
                clause.append(result).append(" like ? or ");
            }

            if(clause.indexOf(" or ") != -1) {
                clause.delete(clause.lastIndexOf(" or "), clause.length());
            }

            clause.append(") and ");
        }

        if(states != null) {
            clause.append(this.forTarget(queryString, this.state)).append(" in ").append(this.createInClause(states)).append(" and ");
        }

        if(status != null) {
            clause.append(this.forTarget(queryString, this.status)).append(" in ").append(this.createInClause(status)).append(" and ");
        }

        if(clause.indexOf(" and ") == -1 && clause.indexOf(" or ") == -1) {
            clause.delete(clause.indexOf(" where "), clause.length());
        } else {
            clause.delete(clause.lastIndexOf(" and "), clause.length());
        }

        if(gruopbyClause.length() > 0) {
            clause.append(" ").append(gruopbyClause);
        }

        if(orderbyClause.length() > 0) {
            clause.append(" ").append(orderbyClause);
        }

        result = clause.toString();
        this.logger.info("HQL QUERY STRING:" + result);
        if(this.logger.isDebugEnabled()) {
            this.logger.debug("CREATED QUERY STRING:" + result);
        }

        return result;
    }

    private String getAccessCondition(RoleDataAccess access) {
        if(access != null) {
            String key = RoleDataAccessStatus.parse(access.getState()).name();
            return (String)this.accessMapping.get(key);
        } else {
            return null;
        }
    }

    private void prepareQuery(String employeeId, Query query, List<String> fields, String text, Integer[] states, Integer[] status) {
        int access = StringUtils.isEmpty(employeeId)?0:1;
        int fieldsSize = !StringUtils.isEmpty(text) && fields != null && !fields.isEmpty()?fields.size():0;
        int stateSize = states == null?0:states.length;
        int statusSize = status == null?0:status.length;
        int length = access + fieldsSize + stateSize + statusSize;
        Object[] objects = new Object[length];
        int pos = 0;
        if(!StringUtils.isEmpty(employeeId)) {
            objects[pos] = employeeId;
            ++pos;
        }

        int i;
        if(!StringUtils.isEmpty(text) && fields != null && !fields.isEmpty()) {
            for(i = 0; i < fields.size(); ++i) {
                objects[pos++] = "%" + text + "%";
            }
        }

        if(states != null) {
            System.arraycopy(states, 0, objects, pos, stateSize);
            pos += stateSize;
        }

        if(status != null) {
            System.arraycopy(status, 0, objects, pos, statusSize);
        }

        for(i = 0; i < objects.length; ++i) {
            query.setParameter(i, objects[i]);
        }

    }

    public long count(final RoleDataAccess access, final String id, final Class<?> cls, final List<String> fields, final String text, final Integer[] states, final Integer[] status, final String HQLCondition, final String queryName) {
        return ((Long)this.getHibernateTemplate().execute(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException, SQLException {
                String accessHQL = SearchDaoHibernateImpl.this.getAccessCondition(access);
                String clause = "";
                if(StringUtils.isEmpty(queryName)) {
                    clause = SearchDaoHibernateImpl.this.createQuery(session, true, accessHQL, cls.getName(), fields, text, states, status, HQLCondition, queryName);
                } else {
                    clause = SearchDaoHibernateImpl.this.createQuery(session, false, accessHQL, cls.getName(), fields, text, states, status, HQLCondition, queryName);
                }

                Query query = session.createQuery(clause);
                SearchDaoHibernateImpl.this.prepareQuery(StringUtils.isEmpty(accessHQL)?null:id, query, fields, text, states, status);
                if(StringUtils.isEmpty(queryName)) {
                    query.uniqueResult();
                    return query.list().get(0);
                } else {
                    return new Long((long)query.list().size());
                }
            }
        })).longValue();
    }

    public List find(final RoleDataAccess access, final String id, final Class<?> cls, final List<String> fields, final String text, final Integer[] states, final Integer[] status, final int start, final int limit, final String HQLCondition, final String queryName) {
        return this.getHibernateTemplate().executeFind(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException, SQLException {
                String accessHQL = SearchDaoHibernateImpl.this.getAccessCondition(access);
                String clause = SearchDaoHibernateImpl.this.createQuery(session, false, accessHQL, cls.getName(), fields, text, states, status, HQLCondition, queryName);
                Query query = session.createQuery(clause);
                if(start >= 0) {
                    query.setFirstResult(start);
                }

                if(limit > 0) {
                    query.setMaxResults(limit);
                }

                SearchDaoHibernateImpl.this.prepareQuery(StringUtils.isEmpty(accessHQL)?null:id, query, fields, text, states, status);
                return query.list();
            }
        });
    }

    public List find(String query, Object[] values) {
        return this.getHibernateTemplate().findByNamedQuery(query, values);
    }

    public List find(String query) {
        return this.getHibernateTemplate().findByNamedQuery(query);
    }
}
