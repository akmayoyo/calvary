package com.calvary.popup.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.calvary.admin.service.IAdminService;
import com.calvary.common.constant.CalvaryConstants;
import com.calvary.common.service.ICommonService;
import com.calvary.common.util.CommonUtil;
import com.calvary.common.util.SessionUtil;
import com.calvary.common.vo.SearchVo;
import com.calvary.common.vo.UserSearchVo;
import com.calvary.excel.ExcelForms;
import com.calvary.excel.service.IExcelService;
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
	public static final String REGIST_PAYMENT = "/registpayment";
	public static final String SAVE_PAYMENT = "/savepayment";
	/** 분양상세정보 페이지  URL */
	public static final String BUNYANG_INFO_URL = "/bunyanginfo";
	
	@Autowired
	private IPopupService popupService;
	@Autowired
	private ICommonService commonService;
	@Autowired
	private IAdminService adminService;
	@Autowired
	private IExcelService excelService;
	
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
		searchVo.setTotalCount(commonService.getTotalCount());
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
	
	@RequestMapping(value=REGIST_PAYMENT)
	public Object registPaymentHandler() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName(ROOT_URL + REGIST_PAYMENT);
		return mv;
	}
	
	@RequestMapping(value=SAVE_PAYMENT)
	@ResponseBody
	public Object savePaymentHandler(
			@RequestParam(value="bunyangSeqs[]") String[] bunyangSeqs,
			@RequestParam(value="paymentDates[]") String[] paymentDates,
			@RequestParam(value="paymentAmounts[]") int[] paymentAmounts,
			@RequestParam(value="paymentTypes[]") String[] paymentTypes,
			@RequestParam(value="paymentMethods[]") String[] paymentMethods,
			@RequestParam(value="contractBunyangSeqs[]", required=false) String[] contractBunyangSeqs,
			@RequestParam(value="fullPaymentBunyangSeqs[]", required=false) String[] fullPaymentBunyangSeqs
			) {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		boolean bRslt = false;
		int iRslt = 0;
		int i = 0;
		String bunyangSeq = null;
		// 납입금 정보 생성
		if(bunyangSeqs != null && bunyangSeqs.length > 0) {
			for(i = 0; i < bunyangSeqs.length; i++) {
				iRslt += adminService.createPaymentHistory(bunyangSeqs[i], paymentAmounts[i], paymentMethods[i], paymentDates[i], paymentTypes[i]);
			}
		}
		// 계약금 납부가 된 건에 대해 계약상태로 업데이트
		if(contractBunyangSeqs != null && contractBunyangSeqs.length > 0) {
			for(i = 0; i < contractBunyangSeqs.length; i++) {
				bunyangSeq = contractBunyangSeqs[i];
				iRslt += adminService.updateBunyangProgressStatus(bunyangSeq, CalvaryConstants.PROGRESS_STATUS_B, SessionUtil.getCurrentUserId());
				String fileSeq = excelService.createBunyangExcelForm(ExcelForms.CONTRACT_FORM, bunyangSeq, "");
				if(!StringUtils.isEmpty(fileSeq)) {
					Map<String, Object> param = new HashMap<String, Object>();
					param.put("bunyangSeq", bunyangSeq);
					param.put("file_seq_contract", fileSeq);
					iRslt += adminService.updateBunyangFileSeq(param);
				}
			}
		}
		// 잔금 완납된 건에 대해 완납상태로 업데이트
		if(fullPaymentBunyangSeqs != null && fullPaymentBunyangSeqs.length > 0) {
			for(i = 0; i < fullPaymentBunyangSeqs.length; i++) {
				bunyangSeq = fullPaymentBunyangSeqs[i];
				iRslt += adminService.updateBunyangProgressStatus(bunyangSeq, CalvaryConstants.PROGRESS_STATUS_C, SessionUtil.getCurrentUserId());
				String fileSeq = excelService.createBunyangExcelForm(ExcelForms.FULL_PAYMENT_FORM, bunyangSeq, "");
				if(!StringUtils.isEmpty(fileSeq)) {
					Map<String, Object> param = new HashMap<String, Object>();
					param.put("bunyangSeq", bunyangSeq);
					param.put("file_seq_full_payment", fileSeq);
					iRslt += adminService.updateBunyangFileSeq(param);
				}
			}
		}
		
		bRslt = iRslt > 0;
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	/** 
	 * 분양상세정보 페이지 
	 */
	@RequestMapping(value=BUNYANG_INFO_URL)
	public Object bunyangInfoHandler(String bunyangSeq) {
		ModelAndView mv = new ModelAndView();
		List<Object> paymentList = null;
		mv.addObject("bunyangSeq", bunyangSeq);
		mv.addObject("bunyangInfo", adminService.getBunyangInfo(bunyangSeq));// 분양정보
		mv.addObject("applyUser", adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_APPLY_USER));// 신청자정보
		mv.addObject("agentUser", adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_AGENT_USER));// 대리신청인정보
		mv.addObject("useUser", adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_USE_USER));// 사용(봉안) 대상자 정보
		mv.addObject("fileList", adminService.getBunyangFileList(bunyangSeq));// 분양 파일 양식 리스트
		paymentList = adminService.getPaymentHistory(bunyangSeq, CalvaryConstants.PAYMENT_TYPE_DOWN_PAYMENT);// 계약금 납부내역
		if(paymentList != null && paymentList.size() > 0) {
			mv.addObject("downPaymentInfo", paymentList.get(0));// 계약금 납부내역
		}
		mv.addObject("balancePaymentList", adminService.getPaymentHistory(bunyangSeq, CalvaryConstants.PAYMENT_TYPE_BALANCE_PAYMENT));// 잔금납부내역
		mv.addObject("totalPaymentInfo", adminService.getTotalPayment(bunyangSeq));
		mv.setViewName(ROOT_URL + BUNYANG_INFO_URL);
		return mv;
	}
	
}
