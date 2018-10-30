 package com.is.eus.web.action.management.biz;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.basic.Product;
 import com.is.eus.pojo.basic.StorageLocation;
 import com.is.eus.pojo.dac.User;
 import com.is.eus.pojo.schedule.Schedule;
 import com.is.eus.pojo.storage.StorageIncoming;
 import com.is.eus.pojo.storage.StorageIncomingItem;
 import com.is.eus.service.EntityService;
 import com.is.eus.service.biz.ui.StorageIncomingService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.type.StorageIncomingState;
 import com.is.eus.web.action.EntityBaseAction;
 import com.is.eus.web.exception.InvalidPageInformationException;
 import java.text.ParseException;
 import java.util.Date;
 import java.util.HashSet;
 import java.util.Set;

 public class storageIncomingAction extends EntityBaseAction
 {
   private String[] productIDs;
   private int[] amounts;
   private String[] scheduleIDs;
   private String[] storageLocationIDs;
   private int[] itemNos;
   private String[] jobCmdNos;
   private StorageIncomingService storageIncomingService;
   private int[] state;
   private Date[] productionDates;
   private int aduit;

   public Date[] getProductionDates()
   {
     return this.productionDates;
   }

   public void setProductionDates(Date[] productionDates) {
     this.productionDates = productionDates;
   }

   public String[] getProductIDs() {
     return this.productIDs;
   }

   public void setProductIDs(String[] productIDs) {
     this.productIDs = productIDs;
   }

   public int[] getAmounts() {
     return this.amounts;
   }

   public void setAmounts(int[] amounts) {
     this.amounts = amounts;
   }

   public String[] getScheduleIDs() {
     return this.scheduleIDs;
   }

   public void setScheduleIDs(String[] scheduleIDs) {
     this.scheduleIDs = scheduleIDs;
   }

   public String[] getStorageLocationIDs() {
     return this.storageLocationIDs;
   }

   public void setStorageLocationIDs(String[] storageLocationIDs) {
     this.storageLocationIDs = storageLocationIDs;
   }

   public int[] getItemNos() {
     return this.itemNos;
   }

   public void setItemNos(int[] itemNos) {
     this.itemNos = itemNos;
   }

   public String[] getJobCmdNos() {
     return this.jobCmdNos;
   }

   public void setJobCmdNos(String[] jobCmdNos) {
     this.jobCmdNos = jobCmdNos;
   }

   public int[] getState() {
     return this.state;
   }

   public void setState(int[] state) {
     this.state = state;
   }

   public int getAduit() {
     return this.aduit;
   }

   public void setAduit(int aduit) {
     this.aduit = aduit;
   }

   public void setStorageIncomingService(StorageIncomingService storageIncomingService)
   {
     this.storageIncomingService = storageIncomingService;
   }

   private Set<StorageIncomingItem> getStorageIncomingItems(StorageIncoming storageIncoming) throws ParseException {
     User user = getUserFromSession();

     Set storageIncomingItem = new HashSet();
     int iTotalAmount = 0;

     for (int i = 0; i < this.productIDs.length; i++) {
       StorageIncomingItem item = new StorageIncomingItem();
       Product product = (Product)this.entityService.get(Product.class, this.productIDs[i]);
       Schedule schedule = (Schedule)this.entityService.get(Schedule.class, this.scheduleIDs[i]);
       StorageLocation storageLocation = null;

       if (this.storageLocationIDs[i].trim().isEmpty())
         storageLocation = (StorageLocation)this.entityService.get(StorageLocation.class, "66B79F13-6918-4A95-B424-DC0ACCE3E497");
       else {
         storageLocation = (StorageLocation)this.entityService.get(StorageLocation.class, this.storageLocationIDs[i]);
       }

       item.setSicItemNo(this.itemNos[i]);
       item.setProduct(product);
       item.setAmount(this.amounts[i]);
       item.setJobCmdNo(this.jobCmdNos[i]);
       item.setStorageLocation(storageLocation);
       item.setSchedule(schedule);
       item.setCreator(user.getEmployee());
       item.setCreateTime(new Date());
       item.setProductionDate(this.productionDates[i]);
       iTotalAmount += this.amounts[i];

       item.setSic(storageIncoming);
       storageIncomingItem.add(item);
     }
     storageIncoming.setTotalAmount(iTotalAmount);
     return storageIncomingItem;
   }

   protected void fillEntity(Entity entity) throws ParseException
   {
     StorageIncoming storageIncoming = (StorageIncoming)entity;

     Set items = getStorageIncomingItems(storageIncoming);
     if (storageIncoming.getItems() == null) {
       storageIncoming.setItems(items);
     } else {
       storageIncoming.getItems().clear();
       storageIncoming.getItems().addAll(items);
     }
   }

   public String add()
   {
     User user = getUserFromSession();
     StorageIncoming storageIncoming = new StorageIncoming();
     try {
       check();
       fillEntity(storageIncoming);
       storageIncoming.setCreator(user.getEmployee());
       storageIncoming.setCreateTime(new Date());
       storageIncoming.setSicDate(new Date());
       this.storageIncomingService.add(storageIncoming);
       simpleResult(true);
     }
     catch (InvalidPageInformationException e) {
       result(false, e.getMessage());
     } catch (InvalidOperationException e) {
       result(false, e.getMessage());
     } catch (ParseException e) {
       result(false, e.getMessage());
     }
     return "success";
   }

   public String aduitByChecker()
   {
     User user = getUserFromSession();
     boolean isAduitSuccess = false;
     StorageIncoming storageIncoming = (StorageIncoming)this.entityService.get(StorageIncoming.class, this.id);
     try {
       storageIncoming.setUpdater(user.getEmployee());
       storageIncoming.setUpdateTime(new Date());

       if (storageIncoming.getState() == StorageIncomingState.CheckerFailed.ordinal()) {
         throw new InvalidOperationException("该入库单已经检验失败，不能再次检验");
       }

       if (getAduit() == StorageIncomingState.ManagerAduit.ordinal()) {
         isAduitSuccess = true;
       }
       this.storageIncomingService.updateCheckerOrManager(storageIncoming, true, isAduitSuccess);
       simpleResult(true);
     }
     catch (InvalidOperationException e) {
       result(false, e.getMessage());
     }
     return "success";
   }

   public String aduitByManager()
   {
     User user = getUserFromSession();
     boolean isAduitSuccess = false;
     StorageIncoming storageIncoming = (StorageIncoming)this.entityService.get(StorageIncoming.class, this.id);
     try {
       storageIncoming.setUpdater(user.getEmployee());
       storageIncoming.setUpdateTime(new Date());

       if (storageIncoming.getState() == StorageIncomingState.ManagerFaild.ordinal()) {
         throw new InvalidOperationException("该入库单已经审核失败，不能再次审核");
       }

       if (getAduit() == StorageIncomingState.AduitSuccess.ordinal()) {
         isAduitSuccess = true;
       }
       this.storageIncomingService.updateCheckerOrManager(storageIncoming, false, isAduitSuccess);
       simpleResult(true);
     }
     catch (InvalidOperationException e) {
       result(false, e.getMessage());
     }
     return "success";
   }

   public String bySchedule()
   {
     User user = getUserFromSession();
     StorageIncoming storageIncoming = new StorageIncoming();
     storageIncoming.setCreator(user.getEmployee());
     try
     {
       check();
       fillEntity(storageIncoming);
       storageIncoming.setCreator(user.getEmployee());
       storageIncoming.setCreateTime(new Date());
       storageIncoming.setSicDate(new Date());
       this.storageIncomingService.addBySchedule(storageIncoming);
       simpleResult(true);
     }
     catch (InvalidPageInformationException e) {
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
     return super.remove();
   }

   public String update()
   {
     return super.update();
   }

   protected Class<StorageIncoming> getEntityClass()
   {
     return StorageIncoming.class;
   }

   protected Class<?> getEntityStateClass()
   {
     return StorageIncomingState.class;
   }

   public String get()
   {
     this.digDepth = 4;
     return super.get();
   }
 }
