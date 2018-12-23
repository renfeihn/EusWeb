package com.is.eus.pojo.basic;

import com.is.eus.pojo.Entity;

public abstract class Product extends Entity {
    private String productCombination;
    private String productCombinationPrint;
    private ProductCode productCode;
    private ProductType productType;
    private String productName;
    private Unit unit;
    private UsageType usageType;
    private float price;
    private String protocol;
    private String memo;
    private String project;
    private String standard;

    public String getProductCombination() {
        return this.productCombination;
    }

    public void setProductCombination(String productCombination) {
        this.productCombination = productCombination;
    }

    public String getProductCombinationPrint() {
        return this.productCombinationPrint;
    }

    public void setProductCombinationPrint(String productCombinationPrint) {
        this.productCombinationPrint = productCombinationPrint;
    }

    public ProductCode getProductCode() {
        return this.productCode;
    }

    public void setProductCode(ProductCode productCode) {
        this.productCode = productCode;
    }

    public ProductType getProductType() {
        return this.productType;
    }

    public void setProductType(ProductType productType) {
        this.productType = productType;
    }

    public Unit getUnit() {
        return this.unit;
    }

    public void setUnit(Unit unit) {
        this.unit = unit;
    }

    public UsageType getUsageType() {
        return this.usageType;
    }

    public void setUsageType(UsageType usageType) {
        this.usageType = usageType;
    }

    public String getProductName() {
        return this.productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public float getPrice() {
        return this.price;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    public String getProtocol() {
        return this.protocol;
    }

    public void setProtocol(String protocol) {
        this.protocol = protocol;
    }

    public String getMemo() {
        return this.memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

    public String getProject() {
        return this.project;
    }

    public void setProject(String project) {
        this.project = project;
    }

    public String getStandard() {
        return this.standard;
    }

    public void setStandard(String standard) {
        this.standard = standard;
    }
}

