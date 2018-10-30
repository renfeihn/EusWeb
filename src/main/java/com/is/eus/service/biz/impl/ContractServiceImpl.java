
package com.is.eus.service.biz.impl;

import com.is.eus.model.event.Event;
import com.is.eus.model.event.Listener;
import com.is.eus.model.search.SearchResult;
import com.is.eus.pojo.Entity;
import com.is.eus.pojo.basic.Capacitor;
import com.is.eus.pojo.basic.Company;
import com.is.eus.pojo.basic.Product;
import com.is.eus.pojo.basic.ProductCode;
import com.is.eus.pojo.basic.Unit;
import com.is.eus.pojo.contract.Contract;
import com.is.eus.pojo.contract.ContractItem;
import com.is.eus.pojo.contract.ContractItemOwnedSummeryView;
import com.is.eus.pojo.contract.ContractItemOwnedSummeryViewPrint;
import com.is.eus.pojo.contract.ContractPrint;
import com.is.eus.pojo.storage.StorageOutcoming;
import com.is.eus.pojo.storage.StorageOutcomingItem;
import com.is.eus.pojo.system.Sequence;
import com.is.eus.service.biz.ui.ContractService;
import com.is.eus.service.exception.InvalidOperationException;
import com.is.eus.service.print.ContractDataSource;
import com.is.eus.service.print.ContractItemOwnedSummeryViewDataSource;
import com.is.eus.service.support.ObservableServiceBase;
import com.is.eus.type.ContractState;
import com.is.eus.type.DataStatus;
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
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperRunManager;
import net.sf.jasperreports.engine.export.JRXlsExporter;
import net.sf.jasperreports.engine.export.JRXlsExporterParameter;
import org.apache.commons.lang.StringUtils;
import org.apache.struts2.ServletActionContext;

public class ContractServiceImpl extends ObservableServiceBase implements ContractService, Listener {
    public ContractServiceImpl() {
    }

    public void add(Contract contract) throws InvalidOperationException {
        String SequenceNo = this.sequenceService.acquire("Contract", false, 1);
        if(StringUtils.isEmpty(SequenceNo)) {
            Sequence strTemp = new Sequence();
            strTemp.setType("Contract");
            strTemp.setPrefix("Contract");
            strTemp.setHead("");
            strTemp.setMiddle("1");
            strTemp.setPostfix("");
            strTemp.setTail("5");
            strTemp.setSequence(1);
            this.entityService.add(strTemp);
            SequenceNo = this.sequenceService.acquire("Contract", false, 1);
        }

        String[] strTemp1 = SequenceNo.split("Contract");
        SequenceNo = strTemp1[0] + contract.getContractNo() + strTemp1[1];
        contract.setContractNo(SequenceNo);
        contract.setStatus(DataStatus.Using.ordinal());
        contract.setState(ContractState.Saved.ordinal());
        contract.setTotalFinishedAmount(0);
        contract.setTotalCheckingAmount(0);
        Iterator var5 = contract.getItems().iterator();

        while(var5.hasNext()) {
            ContractItem item = (ContractItem)var5.next();
            item.setFinishedAmount(0);
            item.setCheckingAmount(0);
        }

        super.add(contract);
    }

    public void remove(String id) throws InvalidOperationException {
        Contract contract = (Contract)super.get(Contract.class, id);
        super.remove(contract);
    }

    public void udpate(Contract contract) throws InvalidOperationException {
        if(contract.getStatus() != DataStatus.Using.ordinal()) {
            throw new InvalidOperationException("修改失败");
        } else {
            super.update(contract);
        }
    }

    public void udpateByBiz(Contract contract, int iType) throws InvalidOperationException {
        if(iType == 0) {
            if(contract.getState() != ContractState.Saved.ordinal() && contract.getState() != ContractState.AduitFailed.ordinal()) {
                throw new InvalidOperationException("合同状态不为[已保存]或[审核失败]状态");
            }

            contract.setState(ContractState.WaitForAduilt.ordinal());
            this.update(contract);
        }

        if(iType == 1) {
            if(contract.getState() != ContractState.WaitForAduilt.ordinal()) {
                throw new InvalidOperationException("合同状态不为[待审核]状态");
            }

            contract.setState(ContractState.AduitFailed.ordinal());
            this.update(contract);
        }

        if(iType == 2) {
            if(contract.getState() != ContractState.WaitForAduilt.ordinal()) {
                throw new InvalidOperationException("合同状态不为[待审核]状态");
            }

            contract.setState(ContractState.None.ordinal());
            this.update(contract);
            this.fire("ScheduleFromContract", contract);
        }

        if(iType == 3) {
            if(contract.getState() == ContractState.WaitForAduilt.ordinal()) {
                throw new InvalidOperationException("合同状态为[待审核]状态,不能进行修改");
            }

            this.update(contract);
        }

        if(iType == 4) {
            if(contract.getState() != ContractState.Saved.ordinal() && contract.getState() != ContractState.AduitFailed.ordinal()) {
                throw new InvalidOperationException("合同状态不为[已保存]或[审核失败]状态");
            }

            contract.setStatus(DataStatus.Deleted.ordinal());
            this.update(contract);
        }

        if(iType == 5) {
            if(contract.getState() != ContractState.None.ordinal() && contract.getState() != ContractState.Part.ordinal()) {
                throw new InvalidOperationException("合同状态不为[未完成]或[部分完成]状态");
            }

            if(contract.getTotalCheckingAmount() != 0) {
                throw new InvalidOperationException("请先审核该合同相关联的出库单");
            }

            contract.setStatus(DataStatus.Deleted.ordinal());
            contract.setState(ContractState.Terminated.ordinal());
            this.update(contract);
            this.fire("RollbackStorageResourceFromContract", contract);
        }

    }

    public void notice(Event event) throws InvalidOperationException {
        String name = event.getName();
        Entity entity = event.getEntity();
        if(name.equals("Update_Contract_And_Storage_FromStorageOutcoming")) {
            this.UpdateContractByStorageOutcoming(entity);
        }

        if(name.equals("Update_Contract_FromStorageOutcoming_AduitSuccess")) {
            this.UpdateContractFromStorageOutcomingAduitSuccess(entity);
        }

        if(name.equals("RollBack_Contract_And_Storage_FromStorageOutcoming")) {
            this.RollBackContractByStorageOutcoming(entity);
        }

    }

    private void UpdateContractByStorageOutcoming(Entity entity) {
        StorageOutcoming soc = (StorageOutcoming)entity;
        Iterator var4 = soc.getSocItems().iterator();

        while(var4.hasNext()) {
            StorageOutcomingItem socItem = (StorageOutcomingItem)var4.next();
            Contract contract = (Contract)this.entityService.get(Contract.class, socItem.getContractItem().getContract().getId());
            ContractItem contractItem = contract.getItem(socItem.getContractItem().getId());
            boolean totalFinishedAmount = false;
            boolean finishedAmount = false;
            boolean totalCheckingAmount = false;
            boolean checkingAmount = false;
            boolean totalAmount = false;
            boolean amount = false;
            boolean socItemAmount = false;
            if(contractItem == null) {
                throw new InvalidOperationException("合同条目不存在");
            }

            if(contract.getState() == ContractState.Complete.ordinal()) {
                throw new InvalidOperationException("该合同已经全部完成");
            }

            int totalAmount1 = contract.getTotalAmount();
            int totalFinishedAmount1 = contract.getTotalFinishedAmount();
            int totalCheckingAmount1 = contract.getTotalCheckingAmount();
            int amount1 = contractItem.getAmount();
            int finishedAmount1 = contractItem.getFinishedAmount();
            int checkingAmount1 = contractItem.getCheckingAmount();
            int socItemAmount1 = socItem.getAmount();
            int totalRestAmount = totalAmount1 - totalFinishedAmount1 - totalCheckingAmount1 - socItemAmount1;
            int restAmount = amount1 - finishedAmount1 - checkingAmount1 - socItemAmount1;
            if(totalRestAmount < 0) {
                throw new InvalidOperationException("该合同现在没有可以可出库的产品");
            }

            if(restAmount < 0) {
                throw new InvalidOperationException("该合同中的产品[" + contractItem.getProduct().getProductCombination() + "],出库数量过大");
            }

            contract.setTotalCheckingAmount(totalCheckingAmount1 + socItemAmount1);
            contract.setUpdater(soc.getCreator());
            contract.setUpdateTime(soc.getCreateTime());
            contractItem.setUpdater(soc.getCreator());
            contractItem.setUpdateTime(soc.getCreateTime());
            contractItem.setCheckingAmount(checkingAmount1 + socItemAmount1);
            this.update(contract);
        }

    }

    private void UpdateContractFromStorageOutcomingAduitSuccess(Entity entity) {
        StorageOutcoming soc = (StorageOutcoming)entity;
        Contract contract = (Contract)this.entityService.get(Contract.class, soc.getContract().getId());
        Iterator var5 = soc.getSocItems().iterator();

        while(var5.hasNext()) {
            StorageOutcomingItem socItem = (StorageOutcomingItem)var5.next();
            ContractItem contractItem = contract.getItem(socItem.getContractItem().getId());
            boolean totalFinishedAmount = false;
            boolean finishedAmount = false;
            boolean totalCheckingAmount = false;
            boolean checkingAmount = false;
            boolean totalAmount = false;
            boolean amount = false;
            boolean socItemAmount = false;
            if(contractItem == null) {
                throw new InvalidOperationException("合同条目不存在");
            }

            if(contract.getState() == ContractState.Complete.ordinal()) {
                throw new InvalidOperationException("该合同已经全部完成");
            }

            int totalAmount1 = contract.getTotalAmount();
            int totalFinishedAmount1 = contract.getTotalFinishedAmount();
            int totalCheckingAmount1 = contract.getTotalCheckingAmount();
            int amount1 = contractItem.getAmount();
            int finishedAmount1 = contractItem.getFinishedAmount();
            int checkingAmount1 = contractItem.getCheckingAmount();
            int socItemAmount1 = socItem.getAmount();
            int totalRestAmount = totalAmount1 - totalFinishedAmount1;
            int restAmount = amount1 - finishedAmount1;
            if(totalRestAmount < 0) {
                throw new InvalidOperationException("该合同现在没有可以可出库的产品");
            }

            if(restAmount < 0) {
                throw new InvalidOperationException("该合同中的产品[" + contractItem.getProduct().getProductName() + "],出库数量已满");
            }

            if(restAmount == amount1) {
                contractItem.setState(ContractState.None.ordinal());
            }

            if(restAmount > 0 && restAmount < amount1) {
                contractItem.setState(ContractState.Part.ordinal());
            }

            if(restAmount == 0) {
                contractItem.setState(ContractState.Complete.ordinal());
            }

            contract.setTotalCheckingAmount(totalCheckingAmount1 - socItemAmount1);
            contract.setTotalFinishedAmount(totalFinishedAmount1 + socItemAmount1);
            contract.setUpdater(soc.getCreator());
            contract.setUpdateTime(soc.getCreateTime());
            contractItem.setUpdater(soc.getCreator());
            contractItem.setUpdateTime(soc.getCreateTime());
            contractItem.setCheckingAmount(checkingAmount1 - socItemAmount1);
            contractItem.setFinishedAmount(finishedAmount1 + socItemAmount1);
        }

        if(contract.getTotalAmount() == contract.getTotalFinishedAmount()) {
            contract.setState(ContractState.Complete.ordinal());
        } else {
            contract.setState(ContractState.Part.ordinal());
        }

        this.update(contract);
    }

    private void RollBackContractByStorageOutcoming(Entity entity) {
        StorageOutcoming soc = (StorageOutcoming)entity;

        Contract contract;
        for(Iterator var4 = soc.getSocItems().iterator(); var4.hasNext(); this.update(contract)) {
            StorageOutcomingItem socItem = (StorageOutcomingItem)var4.next();
            contract = (Contract)this.entityService.get(Contract.class, socItem.getContractItem().getContract().getId());
            ContractItem contractItem = contract.getItem(socItem.getContractItem().getId());
            boolean totalCheckingAmount = false;
            boolean checkingAmount = false;
            boolean socItemAmount = false;
            int totalCheckingAmount1 = contract.getTotalCheckingAmount();
            int checkingAmount1 = contractItem.getCheckingAmount();
            int socItemAmount1 = socItem.getAmount();
            contract.setTotalCheckingAmount(totalCheckingAmount1 - socItemAmount1);
            contractItem.setCheckingAmount(checkingAmount1 - socItemAmount1);
            if(contract.getTotalCheckingAmount() != 0) {
                contract.setState(ContractState.Part.ordinal());
            }

            if(contract.getTotalCheckingAmount() == 0 && contract.getTotalFinishedAmount() == 0) {
                contract.setState(ContractState.None.ordinal());
            }
        }

    }

    public void print(List<ContractItemOwnedSummeryView> contractItemOwnedSummeryViewList) throws IOException {
        HashMap parameters = new HashMap();
        ArrayList contractItemOwnedSummeryViewPrint = new ArrayList();
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        String strDate = "合同对库欠交汇总表  " + format.format(date);
        parameters.put("Duration", strDate);
        Integer i = Integer.valueOf(1);
        Iterator strPath = contractItemOwnedSummeryViewList.iterator();

        while(strPath.hasNext()) {
            ContractItemOwnedSummeryView svDS = (ContractItemOwnedSummeryView)strPath.next();
            ContractItemOwnedSummeryViewPrint e = new ContractItemOwnedSummeryViewPrint();
            Capacitor response = (Capacitor)this.entityService.get(Capacitor.class, svDS.getProduct().getId());
            ProductCode ouputStream = null;
            String strProductCode = "";
            if(response.getProductCode() != null) {
                ouputStream = (ProductCode)this.entityService.get(ProductCode.class, response.getProductCode().getId());
                strProductCode = ouputStream.getName();
            }

            e.setItemNo(i.toString());
            e.setPC(response.getProductCombination());
            e.setProductCode(strProductCode);
            e.setAmount(String.valueOf(svDS.getAmount()));
            e.setFinishedAmount(String.valueOf(svDS.getFinishedAmount()));
            e.setCheckingAmount(String.valueOf(svDS.getCheckingAmount()));
            e.setUnfinishedAmount(String.valueOf(svDS.getUnfinishedAmount()));
            e.setRestAmount(String.valueOf(svDS.getRestAmount()));
            e.setOwnedAmount(String.valueOf(svDS.getOwnedAmount()));
            i = Integer.valueOf(i.intValue() + 1);
            contractItemOwnedSummeryViewPrint.add(e);
        }

        ContractItemOwnedSummeryViewDataSource svDS1 = new ContractItemOwnedSummeryViewDataSource();
        svDS1.setContractItemOwnedSummeryViewPrint(contractItemOwnedSummeryViewPrint);
        String strPath1 = ServletActionContext.getServletContext().getRealPath("/jasper");
        strPath1 = strPath1 + "/OwnedSummeryView.jasper";

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
        } catch (JRException var17) {
            var17.printStackTrace();
        }

    }

    public void printContract(List<Contract> contractList, int iType) throws IOException {
        if(iType == 0) {
            this.printContractPDF(contractList);
        } else if(iType == 1) {
            this.printContractXLT(contractList);
        }

    }

    private void printContractPDF(List<Contract> contractList) throws IOException {
        if(contractList.size() != 0) {
            Contract firstContract = (Contract)this.entityService.get(Contract.class, ((Contract)contractList.get(0)).getId());
            Company firstCompany = (Company)this.entityService.get(Company.class, firstContract.getCompany().getId());
            String strContractID = "";
            String strCompanyID = firstCompany.getId();
            HashMap parameters = new HashMap();
            ArrayList contractPrintList = new ArrayList();
            parameters.put("strCompanyName", firstCompany.getName().trim());
            int iNo = 0;
            Iterator strPath = contractList.iterator();

            while(true) {
                Contract e;
                Company response;
                do {
                    if(!strPath.hasNext()) {
                        ContractDataSource var25 = new ContractDataSource();
                        var25.setContractPrint(contractPrintList);
                        String var26 = ServletActionContext.getServletContext().getRealPath("/jasper");
                        var26 = var26 + "/Contract.jasper";

                        try {
                            byte[] var27 = JasperRunManager.runReportToPdf(var26, parameters, var25);
                            HttpServletResponse var28 = ServletActionContext.getResponse();
                            var28.setContentType("application/pdf");
                            var28.setContentLength(var27.length);
                            ServletOutputStream var29 = var28.getOutputStream();

                            try {
                                var29.write(var27, 0, var27.length);
                                var29.close();
                                var29.flush();
                            } finally {
                                if(var29 != null) {
                                    var29.close();
                                }

                            }
                        } catch (JRException var24) {
                            var24.printStackTrace();
                        }

                        return;
                    }

                    Contract svDS = (Contract)strPath.next();
                    e = (Contract)this.entityService.get(Contract.class, svDS.getId());
                    response = (Company)this.entityService.get(Company.class, svDS.getCompany().getId());
                } while(!strCompanyID.equalsIgnoreCase(response.getId()));

                String[] ouputStream = new String[]{e.getId()};
                SearchResult sr = this.searchService.search("com.is.eus.pojo.contract.ContractItem.printContractItem", ouputStream);
                List contractItemList = sr.get();
                Iterator var17 = contractItemList.iterator();

                while(var17.hasNext()) {
                    ContractItem contractItem = (ContractItem)var17.next();
                    ++iNo;
                    ContractPrint cp = new ContractPrint();
                    if(!strContractID.equalsIgnoreCase(e.getId())) {
                        cp.setContractNo(e.getContractNo());
                    }

                    cp.setNo(String.valueOf(iNo));
                    Product product = (Product)this.entityService.get(Product.class, contractItem.getProduct().getId());
                    Unit unit = (Unit)this.entityService.get(Unit.class, product.getUnit().getId());
                    cp.setItemNo(String.valueOf(contractItem.getContractItemNo()));
                    cp.setPC(product.getProductCombination());
                    cp.setUnit(unit.getName());
                    cp.setAmount(String.valueOf(contractItem.getAmount()));
                    cp.setPrice(String.valueOf(contractItem.getPrice()));
                    cp.setSubTotal(String.valueOf(contractItem.getSubTotal()));
                    cp.setMemo(contractItem.getMemo());
                    contractPrintList.add(cp);
                }

                strContractID = e.getId();
            }
        }
    }

    private void printContractXLT(List<Contract> contractList) throws IOException {
        if(contractList.size() != 0) {
            Contract firstContract = (Contract)this.entityService.get(Contract.class, ((Contract)contractList.get(0)).getId());
            Company firstCompany = (Company)this.entityService.get(Company.class, firstContract.getCompany().getId());
            String strContractID = "";
            String strCompanyID = firstCompany.getId();
            HashMap parameters = new HashMap();
            ArrayList contractPrintList = new ArrayList();
            parameters.put("strCompanyName", firstCompany.getName().trim());
            int iNo = 0;
            Iterator strPath = contractList.iterator();

            while(true) {
                Contract e;
                Company exporter;
                do {
                    if(!strPath.hasNext()) {
                        ContractDataSource var22 = new ContractDataSource();
                        var22.setContractPrint(contractPrintList);
                        String var23 = ServletActionContext.getServletContext().getRealPath("/jasper");
                        var23 = var23 + "/Contract.jasper";

                        try {
                            JasperPrint var24 = JasperFillManager.fillReport(var23, parameters, var22);
                            JRXlsExporter var25 = new JRXlsExporter();
                            HttpServletResponse var26 = ServletActionContext.getResponse();
                            var25.setParameter(JRExporterParameter.JASPER_PRINT, var24);
                            var25.setParameter(JRExporterParameter.OUTPUT_STREAM, var26.getOutputStream());
                            var25.setParameter(JRXlsExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS, Boolean.TRUE);
                            var25.setParameter(JRXlsExporterParameter.IS_ONE_PAGE_PER_SHEET, Boolean.FALSE);
                            var25.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND, Boolean.FALSE);
                            var25.exportReport();
                            var26.setContentType("application/vnd.ms-excel");
                        } catch (JRException var21) {
                            var21.printStackTrace();
                        }

                        return;
                    }

                    Contract svDS = (Contract)strPath.next();
                    e = (Contract)this.entityService.get(Contract.class, svDS.getId());
                    exporter = (Company)this.entityService.get(Company.class, svDS.getCompany().getId());
                } while(!strCompanyID.equalsIgnoreCase(exporter.getId()));

                String[] response = new String[]{e.getId()};
                SearchResult sr = this.searchService.search("com.is.eus.pojo.contract.ContractItem.printContractItem", response);
                List contractItemList = sr.get();
                Iterator var17 = contractItemList.iterator();

                while(var17.hasNext()) {
                    ContractItem contractItem = (ContractItem)var17.next();
                    ++iNo;
                    ContractPrint cp = new ContractPrint();
                    if(!strContractID.equalsIgnoreCase(e.getId())) {
                        cp.setContractNo(e.getContractNo());
                    }

                    cp.setNo(String.valueOf(iNo));
                    Product product = (Product)this.entityService.get(Product.class, contractItem.getProduct().getId());
                    Unit unit = (Unit)this.entityService.get(Unit.class, product.getUnit().getId());
                    cp.setItemNo(String.valueOf(contractItem.getContractItemNo()));
                    cp.setPC(product.getProductCombination());
                    cp.setUnit(unit.getName());
                    cp.setAmount(String.valueOf(contractItem.getAmount()));
                    cp.setPrice(String.valueOf(contractItem.getPrice()));
                    cp.setSubTotal(String.valueOf(contractItem.getSubTotal()));
                    cp.setMemo(contractItem.getMemo());
                    contractPrintList.add(cp);
                }

                strContractID = e.getId();
            }
        }
    }
}
