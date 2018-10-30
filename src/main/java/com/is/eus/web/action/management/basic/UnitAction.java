//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.is.eus.web.action.management.basic;

import com.is.eus.jasper.PersonDataSource;
import com.is.eus.pojo.Entity;
import com.is.eus.pojo.basic.Unit;
import com.is.eus.service.basic.ui.UnitService;
import com.is.eus.service.exception.InvalidOperationException;
import com.is.eus.web.action.EntityBaseAction;
import com.is.eus.web.exception.InvalidPageInformationException;
import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.util.HashMap;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import net.sf.jasperreports.engine.util.FileBufferedOutputStream;
import net.sf.jasperreports.engine.util.JRLoader;
import org.apache.struts2.ServletActionContext;

public class UnitAction extends EntityBaseAction {
    private UnitService unitService;

    public UnitAction() {
    }

    public void setUnitService(UnitService unitService) {
        this.unitService = unitService;
    }

    public String add() {
        return super.add();
    }

    protected void check() throws InvalidOperationException, InvalidPageInformationException {
        super.check();
    }

    public String remove() {
        return super.remove();
    }

    public String update() {
        return super.update();
    }

    protected void fillEntity(Entity entity) throws ParseException {
    }

    protected Class<Unit> getEntityClass() {
        return Unit.class;
    }

    protected Class<?> getEntityStateClass() {
        return null;
    }

    public String test() throws IOException {
        String strPath = ServletActionContext.getServletContext().getRealPath("/jasper");
        File file = new File(strPath + "/FirstJasper.jasper");
        JasperPrint jasperPrint = null;

        try {
            JasperReport fbos = (JasperReport)JRLoader.loadObject(file.getPath());
            HashMap exporter = new HashMap();
            jasperPrint = JasperFillManager.fillReport(fbos, exporter, new PersonDataSource());
        } catch (JRException var18) {
            var18.printStackTrace();
        }

        if(jasperPrint != null) {
            FileBufferedOutputStream fbos1 = new FileBufferedOutputStream(1, 4096);
            JRPdfExporter exporter1 = new JRPdfExporter();
            exporter1.setParameter(JRExporterParameter.OUTPUT_STREAM, fbos1);
            exporter1.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);

            try {
                exporter1.exportReport();
                fbos1.close();
                if(fbos1.size() > 0) {
                    HttpServletResponse e1 = ServletActionContext.getResponse();
                    e1.setContentType("application/pdf");
                    e1.setContentLength(fbos1.size());
                    ServletOutputStream ouputStream = e1.getOutputStream();

                    try {
                        fbos1.writeData(ouputStream);
                        fbos1.dispose();
                        ouputStream.flush();
                    } finally {
                        if(ouputStream != null) {
                            ouputStream.close();
                        }

                    }
                }
            } catch (JRException var20) {
                var20.printStackTrace();
            } finally {
                if(fbos1 != null) {
                    fbos1.close();
                    fbos1.dispose();
                }

            }
        }

        this.simpleResult(true);
        return null;
    }
}
