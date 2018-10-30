 package com.is.eus.service.biz.impl;

 import com.is.eus.pojo.storage.StorageIncoming;
 import com.is.eus.pojo.system.Sequence;
 import com.is.eus.service.EntityService;
 import com.is.eus.service.SequenceService;
 import com.is.eus.service.biz.ui.StorageIncomingService;
 import com.is.eus.service.exception.InvalidOperationException;
 import com.is.eus.service.support.ObservableServiceBase;
 import com.is.eus.type.DataStatus;
 import com.is.eus.type.StorageIncomingState;
 import java.util.Date;
 import org.apache.commons.lang.StringUtils;

 public class StorageIncomingServiceImpl extends ObservableServiceBase
   implements StorageIncomingService
 {
   public void add(StorageIncoming sic)
     throws InvalidOperationException
   {
     sic.setStatus(DataStatus.Using.ordinal());
     sic.setState(StorageIncomingState.CheckerAduit.ordinal());
     String SequenceNo = this.sequenceService.acquire("SIC", true, 0);
     if (StringUtils.isEmpty(SequenceNo)) {
       Sequence sequence = new Sequence();
       sequence.setType("SIC");
       sequence.setHead("");
       sequence.setPrefix("RK");
       sequence.setMiddle("1");
       sequence.setPostfix("");
       sequence.setTail("3");
       sequence.setSequence(1);
       this.entityService.add(sequence);
       SequenceNo = this.sequenceService.acquire("SIC", true, 0);
     }
     sic.setSicNo(SequenceNo);
     super.add(sic);

     fire("Schedule_FromStorageIncoming", sic);
   }

   public void remove(String id) throws InvalidOperationException
   {
     StorageIncoming storageIncoming = (StorageIncoming)super.get(StorageIncoming.class, id);
     super.remove(storageIncoming);
   }

   public void udpate(StorageIncoming sic) throws InvalidOperationException
   {
     if (sic.getStatus() != DataStatus.Using.ordinal()) {
       throw new InvalidOperationException("修改失败");
     }
     super.update(sic);
   }

   public void updateCheckerOrManager(StorageIncoming sic, boolean isCheckerOrManager, boolean isAduitSuccess)
     throws InvalidOperationException
   {
     if (isCheckerOrManager)
       checkerAduit(sic, isAduitSuccess);
     else
       managerAduit(sic, isAduitSuccess);
   }

   private void checkerAduit(StorageIncoming sic, boolean isAduitSuccess)
   {
     int state = sic.getState();
     if (state == StorageIncomingState.CheckerAduit.ordinal()) {
       sic.setSicChecker(sic.getUpdater());
       sic.setSicChecker_createTime(new Date());
       if (isAduitSuccess)
       {
         sic.setState(StorageIncomingState.ManagerAduit.ordinal());
       }
       else
         sic.setState(StorageIncomingState.CheckerFailed.ordinal());
     }
     else {
       throw new InvalidOperationException("入库单必须是待检验审核状态");
     }

     if (!isAduitSuccess) {
       sic.setStatus(DataStatus.Deleted.ordinal());
     }

     update(sic);

     if ((!isAduitSuccess) && (
       (state == StorageIncomingState.CheckerAduit.ordinal()) ||
       (state == StorageIncomingState.ManagerAduit.ordinal())))
       fire("Schedule_RollBack_FromStorageIncoming", sic);
   }

   private void managerAduit(StorageIncoming sic, boolean isAduitSuccess)
   {
     int state = sic.getState();
     if (state == StorageIncomingState.ManagerAduit.ordinal()) {
       sic.setSicManager(sic.getUpdater());
       sic.setSicManager_createTime(new Date());
       if (isAduitSuccess)
       {
         sic.setState(StorageIncomingState.AduitSuccess.ordinal());
       }
       else
         sic.setState(StorageIncomingState.ManagerFaild.ordinal());
     }
     else {
       throw new InvalidOperationException("入库单必须是待成品库检验状态");
     }

     update(sic);

     if (sic.getState() == StorageIncomingState.AduitSuccess.ordinal()) {
       fire("Storage_FromStorageIncoming", sic);
       fire("StorageItem_FromStorageIncoming", sic);
       fire("StorageResource_FromStorageIncoming", sic);
     }

     if ((!isAduitSuccess) && (
       (state == StorageIncomingState.CheckerAduit.ordinal()) ||
       (state == StorageIncomingState.ManagerAduit.ordinal())))
       fire("Schedule_RollBack_FromStorageIncoming", sic);
   }

   public void addBySchedule(StorageIncoming sic)
     throws InvalidOperationException
   {
     String SequenceNo = this.sequenceService.acquire("SIC", true, 0);
     if (StringUtils.isEmpty(SequenceNo)) {
       Sequence sequence = new Sequence();
       sequence.setType("SIC");
       sequence.setHead("");
       sequence.setPrefix("RK");
       sequence.setMiddle("1");
       sequence.setPostfix("");
       sequence.setTail("3");
       sequence.setSequence(1);
       this.entityService.add(sequence);
       SequenceNo = this.sequenceService.acquire("SIC", true, 0);
     }

     sic.setCreateTime(new Date());
     sic.setUpdater(sic.getCreator());
     sic.setUpdateTime(sic.getCreateTime());
     sic.setSicChecker(sic.getCreator());
     sic.setSicChecker_createTime(sic.getCreateTime());
     sic.setSicManager(sic.getCreator());
     sic.setSicManager_createTime(sic.getCreateTime());
     sic.setStatus(DataStatus.Using.ordinal());
     sic.setState(StorageIncomingState.AduitSuccess.ordinal());

     sic.setSicNo(SequenceNo);
     super.add(sic);

     fire("Schedule_FromStorageIncoming", sic);
     fire("Storage_FromStorageIncoming", sic);
     fire("StorageItem_FromStorageIncoming", sic);
     fire("StorageResource_FromStorageIncoming", sic);
   }
 }
