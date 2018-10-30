




package com.is.eus.service.support;

import com.is.eus.dao.SearchDao;
import com.is.eus.model.search.Search;
import com.is.eus.model.search.SearchResult;
import com.is.eus.pojo.dac.RoleDataAccess;
import com.is.eus.pojo.dac.User;
import com.is.eus.service.DataAccessControlService;
import com.is.eus.service.SearchService;
import com.is.eus.service.support.BasicImplEntity;
import com.is.eus.type.DataStatus;
import com.is.eus.util.StateUtil;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;

public class SearchServiceImpl implements SearchService {
    private static final Logger logger = Logger.getLogger(SearchServiceImpl.class);
    private DataAccessControlService dataAccessControlService;
    private SearchDao searchDao;
    private Map<String, String> mapping;
    private List<String> defaultFields;
    private Map<String, List<String>> fieldsMapping;
    private Integer[] defaultStatus;

    public SearchServiceImpl() {
    }

    public void init() {
        BasicImplEntity entity = new BasicImplEntity();
        entity.get();
        this.defaultFields = new ArrayList();
        this.defaultFields.add("code");
        this.defaultFields.add("name");
        this.fieldsMapping = new HashMap();
        Iterator var3 = this.mapping.keySet().iterator();

        while(var3.hasNext()) {
            String key = (String)var3.next();
            ArrayList fields = new ArrayList();
            String[] var8;
            int var7 = (var8 = ((String)this.mapping.get(key)).split(",")).length;

            for(int var6 = 0; var6 < var7; ++var6) {
                String field = var8[var6];
                fields.add(field);
            }

            this.fieldsMapping.put(key, fields);
        }

        this.defaultStatus = new Integer[1];
        this.defaultStatus[0] = Integer.valueOf(DataStatus.Using.ordinal());
    }

    public void setSearchDao(SearchDao dao) {
        this.searchDao = dao;
    }

    public void setMapping(Map<String, String> mapping) {
        this.mapping = mapping;
    }

    public void setDataAccessControlService(DataAccessControlService service) {
        this.dataAccessControlService = service;
    }

    private long count(RoleDataAccess access, String id, Class<?> cls, Class<?> stateClass, String text, String[] states, String[] status, String HQLCondition, String queryName) {
        Integer[] iStates = StateUtil.parse(stateClass, states);
        Integer[] iStatus = StateUtil.parse(DataStatus.class, status);
        List fields = this.getFields(cls.getSimpleName());
        return this.searchDao.count(access, id, cls, fields, text, iStates, iStatus, HQLCondition, queryName);
    }

    private List<?> search(RoleDataAccess access, String id, Class<?> cls, Class<?> stateClass, String text, String[] states, String[] status, int start, int limit, String HQLCondition, String queryName) {
        Integer[] iStates = StateUtil.parse(stateClass, states);
        Integer[] iStatus = StateUtil.parse(DataStatus.class, status);
        List fields = this.getFields(cls.getSimpleName());
        return this.searchDao.find(access, id, cls, fields, text, iStates, iStatus, start, limit, HQLCondition, queryName);
    }

    private List<String> getFields(String name) {
        return this.fieldsMapping.containsKey(name)?(List)this.fieldsMapping.get(name):this.defaultFields;
    }

    public SearchResult search(final Search search) {
        User user = search.getUser();
        String target = search.getEntityClass().getSimpleName();
        final RoleDataAccess access;
        final String employee;
        if(user == null) {
            access = null;
            employee = null;
        } else {
            access = this.dataAccessControlService.fetchRoleDataAccess(user.getRoles(), target);
            employee = user.getEmployee().getId();
        }

        return new SearchResult() {
            public List<?> get() {
                List list = SearchServiceImpl.this.search(access, employee, search.getEntityClass(), search.getStatusClass(), search.getText(), search.getStates(), search.getStatus(), search.getStart(), search.getLimit(), search.getHQLCondition(), search.getQueryName());
                SearchServiceImpl.logger.info(">>Search Results:" + list.size());
                return list;
            }

            public Class<?> getResultClass() {
                return search.getEntityClass();
            }

            public long getTotalCount() {
                return SearchServiceImpl.this.count(access, employee, search.getEntityClass(), search.getStatusClass(), search.getText(), search.getStates(), search.getStatus(), search.getHQLCondition(), search.getQueryName());
            }
        };
    }

    public SearchResult search(String query, Object[] values) {
        final List result = this.searchDao.find(query, values);
        logger.info(">>Search Results:" + result.size());
        return new SearchResult() {
            public List<?> get() {
                return result;
            }

            public Class<?> getResultClass() {
                return result != null && !result.isEmpty()?result.get(0).getClass():null;
            }

            public long getTotalCount() {
                return result != null?(long)result.size():0L;
            }
        };
    }

    public SearchResult search(String query) {
        final List result = this.searchDao.find(query);
        logger.info(">>Search Results:" + result.size());
        return new SearchResult() {
            public List get() {
                return result;
            }

            public Class<?> getResultClass() {
                return result != null && !result.isEmpty()?result.get(0).getClass():null;
            }

            public long getTotalCount() {
                return result != null?(long)result.size():0L;
            }
        };
    }
}
