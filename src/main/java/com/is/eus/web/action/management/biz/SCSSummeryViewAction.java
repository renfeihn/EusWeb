




package com.is.eus.web.action.management.biz;

import com.is.eus.model.search.Search;
import com.is.eus.model.search.SearchResult;
import com.is.eus.pojo.Entity;
import com.is.eus.pojo.storage.SCSSumery;
import com.is.eus.pojo.storage.SCSSummeryView;
import com.is.eus.util.JsonHelper;
import com.is.eus.web.action.EntityBaseAction;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import org.apache.commons.lang.xwork.StringUtils;

public class SCSSummeryViewAction extends EntityBaseAction {
    private String productCombination;
    private String productCode;
    private String errorLevel;
    private String voltage;
    private String capacity;
    private String productType;
    private String humidity;
    private String usageType;
    private String varAmount;
    private String minAmount;
    private String maxAmount;

    public SCSSummeryViewAction() {
    }

    public void setProductCombination(String productCombination) {
        this.productCombination = productCombination;
    }

    public void setProductCode(String productCode) {
        this.productCode = productCode;
    }

    public void setErrorLevel(String errorLevel) {
        this.errorLevel = errorLevel;
    }

    public void setVoltage(String voltage) {
        this.voltage = voltage;
    }

    public void setCapacity(String capacity) {
        this.capacity = capacity;
    }

    public void setProductType(String productType) {
        this.productType = productType;
    }

    public void setHumidity(String humidity) {
        this.humidity = humidity;
    }

    public void setUsageType(String usageType) {
        this.usageType = usageType;
    }

    public void setVarAmount(String varAmount) {
        this.varAmount = varAmount;
    }

    public void setMinAmount(String minAmount) {
        this.minAmount = minAmount;
    }

    public void setMaxAmount(String maxAmount) {
        this.maxAmount = maxAmount;
    }

    protected void fillEntity(Entity entity) throws ParseException {
    }

    protected Class<SCSSummeryView> getEntityClass() {
        return SCSSummeryView.class;
    }

    protected Class<?> getEntityStateClass() {
        return null;
    }

    public String query() throws ParseException {
        if(!StringUtils.isEmpty(this.getHQL())) {
            this.HQLCondition = this.getHQL();
        } else {
            this.HQLCondition = "";
        }

        Search search = this.createSearch(this.getEntityClass(), this.getEntityStateClass(), this.search, this.states, this.status, this.start, this.limit, this.HQLCondition, "query");
        SearchResult result = this.searchService.search(search);
        this.resultJson = JsonHelper.fromCollection(result.get(), result.getResultClass(), result.getTotalCount(), 3);
        return "success";
    }

    public String querySummery() throws ParseException {
        if(!StringUtils.isEmpty(this.getHQL())) {
            this.HQLCondition = this.getHQL();
        } else {
            this.HQLCondition = "";
        }

        Search search = this.createSearch(this.getEntityClass(), this.getEntityStateClass(), this.search, this.states, this.status, this.start, -1, this.HQLCondition, "query");
        SearchResult result = this.searchService.search(search);
        int srTotalAmount = 0;
        int srAmount = 0;
        int coCheckingAmount = 0;
        int coUnfinishedAmount = 0;
        int coOwnedAmount = 0;
        int ssRestAmount = 0;
        int varAmount = 0;
        List items = result.get();

        SCSSummeryView sum;
        for(Iterator sumList = items.iterator(); sumList.hasNext(); varAmount += sum.getVarAmount()) {
            sum = (SCSSummeryView)sumList.next();
            srTotalAmount += sum.getSrTotalAmount();
            srAmount += sum.getSrAmount();
            coCheckingAmount += sum.getCoCheckingAmount();
            coUnfinishedAmount += sum.getCoUnfinishedAmount();
            coOwnedAmount += sum.getCoOwnedAmount();
            ssRestAmount += sum.getSsRestAmount();
        }

        SCSSumery sum1 = new SCSSumery();
        sum1.setSrTotalAmount(srTotalAmount);
        sum1.setSrAmount(srAmount);
        sum1.setCoCheckingAmount(coCheckingAmount);
        sum1.setCoUnfinishedAmount(coUnfinishedAmount);
        sum1.setCoOwnedAmount(coOwnedAmount);
        sum1.setSsRestAmount(ssRestAmount);
        sum1.setVarAmount(varAmount);
        ArrayList sumList1 = new ArrayList();
        sumList1.add(sum1);
        this.resultJson = JsonHelper.fromCollection(sumList1, SCSSumery.class, 1L, this.digDepth);
        return "success";
    }

    private String getHQL() throws ParseException {
        String strHQL = "";
        StringBuilder strClause = new StringBuilder();
        String strConnection = " and ";
        if(!StringUtils.isEmpty(this.varAmount)) {
            String strSymbol = "";
            int iVar = Integer.parseInt(this.varAmount);
            if(iVar > 0) {
                if(iVar == 1) {
                    strSymbol = "=";
                }

                if(iVar == 2) {
                    strSymbol = ">";
                }

                if(iVar == 3) {
                    strSymbol = "<";
                }

                strHQL = "s.varAmount " + strSymbol + " 0 " + strConnection;
                if(StringUtils.isEmpty(this.minAmount) && StringUtils.isEmpty(this.maxAmount)) {
                    strClause.append(strHQL);
                }
            }
        }

        if(!StringUtils.isEmpty(this.minAmount)) {
            strHQL = "s.varAmount >=" + this.minAmount + strConnection;
            strClause.append(strHQL);
        }

        if(!StringUtils.isEmpty(this.maxAmount)) {
            strHQL = "s.varAmount <=" + this.maxAmount + strConnection;
            strClause.append(strHQL);
        }

        if(!StringUtils.isEmpty(this.productCombination)) {
            strHQL = "p.productCombination like \'%" + this.productCombination + "%\'" + strConnection;
            strClause.append(strHQL);
        }

        if(!StringUtils.isEmpty(this.productCode)) {
            strHQL = "pc.id = \'" + this.productCode + "\'" + strConnection;
            strClause.append(strHQL);
        }

        if(!StringUtils.isEmpty(this.errorLevel)) {
            strHQL = "e.id = \'" + this.errorLevel + "\'" + strConnection;
            strClause.append(strHQL);
        }

        if(!StringUtils.isEmpty(this.voltage)) {
            strHQL = "p.voltage like \'%" + this.voltage + "%\'" + strConnection;
            strClause.append(strHQL);
        }

        if(!StringUtils.isEmpty(this.capacity)) {
            strHQL = "p.capacity like \'%" + this.capacity + "%\'" + strConnection;
            strClause.append(strHQL);
        }

        if(!StringUtils.isEmpty(this.productType)) {
            strHQL = "pt.id = \'" + this.productType + "\'" + strConnection;
            strClause.append(strHQL);
        }

        if(!StringUtils.isEmpty(this.humidity)) {
            strHQL = "h.id = \'" + this.humidity + "\'" + strConnection;
            strClause.append(strHQL);
        }

        if(!StringUtils.isEmpty(this.usageType)) {
            strHQL = "ut.id = \'" + this.usageType + "\'" + strConnection;
            strClause.append(strHQL);
        }

        if(strClause.indexOf(strConnection) != -1) {
            strClause.delete(strClause.lastIndexOf(strConnection), strClause.length());
        }

        return strClause.toString();
    }
}
