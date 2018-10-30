 package com.is.eus.service.print;

 import com.is.eus.pojo.schedule.SchedulePrint;
 import java.util.List;
 import net.sf.jasperreports.engine.JRDataSource;
 import net.sf.jasperreports.engine.JRException;
 import net.sf.jasperreports.engine.JRField;

 public class ScheduleDataSource
   implements JRDataSource
 {
   private int index = -1;
   private List<SchedulePrint> schedulePrint;

   public void setSchedulePrint(List<SchedulePrint> schedulePrint)
   {
     this.schedulePrint = schedulePrint;
   }

   public Object getFieldValue(JRField field) throws JRException
   {
     Object value = null;
     String fieldName = field.getName();
     if ("PC".equals(fieldName))
       value = ((SchedulePrint)this.schedulePrint.get(this.index)).getPC();
     else if ("ItemNo".equals(fieldName))
       value = ((SchedulePrint)this.schedulePrint.get(this.index)).getItemNo();
     else if ("Amount".equals(fieldName))
       value = ((SchedulePrint)this.schedulePrint.get(this.index)).getAmount();
     else if ("FinishedAmount".equals(fieldName))
       value = ((SchedulePrint)this.schedulePrint.get(this.index)).getFinishedAmount();
     else if ("UnfinishedAmount".equals(fieldName))
       value = ((SchedulePrint)this.schedulePrint.get(this.index)).getUnfinishedAmount();
     else if ("Q1".equals(fieldName))
       value = ((SchedulePrint)this.schedulePrint.get(this.index)).getQ1();
     else if ("Q2".equals(fieldName))
       value = ((SchedulePrint)this.schedulePrint.get(this.index)).getQ2();
     else if ("Q3".equals(fieldName))
       value = ((SchedulePrint)this.schedulePrint.get(this.index)).getQ3();
     else if ("Q4".equals(fieldName))
       value = ((SchedulePrint)this.schedulePrint.get(this.index)).getQ4();
     else if ("Memo".equals(fieldName)) {
       value = ((SchedulePrint)this.schedulePrint.get(this.index)).getMemo();
     }
     return value;
   }

   public boolean next() throws JRException
   {
     this.index += 1;
     return this.index < this.schedulePrint.size();
   }
 }

