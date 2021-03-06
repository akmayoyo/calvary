package com.calvary.common.util;

import java.math.BigDecimal;
import java.math.BigInteger;

import org.springframework.util.StringUtils;

import com.calvary.admin.vo.BunyangInfoVo;
import com.calvary.common.constant.CalvaryConstants;

public class CommonUtil {

	/** 
	 * 금액을 한글로 변환 
	 */
	public static String convertPriceToHangul(int price) {
		if(price <= 0) {
			return "0";
		}
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
	
	/** 
	 * 생년월일을 YYYY-MM-DD 문자열로 변환 
	 */
	public static String getBirthDateFormatString(String birthDate) {
		String sRtn = birthDate;
		if(!StringUtils.isEmpty(sRtn)) {
			sRtn = sRtn.replaceAll("[^\\d]", "");
		}
		if(!StringUtils.isEmpty(sRtn) && sRtn.length() == 8) {
			String year = sRtn.substring(0, 4);
			String month = sRtn.substring(4, 6);
			String date = sRtn.substring(6, 8);
			sRtn = year + CalvaryConstants.DELIMITER_DATE + month + CalvaryConstants.DELIMITER_DATE + date;
		}
		return sRtn;
	}
	
	/** 
	 * 휴대폰번호를 xxx-xxxx-xxxx 문자열로 변환 
	 */
	public static String getMobileFormatString(String mobile) {
		String sRtn = mobile;
		if(!StringUtils.isEmpty(sRtn)) {
			sRtn = sRtn.replaceAll("[^\\d]", "");
		}
		if(!StringUtils.isEmpty(sRtn)) {
			if(sRtn.length() == 10) {
				sRtn = String.format("%s-%s-%s", sRtn.substring(0, 3), sRtn.substring(3, 6), sRtn.substring(6, 10));
			} else if(sRtn.length() == 11) {
				sRtn = String.format("%s-%s-%s", sRtn.substring(0, 3), sRtn.substring(3, 7), sRtn.substring(7, 11));
			}
		}
		return sRtn;
	}
	
	public static int convertToInt(Object val) {
		int iRtn = 0;
		try {
			if(val instanceof BigDecimal) {
				iRtn = ((BigDecimal)val).intValue();
			}else if(val instanceof Long) {
				iRtn = (int)(long)val;
			}else if(val instanceof Integer) {
				iRtn = (int)val;
			}else if(val instanceof BigInteger) {
				iRtn = ((BigInteger)val).intValue();
			}else if(val instanceof Double) {
				iRtn = ((Double)val).intValue();
			}else if(val instanceof String) {
				iRtn = Integer.parseInt((String)val);
			}
		} catch (Exception e) {
			
		}
		return iRtn;
	}
	
	public static String nullToEmpty(Object val) {
		String sRtn = "";
		if(val != null && val instanceof String) {
			sRtn = (String)val;
		}
		return sRtn;
	}
	
	public static String replaceNewLine(String val) {
		String sRtn = "";
		if(!StringUtils.isEmpty(val)) {
			sRtn = val.replaceAll("(\r\n|\r|\n|\n\r)", "");
		}
		return sRtn;
	}
	
	public static String getGraveSectionExp(String section_seq, String row_seq, int col_seq, int seq_no) {
		String sRtn = section_seq + "구역";
		sRtn += " " + row_seq + "행-" + seqToAlpha(col_seq) + "열(고유번호:" + seq_no + ")";
		return sRtn;
	}
	
	public static String seqToAlpha(int seq) {
		int seqOfA = "A".charAt(0) + (seq-1);
		char alpha = (char)seqOfA; 
		return String.valueOf(alpha);
	}
	
	public static boolean isFreeBunyang(BunyangInfoVo bunyangInfoVo) {
		boolean bRtn = isFreeBunyang(bunyangInfoVo.getPricePerCount());
		return bRtn;
	}
	
	public static boolean isFreeBunyang(int price) {
		boolean bRtn = false;
		if(price <= 0) {
			bRtn = true;
		}
		return bRtn;
	}
	
	
}
