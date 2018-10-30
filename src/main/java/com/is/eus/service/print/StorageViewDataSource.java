 package com.is.eus.service.print;

 import com.is.eus.pojo.storage.StorageViewPrint;
 import java.util.List;
 import net.sf.jasperreports.engine.JRDataSource;
 import net.sf.jasperreports.engine.JRException;
 import net.sf.jasperreports.engine.JRField;

 public class StorageViewDataSource
   implements JRDataSource
 {
   private int index = -1;
   private List<StorageViewPrint> storageViewPrint;

   public void setStorageViewPrint(List<StorageViewPrint> storageViewPrint)
   {
     this.storageViewPrint = storageViewPrint;
   }

   public Object getFieldValue(JRField field) throws JRException
   {
     Object value = null;

     String fieldName = field.getName();
     if ("PC".equals(fieldName))
       value = ((StorageViewPrint)this.storageViewPrint.get(this.index)).getPC();
     else if ("ItemNo".equals(fieldName))
       value = ((StorageViewPrint)this.storageViewPrint.get(this.index)).getItemNo();
     else if ("productCode".equals(fieldName))
       value = ((StorageViewPrint)this.storageViewPrint.get(this.index)).getProductCode();
     else if ("errorLevel".equals(fieldName))
       value = ((StorageViewPrint)this.storageViewPrint.get(this.index)).getErrorLevel();
     else if ("voltage".equals(fieldName))
       value = ((StorageViewPrint)this.storageViewPrint.get(this.index)).getVoltage();
     else if ("capacity".equals(fieldName))
       value = ((StorageViewPrint)this.storageViewPrint.get(this.index)).getCapacity();
     else if ("productType".equals(fieldName))
       value = ((StorageViewPrint)this.storageViewPrint.get(this.index)).getProductType();
     else if ("humidity".equals(fieldName))
       value = ((StorageViewPrint)this.storageViewPrint.get(this.index)).getHumidity();
     else if ("usageType".equals(fieldName))
       value = ((StorageViewPrint)this.storageViewPrint.get(this.index)).getUsageType();
     else if ("totalAmount".equals(fieldName))
       value = ((StorageViewPrint)this.storageViewPrint.get(this.index)).getTotalAmount();
     else if ("advancedAmount".equals(fieldName))
       value = ((StorageViewPrint)this.storageViewPrint.get(this.index)).getAdvancedAmount();
     else if ("restAmount".equals(fieldName)) {
       value = ((StorageViewPrint)this.storageViewPrint.get(this.index)).getRestAmount();
     }

     return value;
   }

   public boolean next() throws JRException
   {
     this.index += 1;
     return this.index < this.storageViewPrint.size();
   }
 }
