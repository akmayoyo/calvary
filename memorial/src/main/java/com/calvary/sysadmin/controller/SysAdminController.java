package com.calvary.sysadmin.controller;

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
import com.calvary.common.service.ICommonService;
import com.calvary.common.util.SessionUtil;
import com.calvary.sysadmin.service.ISysAdminService;
import com.calvary.sysadmin.vo.CodeInfoVo;
import com.calvary.sysadmin.vo.CodeVo;

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
}
