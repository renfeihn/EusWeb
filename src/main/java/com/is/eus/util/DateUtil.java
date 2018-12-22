package com.is.eus.util;

import org.apache.commons.lang.StringUtils;

import java.math.BigDecimal;
import java.util.Calendar;
import java.util.Date;


/**
 * 日期工具类(线程安全)
 *
 * @author renfei
 */
public final class DateUtil {

	public static final String PATTERN_ISO_DATE = "yyyy-MM-dd";
	public static final String PATTERN_ISO_TIME = "HH:mm:ss";
	public static final String PATTERN_ISO_DATETIME = "yyyy-MM-dd HH:mm:ss";
	public static final String PATTERN_ISO_FULL = "yyyy-MM-dd HH:mm:ss.SSS";
	public static final String PATTERN_SIMPLE_DATE = "yyyyMMdd";
	public static final String PATTERN_SIMPLE_TIME = "HHmmss";
	public static final String PATTERN_SIMPLE_DATETIME = "yyyyMMddHHmmss";
	public static final String PATTERN_SIMPLE_FULL = "yyyyMMddHHmmssSSS";
	protected static final String[] PATTERNS = { PATTERN_ISO_DATE, PATTERN_ISO_TIME, PATTERN_ISO_DATETIME,
			PATTERN_ISO_FULL, PATTERN_SIMPLE_DATE, PATTERN_SIMPLE_TIME, PATTERN_SIMPLE_DATETIME, PATTERN_SIMPLE_FULL };

	private DateUtil(){}


	/**
	 * 字符串转日期
	 *
	 * @param strDate
	 *            日期字符串
	 * @return Date 解析后的日期类型 @
	 */
	public static Date parseDate(String strDate) {
		if (StringUtils.isEmpty(strDate)) {
			return null;
		}
		return DateUtils.parse(strDate, PATTERN_SIMPLE_DATE);
	}

	/**
	 * string格式的日期yyyy-xx-dd hh:mm:ss
	 * @param strDate
	 * @return
	 */
	public static Date converDate(String strDate) {
		String startDate = strDate;
		if (StringUtils.isEmpty(startDate)) {
			return null;
		}
		startDate = startDate.replace("-","").substring(0,8);

		return DateUtils.parse(startDate, PATTERN_SIMPLE_DATE);
	}


	/**
	 * 日期转字符串
	 *
	 * @param date
	 *            日期类型
	 * @param pattern
	 *            格式字符串
	 * @return String 格式化后的字符串
	 */
	public static String formatDate(Date date, String pattern) {
		if (date == null) {
			return null;
		}
		String pat = pattern;
		if (StringUtils.isEmpty(pat)) {
			pat = PATTERN_ISO_DATE;
		}
		return DateUtils.getDateTime(date, pat);
	}

	/**
	 * 计算日期加上天数后得到的日期
	 *
	 * @param date
	 * @param i
	 * @return @
	 */
	public static Date addDate(Date date, int i) {
		return DateUtils.addDays(date, i);
	}

	/**
	 * 日期转字符串
	 *
	 * @param calendar
	 *            日历类型
	 * @param pattern
	 *            格式字符串
	 * @return String 格式化后的字符串
	 */
	public static String formatDate(Calendar calendar, String pattern) {
		String pat = pattern;
		if (StringUtils.isEmpty(pat)) {
			pat = PATTERN_ISO_DATE;
		}
		return DateUtils.getDateTime(calendar.getTime(), pat);
	}

	/**
	 * 获取日期的年份
	 *
	 * @param date
	 * @return int
	 */
	public static int getYear(Date date) {
		return DateUtils.getYear(date);
	}

	/**
	 * 获取日期的月份
	 *
	 * @param date
	 * @return int
	 */
	public static int getMonth(Date date) {
		return DateUtils.getMonth(date);
	}

	/**
	 * 获取日期的日
	 *
	 * @param date
	 * @return int
	 */
	public static int getDay(Date date) {
		return DateUtils.getDay(date);
	}

	/**
	 * @param date
	 * @return
	 */
	public static Date getMonthLastDay(Date date) {
		return DateUtils.getMonthLastDay(date);
	}

	/**
	 *  @description 给指定的日期增加addNo个月
	 * @param date
	 * @param addNo
	 * @return
	 */
	public static Date addMonths(Date date, int addNo) {
		return DateUtils.addMonths(date, addNo);
	}
	/**
	 * 计算日期间隔天数
	 *
	 * @param startDate
	 * @param endDate
	 * @return BigDecimal
	 */
	public static BigDecimal getDiffDays(Date startDate, Date endDate) {
		long time = endDate.getTime() - startDate.getTime();
		return new BigDecimal(time / 1000 / 60 / 60 / 24);
	}

}