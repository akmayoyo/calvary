package com.calvary.common.util;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
	
	/** */
	public static String convertMoney(String str) {
		int length = str.length();
        long money = Long.parseLong(str);
        long nanum = strMoney(length);
        String total = pasing(nanum, money, length);
        return total;
	}
	
	/** */
	public static long strMoney(int len) {
        long nanum = 10; 
        for(int i=2; i<len; i++) 
            nanum *= 10;
        return nanum;
    }
	
	/** */
	public static String pasing(long na, long mo, int len) {
        String total = "";
        String tmp = "";
        while(true) {
            long temp = mo / na;    // ??만원 ??천원을 붙이기위함
            tmp = name(len-1);    // 돈위에 만원이나 천원을 붙이기 위함
            total += temp + tmp;    // 위에 둘을 합쳐서 3만원같으걸 뽑음
            mo-=(na*temp);
            na /= 10;    // 1000, 100, 10 이렇게 나누기 위해서 씀
            len--;    // 마찬가지로 한글로 된 돈 자리수를 위해서
            if(mo==0)    // 0이되면 끝
                break;
        }
        if(len>=8 && len<=10)
            total+="억원";
        else if(len>=5 && len<=7)
            total+="만원";    
        else if(mo!=0)
            total+="원";
        return total;
    }
	
	/** */
	public static String name(int na) {
        String[] na_name = {"원","십","백","천","만","십","백","천","억","십","백"};
        String re_name = na_name[na];
        return re_name;
    }
}
