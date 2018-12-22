package com.is.eus.util;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.BeansException;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URLDecoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 业务工具类
 *
 * @author Chengliang
 */
public class BusiUtil {

    private static final String AFTER_OPER = "|ALL$'";
    private static final String BEFORE_OPER = "'^";


    public static boolean isEquals(Long s, Long t) {
        return s.equals(t);
    }

    public static boolean isEquals(String s, String t) {
        return s.equals(t);
    }

    public static boolean isNotEquals(String s, String t) {
        return !isEquals(s, t);
    }

    /**
     * 字符类型比较是否等于Y
     *
     * @param s
     * @return
     */
    public static boolean isEqualY(String s) {
        return isEquals("Y", s);
    }


    /**
     * 转换为BigDecimal类型
     *
     * @param obj
     * @return BigDecimal
     * @author xucxd
     * @update 2016年2月24日 下午16:50:50
     */
    public static BigDecimal toBigDecimal(Object obj) {
        if (obj == null) {
            return null;
        } else if (obj instanceof String) {
            String str = (String) obj;
            if ("".equals(str)) {
                return null;
            } else {
                return new BigDecimal(str);
            }
        }
        return new BigDecimal(String.valueOf(obj));
    }


    /**
     * 判断对象是否为Null，数组size = 0,字符串 length = 0
     *
     * @param obj Object
     * @return boolean
     */
    private static boolean isNullObj(Object obj) {
        if (obj == null) {
            return true;
        }
        if (String.class.isInstance(obj)) {
            return StringUtils.isEmpty((String) obj);
        } else if (List.class.isInstance(obj)) {
            return ((List) obj).isEmpty();
        } else if (Map.class.isInstance(obj)) {
            return ((Map) obj).size() == 0;
        } else {
            return obj == null;
        }
    }

    /**
     * 对象是否为空
     *
     * @param obj Object
     * @return boolean
     */
    public static boolean isNull(Object obj) {
        return isNullObj(obj);
    }


    /**
     * 判断第一个参数是否在后面参数存在
     *
     * @param source
     * @param obj
     * @return
     */
    public static boolean isIn(Object source, Object... obj) {
        boolean result = false;
        if (isNotNull(source) && obj.length > 0) {
            for (int i = 0; i < obj.length; i++) {
                if (source.toString().equals(obj[i])) {
                    result = true;
                    break;
                }
            }
        }
        return result;
    }


    /**
     * 对象是否不为空
     *
     * @param obj Object
     * @return boolean
     */
    public static boolean isNotNull(Object obj) {
        return !isNull(obj);
    }


    /**
     * 对象是否全部为null
     *
     * @param objs
     * @return
     */
    public static boolean isNullAll(Object... objs) {

        for (int i = 0; i < objs.length; i++) {
            if (isNotNull(objs[i])) {
                return false;
            }
        }
        return true;
    }

    /**
     * 对象是否全部不为null
     *
     * @param objs
     * @return
     */
    public static boolean isNotNullAll(Object... objs) {

        for (int i = 0; i < objs.length; i++) {
            if (isNull(objs[i])) {
                return false;
            }
        }
        return true;
    }


    /**
     * 对象为空（包括list size=0, string length=0），返回dest
     *
     * @param source
     * @param dest
     * @return
     */
    public static <T> T nvl(T source, T dest) {
        return isNullObj(source) ? dest : source;
    }


    /**
     * 对象为空（包括list size=0, string length=0），返回dest
     *
     * @param source
     * @param dest
     * @return
     */
    public static String nvlToString(Object source, Object dest) {
        return isNullObj(source) ? dest.toString() : source.toString();
    }


    public static String decode(String s) {
        try {
            return URLDecoder.decode(s, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return "";
    }


    /**
     * 获取有效状态
     *
     * @param value
     * @return
     */
    public static String getStatus(Integer value) {
        switch (value) {
            case 0:
                return "有效";
            case 1:
                return "禁用";
            case 2:
                return "作废";
            default:
                return "未知";
        }
    }

    /**
     * 获取有效状态
     *
     * @param value
     * @return
     */
    public static String getState(Integer value) {
        switch (value) {
            case 0:
                return "已保存";
            case 1:
                return "待审核";
            case 2:
                return "审核失败";
            case 3:
                return "未完成";
            case 4:
                return "部分完成";
            case 5:
                return "全部完成";
            case 6:
                return "终止";
            default:
                return "未知";
        }
    }

    /**
     * 获取类型
     *
     * @param value
     * @return
     */
    public static String getScheduleType(Integer value) {
        switch (value) {
            case 0:
                return "预投";
            case 1:
                return "合同";
            default:
                return "未知";
        }
    }

    /**
     * 日期格式化
     *
     * @param date
     * @return
     */
    public static String dateFormat(Date date) {
        SimpleDateFormat sdf = new SimpleDateFormat(DateUtils.DEFAULT_DATE_FORMAT);
        return sdf.format(date);
    }

    /**
     * 获取日期
     *
     * @param dateStr
     * @return
     */
    public static Date getDate(String dateStr) {
        SimpleDateFormat sdf = new SimpleDateFormat(DateUtils.DEFAULT_DATE_FORMAT);
        Date date = null;
        try {
            date = sdf.parse(dateStr);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return date;
    }


    /**
     * 日期计算
     *
     * @param date 日期
     * @param num  增加数值
     * @param freq 周期类型
     * @return
     */
    private static Date addDate(Date date, int num, int freq) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(freq, num);
        return calendar.getTime();
    }


    /**
     * @param map
     * @param <K>
     * @param <V>
     * @return
     */
    public static <K, V> V getFirstOrNull(Map<K, V> map) {
        V obj = null;
        for (Map.Entry<K, V> entry : map.entrySet()) {
            obj = entry.getValue();
            if (BusiUtil.isNotNull(obj)) {
                break;
            }
        }
        return obj;
    }


    /**
     * 多字符拼接
     *
     * @param str
     * @return
     */
    public static String appendString(String... str) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < str.length; i++) {
            if (isNotNull(str[i])) {
                sb.append(str[i]);
            }
        }
        return sb.toString();
    }

    public static int diffYears(Date one, Date two) {
        Calendar calendar = DateUtils.getCalendar();
        calendar.setTime(one);
        int yearOne = calendar.get(1);
        calendar.setTime(two);
        int yearTwo = calendar.get(1);
        return yearOne - yearTwo;
    }


    public static boolean isGreaterZero(BigDecimal v) {

        if (isNull(v)) {
            return false;
        }

        return v.compareTo(BigDecimal.ZERO) > 0;
    }


    /**
     * 核算
     *
     * @param tableName
     * @param pkName
     * @param models
     * @return
     */
    public static boolean checkDataOperateParams(String tableName, String pkName, List<Map<String, Object>> models) {
        return !(BusiUtil.isNull(tableName) || BusiUtil.isNull(pkName) || models == null);
    }

    /**
     * 核算
     *
     * @param input
     * @return
     */
    public static String getOperString(String input) {
        return new StringBuffer().append(BEFORE_OPER).append(input).append(AFTER_OPER).toString();
    }
}