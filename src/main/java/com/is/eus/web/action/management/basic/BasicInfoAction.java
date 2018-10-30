




package com.is.eus.web.action.management.basic;

import com.is.eus.model.search.Search;
import com.is.eus.model.search.SearchResult;
import com.is.eus.pojo.dac.User;
import com.is.eus.pojo.system.Employee;
import com.is.eus.service.BasicInfoService;
import com.is.eus.service.SearchService;
import com.is.eus.service.exception.InvalidOperationException;
import com.is.eus.type.DataStatus;
import com.is.eus.util.JsonHelper;
import com.is.eus.web.action.AbstractEntityAction;
import com.is.eus.web.exception.InvalidPageInformationException;
import java.util.ArrayList;
import org.apache.commons.lang.StringUtils;

public class BasicInfoAction extends AbstractEntityAction {
    private static final long serialVersionUID = 3290476789078352401L;
    private BasicInfoService basicInfoService;
    private SearchService searchService;
    private String type;
    private String code;
    private String name;

    public BasicInfoAction() {
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public void setType(String type) {
        this.type = type;
    }

    public void setBasicInfoService(BasicInfoService basicInfoService) {
        this.basicInfoService = basicInfoService;
    }

    public void setSearchService(SearchService searchService) {
        this.searchService = searchService;
    }

    private void check() throws InvalidPageInformationException {
        if(StringUtils.isEmpty(this.code) || StringUtils.isEmpty(this.name)) {
            throw new InvalidPageInformationException("编码和名字为必须填写项目.");
        }
    }

    public String add() {
        try {
            this.check();
            User e = this.getUserFromSession();
            Employee creator = e.getEmployee();
            this.basicInfoService.add(this.type, this.id, this.code, this.name, creator);
            this.simpleResult(true);
        } catch (InvalidOperationException var3) {
            this.result(false, var3.getMessage());
        } catch (InvalidPageInformationException var4) {
            this.result(false, var4.getMessage());
        }

        return "success";
    }

    public String update() {
        try {
            this.check();
            User e = this.getUserFromSession();
            Employee updater = e.getEmployee();
            this.basicInfoService.update(this.type, this.id, this.code, this.name, updater);
            this.simpleResult(true);
        } catch (InvalidOperationException var3) {
            this.result(false, var3.getMessage());
        } catch (InvalidPageInformationException var4) {
            this.result(false, var4.getMessage());
        }

        return "success";
    }

    public String remove() {
        try {
            User e = this.getUserFromSession();
            Employee remover = e.getEmployee();
            this.basicInfoService.remove(this.type, this.id, remover);
            this.simpleResult(true);
        } catch (InvalidOperationException var3) {
            this.result(false, var3.getMessage());
        }

        return "success";
    }

    protected final Search createSearch(final Class<?> entityClass, final String text, final String[] states, final String[] status, final int start, final int limit) {
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
                return DataStatus.class;
            }

            public String getText() {
                if(StringUtils.isEmpty(text)) {
                    return null;
                } else {
                    ArrayList texts = new ArrayList();
                    String[] var5;
                    int var4 = (var5 = text.split(" ")).length;

                    for(int var3 = 0; var3 < var4; ++var3) {
                        String t = var5[var3];
                        if(!StringUtils.isEmpty(t)) {
                            texts.add(t);
                        }
                    }

                    return text;
                }
            }

            public String[] getStates() {
                return states;
            }

            public String[] getStatus() {
                return status;
            }

            public User getUser() {
                return BasicInfoAction.this.getUserFromSession();
            }

            public String getHQLCondition() {
                return null;
            }

            public String getQueryName() {
                return null;
            }
        };
    }

    public String find() {
        Class target = this.basicInfoService.getTargetClass(this.type);
        Search search = this.createSearch(target, this.search, this.states, this.status, this.start, this.limit);
        SearchResult result = this.searchService.search(search);
        this.resultJson = JsonHelper.fromCollection(result.get(), result.getResultClass(), result.getTotalCount());
        return "success";
    }

    public String get() {
        this.resultJson = JsonHelper.fromObject(this.basicInfoService.get(this.type, this.id));
        return "success";
    }

    public String list() {
        Class target = this.basicInfoService.getTargetClass(this.type);
        Search search = this.createSearch(target, this.search, this.states, this.status, this.start, this.limit);
        SearchResult result = this.searchService.search(search);
        this.resultJson = JsonHelper.fromCollection(result.get(), result.getResultClass(), result.getTotalCount());
        return "success";
    }

    public String change() {
        try {
            User e = this.getUserFromSession();
            Employee changer = e.getEmployee();
            this.basicInfoService.change(this.type, this.id, this.state, changer);
            this.simpleResult(true);
        } catch (InvalidOperationException var3) {
            this.result(false, var3.getMessage());
        }

        return "success";
    }
}
