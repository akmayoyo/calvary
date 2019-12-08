package com.calvary.common.service;

import java.util.List;
import java.util.Map;

public interface ICommonService {

	public List<Object> getYearList();
	
	public Map<String, Object> getCodeInfo(String codeSeq);
	
	public List<Object> getChildCodeList(String parentCodeSeq);
	
	public List<Object> getChildCodeList(String parentCodeSeq, String displayYn);
	
	public List<Object> getRelationCodeList();
	
	public Map<String, Object> getMenuInfo(String menuSeq);
	
	public long getSeqNexVal(String seqType) throws Exception;
	
	/**
	 * 페이징에서 사용할 전제 행 개수를 반환
	 * 각 쿼리에 SQL_CALC_FOUND_ROWS 를 정의한후 해당 함수 호출해야 정상 동작함
	 */
	public int getTotalCount();
	
	/**
	 * 
	 * 메뉴 접속 이력 생성
	 */
	public int createMenuAccessLog(String loginUser, String loginIP, String deviceType, String menuId) throws Exception;
	
	public Map<String, Object> getSmsMsg(String msgKey);
}
