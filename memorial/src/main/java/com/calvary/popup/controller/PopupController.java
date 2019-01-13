package com.calvary.popup.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
	public static final String USE_APPLY_URL = "/useapply";
	public static final String SELECT_USE_USER = "/selectuseuser";
	public static final String ASSIGN_GRAVE = "/assigngrave";
	
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
	
	/** 
	 * 동산 사용신청
	 */
	@RequestMapping(value=USE_APPLY_URL)
	public Object useApplyHandler(SearchVo searchVo) {
		ModelAndView mv = new ModelAndView();
		List<Object> useApplyList = adminService.getUseApplyList(searchVo);
		searchVo.setTotalCount(CommonUtil.getPaingTotalCount(useApplyList, "total_count"));
		mv.addObject("searchVo", searchVo);
		mv.addObject("useApplyList", useApplyList);
		mv.setViewName(ROOT_URL + USE_APPLY_URL);
		return mv;
	}
	
	@RequestMapping(value=SELECT_USE_USER)
	public Object selectUseUserHandler(SearchVo searchVo, String bunyangSeq) {
		ModelAndView mv = new ModelAndView();
		List<Object> useUserList = adminService.getUseUserList(bunyangSeq);
		Map<String, Object> bunyangInfo = adminService.getBunyangInfo(bunyangSeq);
		mv.addObject("searchVo", searchVo);
		mv.addObject("bunyangSeq", bunyangSeq);
		mv.addObject("useUserList", useUserList);
		mv.addObject("bunyangInfo", bunyangInfo);
		mv.setViewName(ROOT_URL + SELECT_USE_USER);
		return mv;
	}
	
	@RequestMapping(value=ASSIGN_GRAVE)
	@ResponseBody
	public Object assignGraveHandler(
			@RequestParam(value="bunyangSeq") String bunyangSeq,
			@RequestParam(value="productType") String productType,
			@RequestParam(value="userSeqs[]") int[] userSeqs,
			@RequestParam(value="coupleSeqs[]") int[] coupleSeqs
			) {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		boolean bRslt = false;
		int iRslt = 0;
		// 개별형의 경우
		if(CalvaryConstants.PRODUCT_TYPE_EACH.equals(productType)) {
			iRslt = adminService.assignEachGrave(bunyangSeq, userSeqs, coupleSeqs);
		}else if(CalvaryConstants.PRODUCT_TYPE_FAMILY.equals(productType)) {
			iRslt = adminService.assignFamilyGrave(bunyangSeq, userSeqs, coupleSeqs);
		}
		bRslt = iRslt > 0;
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
}
