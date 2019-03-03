package com.calvary.sysadmin.service;

import java.util.List;

import com.calvary.sysadmin.vo.CodeInfoVo;
import com.calvary.sysadmin.vo.CodeVo;

public interface ISysAdminService {

	//===============================================================================
	// 코드관리
	//===============================================================================
	/** 
	 * 최상위 코드리스트 조회 
	 */
	public List<Object> getTopLevelCodeList();
	/** 
	 * 코드 저장 
	 */
	public int createCodeInfo(CodeInfoVo codeInfoVo) throws Exception;
	/** 
	 * 코드 삭제
	 */
	public int deleteCodeInfo(CodeVo codeVo) throws Exception;
	
}
