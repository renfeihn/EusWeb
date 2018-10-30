




package com.is.eus.util;

import java.lang.reflect.Method;
import java.util.Collection;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.hibernate.Hibernate;

public class JsonHelper {
    private static final Logger logger = Logger.getLogger(JsonHelper.class);
    public static final int DEFAULT_DIG_MAX_DEPTH = 2;

    public JsonHelper() {
    }

    private static String translate(String string) {
        return string.replace("\'", "\\\'").replace("\n", "\\n");
    }

    private static String buildField(String field) {
        return "\'" + translate(field) + "\'";
    }

    private static String buildStringValue(StringBuilder appendTo, String value) {
        String append;
        if(!StringUtils.isEmpty(value)) {
            append = value.trim();
        } else {
            append = "";
        }

        return "\'" + translate(append) + "\'";
    }

    private static Object tryInvoke(Method method, Object object) throws Exception {
        return Hibernate.isInitialized(object)?method.invoke(object, new Object[0]):null;
    }

    static StringBuilder jsonFromObject(Object object, Set<Integer> trace, boolean stopWatch, int depth) {
        int max = depth > 2?depth:2;
        if(stopWatch && trace.size() > max) {
            return new StringBuilder("{}");
        } else {
            int hash = object.hashCode();
            if(!trace.add(Integer.valueOf(hash))) {
                return new StringBuilder("{}");
            } else {
                Class cls = object.getClass();
                Method[] methods = cls.getMethods();
                StringBuilder builder = new StringBuilder();
                builder.append("{");
                Method[] var12 = methods;
                int var11 = methods.length;

                for(int var10 = 0; var10 < var11; ++var10) {
                    Method method = var12[var10];
                    if(method.getName().startsWith("get") && method.getTypeParameters().length == 0) {
                        String field = method.getName().substring(3);
                        field = field.substring(0, 1).toLowerCase() + field.substring(1);

                        try {
                            Class retClass = method.getReturnType();
                            if(retClass == String.class) {
                                String var19 = (String)tryInvoke(method, object);
                                builder.append(buildField(field)).append(":").append(buildStringValue(builder, var19)).append(",");
                            } else if(retClass == Date.class) {
                                Date var18 = (Date)tryInvoke(method, object);
                                builder.append(buildField(field)).append(":\'").append(var18).append("\',");
                            } else {
                                Object retObj;
                                if(retClass != Integer.TYPE && retClass != Double.TYPE && retClass != Float.TYPE && retClass != Long.TYPE && retClass != Short.TYPE && retClass != Byte.TYPE && retClass != Long.class) {
                                    if(retClass.getName().contains("com.is.eus")) {
                                        retObj = tryInvoke(method, object);
                                        if(retObj != null && Hibernate.isInitialized(retObj)) {
                                            builder.append(buildField(field)).append(":").append(jsonFromObject(retObj, trace, stopWatch, depth)).append(",");
                                        } else {
                                            builder.append(buildField(field)).append(":{},");
                                        }
                                    } else if(Collection.class.isAssignableFrom(retClass)) {
                                        retObj = tryInvoke(method, object);
                                        Collection collection = (Collection)retObj;
                                        if(collection != null && Hibernate.isInitialized(collection)) {
                                            builder.append(jsonFromCollection(field, collection, trace, stopWatch, depth)).append(",");
                                        } else {
                                            builder.append(buildField(field)).append(":{},");
                                        }
                                    } else {
                                        logger.isDebugEnabled();
                                    }
                                } else {
                                    retObj = tryInvoke(method, object);
                                    builder.append(buildField(field)).append(":\'").append(retObj).append("\',");
                                }
                            }
                        } catch (Exception var17) {
                            ;
                        }
                    }
                }

                trimComma(builder);
                builder.append("}");
                trace.remove(Integer.valueOf(hash));
                return builder;
            }
        }
    }

    private static StringBuilder jsonFromCollection(String name, Collection<?> collection, Set<Integer> trace, boolean stopDigWhenReachMaxDepth, int depth) {
        StringBuilder builder = new StringBuilder();
        builder.append(buildField(name)).append(":[");
        Iterator var7 = collection.iterator();

        while(var7.hasNext()) {
            Object object = var7.next();
            builder.append(jsonFromObject(object, trace, stopDigWhenReachMaxDepth, depth)).append(",");
        }

        trimComma(builder);
        builder.append("]");
        return builder;
    }

    private static StringBuilder jsonFromCollection(Collection<?> collection, Class<?> cls, Set<Integer> trace, boolean stopDigWhenReachMaxDepth, int depth) {
        StringBuilder builder = new StringBuilder();
        String name = collection.iterator().next().getClass().getSimpleName();
        if(name.contains("$")) {
            name = name.substring(0, name.indexOf("$"));
        }

        name = name + "List";
        builder.append(jsonFromCollection(cls == null?name:cls.getSimpleName() + "List", collection, trace, stopDigWhenReachMaxDepth, depth));
        trimComma(builder);
        return builder;
    }

    private static void trimComma(StringBuilder builder) {
        if(builder.charAt(builder.length() - 1) == 44) {
            builder.delete(builder.length() - 1, builder.length());
        }

    }

    public static String fromCollection(Collection<?> collection, Class<?> cls, long count) {
        return fromCollection(collection, cls, count, false, 0);
    }

    public static String fromCollection(Collection<?> collection, Class<?> cls, long count, int depth) {
        return fromCollection(collection, cls, count, false, depth);
    }

    private static String fromCollection(Collection<?> collection, Class<?> cls, long count, boolean digThrough, int depth) {
        if(collection != null && !collection.isEmpty()) {
            HashSet trace = new HashSet();
            StringBuilder builder = new StringBuilder();
            builder.append("{success:true, results:").append(count).append(",").append(jsonFromCollection((Collection)collection, (Class)cls, trace, !digThrough, depth)).append("}");
            return builder.toString();
        } else {
            return "{success:true, results:0, " + cls.getSimpleName() + "List:[]}";
        }
    }

    public static String fromObject(Object object) {
        return fromObject(object, 0);
    }

    public static String fromObject(Object object, int depth) {
        if(object == null) {
            return "{success:false}";
        } else {
            HashSet trace = new HashSet();
            StringBuilder builder = new StringBuilder();
            String name = object.getClass().getSimpleName();
            if(name.contains("$")) {
                name = name.substring(0, name.indexOf("$"));
            }

            builder.append("{success:true,").append(name).append(":").append(jsonFromObject(object, trace, depth > 0, depth)).append("}");
            return builder.toString();
        }
    }
}
