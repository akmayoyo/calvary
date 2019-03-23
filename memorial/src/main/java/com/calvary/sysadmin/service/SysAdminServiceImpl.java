package com.calvary.sysadmin.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.calvary.admin.vo.BunyangUserVo;
import com.calvary.common.dao.CommonDao;
import com.calvary.common.util.CommonUtil;
import com.calvary.common.vo.SearchVo;
import com.calvary.sysadmin.vo.CodeInfoVo;
import com.calvary.sysadmin.vo.CodeVo;
import com.calvary.sysadmin.vo.MenuInfoVo;
import com.calvary.sysadmin.vo.MenuRoleMappingVo;
import com.calvary.sysadmin.vo.MenuVo;
import com.calvary.sysadmin.vo.RoleInfoVo;
import com.calvary.sysadmin.vo.RoleVo;
import com.calvary.sysadmin.vo.UserRoleMappingVo;

@Service
public class SysAdminServiceImpl implements ISysAdminService {
	@Autowired
	private CommonDao commonDao;
	
	//===============================================================================
	// 코드관리
	//===============================================================================
	/** 
	 * 최상위 코드리스트 조회 
	 */
	public List<Object> getTopLevelCodeList() {
		Map<String, Object> parameter = new HashMap<String, Object>();
		List<Object> list = commonDao.selectList("sysadmin.getTopLevelCodeList", parameter); 
		return list;
	}
	
	/** 
	 * 코드 저장 
	 */
	@Transactional
	public int createCodeInfo(CodeInfoVo codeInfoVo) throws Exception {
		int iRslt = 0;
		String parentCodeSeq = codeInfoVo.getParentCodeSeq();
		List<CodeVo> codeList = codeInfoVo.getCodeList();
		if(codeList != null && codeList.size() > 0) {
			for(int i = 0; i < codeList.size(); i++) {
				Map<String, Object> parameter = new HashMap<String, Object>();
				CodeVo codeVo = codeList.get(i);
				parameter.put("codeSeq", codeVo.getCodeSeq());
				parameter.put("codeName", codeVo.getCodeName());
				parameter.put("codeDesc", codeVo.getCodeDesc());
				parameter.put("codeLevel", codeVo.getCodeLevel());
				parameter.put("displayOrder", codeVo.getDisplayOrder());
				parameter.put("codeValue", codeVo.getCodeValue());
				parameter.put("codeValue1", codeVo.getCodeValue1());
				parameter.put("parentCodeSeq", parentCodeSeq);
				if("U".equals(codeVo.getFlag())) {
					iRslt += commonDao.update("sysadmin.updateCodeInfo", parameter);
				} else if("C".equals(codeVo.getFlag())) {
					iRslt += commonDao.insert("sysadmin.createCodeInfo", parameter);
				}
			}
		}
		return iRslt;
	}
	
	/** 
	 * 코드 삭제
	 */
	@Transactional
	public int deleteCodeInfo(CodeVo codeVo) throws Exception {
		int iRslt = 0;
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("codeSeq", codeVo.getCodeSeq());
		parameter.put("parentCodeSeq", codeVo.getParentCodeSeq());
		iRslt += commonDao.delete("sysadmin.deleteCodeInfo", parameter);
		iRslt += commonDao.delete("sysadmin.deleteChildCodeInfo", parameter);
		return iRslt;
	}
	
	
	//===============================================================================
	// 메뉴사용이력
	//===============================================================================
	/** 
	 * 메뉴사용이력 조회 
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getMenuLogList(SearchVo searchVo) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("start", (searchVo.getPageIndex()-1) * searchVo.getCountPerPage());
		parameter.put("count", searchVo.getCountPerPage());
		parameter.put("fromDt", searchVo.getFromDt());
		parameter.put("toDt", searchVo.getToDt());
		parameter.put(searchVo.getSearchKey(), searchVo.getSearchVal());
		List<Object> list = commonDao.selectList("sysadmin.getMenuLogList", parameter); 
		Map<String, Object> countMap = (HashMap<String, Object>)commonDao.selectOne("totalcount.getMenuLogList", parameter);
		int total_count = 0;
		if(countMap != null) {
			total_count = CommonUtil.convertToInt(countMap.get("total_count"));
		}
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("list", list);
		rtnMap.put("total_count", total_count);
		return rtnMap;
	}
	
	
	//===============================================================================
	// 사용자관리
	//===============================================================================
	/** 
	 * Admin 사용자 리스트 조회 
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getAdminUserList(SearchVo searchVo) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("start", (searchVo.getPageIndex()-1) * searchVo.getCountPerPage());
		parameter.put("count", searchVo.getCountPerPage());
		parameter.put(searchVo.getSearchKey(), searchVo.getSearchVal());
		List<Object> list = commonDao.selectList("sysadmin.getAdminUserList", parameter); 
		Map<String, Object> countMap = (HashMap<String, Object>)commonDao.selectOne("totalcount.getAdminUserList", parameter);
		int total_count = 0;
		if(countMap != null) {
			total_count = CommonUtil.convertToInt(countMap.get("total_count"));
		}
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("list", list);
		rtnMap.put("total_count", total_count);
		return rtnMap;
	}
	
	/** 
	 * Admin 사용자 정보 조회 
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getAdminUserInfo(String userId) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("userId", userId);
		Map<String, Object> rtnMap = (HashMap<String, Object>)commonDao.selectOne("sysadmin.getAdminUserInfo", parameter);
		return rtnMap;
	}
	
	/** */
	public int approvalAdminUser(String userId) throws Exception {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("userId", userId);
		int iRslt = commonDao.update("sysadmin.approvalAdminUser", parameter);
		return iRslt;
	}
	
	/** */
	public int deleteAdminUser(String userId) throws Exception {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("userId", userId);
		int iRslt = commonDao.update("sysadmin.deleteAdminUser", parameter);
		return iRslt;
	}
	
	/** */
	public int updateAdminUserInfo(BunyangUserVo userVo) throws Exception {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("userId", userVo.getUserId());
		parameter.put("userName", userVo.getUserName());
		parameter.put("birthDate", userVo.getBirthDate());
		parameter.put("gender", userVo.getGender());
		parameter.put("email", userVo.getEmail());
		parameter.put("mobile", userVo.getMobile());
		parameter.put("phone", userVo.getPhone());
		parameter.put("postNumber", userVo.getPostNumber());
		parameter.put("address1", userVo.getAddress1());
		parameter.put("address2", userVo.getAddress2());
		parameter.put("churchOfficer", userVo.getChurchOfficer());
		parameter.put("diocese", userVo.getDiocese());
		int iRslt = commonDao.update("sysadmin.updateAdminUserInfo", parameter);
		return iRslt;
	}
	
	
	//===============================================================================
	// 메뉴관리
	//===============================================================================
	/** 
	 * 최상위 메뉴리스트 조회 
	 */
	public List<Object> getTopLevelMenuList() {
		Map<String, Object> parameter = new HashMap<String, Object>();
		List<Object> list = commonDao.selectList("sysadmin.getTopLevelMenuList", parameter); 
		return list;
	}
	
	/** 
	 * 하위 메뉴리스트 조회 
	 */
	public List<Object> getChildMenuList(String parentMenuSeq) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("parentMenuSeq", parentMenuSeq);
		List<Object> list = commonDao.selectList("sysadmin.getChildMenuList", parameter); 
		return list;
	}
	
	/** 
	 * 메뉴 저장 
	 */
	@SuppressWarnings("unchecked")
	public int createMenuInfo(MenuInfoVo menuInfoVo) throws Exception {
		int iRslt = 0;
		String parentMenuSeq = menuInfoVo.getParentMenuSeq();
		List<MenuVo> menuList = menuInfoVo.getMenuList();
		if(menuList != null && menuList.size() > 0) {
			for(int i = 0; i < menuList.size(); i++) {
				Map<String, Object> parameter = new HashMap<String, Object>();
				MenuVo menuVo = menuList.get(i);
				parameter.put("menuSeq", menuVo.getMenuSeq());
				parameter.put("menuName", menuVo.getMenuName());
				parameter.put("menuUrl", menuVo.getMenuUrl());
				parameter.put("menuLevel", menuVo.getMenuLevel());
				parameter.put("displayOrder", menuVo.getDisplayOrder());
				parameter.put("parentMenuSeq", parentMenuSeq);
				parameter.put("useYn", menuVo.getUseYn());
				parameter.put("hasAuth", menuVo.getHasAuth());
				if("U".equals(menuVo.getFlag())) {
					iRslt += commonDao.update("sysadmin.updateMenuInfo", parameter);
				} else if("C".equals(menuVo.getFlag())) {
					Map<String, Object> tmp = (HashMap<String,Object>)commonDao.selectOne("sysadmin.getNextMenuSeq", parameter);
					String menuSeq = (String)tmp.get("menu_seq");
					parameter.put("menuSeq", menuSeq);
					iRslt += commonDao.insert("sysadmin.createMenuInfo", parameter);
				}
			}
		}
		return iRslt;
	}
	
	/** 
	 * 메뉴 삭제
	 */
	public int deleteMenuInfo(MenuVo menuVo) throws Exception {
		int iRslt = 0;
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("menuSeq", menuVo.getMenuSeq());
		parameter.put("parentMenuSeq", menuVo.getParentMenuSeq());
		iRslt += commonDao.delete("sysadmin.deleteMenuInfo", parameter);
		iRslt += commonDao.delete("sysadmin.deleteChildMenuInfo", parameter);
		return iRslt;
	}
	
	
	//===============================================================================
	// 사용자그룹관리
	//===============================================================================
	public List<Object> getRoleList() {
		Map<String, Object> parameter = new HashMap<String, Object>();
		List<Object> list = commonDao.selectList("sysadmin.getRoleList", parameter); 
		return list;
	}
	
	public List<Object> getUserRoleList(String roleId) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("roleId", roleId);
		List<Object> list = commonDao.selectList("sysadmin.getUserRoleList", parameter); 
		return list;
	}
	
	@Transactional
	public int createRoleInfo(RoleInfoVo roleInfoVo) throws Exception {
		int iRslt = 0;
		List<RoleVo> roleList = roleInfoVo.getRoleList();
		if(roleList != null && roleList.size() > 0) {
			for(int i = 0; i < roleList.size(); i++) {
				Map<String, Object> parameter = new HashMap<String, Object>();
				RoleVo roleVo = roleList.get(i);
				parameter.put("roleId", roleVo.getRoleId());
				parameter.put("roleName", roleVo.getRoleName());
				parameter.put("roleDesc", roleVo.getRoleDesc());
				if("U".equals(roleVo.getFlag())) {
					iRslt += commonDao.update("sysadmin.updateRole", parameter);
				} else if("C".equals(roleVo.getFlag())) {
					iRslt += commonDao.insert("sysadmin.createRole", parameter);
				}
			}
		}
		return iRslt;
	}
	
	@Transactional
	public int deleteRole(String roleId) throws Exception {
		int iRslt = 0;
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("roleId", roleId);
		iRslt += commonDao.delete("sysadmin.deleteRole", parameter);
		iRslt += commonDao.delete("sysadmin.deleteUserRoleMapping", parameter);
		iRslt += commonDao.delete("sysadmin.deleteMenuRoleMapping", parameter);
		return iRslt;
	}
	
	@Transactional
	public int createUserRoleMapping(UserRoleMappingVo vo) throws Exception {
		int iRslt = 0;
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("roleId", vo.getRoleId());
		iRslt += commonDao.delete("sysadmin.deleteUserRoleMapping", parameter);
		if(vo.getUserIds() != null && vo.getUserIds().size() > 0) {
			for(int i = 0; i < vo.getUserIds().size(); i++) {
				String userId = vo.getUserIds().get(i);
				parameter.put("userId", userId);
				iRslt += commonDao.insert("sysadmin.createUserRoleMapping", parameter);
			}
		}
		return iRslt;
	}
	
	@Transactional
	public int createMenuRoleMapping(MenuRoleMappingVo vo) throws Exception {
		int iRslt = 0;
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("roleId", vo.getRoleId());
		iRslt += commonDao.delete("sysadmin.deleteMenuRoleMapping", parameter);
		if(vo.getMenuIds() != null && vo.getMenuIds().size() > 0) {
			for(int i = 0; i < vo.getMenuIds().size(); i++) {
				String menuId = vo.getMenuIds().get(i);
				parameter.put("menuId", menuId);
				iRslt += commonDao.insert("sysadmin.createMenuRoleMapping", parameter);
			}
		}
		return iRslt;
	}
	
}
