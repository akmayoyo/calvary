package com.calvary.admin.service;

import java.util.List;

public interface IAdminService {

	
	
	//===============================================================================
	// 메뉴 관리
	//===============================================================================
	
	/** 
	 * 메뉴리스트조회 
	 * @param userId 접속유저 아이디
	 */
	public List<Object> getMenuList(String userId);
}
