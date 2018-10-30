 package com.is.eus.web.action.management.basic;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.City;
 import com.is.eus.pojo.basic.Company;
 import com.is.eus.pojo.basic.Province;
 import com.is.eus.pojo.dac.User;
 import com.is.eus.service.EntityService;
 import com.is.eus.service.basic.ui.CompanyService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.type.DataStatus;
 import com.is.eus.web.action.EntityBaseAction;
 import com.is.eus.web.exception.InvalidPageInformationException;
 import java.text.ParseException;
 import java.util.Date;
 import org.apache.commons.lang.xwork.StringUtils;

 public class CompanyAction extends EntityBaseAction
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
   private String province;
   private String city;
   private CompanyService companyService;

   public void setCode(String code)
   {
     this.code = code;
   }

   public void setName(String name) {
     this.name = name;
   }

   public void setAddress(String address) {
     this.address = address;
   }

   public void setCommAddress(String commAddress) {
     this.commAddress = commAddress;
   }

   public void setBank(String bank) {
     this.bank = bank;
   }

   public void setContract(String contract) {
     this.contract = contract;
   }

   public void setAccount(String account) {
     this.account = account;
   }

   public void setTax(String tax) {
     this.tax = tax;
   }

   public void setZipCode(String zipCode) {
     this.zipCode = zipCode;
   }

   public void setTele(String tele) {
     this.tele = tele;
   }

   public void setDelegatee(String delegatee) {
     this.delegatee = delegatee;
   }

   public void setEmail(String email) {
     this.email = email;
   }

   public void setFax(String fax) {
     this.fax = fax;
   }

   public void setMemo(String memo) {
     this.memo = memo;
   }

   public void setProvince(String province) {
     this.province = province;
   }

   public void setCity(String city) {
     this.city = city;
   }

   public void setCompanyService(CompanyService companyService) {
     this.companyService = companyService;
   }

   public String add()
   {
     User user = getUserFromSession();
     Company company = new Company();
     try {
       check();
       fillEntity(company);
       company.setCreator(user.getEmployee());
       company.setCreateTime(new Date());
       this.companyService.add(company);
       simpleResult(true);
     } catch (InvalidPageInformationException e) {
       result(false, e.getMessage());
     } catch (InvalidOperationException e) {
       result(false, e.getMessage());
     } catch (ParseException e) {
       result(false, e.getMessage());
     }
     return "success";
   }

   protected void check()
     throws InvalidOperationException, InvalidPageInformationException
   {
     super.check();
   }

   public String remove()
   {
     try {
       Company company = (Company)this.entityService.get(Company.class, this.id);
       company.setStatus(DataStatus.Deleted.ordinal());
       this.companyService.udpate(company);
       simpleResult(true);
     } catch (InvalidOperationException e) {
       result(false, e.getMessage());
     }
     return "success";
   }

   public String update()
   {
     User user = getUserFromSession();
     Company company = (Company)this.entityService.get(Company.class, this.id);
     try {
       check();
       fillEntity(company);
       company.setUpdater(user.getEmployee());
       company.setUpdateTime(new Date());
       this.companyService.udpate(company);
       simpleResult(true);
     } catch (InvalidPageInformationException e) {
       result(false, e.getMessage());
     } catch (InvalidOperationException e) {
       result(false, e.getMessage());
     } catch (ParseException e) {
       result(false, e.getMessage());
     }
     return "success";
   }

   protected void fillEntity(Entity entity) throws ParseException
   {
     Province province = (Province)this.entityService.get(Province.class, this.province);
     City city = (City)this.entityService.get(City.class, this.city);
     Company company = (Company)entity;
     company.setCode(this.code);
     company.setName(this.name);
     company.setAddress(this.address);
     company.setCommAddress(this.commAddress);
     company.setBank(this.bank);
     company.setContract(this.contract);
     company.setAccount(this.account);
     company.setTax(this.tax);
     company.setZipCode(this.zipCode);
     company.setTele(this.tele);
     company.setDelegatee(this.delegatee);
     company.setEmail(this.email);
     company.setFax(this.fax);
     company.setMemo(this.memo);
     company.setCity(city);
     company.setProvince(province);
   }

   protected Class<Company> getEntityClass()
   {
     return Company.class;
   }

   protected Class<?> getEntityStateClass()
   {
     return null;
   }

   public String find()
   {
     if (!StringUtils.isEmpty(getHQL()))
       this.HQLCondition = getHQL();
     else {
       this.HQLCondition = "";
     }
     return super.find();
   }

   private String getHQL()
   {
     String strHQL = "";
     StringBuilder strClause = new StringBuilder();
     String strConnection = " and ";

     if (!StringUtils.isEmpty(this.code)) {
       strHQL = "c.code like '%" + this.code + "%'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.name)) {
       strHQL = "c.name like '%" + this.name + "%'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.address)) {
       strHQL = "c.address like '%" + this.address + "%'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.commAddress)) {
       strHQL = "c.commAddress like '%" + this.commAddress + "%'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.bank)) {
       strHQL = "c.bank like '%" + this.bank + "%'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.contract)) {
       strHQL = "c.contract like '%" + this.contract + "%'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.account)) {
       strHQL = "c.account like '%" + this.account + "%'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.tax)) {
       strHQL = "c.tax like '%" + this.tax + "%'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.zipCode)) {
       strHQL = "c.zipCode like '%" + this.zipCode + "%'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.tele)) {
       strHQL = "c.tele like '%" + this.tele + "%'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.delegatee)) {
       strHQL = "c.delegatee like '%" + this.delegatee + "%'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.email)) {
       strHQL = "c.email like '%" + this.email + "%'" + strConnection;
       strClause.append(strHQL);
     }if (!StringUtils.isEmpty(this.fax)) {
       strHQL = "c.fax like '%" + this.fax + "%'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.memo)) {
       strHQL = "c.memo like '%" + this.memo + "%'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.province)) {
       strHQL = "c.province.id = '" + this.province + "'" + strConnection;
       strClause.append(strHQL);
     }
     if (!StringUtils.isEmpty(this.city)) {
       strHQL = "c.city.id = '" + this.city + "'" + strConnection;
       strClause.append(strHQL);
     }

     if (strClause.indexOf(strConnection) != -1) {
       strClause.delete(strClause.lastIndexOf(strConnection), strClause.length());
     }

     return strClause.toString();
   }
 }