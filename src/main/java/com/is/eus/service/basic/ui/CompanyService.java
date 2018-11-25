package com.is.eus.service.basic.ui;

import com.is.eus.pojo.basic.Company;
import com.is.eus.service.exception.InvalidOperationException;

import java.io.File;

public abstract interface CompanyService {
    public abstract void add(Company paramCompany)
            throws InvalidOperationException;

    public abstract void udpate(Company paramCompany)
            throws InvalidOperationException;

    public abstract void remove(String paramString)
            throws InvalidOperationException;

    public File getReport();
}
