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
}
