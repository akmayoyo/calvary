package com.calvary.admin.service;

import java.util.List;

import com.calvary.admin.vo.BunyangInfoVo;

public interface IAdminService {

	//===============================================================================
	// 분양신청관리
	//===============================================================================
	/** 
	 * 분양신청 정보 저장
	 * @param bunyangInfoVo
	 */
	public String createBunyangInfo(BunyangInfoVo bunyangInfoVo);
	
	
	//===============================================================================
	// 메뉴 관리
	//===============================================================================
	
	/** 
	 * 메뉴리스트조회 
	 * @param userId 접속유저 아이디
	 */
	public List<Object> getMenuList(String userId);
}
