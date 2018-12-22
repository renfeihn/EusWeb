




package com.is.eus.web.action;

import com.is.eus.model.search.Search;
import com.is.eus.model.search.SearchResult;
import com.is.eus.pojo.Entity;
import com.is.eus.pojo.dac.User;
import com.is.eus.service.EntityService;
import com.is.eus.service.SearchService;
import com.is.eus.service.exception.InvalidOperationException;
import com.is.eus.util.JsonHelper;
import com.is.eus.web.action.AbstractEntityAction;
import com.is.eus.web.exception.InvalidPageInformationException;

import java.io.*;
import java.text.ParseException;

public abstract class EntityBaseAction extends AbstractEntityAction {
    private static final long serialVersionUID = 7664590774096971742L;
    protected SearchService searchService;
    protected EntityService entityService;


    protected File downloadFile;

    public File getDownloadFile() {
        return downloadFile;
    }

    public void setDownloadFile(File downloadFile) {
        this.downloadFile = downloadFile;
    }

    public String getFileName() {
        String downFileName = this.downloadFile.getName();
        try {
            downFileName = new String(downFileName.getBytes(), "ISO8859-1");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return downFileName;
    }

    public InputStream getInputStream() throws FileNotFoundException {
        return new FileInputStream(this.downloadFile);
    }

    public EntityBaseAction() {
    }

    public void setEntityService(EntityService service) {
        this.entityService = service;
    }

    public void setSearchService(SearchService search) {
        this.searchService = search;
    }

    protected abstract <T extends Entity> Class<T> getEntityClass();

    protected abstract Class<?> getEntityStateClass();

    protected void check() throws InvalidOperationException, InvalidPageInformationException {
    }

    protected final Search createSearch(final Class<?> entityClass, final Class<?> statusClass, final String text, final String[] states, final String[] status, final int start, final int limit, final String HQLConditon, final String queryName) {
        final User user = this.getUserFromSession();
        return new Search() {
            public Class<?> getEntityClass() {
                return entityClass;
            }

            public int getLimit() {
                return limit;
            }

            public int getStart() {
                return start;
            }

            public Class<?> getStatusClass() {
                return statusClass;
            }

            public String getText() {
                return text;
            }

            public String[] getStates() {
                return states;
            }

            public String[] getStatus() {
                return status;
            }

            public User getUser() {
                return user;
            }

            public String getHQLCondition() {
                return HQLConditon;
            }

            public String getQueryName() {
                return queryName;
            }
        };
    }

    protected abstract void fillEntity(Entity var1) throws ParseException;

    public String list() {
        Search search = this.createSearch(this.getEntityClass(), this.getEntityStateClass(), this.search, this.states, this.status, this.start, this.limit, this.HQLCondition, this.queryName);
        SearchResult result = this.searchService.search(search);
        this.resultJson = JsonHelper.fromCollection(result.get(), result.getResultClass(), result.getTotalCount());
        return "json";
    }

    public String get() {
        this.resultJson = JsonHelper.fromObject(this.entityService.get(this.getEntityClass(), this.id), this.digDepth);
        return "json";
    }

    public String add() {
        try {
            this.check();
            Entity e = (Entity)this.getEntityClass().newInstance();
            this.fillEntity(e);
            this.entityService.add(e);
            this.simpleResult(true);
        } catch (ParseException var2) {
            this.result(false, "数据格式错误");
        } catch (InvalidOperationException var3) {
            this.result(false, var3.getMessage());
        } catch (InstantiationException var4) {
            this.result(false, "系统错误，请联系系统管理员.");
        } catch (IllegalAccessException var5) {
            this.result(false, "系统错误，请联系系统管理员.");
        } catch (InvalidPageInformationException var6) {
            this.result(false, var6.getMessage());
        }

        return "json";
    }

    public String update() {
        try {
            this.check();
            Entity e = this.entityService.get(this.getEntityClass(), this.id);
            this.fillEntity(e);
            this.entityService.update(e);
            this.simpleResult(true);
        } catch (ParseException var2) {
            this.result(false, "数据格式错误.");
        } catch (InvalidOperationException var3) {
            this.result(false, var3.getMessage());
        } catch (InvalidPageInformationException var4) {
            this.result(false, var4.getMessage());
        }

        return "json";
    }

    public String remove() {
        this.entityService.remove(this.entityService.get(this.getEntityClass(), this.id));
        this.simpleResult(true);
        return "json";
    }

    public String find() {
        Search search = this.createSearch(this.getEntityClass(), this.getEntityStateClass(), this.search, this.states, this.status, this.start, this.limit, this.HQLCondition, this.queryName);
        SearchResult result = this.searchService.search(search);
        this.resultJson = JsonHelper.fromCollection(result.get(), result.getResultClass(), result.getTotalCount(), this.digDepth);
        return "success";
    }

    public String change() {
        try {
            Entity e = this.entityService.get(this.getEntityClass(), this.id);
            this.entityService.change(e, this.getEntityStateClass(), this.state);
            this.simpleResult(true);
        } catch (InvalidOperationException var2) {
            this.result(false, var2.getMessage());
        }

        return "success";
    }
}
