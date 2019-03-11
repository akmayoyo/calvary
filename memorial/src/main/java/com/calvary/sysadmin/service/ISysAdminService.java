package com.calvary.sysadmin.service;

import java.util.List;
import java.util.Map;

import com.calvary.admin.vo.BunyangUserVo;
import com.calvary.common.vo.SearchVo;
import com.calvary.sysadmin.vo.CodeInfoVo;
import com.calvary.sysadmin.vo.CodeVo;
import com.calvary.sysadmin.vo.MenuInfoVo;
import com.calvary.sysadmin.vo.MenuRoleMappingVo;
import com.calvary.sysadmin.vo.MenuVo;
import com.calvary.sysadmin.vo.RoleInfoVo;
import com.calvary.sysadmin.vo.UserRoleMappingVo;

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
	
	
	//===============================================================================
	// 메뉴사용이력
	//===============================================================================
	/** 
	 * 메뉴사용이력 조회 
	 */
	public Map<String, Object> getMenuLogList(SearchVo searchVo);
	
	
	//===============================================================================
	// 사용자관리
	//===============================================================================
	/** 
	 * Admin 사용자 리스트 조회 
	 */
	public Map<String, Object> getAdminUserList(SearchVo searchVo);
	
	/** 
	 * Admin 사용자 정보 조회 
	 */
	public Map<String, Object> getAdminUserInfo(String userId);
	
	/** */
	public int approvalAdminUser(String userId) throws Exception;
	/** */
	public int deleteAdminUser(String userId) throws Exception;
	/** */
	public int updateAdminUserInfo(BunyangUserVo userVo) throws Exception;
	
	
	//===============================================================================
	// 메뉴관리
	//===============================================================================
	/** 
	 * 최상위 메뉴리스트 조회 
	 */
	public List<Object> getTopLevelMenuList();
	/** 
	 * 하위 메뉴리스트 조회 
	 */
	public List<Object> getChildMenuList(String parentMenuSeq);
	/** 
	 * 메뉴 저장 
	 */
	public int createMenuInfo(MenuInfoVo menuInfoVo) throws Exception;
	/** 
	 * 메뉴 삭제
	 */
	public int deleteMenuInfo(MenuVo menuVo) throws Exception;
	
	
	//===============================================================================
	// 사용자그룹관리
	//===============================================================================
	public List<Object> getRoleList();
	
	public List<Object> getUserRoleList(String roleId);
	
	public int createRoleInfo(RoleInfoVo roleInfoVo) throws Exception;
	
	public int deleteRole(String roleId) throws Exception;
	
	public int createUserRoleMapping(UserRoleMappingVo vo) throws Exception;
	
	public int createMenuRoleMapping(MenuRoleMappingVo vo) throws Exception;
	
}
