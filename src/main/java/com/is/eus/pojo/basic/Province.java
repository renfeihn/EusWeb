 package com.is.eus.pojo.basic;

 import com.is.eus.pojo.Entity;
 import java.util.List;

 public class Province extends Entity
 {
   private String name;
   private String description;
   private int ord;
   private List<City> cities;

   public String getName()
   {
     return this.name;
   }
   public void setName(String name) {
     this.name = name;
   }
   public String getDescription() {
     return this.description;
   }
   public void setDescription(String description) {
     this.description = description;
   }
   public int getOrd() {
     return this.ord;
   }
   public void setOrd(int ord) {
     this.ord = ord;
   }
   public List<City> getCities() {
     return this.cities;
   }
   public void setCities(List<City> cities) {
     this.cities = cities;
   }
 }

