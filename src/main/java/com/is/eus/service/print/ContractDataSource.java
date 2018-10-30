 package com.is.eus.service.print;

 import com.is.eus.pojo.contract.ContractPrint;
 import java.util.List;
 import net.sf.jasperreports.engine.JRDataSource;
 import net.sf.jasperreports.engine.JRException;
 import net.sf.jasperreports.engine.JRField;

 public class ContractDataSource
   implements JRDataSource
 {
   private int index = -1;
   private List<ContractPrint> contractPrint;

   public void setContractPrint(List<ContractPrint> contractPrint)
   {
     this.contractPrint = contractPrint;
   }

   public Object getFieldValue(JRField field) throws JRException
   {
     Object value = null;

     String fieldName = field.getName();
     if ("No".equals(fieldName))
       value = ((ContractPrint)this.contractPrint.get(this.index)).getNo();
     else if ("PC".equals(fieldName))
       value = ((ContractPrint)this.contractPrint.get(this.index)).getPC();
     else if ("ItemNo".equals(fieldName))
       value = ((ContractPrint)this.contractPrint.get(this.index)).getItemNo();
     else if ("SubTotal".equals(fieldName))
       value = ((ContractPrint)this.contractPrint.get(this.index)).getSubTotal();
     else if ("Amount".equals(fieldName))
       value = ((ContractPrint)this.contractPrint.get(this.index)).getAmount();
     else if ("Memo".equals(fieldName))
       value = ((ContractPrint)this.contractPrint.get(this.index)).getMemo();
     else if ("Unit".equals(fieldName))
       value = ((ContractPrint)this.contractPrint.get(this.index)).getUnit();
     else if ("Price".equals(fieldName))
       value = ((ContractPrint)this.contractPrint.get(this.index)).getPrice();
     else if ("ContractNo".equals(fieldName)) {
       value = ((ContractPrint)this.contractPrint.get(this.index)).getContractNo();
     }
     return value;
   }

   public boolean next() throws JRException
   {
     this.index += 1;
     return this.index < this.contractPrint.size();
   }
 }

