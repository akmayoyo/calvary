package com.calvary.common.util;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.calvary.common.constant.CalvaryConstants;

public class CommonUtil {

	/** 
	 * 페이징 쿼리 결과에서 전체 건수를 반환 
	 */
	@SuppressWarnings("unchecked")
	public static long getPaingTotalCount(List<Object> list, String totalColName) {
		long totalCount = 0;
		if(list != null && list.size() > 0) {
			Map<String, Object> tmp = (HashMap<String, Object>)list.get(0);
			totalCount = (long)tmp.get(totalColName);
		}
		return totalCount;
	}
	
	/** 
	 * 금액을 한글로 변환 
	 */
	public static String convertPriceToHangul(int price) {
		String[] han1 = {"","일","이","삼","사","오","육","칠","팔","구"}; 
		String[] han2 = {"","십","백","천"}; 
		String[] han3 = {"","만","억","조","경"}; 
		StringBuffer result = new StringBuffer(); 
		String money = String.valueOf(price);
		int len = money.length(); 
		for(int i=len-1; i>=0; i--) { 
			result.append(han1[Integer.parseInt(money.substring(len-i-1, len-i))]); 
			if(Integer.parseInt(money.substring(len-i-1, len-i)) > 0) {
				result.append(han2[i%4]); 
			}
			if(i%4 == 0) {
				result.append(han3[i/4]);
			}
		} 
		return result.toString();
	}
	
	/** 
	 * 세자리 콤마 적용된 문자열 반환 
	 */
	public static String getThousandSeperatorFormatString(int value) {
		String sRtn = String.format("%,d", value);
		return sRtn;
	}
	
	/** 
	 * 총분양대금에 해당하는 계약금 반환 
	 */
	public static int getDownPayment(int totalPrice) {
		int iRtn = 0;
		iRtn = (int)Math.floor(totalPrice * (CalvaryConstants.DOWN_PAYMENT_PERCENT/100));
		return iRtn;
	}
	
	
}
