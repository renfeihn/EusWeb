




package com.is.eus.dao.support.hibernate;

import com.is.eus.dao.InitializeException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Collection;
import java.util.Iterator;
import org.apache.log4j.Logger;
import org.hibernate.Hibernate;

class LazyInitializeUtil {
    private static final Logger logger = Logger.getLogger(LazyInitializeUtil.class);

    LazyInitializeUtil() {
    }

    private static boolean needInitialization(Class<?> cls) {
        return cls.getName().startsWith("com.is.eus.pojo") || Collection.class.isAssignableFrom(cls);
    }

    private static Object doInitialize(Object object, int limit, int depth) throws IllegalArgumentException, IllegalAccessException, InvocationTargetException {
        if(object != null && depth < limit) {
            logger.info("initializing object of:" + object.getClass().getName());
            Method[] methods = object.getClass().getMethods();
            Method[] var7 = methods;
            int var6 = methods.length;

            for(int var5 = 0; var5 < var6; ++var5) {
                Method method = var7[var5];
                if(method.getName().startsWith("get") && method.getTypeParameters().length == 0) {
                    Class ret = method.getReturnType();
                    if(needInitialization(ret)) {
                        Object property = method.invoke(object, new Object[0]);
                        if(!Hibernate.isInitialized(property)) {
                            if(Collection.class.isAssignableFrom(ret)) {
                                Collection collection = (Collection)property;
                                Hibernate.initialize(collection);
                                if(!collection.isEmpty()) {
                                    Iterator var12 = collection.iterator();

                                    while(var12.hasNext()) {
                                        Object obj = var12.next();
                                        doInitialize(obj, limit, depth + 1);
                                    }
                                }
                            } else {
                                doInitialize(property, limit, depth + 1);
                            }
                        }
                    }
                }
            }

            return object;
        } else {
            return null;
        }
    }

    public static Object initialize(Object obj, int depth) throws InitializeException {
        try {
            return doInitialize(obj, 10, 0);
        } catch (Exception var3) {
            var3.printStackTrace();
            throw new InitializeException("Initialize Exception.", var3);
        }
    }
}
