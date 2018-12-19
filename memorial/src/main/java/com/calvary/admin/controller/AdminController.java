package com.calvary.admin.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.calvary.admin.service.IAdminService;
import com.calvary.common.vo.SearchVo;

@Controller
@RequestMapping(value=AdminController.ROOT_URL)
public class AdminController {
	
	/** */
	public static final String ROOT_URL = "/admin";
	
	@Autowired
	private IAdminService adminService;
	
	//===============================================================================
	// 분양신청관리
	//===============================================================================
	/** 분양신청관리 ROOT URL */
	public static final String APPLY_MGMT_URL = "/applymgmt";
	
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
