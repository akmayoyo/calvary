package com.calvary.popup.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.calvary.admin.service.IAdminService;
import com.calvary.common.constant.CalvaryConstants;
import com.calvary.common.service.ICommonService;
import com.calvary.common.util.CommonUtil;
import com.calvary.common.vo.SearchVo;
import com.calvary.common.vo.UserSearchVo;
import com.calvary.popup.service.IPopupService;

@Controller
@RequestMapping(value=PopupController.ROOT_URL)
public class PopupController {

	/** */
	public static final String ROOT_URL = "/popup";
	
	public static final String SELECT_USER_URL = "/selectuser";
	public static final String CHECK_DUPLICATED_USER_URL = "/checkduplicateduser";
	public static final String CONTRACT_CANCEL_URL = "/contractcancel";
	
	@Autowired
	private IPopupService popupService;
	@Autowired
	private ICommonService commonService;
	@Autowired
	private IAdminService adminService;
	
	@RequestMapping(value=SELECT_USER_URL)
	public Object selectUserHandler(SearchVo searchVo, String popupTitle) {
		ModelAndView mv = new ModelAndView();
		List<Object> userList = popupService.getUserList(searchVo);
		searchVo.setTotalCount(popupService.getUserListTotalCount(searchVo));
		mv.addObject("userList", userList);
		mv.addObject("officerList", commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_CHURCH_OFFICER));
		mv.addObject("searchVo", searchVo);
		mv.addObject("popupTitle", popupTitle);
		mv.setViewName(ROOT_URL + SELECT_USER_URL);
		return mv;
	}
	
	@RequestMapping(value=CHECK_DUPLICATED_USER_URL)
	@ResponseBody
	public Object checkDuplicatedUserHandler(String userName, String birthDate) {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		boolean bRslt = popupService.checkDuplicatedUser(userName, birthDate);
		Map<String, Object> user = null;
		if(bRslt) {
			user = popupService.getUserByNameAndBirthDate(userName, birthDate);
		}
		rtnMap.put("isduplicated", bRslt);
		rtnMap.put("user", user);
		return rtnMap;
	}
	
	/** 
	 * 분양계약 해약
	 */
	@RequestMapping(value=CONTRACT_CANCEL_URL)
	public Object contractCancelHandler(String bunyangSeq) {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> bunyangInfo = adminService.getBunyangInfo(bunyangSeq);
		mv.addObject("bunyangInfo", bunyangInfo);
		mv.setViewName(ROOT_URL + CONTRACT_CANCEL_URL);
		return mv;
	}
}
