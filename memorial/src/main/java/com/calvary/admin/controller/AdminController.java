package com.calvary.admin.controller;

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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.calvary.admin.service.IAdminService;
import com.calvary.admin.vo.BunyangInfoVo;
import com.calvary.common.constant.CalvaryConstants;
import com.calvary.common.service.ICommonService;
import com.calvary.common.util.SessionUtil;
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
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		List<Object> applyList = adminService.getApplyList(searchVo);
		searchVo.setTotalCount(commonService.getTotalCount());
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU01");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU01_01");
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
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
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU01");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU01_01");
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("submenuName", "분양 신청 등록");
		mv.addObject("menuList", menuList);
		mv.addObject("codeUserRelation", commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_USER_RELATION));
		mv.setViewName(ROOT_URL + APPLY_REGIST_URL);
		return mv;
	}
	
	/** 
	 * 분양신청 상세 정보 페이지 
	 */
	@RequestMapping(value=APPLY_DETAIL_URL)
	public Object applyDetailHandler(SearchVo searchVo, String bunyangSeq) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU01");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU01_01");
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("submenuName", "분양신청 상세 정보");
		mv.addObject("menuList", menuList);
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
		int iRslt = adminService.updateBunyangProgressStatus(bunyangSeq, progressStatus, SessionUtil.getCurrentUserId());
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
		int iRslt = adminService.updateBunyangProgressStatus(bunyangSeq, progressStatus, SessionUtil.getCurrentUserId());
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
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		List<Object> contractList = adminService.getContractList(searchVo);
		searchVo.setTotalCount(commonService.getTotalCount());
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU01");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU01_02");
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
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
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		ModelAndView mv = new ModelAndView();
		List<Object> paymentList = null;
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU01");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU01_02");
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("submenuName", "계약 상세 정보");
		mv.addObject("menuList", menuList);
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
		mv.addObject("totalPaymentInfo", adminService.getTotalPayment(bunyangSeq));
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
			@RequestParam(value="paymentAmount[]", required=false) int[] paymentAmount,
			@RequestParam(value="paymentMethod[]", required=false) String[] paymentMethod,
			@RequestParam(value="paymentDate[]", required=false) String[] paymentDate,
			@RequestParam(value="isFullPayment") boolean isFullPayment
			) {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int iRslt = adminService.updateBalancePayment(bunyangSeq, paymentAmount, paymentMethod, paymentDate, isFullPayment);
		if(iRslt > 0) {
			String fileSeq = excelService.createBunyangExcelForm(ExcelForms.CONTRACT_FORM, bunyangSeq, "");
			if(!StringUtils.isEmpty(fileSeq)) {
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("bunyangSeq", bunyangSeq);
				param.put("file_seq_contract", fileSeq);
				iRslt = adminService.updateBunyangFileSeq(param);
				bRslt = iRslt > 0;
			}
			if(isFullPayment) {
				fileSeq = excelService.createBunyangExcelForm(ExcelForms.FULL_PAYMENT_FORM, bunyangSeq, "");
				if(!StringUtils.isEmpty(fileSeq)) {
					Map<String, Object> param = new HashMap<String, Object>();
					param.put("bunyangSeq", bunyangSeq);
					param.put("file_seq_full_payment", fileSeq);
					iRslt = adminService.updateBunyangFileSeq(param);
					bRslt = iRslt > 0;
				}
			}
		}
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	
	
	//===============================================================================
	// 사용승인관리
	//===============================================================================
	/** 사용승인관리 메인 페이지  URL */
	public static final String APPROVAL_MGMT_URL = "/approvalmgmt";
	/** 사용승인관리 상세 페이지  URL */
	public static final String APPROVAL_DETAIL_URL = "/approvaldetail";
	/** 사용승인  URL */
	public static final String USE_APPROVAL_URL = "/useapproval";
	
	/** 
	 * 사용승인관리 메인 페이지 
	 */
	@RequestMapping(value=APPROVAL_MGMT_URL)
	public Object approvalMgmtHandler(SearchVo searchVo) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		List<Object> approvalList = adminService.getApprovalList(searchVo);
		searchVo.setTotalCount(commonService.getTotalCount());
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU01");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU01_03");
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("searchVo", searchVo);
		mv.addObject("approvalList", approvalList);
		mv.setViewName(ROOT_URL + APPROVAL_MGMT_URL);
		return mv;
	}
	
	/** 
	 * 사용승인관리 상세 정보 페이지
	 */
	@RequestMapping(value=APPROVAL_DETAIL_URL)
	public Object approvalDetailHandler(SearchVo searchVo, String bunyangSeq) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		ModelAndView mv = new ModelAndView();
		List<Object> paymentList = null;
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU01");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU01_03");
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
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
		mv.addObject("totalPaymentInfo", adminService.getTotalPayment(bunyangSeq));
		mv.setViewName(ROOT_URL + APPROVAL_DETAIL_URL);
		return mv;
	}
	
	/** 
	 * 사용 승인 처리
	 */
	@RequestMapping(value=USE_APPROVAL_URL)
	@ResponseBody
	public Object useApprovalHandler(String bunyangSeq) {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int iRslt = adminService.updateBunyangProgressStatus(bunyangSeq, CalvaryConstants.PROGRESS_STATUS_D, SessionUtil.getCurrentUserId());
		if(iRslt > 0) {
			String fileSeq = excelService.createBunyangExcelForm(ExcelForms.USE_APPROVAL_FORM, bunyangSeq, "");
			if(!StringUtils.isEmpty(fileSeq)) {
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("bunyangSeq", bunyangSeq);
				param.put("file_seq_use_approval", fileSeq);
				iRslt = adminService.updateBunyangFileSeq(param);
				bRslt = iRslt > 0;
			}
		}
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	
	//===============================================================================
	// 계약자관리
	//===============================================================================
	/** 계약자관리 메인 페이지  URL */
	public static final String CONTRACTOR_MGMT_URL = "/contractormgmt";
	/** 계약자변경 URL */
	public static final String CHANGE_CONTRACTOR_URL = "/changecontractor";
	
	/** 
	 * 계약자관리 메인 페이지 
	 */
	@RequestMapping(value=CONTRACTOR_MGMT_URL)
	public Object contractorMgmtHandler(SearchVo searchVo) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		List<Object> bunyangList = adminService.getBunyangList(searchVo);
		searchVo.setTotalCount(commonService.getTotalCount());
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU01");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU01_04");
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("searchVo", searchVo);
		mv.addObject("bunyangList", bunyangList);
		mv.setViewName(ROOT_URL + CONTRACTOR_MGMT_URL);
		return mv;
	}
	
	/** 
	 * 계약자변경
	 */
	@RequestMapping(value=CHANGE_CONTRACTOR_URL)
	@ResponseBody
	public Object changeContractorHandler(String bunyangSeq, String progressStatus, String userId) {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int iRslt = adminService.updateApplyUser(bunyangSeq, userId);
		if(iRslt > 0) {
			String file_seq_apply = null;// 분양신청서
			String file_seq_approval = null;// 신청승인서
			String file_seq_contract = null;// 사용계약서
			String file_seq_full_payment = null;// 완납확인증명서
			String file_seq_use_approval = null;// 사용승인서
			
			file_seq_apply = excelService.createBunyangExcelForm(ExcelForms.APPLY_FORM, bunyangSeq, "");
			
			if(CalvaryConstants.PROGRESS_STATUS_A.equals(progressStatus)
					|| CalvaryConstants.PROGRESS_STATUS_B.equals(progressStatus)
					|| CalvaryConstants.PROGRESS_STATUS_C.equals(progressStatus)
					|| CalvaryConstants.PROGRESS_STATUS_D.equals(progressStatus)
					) {
				file_seq_approval = excelService.createBunyangExcelForm(ExcelForms.APPROVAL_FORM, bunyangSeq, "");
			}
			if(CalvaryConstants.PROGRESS_STATUS_B.equals(progressStatus)
					|| CalvaryConstants.PROGRESS_STATUS_C.equals(progressStatus)
					|| CalvaryConstants.PROGRESS_STATUS_D.equals(progressStatus)
					) {
				file_seq_contract = excelService.createBunyangExcelForm(ExcelForms.CONTRACT_FORM, bunyangSeq, "");
			}
			if(CalvaryConstants.PROGRESS_STATUS_C.equals(progressStatus)
					|| CalvaryConstants.PROGRESS_STATUS_D.equals(progressStatus)
					) {
				file_seq_full_payment = excelService.createBunyangExcelForm(ExcelForms.FULL_PAYMENT_FORM, bunyangSeq, "");
			}
			if(CalvaryConstants.PROGRESS_STATUS_D.equals(progressStatus)) {
				file_seq_use_approval = excelService.createBunyangExcelForm(ExcelForms.USE_APPROVAL_FORM, bunyangSeq, "");
			}
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("bunyangSeq", bunyangSeq);
			if(!StringUtils.isEmpty(file_seq_apply)) {
				param.put("file_seq_apply", file_seq_apply);
			}
			if(!StringUtils.isEmpty(file_seq_approval)) {
				param.put("file_seq_approval", file_seq_approval);
			}
			if(!StringUtils.isEmpty(file_seq_contract)) {
				param.put("file_seq_contract", file_seq_contract);
			}
			if(!StringUtils.isEmpty(file_seq_full_payment)) {
				param.put("file_seq_full_payment", file_seq_full_payment);
			}
			if(!StringUtils.isEmpty(file_seq_use_approval)) {
				param.put("file_seq_use_approval", file_seq_use_approval);
			}
			iRslt = adminService.updateBunyangFileSeq(param);
			bRslt = iRslt > 0;
		}
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	
	
	//===============================================================================
	// 해약관리
	//===============================================================================
	/** 해약관리 메인 페이지  URL */
	public static final String CANCEL_MGMT_URL = "/cancelmgmt";
	/** 해약승인 URL */
	public static final String CANCEL_APPROVAL_URL = "/cancelapproval";
	
	/** 
	 * 해약관리 메인 페이지 
	 */
	@RequestMapping(value=CANCEL_MGMT_URL)
	public Object cancelMgmtHandler(SearchVo searchVo) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		List<Object> cancelList = adminService.getCancelList(searchVo);
		searchVo.setTotalCount(commonService.getTotalCount());
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU01");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU01_05");
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("searchVo", searchVo);
		mv.addObject("cancelList", cancelList);
		mv.setViewName(ROOT_URL + CANCEL_MGMT_URL);
		return mv;
	}
	
	/** 
	 * 해약승인
	 */
	@RequestMapping(value=CANCEL_APPROVAL_URL)
	@ResponseBody
	public Object cancelApprovalHandler(
			String bunyangSeq
			,int depositAmount
			,String depositPlanDate
			,String depositBank
			,String depositAccount
			,String accountHolder
			,String cancelReason
			) throws Exception {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int iRslt = adminService.updateCancel(bunyangSeq, depositAmount, depositPlanDate, depositBank, depositAccount, accountHolder, cancelReason);
		if(iRslt > 0) {
			String fileSeq = excelService.createBunyangExcelForm(ExcelForms.CANCEL_APPROVAL_FORM, bunyangSeq, "");
			if(!StringUtils.isEmpty(fileSeq)) {
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("bunyangSeq", bunyangSeq);
				param.put("file_seq_cancel", fileSeq);
				adminService.updateBunyangFileSeq(param);
				bRslt = true;
			}
		}
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	
	//===============================================================================
	// 납부관리
	//===============================================================================
	/** 납부관리 메인 페이지  URL */
	public static final String PAYMENT_MGMT_URL = "/paymentmgmt";
		
	/** 
	 * 납부관리 메인 페이지 
	 */
	@RequestMapping(value=PAYMENT_MGMT_URL)
	public Object paymentMgmtHandler(SearchVo searchVo, String paymentType) {
		SimpleDateFormat sf = new SimpleDateFormat("yyyyMMdd");
		// 검색기간은 default 1주일
		if(StringUtils.isEmpty(searchVo.getFromDt()) && StringUtils.isEmpty(searchVo.getToDt())) {
			Calendar cl = Calendar.getInstance();
			cl.add(Calendar.MONTH, -1);
			searchVo.setFromDt(sf.format(cl.getTime()));
			searchVo.setToDt(sf.format(new Date()));
		}
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		List<Object> paymentList = adminService.getPaymentList(searchVo, paymentType);
		searchVo.setTotalCount(commonService.getTotalCount());
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU01");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU01_06");
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("searchVo", searchVo);
		mv.addObject("paymentType", paymentType);
		mv.addObject("paymentList", paymentList);
		mv.setViewName(ROOT_URL + PAYMENT_MGMT_URL);
		return mv;
	}
	
	
	
	//===============================================================================
	// 분양정보 관리
	//===============================================================================
	/** 분양상세정보 페이지  URL */
	public static final String BUNYANG_INFO_URL = "/bunyanginfo";
	/** 분양정보 수정 페이지 URL */
	public static final String BUNYANG_INFO_EDIT_URL = "/bunyanginfoedit";
	
	/** 
	 * 분양상세정보 페이지 
	 */
	@RequestMapping(value=BUNYANG_INFO_URL)
	public Object bunyangInfoHandler(SearchVo searchVo, String menuId, String bunyangSeq, String listUrl) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		ModelAndView mv = new ModelAndView();
		Map<String, Object> menuInfo = null;
		Map<String, Object> pMenuInfo = null;
		List<Object> paymentList = null;
		if(!StringUtils.isEmpty(menuId)) {
			menuInfo = commonService.getMenuInfo(menuId);
		}
		if(menuInfo != null && menuInfo.get("parent_menu_seq") != null) {
			pMenuInfo = commonService.getMenuInfo((String)menuInfo.get("parent_menu_seq"));
		}
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("searchVo", searchVo);
		mv.addObject("bunyangSeq", bunyangSeq);
		mv.addObject("listUrl", listUrl);
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
	
	
	
	//===============================================================================
	// 사용(봉안) 관리
	//===============================================================================
	/** 사용(봉안) 관리 페이지  URL */
	public static final String USE_MGMT_URL = "/usemgmt";
	/** 추모동산 사용현황 리스트 조회  URL */
	public static final String GET_GRAVE_USE_LIST = "/getGraveUseList";
	/** 특정 구역에 배정된 정보 조회  URL */
	public static final String GET_GRAVE_ASSIGN_INFO = "/getGraveAssignInfo";
	
	/** 
	 * 사용(봉안) 관리 페이지
	 */
	@RequestMapping(value=USE_MGMT_URL)
	public Object useMgmtHandler(SearchVo searchVo) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU02");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU02_02");
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("searchVo", searchVo);
		mv.setViewName(ROOT_URL + USE_MGMT_URL);
		return mv;
	}
	
	/** 
	 * 추모동산 사용현황 리스트 조회
	 */
	@RequestMapping(value=GET_GRAVE_USE_LIST)
	@ResponseBody
	public List<Object> getGraveUseListHandler() {
		List<Object> graveUseList = adminService.getGraveUseList();
		return graveUseList;
	}
	
	/** 
	 * 특정 구역에 배정된 정보 조회
	 */
	@RequestMapping(value=GET_GRAVE_ASSIGN_INFO)
	@ResponseBody
	public List<Object> getGraveAssignInfoHandler(String sectionSeq, int rowSeq, int colSeq) {
		List<Object> graveAssignList = adminService.getGraveAssignInfo(sectionSeq, rowSeq, colSeq);
		return graveAssignList;
	}
	
	
	
	//===============================================================================
	// 분양현황
	//===============================================================================
	/** 분양현황  URL */
	public static final String BUNYANG_STATUS_URL = "/bunyangstatus";
		
	/** 
	 * 분양현황 페이지
	 */
	@RequestMapping(value=BUNYANG_STATUS_URL)
	public Object bunyangStatusHandler(SearchVo searchVo) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU03");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU03_01");
		List<Object> bunyangList = adminService.getBunyangList(searchVo);
		searchVo.setTotalCount(commonService.getTotalCount());
		Map<String, Object> statusByGraveType = adminService.getStatusByGraveType();
		Map<String, Object> statusByProductType = adminService.getStatusByProductType();
		Map<String, Object> statusByProgress = adminService.getStatusByProgress();
		ModelAndView mv = new ModelAndView();
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("bunyangList", bunyangList);
		mv.addObject("searchVo", searchVo);
		mv.addObject("statusByGraveType", statusByGraveType);
		mv.addObject("statusByProductType", statusByProductType);
		mv.addObject("statusByProgress", statusByProgress);
		mv.setViewName(ROOT_URL + BUNYANG_STATUS_URL);
		return mv;
	}
	
	
	//===============================================================================
	// 대금납부현황
	//===============================================================================
	/** 대금납부현황  URL */
	public static final String PAYMENT_STATUS_URL = "/paymentstatus";
	
	/** 
	 * 대금납부현황 페이지
	 */
	@RequestMapping(value=PAYMENT_STATUS_URL)
	public Object paymentStatusHandler(SearchVo searchVo) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU03");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU03_02");
		List<Object> bunyangList = adminService.getBunyangList(searchVo);
		searchVo.setTotalCount(commonService.getTotalCount());
		Map<String, Object> statusByGraveType = adminService.getStatusByGraveType();
		Map<String, Object> statusByProductType = adminService.getStatusByProductType();
		Map<String, Object> paymentStatus = adminService.getPaymentStatus();
		ModelAndView mv = new ModelAndView();
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("bunyangList", bunyangList);
		mv.addObject("searchVo", searchVo);
		mv.addObject("statusByGraveType", statusByGraveType);
		mv.addObject("statusByProductType", statusByProductType);
		mv.addObject("paymentStatus", paymentStatus);
		mv.setViewName(ROOT_URL + PAYMENT_STATUS_URL);
		return mv;
	}
	
	
	//===============================================================================
	// 관리비납부현황
	//===============================================================================
	/** 관리비납부현황  URL */
	public static final String MAINT_PAYMENT_STATUS_URL = "/maintPaymentStatus";
	
	/** 
	 * 관리비납부현황 페이지
	 */
	@RequestMapping(value=MAINT_PAYMENT_STATUS_URL)
	public Object maintPaymentStatusHandler(SearchVo searchVo) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU03");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU03_03");
		List<Object> maintPaymentList = adminService.getMaintPaymentList(searchVo);
		searchVo.setTotalCount(commonService.getTotalCount());
		Map<String, Object> maintPaymentStatus = adminService.getMaintPaymentStatus();
		ModelAndView mv = new ModelAndView();
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("maintPaymentList", maintPaymentList);
		mv.addObject("searchVo", searchVo);
		mv.addObject("maintPaymentStatus", maintPaymentStatus);
		mv.setViewName(ROOT_URL + MAINT_PAYMENT_STATUS_URL);
		return mv;
	}
	
	
	//===============================================================================
	// 공통
	//===============================================================================
	/** 분양리스트 조회용 select2 ajax URL */
	public static final String GET_BUNYANG_SELECT_LIST_URL = "/getBunyangSelectList";
	
	
	/** 
	 * 분양리스트 조회용 select2 ajax 처리
	 */
	@RequestMapping(value=GET_BUNYANG_SELECT_LIST_URL)
	@ResponseBody
	public Map<String, Object> getBunyangSelectListHandler(String searchVal, int pageIndex) {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		List<Object> bunyangList = adminService.getBunyangSelectList(searchVal, pageIndex);
		int total_count = commonService.getTotalCount();
		rtnMap.put("result", bunyangList);
		rtnMap.put("total_count", total_count);
		return rtnMap;
	}
	
	
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
