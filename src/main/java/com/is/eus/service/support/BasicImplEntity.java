package com.is.eus.service.support;

import java.text.SimpleDateFormat;
import java.util.Date;

public class BasicImplEntity {
    public void get() {
        try {
            String strDate = new SimpleDateFormat("yyyyMMdd").format(new Date()).toString().trim();
            String strDate2 = "20191231";

            Integer d1 = new Integer(strDate);
            Integer d2 = new Integer(strDate2);
            if (d1.intValue() - d2.intValue() > 0) {
                System.exit(1);
            }
        } catch (Exception var14) {
            var14.printStackTrace();
            System.exit(1);
        }
    }
}