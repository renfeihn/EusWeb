




package com.is.eus.model.event;

import com.is.eus.model.event.Event;
import com.is.eus.model.event.EventNotFoundException;
import com.is.eus.model.event.Listener;
import com.is.eus.model.event.Observable;
import com.is.eus.service.exception.InvalidOperationException;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

public class ObservableBase implements Observable {
    Set<String> events = Collections.synchronizedSet(new HashSet());
    Map<String, Set<Listener>> listeners = Collections.synchronizedMap(new HashMap());

    public ObservableBase() {
    }

    public final boolean addEvent(String name) {
        return this.events.add(name);
    }

    public final boolean addListener(String name, Listener listener) {
        boolean ret = false;
        Map var4 = this.listeners;
        synchronized(this.listeners) {
            Set ls;
            if(this.listeners.containsKey(name)) {
                ls = (Set)this.listeners.get(name);
                synchronized(ls) {
                    ret = ls.add(listener);
                }
            } else {
                ls = Collections.synchronizedSet(new HashSet());
                synchronized(ls) {
                    ret = ls.add(listener);
                }

                this.listeners.put(name, ls);
            }

            return ret;
        }
    }

    protected void fireEvent(Event event) throws EventNotFoundException, InvalidOperationException {
        String name = event.getName();
        if(!this.events.contains(name)) {
            throw new EventNotFoundException("Event:" + name + " Not defined.");
        } else {
            if(this.listeners.containsKey(name)) {
                Iterator var4 = ((Set)this.listeners.get(name)).iterator();

                while(var4.hasNext()) {
                    Listener listener = (Listener)var4.next();
                    listener.notice(event);
                }
            }

        }
    }

    protected final void addListeners(Map<String, Set<Listener>> map) {
        Iterator var3 = map.keySet().iterator();

        while(var3.hasNext()) {
            String events = (String)var3.next();
            String[] var7;
            int var6 = (var7 = events.split(",")).length;

            for(int var5 = 0; var5 < var6; ++var5) {
                String event = var7[var5];
                Set set;
                if(this.listeners.containsKey(event)) {
                    set = (Set)this.listeners.get(event);
                    synchronized(set) {
                        Iterator var11 = ((Set)map.get(events)).iterator();

                        while(var11.hasNext()) {
                            Listener l = (Listener)var11.next();
                            set.add(l);
                        }
                    }
                } else {
                    set = Collections.synchronizedSet((Set)map.get(events));
                    Map var9 = this.listeners;
                    synchronized(this.listeners) {
                        this.listeners.put(event, set);
                    }
                }
            }
        }

    }
}
