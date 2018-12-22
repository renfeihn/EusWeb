package com.is.eus.util;

import com.opensymphony.xwork2.util.logging.Logger;
import com.opensymphony.xwork2.util.logging.LoggerFactory;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by renfei on 2018/12/20.
 */

public class DateUtils {
    private static final Logger logger = LoggerFactory.getLogger(DateUtils.class);
    public static final String PATTERN_ISO_DATE = "yyyy-MM-dd";
    public static final String PATTERN_ISO_TIME = "HH:mm:ss";
    public static final String PATTERN_ISO_DATETIME = "yyyy-MM-dd HH:mm:ss";
    public static final String PATTERN_ISO_FULL = "yyyy-MM-dd HH:mm:ss.SSS";
    public static final String PATTERN_DEFAULT_DATE = "yyyyMMdd";
    public static final String PATTERN_DEFAULT_TIME = "HH:mm:ss";
    public static final String PATTERN_DEFAULT_DATETIME = "yyyyMMdd HH:mm:ss";
    public static final String PATTERN_DEFAULT_FULL = "yyyyMMdd HH:mm:ss.SSS";
    public static final String PATTERN_SIMPLE_DATE = "yyyyMMdd";
    public static final String PATTERN_SIMPLE_TIME = "HHmmss";
    public static final String PATTERN_SIMPLE_DATETIME = "yyyyMMddHHmmss";
    public static final String PATTERN_SIMPLE_FULL = "yyyyMMddHHmmssSSS";
    public static final String DEFAULT_DATE_FORMAT = "yyyyMMdd";
    public static final String DEFAULT_DATETIME_FORMAT = "yyyyMMdd HH:mm:ss";
    private static final int MILLIS = 1000;
    private static final int MONTH_PER_YEAR = 12;
    private static ThreadLocal<Map<String, DateFormat>> localFormat = new ThreadLocal() {
        protected Map<String, DateFormat> initialValue() {
            HashMap formatMap = new HashMap();
            formatMap.put("yyyy-MM-dd", new SimpleDateFormat("yyyy-MM-dd"));
            formatMap.put("HH:mm:ss", new SimpleDateFormat("HH:mm:ss"));
            formatMap.put("yyyy-MM-dd HH:mm:ss", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"));
            formatMap.put("yyyy-MM-dd HH:mm:ss.SSS", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS"));
            formatMap.put("yyyyMMdd", new SimpleDateFormat("yyyyMMdd"));
            formatMap.put("yyyyMMdd HH:mm:ss", new SimpleDateFormat("yyyyMMdd HH:mm:ss"));
            formatMap.put("yyyyMMdd HH:mm:ss.SSS", new SimpleDateFormat("yyyyMMdd HH:mm:ss.SSS"));
            formatMap.put("yyyy-MM-dd HH:mm:ss.SSS", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS"));
            formatMap.put("yyyyMMdd", new SimpleDateFormat("yyyyMMdd"));
            formatMap.put("HHmmss", new SimpleDateFormat("HHmmss"));
            formatMap.put("yyyyMMddHHmmss", new SimpleDateFormat("yyyyMMddHHmmss"));
            formatMap.put("yyyyMMddHHmmssSSS", new SimpleDateFormat("yyyyMMddHHmmssSSS"));
            return formatMap;
        }
    };
    private static ThreadLocal<Calendar> calendar = new ThreadLocal() {
        protected Calendar initialValue() {
            return Calendar.getInstance();
        }
    };

    private DateUtils() {
    }

    public static Date getNow() {
        return new Date();
    }

    public static String getDate() {
        return getDateTime("yyyyMMdd");
    }

    public static String getDateTime() {
        return getDateTime("yyyyMMdd HH:mm:ss");
    }

    public static String getDateTime(String pattern) {
        return getDateTime(new Date(), pattern);
    }

    public static DateFormat getDateFormat(String pattern) {
        if(((Map)localFormat.get()).containsKey(pattern)) {
            return (DateFormat)((Map)localFormat.get()).get(pattern);
        } else {
            SimpleDateFormat dateFormat = new SimpleDateFormat(pattern);
            ((Map)localFormat.get()).put(pattern, dateFormat);
            return dateFormat;
        }
    }

    public static Calendar getCalendar() {
        Calendar calendar = (Calendar)DateUtils.calendar.get();
        calendar.setTimeInMillis(System.currentTimeMillis());
        return calendar;
    }

    public static Calendar getCalendar(long date) {
        Calendar calendar = (Calendar)DateUtils.calendar.get();
        calendar.setTimeInMillis(date);
        return calendar;
    }

    public static Calendar getCalendar(Date date) {
        Calendar calendar = (Calendar)DateUtils.calendar.get();
        calendar.setTimeInMillis(date.getTime());
        return calendar;
    }

    public static String getDateTime(Date date, String pattern) {
        if(null == pattern || "".equals(pattern)) {
            pattern = "yyyyMMdd HH:mm:ss";
        }

        return getDateFormat(pattern).format(date);
    }

    public static int getCurrentYear() {
        return getCalendar().get(1);
    }

    public static int getCurrentMonth() {
        return getCalendar().get(2) + 1;
    }

    public static int getCurrentDay() {
        return Calendar.getInstance().get(5);
    }

    public static Date addDays(int days) {
        return add(getNow(), days, 5);
    }

    public static Date addDays(Date date, int days) {
        return add(date, days, 5);
    }

    public static Date addMonths(int months) {
        return add(getNow(), months, 2);
    }

    public static Date addMonths(Date date, int months) {
        return add(date, months, 2);
    }

    public static Date addYears(int years) {
        return add(getNow(), years, 1);
    }

    public static Date addYears(Date date, int years) {
        return add(date, years, 1);
    }

    private static Date add(Date date, int amount, int field) {
        Calendar calendar = getCalendar();
        calendar.setTime(date);
        calendar.add(field, amount);
        return calendar.getTime();
    }

    public static String getHourMin(Date date) {
        StringBuffer sf = new StringBuffer();
        sf.append(date.getHours());
        sf.append(":");
        sf.append(date.getMinutes());
        return sf.toString();
    }

    public static long diffDays(Date one, Date two) {
        Calendar calendar = getCalendar();
        calendar.clear();
        calendar.setTime(one);
        calendar.set(calendar.get(1), calendar.get(2), calendar.get(5), 0, 0, 0);
        Date d1 = calendar.getTime();
        calendar.clear();
        calendar.setTime(two);
        calendar.set(calendar.get(1), calendar.get(2), calendar.get(5), 0, 0, 0);
        Date d2 = calendar.getTime();
        int MILISECONDS = 86400000;
        BigDecimal r = new BigDecimal((new Double((double)(d1.getTime() - d2.getTime()))).doubleValue() / 8.64E7D);
        return Math.round(r.doubleValue());
    }

    public static int diffMonths(Date one, Date two) {
        Calendar calendar = getCalendar();
        calendar.setTime(one);
        int yearOne = calendar.get(1);
        int monthOne = calendar.get(2);
        calendar.setTime(two);
        int yearTwo = calendar.get(1);
        int monthTwo = calendar.get(2);
        return (yearOne - yearTwo) * 12 + (monthOne - monthTwo);
    }

    public static int getYear(Date d) {
        Calendar calendar = getCalendar();
        calendar.setTime(d);
        return calendar.get(1);
    }

    public static int getMonth(Date d) {
        Calendar calendar = getCalendar();
        calendar.setTime(d);
        return calendar.get(2) + 1;
    }

    public static int getDay(Date d) {
        Calendar calendar = getCalendar();
        calendar.setTime(d);
        return calendar.get(5);
    }

    public static Date parse(String datestr, String pattern) {
        Date date = null;
        if(null == pattern || "".equals(pattern)) {
            pattern = "yyyyMMdd";
        }

        try {
            date = getDateFormat(pattern).parse(datestr);
        } catch (ParseException var4) {
            if(logger.isWarnEnabled()) {
                logger.warn(var4.getMessage());
            }
        }

        return date;
    }

    public static Date getMonthFirstDay() {
        return getMonthFirstDay(getNow());
    }

    public static Date getMonthFirstDay(Date date) {
        Calendar calendar = getCalendar();
        calendar.setTime(date);
        calendar.set(calendar.get(1), calendar.get(2), 1);
        return calendar.getTime();
    }

    public static Date getMonthLastDay() {
        return getMonthLastDay(getNow());
    }

    public static Date getMonthLastDay(Date date) {
        Calendar calendar = getCalendar();
        calendar.setTime(date);
        calendar.set(calendar.get(1), calendar.get(2) + 1, 1);
        calendar.add(5, -1);
        return calendar.getTime();
    }

    public static long diffSeconds(Date date1, Date date2, boolean onlyTime) {
        if(onlyTime) {
            Calendar calendar = getCalendar();
            calendar.setTime(date1);
            long t1 = calendar.getTimeInMillis();
            calendar.setTime(date2);
            long t2 = calendar.getTimeInMillis();
            return (t1 - t2) / 1000L;
        } else {
            return (date1.getTime() - date2.getTime()) / 1000L;
        }
    }

    public static long diffSeconds(Date date1, Date date2) {
        return diffSeconds(date1, date2, false);
    }

    public static int getDayOfWeek(Date date) {
        Calendar cd = getCalendar();
        cd.setTime(date);
        int mydate = cd.get(7);
        return mydate;
    }

    public static boolean isValidDate(String validDate, String format) {
        Date valid = parse(validDate, format);
        Date now = new Date();
        String nowStr = getDateFormat(format).format(now);

        try {
            now = getDateFormat(format).parse(nowStr);
        } catch (ParseException var6) {
            if(logger.isWarnEnabled()) {
                logger.warn(var6.getMessage());
            }
        }

        return valid.after(now);
    }
}
