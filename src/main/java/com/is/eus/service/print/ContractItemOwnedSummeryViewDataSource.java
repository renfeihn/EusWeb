 package com.is.eus.service.print;

 import com.is.eus.pojo.contract.ContractItemOwnedSummeryViewPrint;
 import java.util.List;
 import net.sf.jasperreports.engine.JRDataSource;
 import net.sf.jasperreports.engine.JRException;
 import net.sf.jasperreports.engine.JRField;

 public class ContractItemOwnedSummeryViewDataSource
   implements JRDataSource
 {
   private int index = -1;
   private List<ContractItemOwnedSummeryViewPrint> contractItemOwnedSummeryViewPrint;

   public void setContractItemOwnedSummeryViewPrint(List<ContractItemOwnedSummeryViewPrint> contractItemOwnedSummeryViewPrint)
   {
     this.contractItemOwnedSummeryViewPrint = contractItemOwnedSummeryViewPrint;
   }

   public Object getFieldValue(JRField field) throws JRException
   {
     Object value = null;

     String fieldName = field.getName();
     if ("PC".equals(fieldName))
       value = ((ContractItemOwnedSummeryViewPrint)this.contractItemOwnedSummeryViewPrint.get(this.index)).getPC();
     else if ("ItemNo".equals(fieldName))
       value = ((ContractItemOwnedSummeryViewPrint)this.contractItemOwnedSummeryViewPrint.get(this.index)).getItemNo();
     else if ("productCode".equals(fieldName))
       value = ((ContractItemOwnedSummeryViewPrint)this.contractItemOwnedSummeryViewPrint.get(this.index)).getProductCode();
     else if ("amount".equals(fieldName))
       value = ((ContractItemOwnedSummeryViewPrint)this.contractItemOwnedSummeryViewPrint.get(this.index)).getAmount();
     else if ("finishedAmount".equals(fieldName))
       value = ((ContractItemOwnedSummeryViewPrint)this.contractItemOwnedSummeryViewPrint.get(this.index)).getFinishedAmount();
     else if ("checkingAmount".equals(fieldName))
       value = ((ContractItemOwnedSummeryViewPrint)this.contractItemOwnedSummeryViewPrint.get(this.index)).getCheckingAmount();
     else if ("unfinishedAmount".equals(fieldName))
       value = ((ContractItemOwnedSummeryViewPrint)this.contractItemOwnedSummeryViewPrint.get(this.index)).getUnfinishedAmount();
     else if ("restAmount".equals(fieldName))
       value = ((ContractItemOwnedSummeryViewPrint)this.contractItemOwnedSummeryViewPrint.get(this.index)).getRestAmount();
     else if ("ownedAmount".equals(fieldName)) {
       value = ((ContractItemOwnedSummeryViewPrint)this.contractItemOwnedSummeryViewPrint.get(this.index)).getOwnedAmount();
     }

     return value;
   }

   public boolean next() throws JRException
   {
     this.index += 1;
     return this.index < this.contractItemOwnedSummeryViewPrint.size();
   }
 }

