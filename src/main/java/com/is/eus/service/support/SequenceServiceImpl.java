




package com.is.eus.service.support;

import com.is.eus.pojo.system.Sequence;
import com.is.eus.service.EntityService;
import com.is.eus.service.SearchService;
import com.is.eus.service.SequenceService;
import com.is.eus.util.SequenceUtil;
import java.util.Calendar;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;

public class SequenceServiceImpl implements SequenceService {
    private static final Logger logger = Logger.getLogger(SequenceServiceImpl.class);
    private Map<String, Sequence> sequencers;
    private EntityService entityService;
    private SearchService searchService;

    public SequenceServiceImpl() {
    }

    public void setSearchService(SearchService service) {
        this.searchService = service;
    }

    public void setEntityService(EntityService service) {
        this.entityService = service;
    }

    public void init() {
        this.sequencers = Collections.synchronizedMap(new HashMap());
        this.load();
    }

    public void load() {
        if(!this.sequencers.isEmpty()) {
            this.sequencers.clear();
        }

        List seq = this.searchService.search("com.is.eus.pojo.system.Sequence.list").get();
        Iterator var3 = seq.iterator();

        while(var3.hasNext()) {
            Sequence s = (Sequence)var3.next();
            logger.info("loadding:" + s.getType() + " sequencer.");
            this.sequencers.put(s.getType(), s);
        }

    }

    public String acquire(String type) {
        this.load();
        Sequence sequence = (Sequence)this.sequencers.get(type);
        if(sequence == null) {
            return null;
        } else {
            Calendar calendar = Calendar.getInstance();
            Calendar last = Calendar.getInstance();
            Date lastUpdate = sequence.getLastUpdate();
            if(lastUpdate != null) {
                last.setTime(lastUpdate);
                if(calendar.get(6) == last.get(6) && calendar.get(2) == last.get(2) && calendar.get(1) == last.get(1)) {
                    sequence.setSequence(sequence.getSequence() + 1);
                } else {
                    sequence.setSequence(1);
                }
            } else {
                sequence.setSequence(1);
            }

            Map var6 = this.sequencers;
            synchronized(this.sequencers) {
                sequence.setLastUpdate(calendar.getTime());
                this.entityService.update(sequence);
                this.sequencers.put(sequence.getType(), sequence);
            }

            return SequenceUtil.create(sequence);
        }
    }

    public String acquire(String type, boolean isFrontHeader, int iType) {
        this.load();
        Sequence sequence = (Sequence)this.sequencers.get(type);
        if(sequence == null) {
            return null;
        } else {
            Calendar calendar = Calendar.getInstance();
            Calendar last = Calendar.getInstance();
            Date lastUpdate = sequence.getLastUpdate();
            if(lastUpdate != null) {
                last.setTime(lastUpdate);
                if(iType == 0) {
                    if(calendar.get(6) == last.get(6) && calendar.get(2) == last.get(2) && calendar.get(1) == last.get(1)) {
                        sequence.setSequence(sequence.getSequence() + 1);
                    } else {
                        sequence.setSequence(1);
                    }
                } else if(iType == 1) {
                    if(calendar.get(1) == last.get(1)) {
                        sequence.setSequence(sequence.getSequence() + 1);
                    } else {
                        sequence.setSequence(1);
                    }
                } else if(iType == 2) {
                    if(calendar.get(2) == last.get(2) && calendar.get(1) == last.get(1)) {
                        sequence.setSequence(sequence.getSequence() + 1);
                    } else {
                        sequence.setSequence(1);
                    }
                }
            } else {
                sequence.setSequence(1);
            }

            Map var8 = this.sequencers;
            synchronized(this.sequencers) {
                sequence.setLastUpdate(calendar.getTime());
                this.entityService.update(sequence);
                this.sequencers.put(sequence.getType(), sequence);
            }

            return !isFrontHeader?SequenceUtil.create(sequence):SequenceUtil.createFront(sequence);
        }
    }

    public Collection<Sequence> list() {
        return this.sequencers.values();
    }
}
