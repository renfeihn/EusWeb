 package com.is.eus.dao.support.hibernate;

 import java.util.ArrayList;
 import java.util.HashSet;
 import java.util.List;
 import java.util.Map;
 import java.util.Set;
 import org.apache.commons.lang.StringUtils;
 import org.apache.log4j.Logger;
 import org.hibernate.criterion.Criterion;
 import org.hibernate.criterion.DetachedCriteria;
 import org.hibernate.criterion.LogicalExpression;
 import org.hibernate.criterion.Restrictions;
 import org.hibernate.criterion.SimpleExpression;

 public class HibernateUtils
 {
   private static final Logger logger = Logger.getLogger(HibernateUtils.class);

   public static <T> DetachedCriteria createCriteriaForSearch(Class<T> cls, Map<String, String> searchFields, String text)
   {
     DetachedCriteria criteria = DetachedCriteria.forClass(cls);

     List exps = new ArrayList();
     for (String name : searchFields.keySet()) {
       SimpleExpression expression = null;
       String value = (String)searchFields.get(name);
       if (StringUtils.isEmpty(value)) {
         expression = Restrictions.like(name, "%" + text + "%");
       } else {
         String alias = name.substring(name.indexOf(".") + 1);
         criteria.createAlias(name, alias);
         expression = Restrictions.like((String)searchFields.get(name), "%" + text + "%");
       }
       exps.add(expression);
     }

     if (exps.size() == 1)
     {
       criteria.add((Criterion)exps.get(0));
     }
     else {
       LogicalExpression lexp = null;
       lexp = Restrictions.or((Criterion)exps.get(0), (Criterion)exps.get(1));
       for (int i = 2; i < exps.size(); i++) {
         lexp = Restrictions.or(lexp, (Criterion)exps.get(i));
       }
       criteria.add(lexp);
     }

     return criteria;
   }

   public static <T> DetachedCriteria createCriteriaForSearch(Class<T> cls, List<String> searchFields, String text)
   {
     DetachedCriteria criteria = DetachedCriteria.forClass(cls);

     Set aliases = new HashSet();

     List exps = new ArrayList();
     for (String name : searchFields) {
       SimpleExpression expression = null;
       if (name.contains(".")) {
         String path = name.substring(0, name.lastIndexOf("."));
         String alias = path.contains(".") ? path.substring(path.lastIndexOf(".") + 1) : path;
         String search = name.substring(name.indexOf(alias));

         logger.info(" path:" + path + ", alias:" + alias + ", search:" + search);

         if (!aliases.contains(alias)) {
           criteria.createAlias(path, alias);
           aliases.add(alias);
         }
         expression = Restrictions.like(search, "%" + text + "%");
       } else {
         expression = Restrictions.like(name, "%" + text + "%");
       }
       exps.add(expression);
     }

     if (exps.size() == 1)
     {
       criteria.add((Criterion)exps.get(0));
     }
     else {
       LogicalExpression lexp = null;
       lexp = Restrictions.or((Criterion)exps.get(0), (Criterion)exps.get(1));
       for (int i = 2; i < exps.size(); i++) {
         lexp = Restrictions.or(lexp, (Criterion)exps.get(i));
       }
       criteria.add(lexp);
     }

     return criteria;
   }
 }


