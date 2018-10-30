




package com.is.eus.service.support;

import com.is.eus.pojo.system.Preference;
import com.is.eus.service.PreferenceService;
import com.is.eus.service.SearchService;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class PreferenceServiceImpl implements PreferenceService {
    private SearchService searchService;
    private Map<String, Preference> preferences = new HashMap();

    public PreferenceServiceImpl() {
    }

    public void setSearchService(SearchService searchService) {
        this.searchService = searchService;
    }

    public Preference get(String key) {
        return (Preference)this.preferences.get(key);
    }

    public void init() {
        List prfs = this.searchService.search("com.is.eus.pojo.system.Preference.list").get();
        Iterator var3 = prfs.iterator();

        while(var3.hasNext()) {
            Preference p = (Preference)var3.next();
            this.preferences.put(p.getCode(), p);
        }

    }

    public void reload() {
        this.preferences.clear();
        List prfs = this.searchService.search("com.is.eus.pojo.system.Preference.list").get();
        Iterator var3 = prfs.iterator();

        while(var3.hasNext()) {
            Preference p = (Preference)var3.next();
            this.preferences.put(p.getId(), p);
        }

    }
}
