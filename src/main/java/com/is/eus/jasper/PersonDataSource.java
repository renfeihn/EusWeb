 package com.is.eus.jasper;

 import java.util.List;
 import net.sf.jasperreports.engine.JRDataSource;
 import net.sf.jasperreports.engine.JRException;
 import net.sf.jasperreports.engine.JRField;

 public class PersonDataSource
   implements JRDataSource
 {
   private int index = -1;

   private List<Person> personList = new PersonService().getAllPerson();

   public Object getFieldValue(JRField field) throws JRException {
     Object value = null;
     String fieldName = field.getName();
     if ("person_Id".equals(fieldName))
       value = ((Person)this.personList.get(this.index)).getPerson_Id();
     else if ("person_name".equals(fieldName))
       value = ((Person)this.personList.get(this.index)).getPerson_name();
     else if ("person_age".equals(fieldName))
       value = ((Person)this.personList.get(this.index)).getPerson_age();
     else if ("person_address".equals(fieldName)) {
       value = ((Person)this.personList.get(this.index)).getPerson_address();
     }
     return value;
   }
   public boolean next() throws JRException {
     this.index += 1;
     return this.index < this.personList.size();
   }
 }

