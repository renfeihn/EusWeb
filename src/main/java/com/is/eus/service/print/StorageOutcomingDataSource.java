 package com.is.eus.service.print;

 import com.is.eus.pojo.storage.StorageOutcomingPrint;
 import java.util.List;
 import net.sf.jasperreports.engine.JRDataSource;
 import net.sf.jasperreports.engine.JRException;
 import net.sf.jasperreports.engine.JRField;

 public class StorageOutcomingDataSource
   implements JRDataSource
 {
   private int index = -1;
   private List<StorageOutcomingPrint> storageOutcomingPrint;

   public void setStorageOutcomingPrint(List<StorageOutcomingPrint> storageOutcomingPrint)
   {
     this.storageOutcomingPrint = storageOutcomingPrint;
   }

   public Object getFieldValue(JRField field) throws JRException
   {
     Object value = null;
     String fieldName = field.getName();
     if ("PC".equals(fieldName))
       value = ((StorageOutcomingPrint)this.storageOutcomingPrint.get(this.index)).getPC();
     else if ("Unit".equals(fieldName))
       value = ((StorageOutcomingPrint)this.storageOutcomingPrint.get(this.index)).getUnit();
     else if ("Amount".equals(fieldName))
       value = ((StorageOutcomingPrint)this.storageOutcomingPrint.get(this.index)).getAmount();
     else if ("Price".equals(fieldName))
       value = ((StorageOutcomingPrint)this.storageOutcomingPrint.get(this.index)).getPrice();
     else if ("PriceWithoutTax".equals(fieldName))
       value = ((StorageOutcomingPrint)this.storageOutcomingPrint.get(this.index)).getPriceWithoutTax();
     else if ("SubTotal".equals(fieldName))
       value = ((StorageOutcomingPrint)this.storageOutcomingPrint.get(this.index)).getSubTotal();
     else if ("SubTotalWithoutTax".equals(fieldName))
       value = ((StorageOutcomingPrint)this.storageOutcomingPrint.get(this.index)).getSubTotalWithoutTax();
     else if ("Tax".equals(fieldName))
       value = ((StorageOutcomingPrint)this.storageOutcomingPrint.get(this.index)).getTax();
     else if ("TaxAmount".equals(fieldName))
       value = ((StorageOutcomingPrint)this.storageOutcomingPrint.get(this.index)).getTaxAmount();
     else if ("Memo".equals(fieldName)) {
       value = ((StorageOutcomingPrint)this.storageOutcomingPrint.get(this.index)).getMemo();
     }
     return value;
   }

   public boolean next() throws JRException
   {
     this.index += 1;
     return this.index < this.storageOutcomingPrint.size();
   }
 }

