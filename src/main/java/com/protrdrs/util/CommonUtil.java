package com.protrdrs.util;

import java.text.DecimalFormat;

public class CommonUtil {
	private static final DecimalFormat decimalFormat = new DecimalFormat("#,###,###,###.00");
	public static String formatNumber(Double objvalue){
		if (objvalue == null || objvalue.equals(0.0)) return "0.00";
		String formattedNumber = decimalFormat.format(objvalue);
		return formattedNumber;
	}
}
