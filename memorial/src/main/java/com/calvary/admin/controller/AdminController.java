package com.calvary.admin.controller;

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
import com.calvary.admin.vo.BunyangInfoVo;
import com.calvary.common.constant.CalvaryConstants;
import com.calvary.common.service.ICommonService;
import com.calvary.common.util.CommonUtil;
import com.calvary.common.vo.SearchVo;
import com.calvary.excel.ExcelForms;
import com.calvary.excel.service.IExcelService;

@Controller
@RequestMapping(value=AdminController.ROOT_URL)
public class AdminController {
	
	/** */
	public static final String ROOT_URL = "/admin";
	
	@Autowired
	private IAdminService adminService;
	@Autowired
	private ICommonService commonService;
	@Autowired
	private IExcelService excelService;
	
	//===============================================================================
	// 분양신청관리
	//===============================================================================
	/** 분양신청관리 메인 페이지  URL */
	public static final String APPLY_MGMT_URL = "/applymgmt";
	/** 분양 신청정보 등록 페이지  URL */
	public static final String APPLY_REGIST_URL = "/applyregist";
	/** 분양신청 상세 정보 페이지  URL */
	public static final String APPLY_DETAIL_URL = "/applydetail";
	/** 분양 신청정보 저장 URL */
	public static final String SAVE_APPLY_URL = "/saveapply";
	/** 신청승인 URL */
	public static final String APPROVAL_URL = "/approval";
	/** 반려 URL */
	public static final String REJECT_URL = "/reject";
	
	/** 
	 * 분양신청관리 메인 페이지 
	 */
	@RequestMapping(value=APPLY_MGMT_URL)
	public Object applyMgmtHandler(SearchVo searchVo) {
		List<Object> menuList = adminService.getMenuList("");
		List<Object> applyList = adminService.getApplyList(searchVo);
		searchVo.setTotalCount(CommonUtil.getPaingTotalCount(applyList, "total_count"));
		ModelAndView mv = new ModelAndView();
		mv.addObject("menuList", menuList);
		mv.addObject("menuSeq", "MENU01_01");
		mv.addObject("pmenuSeq", "MENU01");
		mv.addObject("searchVo", searchVo);
		mv.addObject("applyList", applyList);
		mv.setViewName(ROOT_URL + APPLY_MGMT_URL);
		return mv;
	}
	
	/** 
	 * 분양 신청정보 등록 페이지 
	 */
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
	
	/** 
	 * 분양신청 상세 정보 페이지 
	 */
	@RequestMapping(value=APPLY_DETAIL_URL)
	public Object applyDetailHandler(SearchVo searchVo, String bunyangSeq) {
		List<Object> menuList = adminService.getMenuList("");
		ModelAndView mv = new ModelAndView();
		mv.addObject("menuList", menuList);
		mv.addObject("menuSeq", "MENU01_01");
		mv.addObject("pmenuSeq", "MENU01");
		mv.addObject("bunyangSeq", bunyangSeq);
		mv.addObject("searchVo", searchVo);
		mv.addObject("bunyangInfo", adminService.getBunyangInfo(bunyangSeq));// 분양정보
		mv.addObject("applyUser", adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_APPLY_USER));// 신청자정보
		mv.addObject("agentUser", adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_AGENT_USER));// 대리신청인정보
		mv.addObject("useUser", adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_USE_USER));// 사용(봉안) 대상자 정보
		mv.addObject("fileList", adminService.getBunyangFileList(bunyangSeq));// 분양 파일 양식 리스트
		mv.setViewName(ROOT_URL + APPLY_DETAIL_URL);
		return mv;
	}
	
	/** 
	 * 분양 신청정보 저장 
	 */
	@RequestMapping(value=SAVE_APPLY_URL)
	@ResponseBody
	public Object saveApplyHandler(@RequestBody BunyangInfoVo bunyangInfoVo) {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String bunyangSeq = adminService.createBunyangInfo(bunyangInfoVo);
		if(!StringUtils.isEmpty(bunyangSeq)) {
			String applyFileSeq = excelService.createBunyangExcelForm(ExcelForms.APPLY_FORM, bunyangSeq, "");
			String useUserFileSeq = excelService.createBunyangExcelForm(ExcelForms.USE_USER_FORM, bunyangSeq, "");
			if(!StringUtils.isEmpty(applyFileSeq) && !StringUtils.isEmpty(useUserFileSeq)) {
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("bunyangSeq", bunyangSeq);
				param.put("file_seq_apply", applyFileSeq);
				param.put("file_seq_use_user", useUserFileSeq);
				int iRslt = adminService.updateBunyangFileSeq(param);
				bRslt = iRslt > 0;
			}
		}
		rtnMap.put("result", bRslt);
		rtnMap.put("bunyangSeq", bunyangSeq);
		return rtnMap;
	}
	
	/** 
	 * 신청승인
	 */
	@RequestMapping(value=APPROVAL_URL)
	@ResponseBody
	public Object approvalHandler(@RequestBody BunyangInfoVo bunyangInfoVo) {
		boolean bRslt = false;
		String bunyangSeq = bunyangInfoVo.getBunyangSeq();
		String progressStatus = bunyangInfoVo.getProgressStatus();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int iRslt = adminService.updateBunyangProgressStatus(bunyangSeq, progressStatus);
		if(iRslt > 0) {
			String approvalFileSeq = excelService.createBunyangExcelForm(ExcelForms.APPROVAL_FORM, bunyangSeq, "");
			if(!StringUtils.isEmpty(approvalFileSeq)) {
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("bunyangSeq", bunyangSeq);
				param.put("file_seq_approval", approvalFileSeq);
				iRslt = adminService.updateBunyangFileSeq(param);
				bRslt = iRslt > 0;
			}
		}
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	/** 
	 * 반려
	 */
	@RequestMapping(value=REJECT_URL)
	@ResponseBody
	public Object rejectHandler(@RequestBody BunyangInfoVo bunyangInfoVo) {
		boolean bRslt = false;
		String bunyangSeq = bunyangInfoVo.getBunyangSeq();
		String progressStatus = bunyangInfoVo.getProgressStatus();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int iRslt = adminService.updateBunyangProgressStatus(bunyangSeq, progressStatus);
		if(iRslt > 0) {
			String approvalFileSeq = excelService.createBunyangExcelForm(ExcelForms.APPROVAL_FORM, bunyangSeq, "");
//			if(!StringUtils.isEmpty(approvalFileSeq)) {
//				Map<String, Object> param = new HashMap<String, Object>();
//				param.put("bunyangSeq", bunyangSeq);
//				param.put("file_seq_approval", approvalFileSeq);
//				iRslt = adminService.updateBunyangFileSeq(param);
//				bRslt = iRslt > 0;
//			}
			bRslt = iRslt > 0;
		}
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	
	//===============================================================================
	// 사용계약관리
	//===============================================================================
	/** 사용계약관리 메인 페이지  URL */
	public static final String CONTRACT_MGMT_URL = "/contractmgmt";
	/** 사용계약관리 상세 정보 페이지  URL */
	public static final String CONTRACT_DETAIL_URL = "/contractdetail";
	/** 계약 승인 처리 URL */
	public static final String APPR_CONTRACT_URL = "/apprcontract";
	/** 잔금 납부 처리 URL */
	public static final String SAVE_BALANCE_PAYMENT_URL = "/savebalancepayment";
	
	/** 
	 * 사용계약관리 메인 페이지 
	 */
	@RequestMapping(value=CONTRACT_MGMT_URL)
	public Object contractMgmtHandler(SearchVo searchVo) {
		List<Object> menuList = adminService.getMenuList("");
		List<Object> contractList = adminService.getContractList(searchVo);
		searchVo.setTotalCount(CommonUtil.getPaingTotalCount(contractList, "total_count"));
		ModelAndView mv = new ModelAndView();
		mv.addObject("menuList", menuList);
		mv.addObject("menuSeq", "MENU01_02");
		mv.addObject("pmenuSeq", "MENU01");
		mv.addObject("searchVo", searchVo);
		mv.addObject("contractList", contractList);
		mv.setViewName(ROOT_URL + CONTRACT_MGMT_URL);
		return mv;
	}
	
	/** 
	 * 사용계약관리 상세 정보 페이지
	 */
	@RequestMapping(value=CONTRACT_DETAIL_URL)
	public Object contractDetailHandler(SearchVo searchVo, String bunyangSeq) {
		List<Object> menuList = adminService.getMenuList("");
		ModelAndView mv = new ModelAndView();
		List<Object> paymentList = null;
		mv.addObject("menuList", menuList);
		mv.addObject("menuSeq", "MENU01_02");
		mv.addObject("pmenuSeq", "MENU01");
		mv.addObject("bunyangSeq", bunyangSeq);
		mv.addObject("searchVo", searchVo);
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
		mv.setViewName(ROOT_URL + CONTRACT_DETAIL_URL);
		return mv;
	}
	
	/** 
	 * 계약 승인 처리
	 */
	@RequestMapping(value=APPR_CONTRACT_URL)
	@ResponseBody
	public Object apprContractHandler(String bunyangSeq, int paymentAmount, String paymentMethod, String paymentDate) {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int iRslt = adminService.updateDownPayment(bunyangSeq, paymentAmount, paymentMethod, paymentDate);
		if(iRslt > 0) {
			String fileSeq = excelService.createBunyangExcelForm(ExcelForms.CONTRACT_FORM, bunyangSeq, "");
			if(!StringUtils.isEmpty(fileSeq)) {
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("bunyangSeq", bunyangSeq);
				param.put("file_seq_contract", fileSeq);
				iRslt = adminService.updateBunyangFileSeq(param);
				bRslt = iRslt > 0;
			}
		}
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	/** 
	 * 잔급 납부 처리
	 */
	@RequestMapping(value=SAVE_BALANCE_PAYMENT_URL)
	@ResponseBody
	public Object saveBalancePaymentHandler(
			@RequestParam(value="bunyangSeq") String bunyangSeq,
			@RequestParam(value="paymentAmount[]") int[] paymentAmount,
			@RequestParam(value="paymentMethod[]") String[] paymentMethod,
			@RequestParam(value="paymentDate[]") String[] paymentDate
			) {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int iRslt = adminService.updateBalancePayment(bunyangSeq, paymentAmount, paymentMethod, paymentDate);
		if(iRslt > 0) {
			String fileSeq = excelService.createBunyangExcelForm(ExcelForms.CONTRACT_FORM, bunyangSeq, "");
			if(!StringUtils.isEmpty(fileSeq)) {
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("bunyangSeq", bunyangSeq);
				param.put("file_seq_contract", fileSeq);
				iRslt = adminService.updateBunyangFileSeq(param);
				bRslt = iRslt > 0;
			}
		}
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	
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
