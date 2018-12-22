package com.calvary.admin.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.calvary.admin.service.IAdminService;
import com.calvary.admin.vo.BunyangInfoVo;
import com.calvary.admin.vo.BunyangUserVo;
import com.calvary.common.constant.CalvaryConstants;
import com.calvary.common.service.ICommonService;
import com.calvary.common.vo.SearchVo;
import com.calvary.common.vo.UserVo;

@Controller
@RequestMapping(value=AdminController.ROOT_URL)
public class AdminController {
	
	/** */
	public static final String ROOT_URL = "/admin";
	
	@Autowired
	private IAdminService adminService;
	@Autowired
	private ICommonService commonService;
	
	//===============================================================================
	// 분양신청관리
	//===============================================================================
	/** 분양신청관리 URL */
	public static final String APPLY_MGMT_URL = "/applymgmt";
	/** 분양신청 URL */
	public static final String APPLY_REGIST_URL = "/applyregist";
	/** 분양신청정보 저장 URL */
	public static final String SAVE_APPLY_URL = "/saveapply";
	
	@RequestMapping(value=APPLY_MGMT_URL)
	public Object applyMgmtHandler(SearchVo searchVo) {
		List<Object> menuList = adminService.getMenuList("");
		ModelAndView mv = new ModelAndView();
		mv.addObject("menuList", menuList);
		mv.addObject("menuSeq", "MENU01_01");
		mv.addObject("pmenuSeq", "MENU01");
		mv.setViewName(ROOT_URL + APPLY_MGMT_URL);
		return mv;
	}
	
	@RequestMapping(value=APPLY_REGIST_URL)
	public Object applyRegistHandler(SearchVo searchVo) {
		List<Object> menuList = adminService.getMenuList("");
		ModelAndView mv = new ModelAndView();
		mv.addObject("menuList", menuList);
		mv.addObject("menuSeq", "MENU01_01");
		mv.addObject("pmenuSeq", "MENU01");
		mv.addObject("codeUserRelation", commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_USER_RELATION));
		mv.setViewName(ROOT_URL + APPLY_REGIST_URL);
		return mv;
	}
	
	@RequestMapping(value=SAVE_APPLY_URL)
	@ResponseBody
	public Object saveApplyHandler(@RequestBody BunyangInfoVo bunyangInfoVo) {
		boolean bRslt = false;
		
		System.out.println(bunyangInfoVo.toString());
		
		return bRslt;
	}
	
	
	//===============================================================================
	// 사용계약관리
	//===============================================================================
	
	
	
	//===============================================================================
	// 사용승인관리
	//===============================================================================
	
	
	
	//===============================================================================
	// 해약관리
	//===============================================================================
	
	
	
	//===============================================================================
	// 계약자관리
	//===============================================================================
	
	
	
	//===============================================================================
	// 사용자 관리
	//===============================================================================
	/** 사용자 관리 ROOT URL */
	public static final String USER_MGMT_URL = "/usermgmt";
	
	@RequestMapping(value=USER_MGMT_URL)
	public Object userMgmtHandler() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName(ROOT_URL + USER_MGMT_URL);
		return mv;
	}
	
	
	//===============================================================================
	// 메뉴 관리
	//===============================================================================
	/** 메뉴 관리 ROOT URL */
	public static final String MENU_MGMT_URL = "/menumgmt";
	
	@RequestMapping(value=MENU_MGMT_URL)
	public Object menuMgmtHandler() {
		// TODO 로그인아이디 넘겨야됨
		List<Object> menuList = adminService.getMenuList("");
		ModelAndView mv = new ModelAndView();
		mv.addObject("menuList", menuList);
		mv.setViewName(ROOT_URL + MENU_MGMT_URL);
		return mv;
	}
	
}
