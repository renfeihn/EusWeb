 package com.is.eus.web.action.system;

 import com.is.eus.pojo.Entity;
 import com.is.eus.pojo.dac.User;
 import com.is.eus.pojo.system.Corporation;
 import com.is.eus.pojo.system.Department;
 import com.is.eus.pojo.system.Employee;
 import com.is.eus.pojo.system.Position;
 import com.is.eus.pojo.system.Sequence;
 import com.is.eus.service.EntityService;
 import com.is.eus.service.SequenceService;
 import com.is.eus.util.JsonHelper;
 import com.is.eus.web.action.AbstractSessionAwareAction;
 import java.util.ArrayList;
 import java.util.Collection;
 import java.util.List;

 public class PreferenceAction extends AbstractSessionAwareAction
 {
   private static final long serialVersionUID = 6356917319609698807L;
   private EntityService entityService;
   private SequenceService sequenceService;
   private String[] ids;
   private String[] sequenceHead;
   private String[] sequencePrefix;
   private String[] sequenceMiddle;
   private String[] sequencePostfix;
   private String[] sequenceTail;

   public void setSequenceService(SequenceService service)
   {
     this.sequenceService = service;
   }
   public void setEntityService(EntityService service) {
     this.entityService = service;
   }

   public void setIds(String[] ids)
   {
     this.ids = ids;
   }

   public void setSequenceHead(String[] sequenceHead) {
     this.sequenceHead = sequenceHead;
   }

   public void setSequencePrefix(String[] sequencePrefix) {
     this.sequencePrefix = sequencePrefix;
   }

   public void setSequenceMiddle(String[] sequenceMiddle) {
     this.sequenceMiddle = sequenceMiddle;
   }

   public void setSequencePostfix(String[] sequencePostfix) {
     this.sequencePostfix = sequencePostfix;
   }

   public void setSequenceTail(String[] sequenceTail) {
     this.sequenceTail = sequenceTail;
   }

   public String sequence() {
     Collection list = this.sequenceService.list();
     this.resultJson = JsonHelper.fromCollection(list, Sequence.class, list.size());
     return "success";
   }

   public String getCorporation() {
     try {
       Corporation corp = getUserFromSession().getEmployee().getPosition().getDepartment().getCorporation();

       this.resultJson = JsonHelper.fromObject(corp);
     } catch (Exception e) {
       this.resultJson = "{success:true, Corporation: {}}";
     }
     return "success";
   }

   public String applySequence() {
     List seqs = new ArrayList();
     for (int i = 0; i < this.ids.length; i++) {
       Sequence seq = (Sequence)this.entityService.get(Sequence.class, this.ids[i]);
       if (seq != null) {
         seq.setHead(this.sequenceHead[i]);
         seq.setPrefix(this.sequencePrefix[i]);
         seq.setMiddle(this.sequenceMiddle[i]);
         seq.setPostfix(this.sequencePostfix[i]);
         seq.setTail(this.sequenceTail[i]);
         seqs.add(seq);
       }
     }
     this.entityService.update((Entity[])seqs.toArray(new Sequence[0]));
     this.sequenceService.load();
     simpleResult(true);
     return "success";
   }
 }

