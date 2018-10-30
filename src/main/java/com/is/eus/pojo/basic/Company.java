 package com.is.eus.pojo.basic;

 import com.is.eus.pojo.Entity;

 public class Company extends Entity
 {
   private String code;
   private String name;
   private String address;
   private String commAddress;
   private String bank;
   private String contract;
   private String account;
   private String tax;
   private String zipCode;
   private String tele;
   private String delegatee;
   private String email;
   private String fax;
   private String memo;
   private Province province;
   private City city;

   public String getCode()
   {
     return this.code;
   }
   public void setCode(String code) {
     this.code = code;
   }
   public String getName() {
     return this.name;
   }
   public void setName(String name) {
     this.name = name;
   }
   public String getAddress() {
     return this.address;
   }
   public void setAddress(String address) {
     this.address = address;
   }
   public String getCommAddress() {
     return this.commAddress;
   }
   public void setCommAddress(String commAddress) {
     this.commAddress = commAddress;
   }
   public String getBank() {
     return this.bank;
   }
   public void setBank(String bank) {
     this.bank = bank;
   }
   public String getContract() {
     return this.contract;
   }
   public void setContract(String contract) {
     this.contract = contract;
   }
   public String getAccount() {
     return this.account;
   }
   public void setAccount(String account) {
     this.account = account;
   }
   public String getTax() {
     return this.tax;
   }
   public void setTax(String tax) {
     this.tax = tax;
   }
   public String getZipCode() {
     return this.zipCode;
   }
   public void setZipCode(String zipCode) {
     this.zipCode = zipCode;
   }
   public String getTele() {
     return this.tele;
   }
   public void setTele(String tele) {
     this.tele = tele;
   }
   public String getDelegatee() {
     return this.delegatee;
   }
   public void setDelegatee(String delegatee) {
     this.delegatee = delegatee;
   }
   public String getEmail() {
     return this.email;
   }
   public void setEmail(String email) {
     this.email = email;
   }
   public String getFax() {
     return this.fax;
   }
   public void setFax(String fax) {
     this.fax = fax;
   }
   public String getMemo() {
     return this.memo;
   }
   public void setMemo(String memo) {
     this.memo = memo;
   }
   public Province getProvince() {
     return this.province;
   }
   public void setProvince(Province province) {
     this.province = province;
   }
   public City getCity() {
     return this.city;
   }
   public void setCity(City city) {
     this.city = city;
   }
 }



