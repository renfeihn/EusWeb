//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.is.eus.service.biz.impl;

import com.is.eus.pojo.basic.Capacitor;
import com.is.eus.pojo.basic.ErrorLevel;
import com.is.eus.pojo.basic.Humidity;
import com.is.eus.pojo.basic.ProductCode;
import com.is.eus.pojo.basic.ProductType;
import com.is.eus.pojo.basic.UsageType;
import com.is.eus.pojo.storage.StorageView;
import com.is.eus.pojo.storage.StorageViewPrint;
import com.is.eus.service.biz.ui.StorageViewService;
import com.is.eus.service.print.StorageViewDataSource;
import com.is.eus.service.support.ObservableServiceBase;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperRunManager;
import org.apache.struts2.ServletActionContext;

public class StorageViewServiceImpl extends ObservableServiceBase implements StorageViewService {
    public StorageViewServiceImpl() {
    }

    public void print(List<StorageView> storageViewList) throws IOException {
        HashMap parameters = new HashMap();
        ArrayList storageViewPrint = new ArrayList();
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        String strDate = "库存明细表  " + format.format(date);
        parameters.put("Duration", strDate);
        Integer i = Integer.valueOf(1);
        Iterator strPath = storageViewList.iterator();

        while(strPath.hasNext()) {
            StorageView svDS = (StorageView)strPath.next();
            StorageViewPrint e = new StorageViewPrint();
            Capacitor response = (Capacitor)this.entityService.get(Capacitor.class, svDS.getProduct().getId());
            ProductCode ouputStream = null;
            Humidity humidity = null;
            ErrorLevel errorLevel = null;
            String strProductCode = "";
            String strHumidity = "";
            String strErrorLevel = "";
            if(response.getProductCode() != null) {
                ouputStream = (ProductCode)this.entityService.get(ProductCode.class, response.getProductCode().getId());
                strProductCode = ouputStream.getName();
            }

            if(response.getHumidity() != null) {
                humidity = (Humidity)this.entityService.get(Humidity.class, response.getHumidity().getId());
                strHumidity = humidity.getCode();
            }

            if(response.getErrorLevel() != null) {
                errorLevel = (ErrorLevel)this.entityService.get(ErrorLevel.class, response.getErrorLevel().getId());
                strErrorLevel = errorLevel.getCode();
            }

            UsageType usageType = (UsageType)this.entityService.get(UsageType.class, response.getUsageType().getId());
            String strUsageType = usageType.getName();
            ProductType productType = (ProductType)this.entityService.get(ProductType.class, response.getProductType().getId());
            String strProductType = productType.getName();
            e.setItemNo(i.toString());
            e.setPC(response.getProductCombination());
            e.setProductCode(strProductCode);
            e.setErrorLevel(strErrorLevel);
            e.setVoltage(response.getVoltage());
            e.setCapacity(response.getCapacity());
            e.setProductType(strProductType);
            e.setHumidity(strHumidity);
            e.setUsageType(strUsageType);
            e.setTotalAmount(String.valueOf(svDS.getTotalAmount()));
            e.setAdvancedAmount(String.valueOf(svDS.getAdvancedAmount()));
            e.setRestAmount(String.valueOf(svDS.getRestAmount()));
            i = Integer.valueOf(i.intValue() + 1);
            storageViewPrint.add(e);
        }

        StorageViewDataSource svDS1 = new StorageViewDataSource();
        svDS1.setStorageViewPrint(storageViewPrint);
        String strPath1 = ServletActionContext.getServletContext().getRealPath("/jasper");
        strPath1 = strPath1 + "/StorageView.jasper";

        try {
            byte[] e1 = JasperRunManager.runReportToPdf(strPath1, parameters, svDS1);
            HttpServletResponse response1 = ServletActionContext.getResponse();
            response1.setContentType("application/pdf");
            response1.setContentLength(e1.length);
            ServletOutputStream ouputStream1 = response1.getOutputStream();

            try {
                ouputStream1.write(e1, 0, e1.length);
                ouputStream1.close();
                ouputStream1.flush();
            } finally {
                if(ouputStream1 != null) {
                    ouputStream1.close();
                }

            }
        } catch (JRException var25) {
            var25.printStackTrace();
        }

    }
}
