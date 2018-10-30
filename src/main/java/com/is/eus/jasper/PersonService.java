 package com.is.eus.jasper;

 import java.util.ArrayList;
 import java.util.List;

 public class PersonService
 {
   public List<Person> getAllPerson()
   {
     List perList = new ArrayList();
     perList.add(new Person("101", "小博", "22", "湖北"));
     perList.add(new Person("102", "张三", "21", "湖南"));
     perList.add(new Person("103", "李四", "23", "江苏"));
     perList.add(new Person("104", "王五", "22", "上海"));
     return perList;
   }
 }

