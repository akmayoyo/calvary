package com.calvary.sysadmin.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.calvary.admin.service.IAdminService;
import com.calvary.admin.vo.BunyangUserVo;
import com.calvary.common.constant.CalvaryConstants;
import com.calvary.common.service.ICommonService;
import com.calvary.common.util.CommonUtil;
import com.calvary.common.util.SessionUtil;
import com.calvary.common.vo.SearchVo;
import com.calvary.sysadmin.service.ISysAdminService;
import com.calvary.sysadmin.vo.CodeInfoVo;
import com.calvary.sysadmin.vo.CodeVo;
import com.calvary.sysadmin.vo.MenuInfoVo;
import com.calvary.sysadmin.vo.MenuRoleMappingVo;
import com.calvary.sysadmin.vo.MenuVo;
import com.calvary.sysadmin.vo.RoleInfoVo;
import com.calvary.sysadmin.vo.UserRoleMappingVo;

@Controller
@RequestMapping(value=SysAdminController.ROOT_URL)
public class SysAdminController {
	/** */
	public static final String ROOT_URL = "/sysadmin";
	
	@Autowired
	private ISysAdminService sysAdminService;
	
	@Autowired
	private IAdminService adminService;
	@Autowired
	private ICommonService commonService;
	
	//===============================================================================
	// 코드관리
	//===============================================================================
	/** 코드관리 메인 페이지  URL */
	public static final String CODE_MGMT_URL = "/codeMgmt";
	/** 코드 저장  URL */
	public static final String SAVE_CODE_URL = "/saveCode";
	/** 코드 삭제  URL */
	public static final String DELETE_CODE_URL = "/deleteCode";
	
	/** 
	 * 코드관리 메인 페이지 
	 */
	@RequestMapping(value=CODE_MGMT_URL)
	public Object codeMgmtHandler(String parentCodeSeq, String parentCodeName) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU04");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU04_04");
		
		List<Object> topLevelCodeList = sysAdminService.getTopLevelCodeList();
		List<Object> childeCodeList = null;
		if(!StringUtils.isEmpty(parentCodeSeq)) {
			childeCodeList = commonService.getChildCodeList(parentCodeSeq);
		}
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("topLevelCodeList", topLevelCodeList);
		mv.addObject("childeCodeList", childeCodeList);
		mv.addObject("parentCodeSeq", parentCodeSeq);
		mv.addObject("parentCodeName", parentCodeName);
		mv.setViewName(ROOT_URL + CODE_MGMT_URL);
		return mv;
	}
	
	/** 
	 * 코드 저장
	 */
	@RequestMapping(value=SAVE_CODE_URL)
	@ResponseBody
	public Object saveCodeHandler(@RequestBody CodeInfoVo codeInfoVo) throws Exception {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int iRslt = sysAdminService.createCodeInfo(codeInfoVo);
		bRslt = iRslt > 0;
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	/** 
	 * 코드 삭제
	 */
	@RequestMapping(value=DELETE_CODE_URL)
	@ResponseBody
	public Object deleteCodeHandler(@RequestBody CodeVo codeVo) throws Exception {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int iRslt = sysAdminService.deleteCodeInfo(codeVo);
		bRslt = iRslt > 0;
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	
	//===============================================================================
	// 메뉴사용이력
	//===============================================================================
	/** 메뉴사용이력 페이지  URL */
	public static final String MENU_LOG_URL = "/menuLog";
	
	/** 
	 * 메뉴사용이력 페이지 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value=MENU_LOG_URL)
	public Object menuLogHandler(SearchVo searchVo) {
		
		SimpleDateFormat sf = new SimpleDateFormat("yyyyMMdd");
		// 검색기간은 default 1주일
		if(StringUtils.isEmpty(searchVo.getFromDt()) && StringUtils.isEmpty(searchVo.getToDt())) {
			Calendar cl = Calendar.getInstance();
			cl.add(Calendar.DATE, -7);
			searchVo.setFromDt(sf.format(cl.getTime()));
			searchVo.setToDt(sf.format(new Date()));
		}
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU04");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU04_06");
		Map<String, Object> rtnMap = sysAdminService.getMenuLogList(searchVo);
		List<Object> menuLogList = (List<Object>)rtnMap.get("list");
		int totalCount = CommonUtil.convertToInt(rtnMap.get("total_count"));
		searchVo.setTotalCount(totalCount);
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("menuLogList", menuLogList);
		mv.addObject("searchVo", searchVo);
		mv.setViewName(ROOT_URL + MENU_LOG_URL);
		return mv;
	}
	
	
	//===============================================================================
	// 사용자관리
	//===============================================================================
	/** 사용자관리 페이지  URL */
	public static final String ADMIN_USER_MGMT_URL = "/adminUserMgmt";
	/** 사용자상세 페이지  URL */
	public static final String ADMIN_USER_DETAIL_URL = "/adminUserDetail";
	/** 사용자 승인 */
	public static final String APPROVAL_ADMIN_USER_URL = "/approvalAdminUser";
	/** 사용자 삭제 */
	public static final String DELETE_ADMIN_USER_URL = "/deleteAdminUser";
	/** 사용자 정보 저장 */
	public static final String SAVE_ADMIN_USER_INFO_URL = "/saveAdminUserInfo";
	
	/** 
	 * 사용자관리 페이지 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value=ADMIN_USER_MGMT_URL)
	public Object adminUserMgmtHandler(SearchVo searchVo) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU04");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU04_02");
		Map<String, Object> rtnMap = sysAdminService.getAdminUserList(searchVo);
		List<Object> userList = (List<Object>)rtnMap.get("list");
		int totalCount = CommonUtil.convertToInt(rtnMap.get("total_count"));
		searchVo.setTotalCount(totalCount);
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("userList", userList);
		mv.addObject("searchVo", searchVo);
		mv.setViewName(ROOT_URL + ADMIN_USER_MGMT_URL);
		return mv;
	}
	
	/** 
	 * 사용자관리 페이지 
	 */
	@RequestMapping(value=ADMIN_USER_DETAIL_URL)
	public Object adminUserDetailHandler(SearchVo searchVo, String userId) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU04");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU04_02");
		Map<String, Object> userInfo = sysAdminService.getAdminUserInfo(userId);
		mv.addObject("yearList", commonService.getYearList());
		mv.addObject("officerList", commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_CHURCH_OFFICER));// 직분코드
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("userInfo", userInfo);
		mv.addObject("searchVo", searchVo);
		mv.addObject("userId", userId);
		mv.setViewName(ROOT_URL + ADMIN_USER_DETAIL_URL);
		return mv;
	}
	
	/** 
	 * 사용자 승인 
	 */
	@RequestMapping(value=APPROVAL_ADMIN_USER_URL)
	@ResponseBody
	public Object approvalAdminUserHandler(String userId) throws Exception {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int iRslt = sysAdminService.approvalAdminUser(userId);
		bRslt = iRslt > 0;
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	/** 
	 * 사용자 삭제
	 */
	@RequestMapping(value=DELETE_ADMIN_USER_URL)
	@ResponseBody
	public Object deleteAdminUserHandler(String userId) throws Exception {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int iRslt = sysAdminService.deleteAdminUser(userId);
		bRslt = iRslt > 0;
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	/** 
	 * 사용자 정보 저장
	 */
	@RequestMapping(value=SAVE_ADMIN_USER_INFO_URL)
	@ResponseBody
	public Object saveAdminUserInfoHandler(@RequestBody BunyangUserVo userVo) throws Exception {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int iRslt = sysAdminService.updateAdminUserInfo(userVo);
		bRslt = iRslt > 0;
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	
	//===============================================================================
	// 메뉴관리
	//===============================================================================
	/** 메뉴관리 메인 페이지  URL */
	public static final String MENU_MGMT_URL = "/menuMgmt";
	/** 메뉴 저장  URL */
	public static final String SAVE_MENU_URL = "/saveMenu";
	/** 메뉴 삭제  URL */
	public static final String DELETE_MENU_URL = "/deleteMenu";
	
	/** 
	 * 메뉴관리 메인 페이지 
	 */
	@RequestMapping(value=MENU_MGMT_URL)
	public Object menuMgmtHandler(String parentMenuSeq, String parentMenuName) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU04");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU04_01");
		
		List<Object> topLevelMenuList = sysAdminService.getTopLevelMenuList();
		List<Object> childeMenuList = null;
		if(!StringUtils.isEmpty(parentMenuSeq)) {
			childeMenuList = sysAdminService.getChildMenuList(parentMenuSeq);
		}
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("topLevelMenuList", topLevelMenuList);
		mv.addObject("childeMenuList", childeMenuList);
		mv.addObject("parentMenuSeq", parentMenuSeq);
		mv.addObject("parentMenuName", parentMenuName);
		mv.setViewName(ROOT_URL + MENU_MGMT_URL);
		return mv;
	}
	
	/** 
	 * 메뉴 저장
	 */
	@RequestMapping(value=SAVE_MENU_URL)
	@ResponseBody
	public Object saveMenuHandler(@RequestBody MenuInfoVo menuInfoVo) throws Exception {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int iRslt = sysAdminService.createMenuInfo(menuInfoVo);
		bRslt = iRslt > 0;
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	/** 
	 * 메뉴 삭제
	 */
	@RequestMapping(value=DELETE_MENU_URL)
	@ResponseBody
	public Object deleteMenuHandler(@RequestBody MenuVo menuVo) throws Exception {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int iRslt = sysAdminService.deleteMenuInfo(menuVo);
		bRslt = iRslt > 0;
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	
	//===============================================================================
	// 사용자그룹관리
	//===============================================================================
	/** 사용자그룹관리 메인 페이지  URL */
	public static final String USER_ROLE_MGMT_URL = "/userRoleMgmt";
	/** 그룹 메뉴권한 저장  URL */
	public static final String SAVE_MENU_ROLE_URL = "/saveMenuRole";
	/** 사용자권한 저장  URL */
	public static final String SAVE_USER_ROLE_URL = "/saveUserRole";
	/** 사용자그룹 정보 저장  URL */
	public static final String SAVE_ROLE_URL = "/saveRole";
	/** 사용자그룹 삭제  URL */
	public static final String DELETE_ROLE_URL = "/deleteRole";
	
	/** 
	 * 사용자그룹관리 메인 페이지 
	 */
	@RequestMapping(value=USER_ROLE_MGMT_URL)
	public Object userRoleMgmtHandler() {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU04");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU04_03");
		List<Object> roleList = sysAdminService.getRoleList();
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("roleList", roleList);
		mv.setViewName(ROOT_URL + USER_ROLE_MGMT_URL);
		return mv;
	}
	
	/** 
	 * 그룹 메뉴권한 저장
	 */
	@RequestMapping(value=SAVE_MENU_ROLE_URL)
	@ResponseBody
	public Object saveMenuRoleHandler(@RequestBody MenuRoleMappingVo vo) throws Exception {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		sysAdminService.createMenuRoleMapping(vo);
		bRslt = true;
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	/** 
	 * 사용자권한 저장
	 */
	@RequestMapping(value=SAVE_USER_ROLE_URL)
	@ResponseBody
	public Object saveUserRoleHandler(@RequestBody UserRoleMappingVo vo) throws Exception {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		sysAdminService.createUserRoleMapping(vo);
		bRslt = true;
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	/** 
	 * 사용자그룹 정보 저장
	 */
	@RequestMapping(value=SAVE_ROLE_URL)
	@ResponseBody
	public Object saveRoleHandler(@RequestBody RoleInfoVo vo) throws Exception {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int iRslt = sysAdminService.createRoleInfo(vo);
		bRslt = iRslt > 0;
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	/** 
	 * 사용자그룹 삭제
	 */
	@RequestMapping(value=DELETE_ROLE_URL)
	@ResponseBody
	public Object deleteRoleHandler(String roleId) throws Exception {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int iRslt = sysAdminService.deleteRole(roleId);
		bRslt = iRslt > 0;
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
}
