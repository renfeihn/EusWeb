 package com.is.eus.pojo.storage;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.Product;
 import com.is.eus.pojo.basic.StorageLocation;
 import com.is.eus.pojo.contract.ContractItem;

 public class StorageOutcomingItem extends Entity
 {
   private int socItemNo;
   private Product product;
   private StorageLocation storageLocation;
   private float price;
   private double priceWithoutTax;
   private int amount;
   private int tax;
   private float subTotal;
   private float subTotalWithoutTax;
   private float TaxAmount;
   private String memo;
   private StorageOutcoming soc;
   private ContractItem contractItem;

   public int getSocItemNo()
   {
     return this.socItemNo;
   }
   public void setSocItemNo(int socItemNo) {
     this.socItemNo = socItemNo;
   }
   public Product getProduct() {
     return this.product;
   }
   public void setProduct(Product product) {
     this.product = product;
   }
   public StorageLocation getStorageLocation() {
     return this.storageLocation;
   }
   public void setStorageLocation(StorageLocation storageLocation) {
     this.storageLocation = storageLocation;
   }
   public float getPrice() {
     return this.price;
   }
   public void setPrice(float price) {
     this.price = price;
   }
   public double getPriceWithoutTax() {
     return this.priceWithoutTax;
   }
   public void setPriceWithoutTax(double priceWithoutTax) {
     this.priceWithoutTax = priceWithoutTax;
   }
   public int getAmount() {
     return this.amount;
   }
   public void setAmount(int amount) {
     this.amount = amount;
   }
   public int getTax() {
     return this.tax;
   }
   public void setTax(int tax) {
     this.tax = tax;
   }
   public float getSubTotal() {
     return this.subTotal;
   }
   public void setSubTotal(float subTotal) {
     this.subTotal = subTotal;
   }
   public float getSubTotalWithoutTax() {
     return this.subTotalWithoutTax;
   }
   public void setSubTotalWithoutTax(float subTotalWithoutTax) {
     this.subTotalWithoutTax = subTotalWithoutTax;
   }
   public float getTaxAmount() {
     return this.TaxAmount;
   }
   public void setTaxAmount(float taxAmount) {
     this.TaxAmount = taxAmount;
   }
   public String getMemo() {
     return this.memo;
   }
   public void setMemo(String memo) {
     this.memo = memo;
   }
   public StorageOutcoming getSoc() {
     return this.soc;
   }
   public void setSoc(StorageOutcoming soc) {
     this.soc = soc;
   }
   public ContractItem getContractItem() {
     return this.contractItem;
   }
   public void setContractItem(ContractItem contractItem) {
     this.contractItem = contractItem;
   }
 }