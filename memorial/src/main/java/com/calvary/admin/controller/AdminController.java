package com.calvary.admin.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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
import com.calvary.admin.vo.BunyangUserVo;
import com.calvary.common.constant.CalvaryConstants;
import com.calvary.common.service.ICommonService;
import com.calvary.common.util.CommonUtil;
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
	/** 취소 URL */
	public static final String CANCEL_URL = "/cancel";
	
	/** 
	 * 분양신청관리 메인 페이지 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value=APPLY_MGMT_URL)
	public Object applyMgmtHandler(SearchVo searchVo) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		List<Object> bunyangTimesList = commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_BUNYANG_TIMES);
//		if(searchVo.getBunyangTimes() <= 0 && bunyangTimesList != null && bunyangTimesList.size() > 0) {
//			searchVo.setBunyangTimes(CommonUtil.convertToInt(((Map<String, Object>)bunyangTimesList.get(0)).get("code_seq")));
//		}
		Map<String, Object> rtnMap = adminService.getApplyList(searchVo);
		List<Object> applyList = (ArrayList<Object>)rtnMap.get("list");
		int total_count = CommonUtil.convertToInt(rtnMap.get("total_count"));
		searchVo.setTotalCount(total_count);
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU01");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU01_01");
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("searchVo", searchVo);
		mv.addObject("applyList", applyList);
		mv.addObject("bunyangTimesList", bunyangTimesList);
		mv.setViewName(ROOT_URL + APPLY_MGMT_URL);
		return mv;
	}
	
	/** 
	 * 분양 신청정보 등록 페이지 
	 */
	@RequestMapping(value=APPLY_REGIST_URL)
	public Object applyRegistHandler(SearchVo searchVo) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		List<Object> bunyangTimesList = commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_BUNYANG_TIMES, "Y");
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU01");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU01_01");
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("submenuName", "분양 신청 등록");
		mv.addObject("menuList", menuList);
		mv.addObject("codeUserRelation", commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_USER_RELATION));
		mv.addObject("bunyangTimesList", bunyangTimesList);
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
		Map<String, Object> bunyangInfo = adminService.getBunyangInfo(bunyangSeq);
		String group_seq = null;
		if(bunyangInfo != null) {
			group_seq = String.valueOf(bunyangInfo.get("group_seq"));
		}
		List<Object> addedBunyangList = adminService.getAddedBunyangList(group_seq, bunyangSeq);
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("submenuName", "분양신청 상세 정보");
		mv.addObject("menuList", menuList);
		mv.addObject("bunyangSeq", bunyangSeq);
		mv.addObject("searchVo", searchVo);
		mv.addObject("bunyangInfo", bunyangInfo);// 분양정보
		mv.addObject("addedBunyangList", addedBunyangList);// 추가 분양 리스트
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
	public Object saveApplyHandler(@RequestBody BunyangInfoVo bunyangInfoVo) throws Exception {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String bunyangSeq = adminService.createBunyangInfo(bunyangInfoVo, null);
		if(!StringUtils.isEmpty(bunyangSeq)) {
			String applyFileSeq = excelService.createBunyangExcelForm(ExcelForms.APPLY_FORM, bunyangSeq, "", "");
			String useUserFileSeq = excelService.createBunyangExcelForm(ExcelForms.USE_USER_FORM, bunyangSeq, "", "");
			if(!StringUtils.isEmpty(applyFileSeq) && !StringUtils.isEmpty(useUserFileSeq)) {
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("bunyangSeq", bunyangSeq);
				param.put("file_seq_apply", applyFileSeq);
				param.put("file_seq_use_user", useUserFileSeq);
				int iRslt = adminService.updateBunyangFileSeq(param);
				bRslt = iRslt > 0;
			}
			// 무료분양인 경우 즉시 완납상태까지 진행
			if(CommonUtil.isFreeBunyang(bunyangInfoVo)) {
				String updateDate = new SimpleDateFormat("yyyyMMdd").format(new Date());
				bunyangInfoVo.setBunyangSeq(bunyangSeq);
				// 신청 승인
				approvalHandler(bunyangInfoVo);
				// 계약 승인
				apprContractHandler(bunyangSeq, CalvaryConstants.PROGRESS_STATUS_B, updateDate);
				// 완납 승인
				apprContractHandler(bunyangSeq, CalvaryConstants.PROGRESS_STATUS_C, updateDate);
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
	public Object approvalHandler(@RequestBody BunyangInfoVo bunyangInfoVo) throws Exception {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String bunyangNo = adminService.getNextBunyangNo(bunyangInfoVo.getBunyangTimes());
		bunyangInfoVo.setBunyangNo(bunyangNo);
		int iRslt = adminService.updateBunyangProgressStatus(bunyangInfoVo, SessionUtil.getCurrentUserId(), null);
		String approvalFileSeq = null;
		if(iRslt > 0) {
			approvalFileSeq = excelService.createBunyangExcelForm(ExcelForms.APPROVAL_FORM, bunyangInfoVo.getBunyangSeq(), "", "");
			if(!StringUtils.isEmpty(approvalFileSeq)) {
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("bunyangSeq", bunyangInfoVo.getBunyangSeq());
				param.put("file_seq_approval", approvalFileSeq);
				iRslt = adminService.updateBunyangFileSeq(param);
				bRslt = iRslt > 0;
			}
		}
		rtnMap.put("result", bRslt);
		rtnMap.put("fileSeq", approvalFileSeq);
		return rtnMap;
	}
	
	/** 
	 * 반려
	 */
	@RequestMapping(value=REJECT_URL)
	@ResponseBody
	public Object rejectHandler(@RequestBody BunyangInfoVo bunyangInfoVo) throws Exception {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int iRslt = adminService.updateBunyangProgressStatus(bunyangInfoVo, SessionUtil.getCurrentUserId(), null);
		bRslt = iRslt > 0;
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	/** 
	 * 취소
	 */
	@RequestMapping(value=CANCEL_URL)
	@ResponseBody
	public Object cancelHandler(@RequestBody BunyangInfoVo bunyangInfoVo) throws Exception {
		boolean bRslt = false;
		String progressStatus = bunyangInfoVo.getProgressStatus();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int iRslt = 0;
		if(CalvaryConstants.PROGRESS_STATUS_NEW.equals(progressStatus)) {// 신청(미승인)건은 데이터삭제
			iRslt = adminService.deleteBunyangInfo(bunyangInfoVo, SessionUtil.getCurrentUserId());
		} else {// 그외건은 상태를 취소상태로 변경
			iRslt = adminService.cancelBunyangInfo(bunyangInfoVo, SessionUtil.getCurrentUserId());
		}
		bRslt = iRslt > 0;
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
	@SuppressWarnings("unchecked")
	@RequestMapping(value=CONTRACT_MGMT_URL)
	public Object contractMgmtHandler(SearchVo searchVo) {
		if(StringUtils.isEmpty(searchVo.getProgressStatus())) {// 초기 상태값은 신청승인
			searchVo.setProgressStatus(CalvaryConstants.PROGRESS_STATUS_A);
		}
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		List<Object> bunyangTimesList = commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_BUNYANG_TIMES);
		Map<String, Object> rtnMap = adminService.getContractList(searchVo);
		List<Object> contractList = (ArrayList<Object>)rtnMap.get("list");
		int total_count = CommonUtil.convertToInt(rtnMap.get("total_count"));
		searchVo.setTotalCount(total_count);
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU01");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU01_02");
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("searchVo", searchVo);
		mv.addObject("contractList", contractList);
		mv.addObject("bunyangTimesList", bunyangTimesList);
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
		Map<String, Object> bunyangInfo = adminService.getBunyangInfo(bunyangSeq);
		String group_seq = null;
		if(bunyangInfo != null) {
			group_seq = String.valueOf(bunyangInfo.get("group_seq"));
		}
		List<Object> addedBunyangList = adminService.getAddedBunyangList(group_seq, bunyangSeq);
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("submenuName", "계약 상세 정보");
		mv.addObject("menuList", menuList);
		mv.addObject("bunyangSeq", bunyangSeq);
		mv.addObject("searchVo", searchVo);
		mv.addObject("bunyangInfo", bunyangInfo);// 분양정보
		mv.addObject("addedBunyangList", addedBunyangList);// 추가 분양 리스트
		mv.addObject("applyUser", adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_APPLY_USER));// 신청자정보
		mv.addObject("agentUser", adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_AGENT_USER));// 대리신청인정보
		mv.addObject("useUser", adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_USE_USER));// 사용(봉안) 대상자 정보
		mv.addObject("fileList", adminService.getBunyangFileList(bunyangSeq));// 분양 파일 양식 리스트
		paymentList = adminService.getPaymentHistory(bunyangSeq, CalvaryConstants.PAYMENT_TYPE_DOWN_PAYMENT);// 계약금
		paymentList.addAll(adminService.getPaymentHistory(bunyangSeq, CalvaryConstants.PAYMENT_TYPE_BALANCE_PAYMENT));// 분양잔금
		mv.addObject("paymentList", paymentList);
		mv.addObject("totalPaymentInfo", adminService.getTotalPayment(bunyangSeq));
		mv.setViewName(ROOT_URL + CONTRACT_DETAIL_URL);
		return mv;
	}
	
	/** 
	 * 계약 승인 처리
	 */
	@RequestMapping(value=APPR_CONTRACT_URL)
	@ResponseBody
	public Object apprContractHandler(String bunyangSeq, String progressStatus, String updateDate) throws Exception {
		boolean bRslt = false;
		String fileSeq = null;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		Map<String, Object> param = null;
		BunyangInfoVo bunyangInfoVo = new BunyangInfoVo();
		bunyangInfoVo.setBunyangSeq(bunyangSeq);
		bunyangInfoVo.setProgressStatus(progressStatus);
		int iRslt = adminService.updateBunyangProgressStatus(bunyangInfoVo, SessionUtil.getCurrentUserId(), updateDate);
		if(iRslt > 0) {
			if(CalvaryConstants.PROGRESS_STATUS_B.equals(progressStatus)) {
				fileSeq = excelService.createBunyangExcelForm(ExcelForms.CONTRACT_FORM, bunyangSeq, "", "");
				if(!StringUtils.isEmpty(fileSeq)) {
					param = new HashMap<String, Object>();
					param.put("bunyangSeq", bunyangSeq);
					param.put("file_seq_contract", fileSeq);
					iRslt = adminService.updateBunyangFileSeq(param);
				}
				bRslt = true;
			} else if(CalvaryConstants.PROGRESS_STATUS_C.equals(progressStatus)) {
				fileSeq = excelService.createBunyangExcelForm(ExcelForms.CONTRACT_FORM, bunyangSeq, "", "");
				if(!StringUtils.isEmpty(fileSeq)) {
					param = new HashMap<String, Object>();
					param.put("bunyangSeq", bunyangSeq);
					param.put("file_seq_contract", fileSeq);
					iRslt = adminService.updateBunyangFileSeq(param);
				}
				fileSeq = excelService.createBunyangExcelForm(ExcelForms.FULL_PAYMENT_FORM, bunyangSeq, "", "");
				if(!StringUtils.isEmpty(fileSeq)) {
					param = new HashMap<String, Object>();
					param.put("bunyangSeq", bunyangSeq);
					param.put("file_seq_full_payment", fileSeq);
					iRslt = adminService.updateBunyangFileSeq(param);
				}
				bRslt = true;
			}
		}
		rtnMap.put("result", bRslt);
		rtnMap.put("fileSeq", fileSeq);
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
			) throws Exception {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int iRslt = adminService.updateBalancePayment(bunyangSeq, paymentAmount, paymentMethod, paymentDate, null, isFullPayment);
		if(iRslt > 0) {
			String fileSeq = excelService.createBunyangExcelForm(ExcelForms.CONTRACT_FORM, bunyangSeq, "", "");
			if(!StringUtils.isEmpty(fileSeq)) {
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("bunyangSeq", bunyangSeq);
				param.put("file_seq_contract", fileSeq);
				iRslt = adminService.updateBunyangFileSeq(param);
				bRslt = iRslt > 0;
			}
			if(isFullPayment) {
				fileSeq = excelService.createBunyangExcelForm(ExcelForms.FULL_PAYMENT_FORM, bunyangSeq, "", "");
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
	/** 사용자 승인  URL */
	public static final String SAVE_USER_APPROVAL_URL = "/saveUserApproval";
	/** 용인공원 확약번호 저장  URL */
	public static final String SAVE_YONGIN_NO_URL = "/saveYonginNo";
	/** 사용자 승인서 출력  URL */
	public static final String EXPORT_USER_APPROVAL_URL = "/exportUserApproval";
	/** 분양정보 사용 승인  URL */
	public static final String APPROVAL_BUNYANG_INFO_URL = "/approvalBunyangInfo";
	
	/** 
	 * 사용승인관리 메인 페이지 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value=APPROVAL_MGMT_URL)
	public Object approvalMgmtHandler(SearchVo searchVo) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		List<Object> bunyangTimesList = commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_BUNYANG_TIMES);
		Map<String, Object> rtnMap = adminService.getApprovalList(searchVo);
		List<Object> approvalList = (ArrayList<Object>)rtnMap.get("list");
		int total_count = CommonUtil.convertToInt(rtnMap.get("total_count"));
		searchVo.setTotalCount(total_count);
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU01");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU01_03");
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("searchVo", searchVo);
		mv.addObject("bunyangTimesList", bunyangTimesList);
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
		Map<String, Object> bunyangInfo = adminService.getBunyangInfo(bunyangSeq);
		String group_seq = null;
		if(bunyangInfo != null) {
			group_seq = String.valueOf(bunyangInfo.get("group_seq"));
		}
		List<Object> addedBunyangList = adminService.getAddedBunyangList(group_seq, bunyangSeq);
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("bunyangSeq", bunyangSeq);
		mv.addObject("searchVo", searchVo);
		mv.addObject("bunyangInfo", bunyangInfo);// 분양정보
		mv.addObject("addedBunyangList", addedBunyangList);// 추가연결된 분양리스트
		mv.addObject("applyUser", adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_APPLY_USER));// 신청자정보
		mv.addObject("agentUser", adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_AGENT_USER));// 대리신청인정보
		mv.addObject("useUser", adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_USE_USER));// 사용(봉안) 대상자 정보
		mv.addObject("fileList", adminService.getBunyangFileList(bunyangSeq));// 분양 파일 양식 리스트
		paymentList = adminService.getPaymentHistory(bunyangSeq, CalvaryConstants.PAYMENT_TYPE_DOWN_PAYMENT);// 계약금
		paymentList.addAll(adminService.getPaymentHistory(bunyangSeq, CalvaryConstants.PAYMENT_TYPE_BALANCE_PAYMENT));// 분양잔금
		mv.addObject("paymentList", paymentList);
		mv.addObject("totalPaymentInfo", adminService.getTotalPayment(bunyangSeq));
		mv.setViewName(ROOT_URL + APPROVAL_DETAIL_URL);
		return mv;
	}
	
	/** 
	 * 사용자 승인 처리
	 */
	@RequestMapping(value=SAVE_USER_APPROVAL_URL)
	@ResponseBody
	public Object saveUserApprovalHandler(String bunyangSeq, String userId, String approvalNo, String yonginNo, String approvalDate) throws Exception {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
//		BunyangInfoVo bunyangInfoVo = new BunyangInfoVo();
//		bunyangInfoVo.setBunyangSeq(bunyangSeq);
//		bunyangInfoVo.setProgressStatus(CalvaryConstants.PROGRESS_STATUS_D);
//		int iRslt = adminService.updateBunyangProgressStatus(bunyangInfoVo, SessionUtil.getCurrentUserId(), null);
//		if(iRslt > 0) {
//			String fileSeq = excelService.createBunyangExcelForm(ExcelForms.USE_APPROVAL_FORM, bunyangSeq, "");
//			if(!StringUtils.isEmpty(fileSeq)) {
//				Map<String, Object> param = new HashMap<String, Object>();
//				param.put("bunyangSeq", bunyangSeq);
//				param.put("file_seq_use_approval", fileSeq);
//				iRslt = adminService.updateBunyangFileSeq(param);
//				bRslt = iRslt > 0;
//			}
//		}
		int existCount = adminService.checkDuplicatedYonginNo(yonginNo);
		if(existCount > 0) {
			rtnMap.put("existno", true);
		} else {
			int iRslt = adminService.approvalUser(bunyangSeq, userId, approvalNo, yonginNo, approvalDate);
			bRslt = iRslt > 0;
		}
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	/** 
	 * 용인공원 확약번호 저장
	 */
	@RequestMapping(value=SAVE_YONGIN_NO_URL)
	@ResponseBody
	public Object saveYonginNoHandler(String bunyangSeq, String userId, String yonginNo) throws Exception {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int iRslt = adminService.saveYonginNo(bunyangSeq, userId, yonginNo);
		bRslt = iRslt > 0;
		// 확약번호 저장 성공 했을 경우 엑셀 파일도 업데이트 해줌
		if(bRslt) {
			Map<String, Object> userMap = adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_USE_USER, userId);
			Map<String, Object> bunyangInfo = adminService.getBunyangInfo(bunyangSeq);
			Map<String, Object> coupleUserMap = null;
			// 1. 분양신청-사용자 엑셀파일의 승인번호 업데이트
			if(bunyangInfo != null) {
				String useUserFileSeq = (String)bunyangInfo.get("file_seq_use_user");
				excelService.createBunyangExcelForm(ExcelForms.USE_USER_FORM, bunyangSeq, useUserFileSeq, "");
			}
			// 2. 생성된 사용승인서 파일이 있을 경우 업데이트
			String approvalFileSeq = (String)userMap.get("approval_file_seq");
			if(!StringUtils.isEmpty(approvalFileSeq)) {
				excelService.createBunyangExcelForm(ExcelForms.USE_APPROVAL_FORM, bunyangSeq, approvalFileSeq, userId);
			}
			// 3. 배우자 사용승인서 파일이 있을 경우 업데이트
			int coupleSeq = CommonUtil.convertToInt(userMap.get("couple_seq"));
			if(coupleSeq > 0 ) {
				coupleUserMap = adminService.getCoupleUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_USE_USER, userId, coupleSeq);
				if(coupleUserMap != null) {
					String coupleUserId = (String)coupleUserMap.get("user_id");
					String coupleFileSeq = (String)coupleUserMap.get("approval_file_seq");
					if(!StringUtils.isEmpty(coupleFileSeq)) {
						excelService.createBunyangExcelForm(ExcelForms.USE_APPROVAL_FORM, bunyangSeq, coupleFileSeq, coupleUserId);
					}
				}
			}
		}
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	/** 
	 * 사용자 승인서 출력
	 */
	@RequestMapping(value=EXPORT_USER_APPROVAL_URL)
	@ResponseBody
	public Object exportUserApprovalHandler(String bunyangSeq, String userId) throws Exception {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		Map<String, Object> userMap = adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_USE_USER, userId);
		Map<String, Object> bunyangInfo = adminService.getBunyangInfo(bunyangSeq);
		Map<String, Object> coupleUserMap = null;
		int coupleSeq = CommonUtil.convertToInt(userMap.get("couple_seq"));
		// 사용승인서 엑셀파일 생성
		String fileSeq = excelService.createBunyangExcelForm(ExcelForms.USE_APPROVAL_FORM, bunyangSeq, "", userId);
		if(bunyangInfo != null) {
			String useUserFileSeq = (String)bunyangInfo.get("file_seq_use_user");
			// 분양신청-사용자 엑셀파일의 승인번호 업데이트
			excelService.createBunyangExcelForm(ExcelForms.USE_USER_FORM, bunyangSeq, useUserFileSeq, "");
		}
		if(!StringUtils.isEmpty(fileSeq)) {
			// 사용(봉안)자의 사용승인서 파일 시퀀스 업데이트
			adminService.updateUseUserFileSeq(fileSeq, bunyangSeq, userId);
			// 배우자가 있고 배우자의 사용승인서 파일이 있을 경우 같이 업데이트해줌
			if(coupleSeq > 0 ) {
				coupleUserMap = adminService.getCoupleUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_USE_USER, userId, coupleSeq);
				if(coupleUserMap != null) {
					String coupleUserId = (String)coupleUserMap.get("user_id");
					String coupleFileSeq = (String)coupleUserMap.get("approval_file_seq");
					if(!StringUtils.isEmpty(coupleFileSeq)) {
						excelService.createBunyangExcelForm(ExcelForms.USE_APPROVAL_FORM, bunyangSeq, coupleFileSeq, coupleUserId);
					}
				}
			}
		}
		int iRslt = adminService.updateApprovalAssignDate(bunyangSeq, userId);
		bRslt = iRslt > 0;
		rtnMap.put("result", bRslt);
		rtnMap.put("fileSeq", fileSeq);
		return rtnMap;
	}
	
	/** 
	 * 분양정보 사용 승인
	 */
	@RequestMapping(value=APPROVAL_BUNYANG_INFO_URL)
	@ResponseBody
	public Object approvalBunyangInfoHandler(String bunyangSeq, String approvalDate) throws Exception {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		BunyangInfoVo bunyangInfoVo = new BunyangInfoVo();
		bunyangInfoVo.setBunyangSeq(bunyangSeq);
		bunyangInfoVo.setProgressStatus(CalvaryConstants.PROGRESS_STATUS_D);
		int iRslt = adminService.updateBunyangProgressStatus(bunyangInfoVo, SessionUtil.getCurrentUserId(), approvalDate);
		if(iRslt > 0) {
			Map<String, Object> tmp = adminService.getBunyangInfo(bunyangSeq);
			// 해당 분양차수의 분양 시작일로 관리비 납부 정보를 생성
			String startDate = adminService.getBunyangStartDate(CommonUtil.convertToInt(tmp.get("bunyang_times")));
			// 사용승인 이후 관리비가 발생하기 때문에 관리비 납부여부 체크를 위한 정보를 생성한다.
			iRslt += adminService.createMaintPaymentInfo(bunyangSeq, StringUtils.isEmpty(startDate) ? approvalDate : startDate);
		}
		bRslt = iRslt > 0;
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	
	//===============================================================================
	// 계약자관리
	//===============================================================================
	/** 계약자관리 메인 페이지  URL */
	public static final String CONTRACTOR_MGMT_URL = "/contractormgmt";
	/** 계약자관리 상세 페이지  URL */
	public static final String CONTRACTOR_DETAIL_URL = "/contractordetail";
	/** 계약자정보변경 URL */
	public static final String CHANGE_CONTRACT_INFO_URL = "/changeContractInfo";
	
	/** 
	 * 계약자관리 메인 페이지 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value=CONTRACTOR_MGMT_URL)
	public Object contractorMgmtHandler(SearchVo searchVo) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		List<Object> bunyangTimesList = commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_BUNYANG_TIMES);
		Map<String, Object> rtnMap = adminService.getContractorList(searchVo);
		List<Object> contractList = (ArrayList<Object>)rtnMap.get("list");
		int total_count = CommonUtil.convertToInt(rtnMap.get("total_count"));
		searchVo.setTotalCount(total_count);
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU01");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU01_04");
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("searchVo", searchVo);
		mv.addObject("contractList", contractList);
		mv.addObject("bunyangTimesList", bunyangTimesList);
		mv.setViewName(ROOT_URL + CONTRACTOR_MGMT_URL);
		return mv;
	}
	
	/** 
	 * 계약자관리 상세 정보 페이지
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value=CONTRACTOR_DETAIL_URL)
	public Object contractorDetailHandler(SearchVo searchVo, String bunyangSeq) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		ModelAndView mv = new ModelAndView();
		List<Object> paymentList = null;
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU01");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU01_04");
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("submenuName", "계약 상세 정보");
		mv.addObject("menuList", menuList);
		mv.addObject("bunyangSeq", bunyangSeq);
		mv.addObject("searchVo", searchVo);
		
		List<Object> applyUserList = adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_APPLY_USER);
		List<Object> agentUserList = adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_AGENT_USER);
		Map<String, Object> applyUser = null;
		Map<String, Object> agentUser = null;
		if(applyUserList != null && applyUserList.size() > 0) {
			applyUser = (HashMap<String, Object>)applyUserList.get(0);
		}
		if(agentUserList != null && agentUserList.size() > 0) {
			agentUser = (HashMap<String, Object>)agentUserList.get(0);
		}
		Map<String, Object> bunyangInfo = adminService.getBunyangInfo(bunyangSeq);
		String group_seq = null;
		if(bunyangInfo != null) {
			group_seq = String.valueOf(bunyangInfo.get("group_seq"));
		}
		List<Object> addedBunyangList = adminService.getAddedBunyangList(group_seq, bunyangSeq);
		mv.addObject("bunyangInfo", bunyangInfo);// 분양정보
		mv.addObject("addedBunyangList", addedBunyangList);// 추가 분양 리스트
		mv.addObject("applyUser", applyUser);// 신청자정보
		mv.addObject("agentUser", agentUser);// 대리신청인정보
		mv.addObject("useUser", adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_USE_USER));// 사용(봉안) 대상자 정보
		mv.addObject("fileList", adminService.getBunyangFileList(bunyangSeq));// 분양 파일 양식 리스트
		paymentList = adminService.getPaymentHistory(bunyangSeq, CalvaryConstants.PAYMENT_TYPE_DOWN_PAYMENT);// 계약금
		paymentList.addAll(adminService.getPaymentHistory(bunyangSeq, CalvaryConstants.PAYMENT_TYPE_BALANCE_PAYMENT));// 분양잔금
		mv.addObject("paymentList", paymentList);
		mv.addObject("totalPaymentInfo", adminService.getTotalPayment(bunyangSeq));
		mv.setViewName(ROOT_URL + CONTRACTOR_DETAIL_URL);
		return mv;
	}
	
	/** 
	 * 계약자정보변경
	 */
	@RequestMapping(value=CHANGE_CONTRACT_INFO_URL)
	@ResponseBody
	public Object changeContractInfoHandler(@RequestBody BunyangInfoVo bunyangInfoVo) throws Exception{
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String bunyangSeq = bunyangInfoVo.getBunyangSeq();
		// 계약정보 및 관련 사용자 정보 업데이트
		int iRslt = adminService.updateContractInfo(bunyangInfoVo);
		// 엑셀양식 업데이트
		if(iRslt > 0) {
			// 분양신청서
			String file_seq_apply = excelService.createBunyangExcelForm(ExcelForms.APPLY_FORM, bunyangSeq, "", "");
			// 분양신청서-사용자
			String file_seq_use_user = excelService.createBunyangExcelForm(ExcelForms.USE_USER_FORM, bunyangSeq, "", "");
			// 신청승인서
			String file_seq_approval = excelService.createBunyangExcelForm(ExcelForms.APPROVAL_FORM, bunyangSeq, "", "");
			// 분양계약서
			String file_seq_contract = null;
			// 완납확인증명서
			String file_seq_full_payment = null;
			// 계약상태 이후만
			if(CalvaryConstants.PROGRESS_STATUS_B.equals(bunyangInfoVo.getProgressStatus()) 
					||CalvaryConstants.PROGRESS_STATUS_C.equals(bunyangInfoVo.getProgressStatus())
					) {
				// 분양계약서
				file_seq_contract = excelService.createBunyangExcelForm(ExcelForms.CONTRACT_FORM, bunyangSeq, "", "");
				// 완납확인증명서
				file_seq_full_payment = excelService.createBunyangExcelForm(ExcelForms.FULL_PAYMENT_FORM, bunyangSeq, "", "");
			}
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("bunyangSeq", bunyangSeq);
			param.put("file_seq_apply", file_seq_apply);
			param.put("file_seq_use_user", file_seq_use_user);
			param.put("file_seq_approval", file_seq_approval);
			param.put("file_seq_contract", file_seq_contract);
			param.put("file_seq_full_payment", file_seq_full_payment);
			adminService.updateBunyangFileSeq(param);
			
			bRslt = true;
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
	@SuppressWarnings("unchecked")
	@RequestMapping(value=CANCEL_MGMT_URL)
	public Object cancelMgmtHandler(SearchVo searchVo) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		Map<String, Object> rtnMap = adminService.getCancelList(searchVo);
		List<Object> cancelList = (ArrayList<Object>)rtnMap.get("list");
		int total_count = CommonUtil.convertToInt(rtnMap.get("total_count"));
		searchVo.setTotalCount(total_count);
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
			,String cancelDate
			,String cancelReason
			) throws Exception {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String fileSeq = null;
		int iRslt = adminService.updateCancel(bunyangSeq, depositAmount, depositPlanDate, depositBank, depositAccount, accountHolder, cancelDate, cancelReason);
		if(iRslt > 0) {
			fileSeq = excelService.createBunyangExcelForm(ExcelForms.CANCEL_APPROVAL_FORM, bunyangSeq, "", "");
			if(!StringUtils.isEmpty(fileSeq)) {
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("bunyangSeq", bunyangSeq);
				param.put("file_seq_cancel", fileSeq);
				adminService.updateBunyangFileSeq(param);
				bRslt = true;
			}
		}
		rtnMap.put("result", bRslt);
		rtnMap.put("fileSeq", fileSeq);
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
	@SuppressWarnings("unchecked")
	@RequestMapping(value=PAYMENT_MGMT_URL)
	public Object paymentMgmtHandler(SearchVo searchVo, String paymentDivision, String paymentType, String parentCodeSeq) {
		SimpleDateFormat sf = new SimpleDateFormat("yyyyMMdd");
		// 검색기간은 default 1주일
		if(StringUtils.isEmpty(searchVo.getFromDt()) && StringUtils.isEmpty(searchVo.getToDt())) {
			Calendar cl = Calendar.getInstance();
			cl.add(Calendar.MONTH, -1);
			searchVo.setFromDt(sf.format(cl.getTime()));
			searchVo.setToDt(sf.format(new Date()));
		}
		String searchPaymentDivision = paymentDivision;
		if(StringUtils.isEmpty(searchPaymentDivision)) {
			searchPaymentDivision = parentCodeSeq;
		}
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		List<Object> depositTypeList = commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_DEPOSIT_TYPE);
		List<Object> withdrawalTypeList = commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_WITHDRAWAL_TYPE);
		Map<String, Object> rtnMap = adminService.getPaymentList(searchVo, paymentType, searchPaymentDivision);
		List<Object> paymentList = (ArrayList<Object>)rtnMap.get("list");
		int total_count = CommonUtil.convertToInt(rtnMap.get("total_count"));
		searchVo.setTotalCount(total_count);
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU01");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU01_06");
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("searchVo", searchVo);
		mv.addObject("paymentDivision", paymentDivision);
		mv.addObject("paymentType", paymentType);
		mv.addObject("parentCodeSeq", parentCodeSeq);
		mv.addObject("paymentList", paymentList);
		mv.addObject("depositTypeList", depositTypeList);
		mv.addObject("withdrawalTypeList", withdrawalTypeList);
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
	// 사용(봉안)신청 관리
	//===============================================================================
	/** 사용(봉안)신청 관리 페이지  URL */
	public static final String USE_MGMT_URL = "/usemgmt";
	/** 추모동산 사용현황 리스트 조회  URL */
	public static final String GET_GRAVE_USE_LIST = "/getGraveUseList";
	/** 특정 구역에 배정된 정보 조회  URL */
	public static final String GET_GRAVE_ASSIGN_INFO = "/getGraveAssignInfo";
	/** 가족형으로 묶인 모든 배정 정보 조회  URL */
	public static final String GET_GRAVE_ASSIGN_INFO_BY_FAMILY = "/getGraveAssignInfoByFamily";
	
	/** 동산 위치 수정 페이지  URL */
	public static final String MODIFY_GRAVE_URL = "/modifyGrave";
	
	/** 동산 위치 수정 페이지(다음 Step)  URL */
	public static final String MODIFY_GRAVE_NEXT_URL = "/modifyGraveNext";
	
	/** 위치 수정할 분양건에 대해 승인되지 않은 신청 정보가 있는지 조회 */
	public static final String NOT_APPROVAL_GRAVE_LIST_URL = "/notApprovalGraveList";
	
	/** 동산 위치 수정 정보 저장  URL */
	public static final String SAVE_CHANGED_GRAVE_URL = "/saveChangedGrave";
	
	/** 
	 * 사용(봉안)신청 관리 페이지
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value=USE_MGMT_URL)
	public Object useMgmtHandler(SearchVo searchVo, String requestStatus) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU02");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU02_02");
		
		Map<String, Object> rtnMap = adminService.getGraveRequestList(searchVo, requestStatus);
		List<Object> graveRequestList = (ArrayList<Object>)rtnMap.get("list");
		int total_count = CommonUtil.convertToInt(rtnMap.get("total_count"));
		searchVo.setTotalCount(total_count);
		
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("graveRequestList", graveRequestList);
		mv.addObject("searchVo", searchVo);
		mv.addObject("requestStatus", requestStatus);
		mv.setViewName(ROOT_URL + USE_MGMT_URL);
		return mv;
	}
	
	/** 
	 * 동산 위치 수정 페이지
	 */
	@RequestMapping(value=MODIFY_GRAVE_URL)
	public Object modifyGraveHandler(SearchVo searchVo) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU02");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU02_02");
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("searchVo", searchVo);
		mv.addObject("step", 1);
		mv.setViewName(ROOT_URL + MODIFY_GRAVE_URL);
		return mv;
	}
	
	/** 
	 * 동산 위치 수정 페이지(다음 Step)
	 */
	@RequestMapping(value=MODIFY_GRAVE_NEXT_URL)
	public Object modifyGraveNextHandler(
			SearchVo searchVo, 
			String group_seq, 
			String bunyang_seq, 
			String sectionSeq, 
			String rowSeq, 
			String colSeq
			) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU02");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU02_02");
		
		List<Object> graveAssignList = adminService.getGraveAssignInfoByFamily(group_seq, bunyang_seq, sectionSeq, rowSeq, colSeq);
		
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("searchVo", searchVo);
		mv.addObject("group_seq", group_seq);
		mv.addObject("bunyang_seq", bunyang_seq);
		mv.addObject("sectionSeq", sectionSeq);
		mv.addObject("rowSeq", rowSeq);
		mv.addObject("colSeq", colSeq);
		mv.addObject("graveAssignList", graveAssignList);
		mv.addObject("step", 2);
		mv.setViewName(ROOT_URL + MODIFY_GRAVE_URL);
		return mv;
	}
	
	/** 
	 * 위치 수정할 분양건에 대해 승인되지 않은 신청 정보가 있는지 조회
	 */
	@RequestMapping(value=NOT_APPROVAL_GRAVE_LIST_URL)
	@ResponseBody
	public Object notApprovalGraveListHandler(HttpServletRequest request, String bunyang_seq) throws Exception {
		List<Object> notApprovalGraveList = adminService.getNotApprovalGraveList(bunyang_seq);
		return notApprovalGraveList;
	}
	
	/** 
	 * 동산 위치 수정 정보 저장
	 */
	@RequestMapping(value=SAVE_CHANGED_GRAVE_URL)
	@ResponseBody
	public Object saveChangedGraveHandler(HttpServletRequest request) throws Exception {
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		// source
		String[] selected_section_seqs = request.getParameterValues("selected_section_seq");
		String[] selected_row_seqs = request.getParameterValues("selected_row_seq");
		String[] selected_col_seqs = request.getParameterValues("selected_col_seq");
		// target
		String[] modify_section_seqs = request.getParameterValues("modify_section_seq");
		String[] modify_row_seqs = request.getParameterValues("modify_row_seq");
		String[] modify_col_seqs = request.getParameterValues("modify_col_seq");
		int iRslt = adminService.saveChangedGrave(selected_section_seqs, selected_row_seqs, selected_col_seqs, modify_section_seqs, modify_row_seqs, modify_col_seqs);
		bRslt = iRslt > 0;
		rtnMap.put("result", bRslt);
		return rtnMap;
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
	
	/** 
	 * 가족형으로 묶인 모든 배정 정보 조회
	 */
	@RequestMapping(value=GET_GRAVE_ASSIGN_INFO_BY_FAMILY)
	@ResponseBody
	public List<Object> getGraveAssignInfoByFamilyHandler(
			String group_seq, 
			String bunyang_seq, 
			String sectionSeq, 
			String rowSeq, 
			String colSeq
			) {
		List<Object> graveAssignList = adminService.getGraveAssignInfoByFamily(group_seq, bunyang_seq, sectionSeq, rowSeq, colSeq);
		return graveAssignList;
	}
	
	
	//===============================================================================
	// 사용계약 변경 및 해약
	//===============================================================================
	/** 사용계약 변경 및 해약  URL */
	public static final String USE_CHANGE_URL = "/usechange";
	/** 사용계약 변경 및 해약 상세페이지  URL */
	public static final String USE_CHANGE_DETAIL_URL = "/useChangeDetail";
	/** 계약승계  URL */
	public static final String SUCCEED_CONTRACTOR_URL = "/succeedContractor";
	/** 사용자 정보 변경  URL */
	public static final String CHANGE_REF_USER_INFO_URL = "/changeRefUserInfo";
	/** 관리비 납부자 변경  URL */
	public static final String CHANGE_SERVICE_CHARGER_URL = "/changeServiceCharger";
	/** 사용(봉안)자 해약 처리  URL */
	public static final String CANCEL_USE_USER_URL = "/cancelUseUser";
	
	/** 
	 * 사용계약 변경 및 해약 페이지
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value=USE_CHANGE_URL)
	public Object useChangeHandler(SearchVo searchVo) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		List<Object> bunyangTimesList = commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_BUNYANG_TIMES);
		Map<String, Object> rtnMap = adminService.getUseChangeList(searchVo);
		List<Object> useChangeList = (ArrayList<Object>)rtnMap.get("list");
		int total_count = CommonUtil.convertToInt(rtnMap.get("total_count"));
		searchVo.setTotalCount(total_count);
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU02");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU02_03");
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("searchVo", searchVo);
		mv.addObject("bunyangTimesList", bunyangTimesList);
		mv.addObject("useChangeList", useChangeList);
		mv.setViewName(ROOT_URL + USE_CHANGE_URL);
		return mv;
	}
	
	/** 
	 * 사용계약 변경 및 해약 상세페이지
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value=USE_CHANGE_DETAIL_URL)
	public Object useChangeDetailHandler(SearchVo searchVo, String bunyangSeq) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		ModelAndView mv = new ModelAndView();
		List<Object> paymentList = null;
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU02");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU02_03");
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("submenuName", "사용계약 상세 정보");
		mv.addObject("menuList", menuList);
		mv.addObject("bunyangSeq", bunyangSeq);
		mv.addObject("searchVo", searchVo);
		
		List<Object> applyUserList = adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_APPLY_USER);
		List<Object> agentUserList = adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_AGENT_USER);
		Map<String, Object> applyUser = null;
		Map<String, Object> agentUser = null;
		if(applyUserList != null && applyUserList.size() > 0) {
			applyUser = (HashMap<String, Object>)applyUserList.get(0);
		}
		if(agentUserList != null && agentUserList.size() > 0) {
			agentUser = (HashMap<String, Object>)agentUserList.get(0);
		}
		Map<String, Object> bunyangInfo = adminService.getBunyangInfo(bunyangSeq);
		String group_seq = null;
		if(bunyangInfo != null) {
			group_seq = String.valueOf(bunyangInfo.get("group_seq"));
		}
		List<Object> addedBunyangList = adminService.getAddedBunyangList(group_seq, bunyangSeq);
		mv.addObject("bunyangInfo", bunyangInfo);// 분양정보
		mv.addObject("addedBunyangList", addedBunyangList);// 추가 분양 리스트
		mv.addObject("applyUser", applyUser);// 신청자정보
		mv.addObject("agentUser", agentUser);// 대리신청인정보
		mv.addObject("useUser", adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_USE_USER));// 사용(봉안) 대상자 정보
		mv.addObject("fileList", adminService.getBunyangFileList(bunyangSeq));// 분양 파일 양식 리스트
		paymentList = adminService.getPaymentHistory(bunyangSeq, CalvaryConstants.PAYMENT_TYPE_DOWN_PAYMENT);// 계약금
		paymentList.addAll(adminService.getPaymentHistory(bunyangSeq, CalvaryConstants.PAYMENT_TYPE_BALANCE_PAYMENT));// 분양잔금
		mv.addObject("paymentList", paymentList);
		mv.addObject("totalPaymentInfo", adminService.getTotalPayment(bunyangSeq));
		mv.setViewName(ROOT_URL + USE_CHANGE_DETAIL_URL);
		return mv;
	}
	
	/** 
	 * 계약승계
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value=SUCCEED_CONTRACTOR_URL)
	@ResponseBody
	public Object succeedContractorHandler(BunyangUserVo bunyangUserVo, String changeReason, String remarks) throws Exception{
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String bunyangSeq = bunyangUserVo.getBunyangSeq();
		// 계약자 정보를 승계신청자 정보로 변경
		int iRslt = adminService.updateSucceedContractor(bunyangUserVo, changeReason, remarks);
		// 엑셀양식 업데이트
		if(iRslt > 0) {
			// 분양신청서
			String file_seq_apply = excelService.createBunyangExcelForm(ExcelForms.APPLY_FORM, bunyangSeq, "", "");
			// 분양신청서-사용자
			String file_seq_use_user = excelService.createBunyangExcelForm(ExcelForms.USE_USER_FORM, bunyangSeq, "", "");
			// 신청승인서
			String file_seq_approval = excelService.createBunyangExcelForm(ExcelForms.APPROVAL_FORM, bunyangSeq, "", "");
			// 분양계약서
			String file_seq_contract = excelService.createBunyangExcelForm(ExcelForms.CONTRACT_FORM, bunyangSeq, "", "");
			// 완납확인증명서
			String file_seq_full_payment = excelService.createBunyangExcelForm(ExcelForms.FULL_PAYMENT_FORM, bunyangSeq, "", "");
			
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("bunyangSeq", bunyangSeq);
			param.put("file_seq_apply", file_seq_apply);
			param.put("file_seq_use_user", file_seq_use_user);
			param.put("file_seq_approval", file_seq_approval);
			param.put("file_seq_contract", file_seq_contract);
			param.put("file_seq_full_payment", file_seq_full_payment);
			adminService.updateBunyangFileSeq(param);
			
			List<Object> useUserList = adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_USE_USER);
			
			if(useUserList != null && useUserList.size() > 0) {
				for(int i = 0; i < useUserList.size(); i++) {
					Map<String, Object> tmp = (HashMap<String, Object>)useUserList.get(i);
					String approval_file_seq = (String)tmp.get("approval_file_seq");
					// 사용승인서가 있을 경우 업데이트
					if(!StringUtils.isEmpty(approval_file_seq)) {
						excelService.createBunyangExcelForm(ExcelForms.USE_APPROVAL_FORM, bunyangSeq, approval_file_seq, (String)tmp.get("user_id"));
					}
				}
			}
			
			bRslt = true;
		}
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	/** 
	 * 사용자 정보 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value=CHANGE_REF_USER_INFO_URL)
	@ResponseBody
	public Object changeRefUserInfoHandler(BunyangUserVo bunyangUserVo) throws Exception{
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String bunyangSeq = bunyangUserVo.getBunyangSeq();
		// 사용자 정보 변경
		int iRslt = adminService.updateRefUserInfo(bunyangUserVo);
		// 엑셀양식 업데이트
		if(iRslt > 0) {
			
			Map<String, Object> bunyangInfo = adminService.getBunyangInfo(bunyangSeq);
			
			List<Object> useUserList = adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_USE_USER);
			
			// 분양신청서
			String file_seq_apply = (String)bunyangInfo.get("file_seq_apply");
			// 분양신청서-사용자
			String file_seq_use_user = (String)bunyangInfo.get("file_seq_use_user");
			// 신청승인서
			String file_seq_approval = (String)bunyangInfo.get("file_seq_approval");
			// 분양계약서
			String file_seq_contract = (String)bunyangInfo.get("file_seq_contract");
			// 완납확인증명서
			String file_seq_full_payment = (String)bunyangInfo.get("file_seq_full_payment");
			excelService.createBunyangExcelForm(ExcelForms.APPLY_FORM, bunyangSeq, file_seq_apply, "");
			excelService.createBunyangExcelForm(ExcelForms.USE_USER_FORM, bunyangSeq, file_seq_use_user, "");
			excelService.createBunyangExcelForm(ExcelForms.APPROVAL_FORM, bunyangSeq, file_seq_approval, "");
			excelService.createBunyangExcelForm(ExcelForms.CONTRACT_FORM, bunyangSeq, file_seq_contract, "");
			excelService.createBunyangExcelForm(ExcelForms.FULL_PAYMENT_FORM, bunyangSeq, file_seq_full_payment, "");
			
			if(useUserList != null && useUserList.size() > 0) {
				for(int i = 0; i < useUserList.size(); i++) {
					Map<String, Object> tmp = (HashMap<String, Object>)useUserList.get(i);
					String approval_file_seq = (String)tmp.get("approval_file_seq");
					// 사용승인서가 있을 경우
					if(!StringUtils.isEmpty(approval_file_seq)) {
						excelService.createBunyangExcelForm(ExcelForms.USE_APPROVAL_FORM, bunyangSeq, approval_file_seq, (String)tmp.get("user_id"));
					}
				}
			}
			
			bRslt = true;
		}
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	/** 
	 * 관리비 납부자 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value=CHANGE_SERVICE_CHARGER_URL)
	@ResponseBody
	public Object changeServiceChargerHandler(String bunyangSeq, String serviceChargeType, String maintCharger) throws Exception{
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		// 사용자 정보 변경
		int iRslt = adminService.updateServiceCharger(bunyangSeq, serviceChargeType, maintCharger);
		// 엑셀양식 업데이트
		if(iRslt > 0) {
			
			Map<String, Object> bunyangInfo = adminService.getBunyangInfo(bunyangSeq);
			
			List<Object> useUserList = adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_USE_USER);
			
			// 분양신청서
			String file_seq_apply = (String)bunyangInfo.get("file_seq_apply");
			// 분양신청서-사용자
			String file_seq_use_user = (String)bunyangInfo.get("file_seq_use_user");
			// 신청승인서
			String file_seq_approval = (String)bunyangInfo.get("file_seq_approval");
			// 분양계약서
			String file_seq_contract = (String)bunyangInfo.get("file_seq_contract");
			// 완납확인증명서
			String file_seq_full_payment = (String)bunyangInfo.get("file_seq_full_payment");
			excelService.createBunyangExcelForm(ExcelForms.APPLY_FORM, bunyangSeq, file_seq_apply, "");
			excelService.createBunyangExcelForm(ExcelForms.USE_USER_FORM, bunyangSeq, file_seq_use_user, "");
			excelService.createBunyangExcelForm(ExcelForms.APPROVAL_FORM, bunyangSeq, file_seq_approval, "");
			excelService.createBunyangExcelForm(ExcelForms.CONTRACT_FORM, bunyangSeq, file_seq_contract, "");
			excelService.createBunyangExcelForm(ExcelForms.FULL_PAYMENT_FORM, bunyangSeq, file_seq_full_payment, "");
			
			if(useUserList != null && useUserList.size() > 0) {
				for(int i = 0; i < useUserList.size(); i++) {
					Map<String, Object> tmp = (HashMap<String, Object>)useUserList.get(i);
					String approval_file_seq = (String)tmp.get("approval_file_seq");
					// 사용승인서가 있을 경우
					if(!StringUtils.isEmpty(approval_file_seq)) {
						excelService.createBunyangExcelForm(ExcelForms.USE_APPROVAL_FORM, bunyangSeq, approval_file_seq, (String)tmp.get("user_id"));
					}
				}
			}
			
			bRslt = true;
		}
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	/** 
	 * 사용(봉안)자 해약 처리
	 */
	@RequestMapping(value=CANCEL_USE_USER_URL)
	@ResponseBody
	public Object cancelUseUserHandler(String bunyangSeq
			,String userId1
			,String userId2
			,String cancelReason
			,String cancelBank
			,String cancelAccount
			,String cancelAccountHolder
			,String cancelDepositPlanDate
			,int surrenderValue
			,int penaltyValue) throws Exception{
		boolean bRslt = false;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		// 사용자 정보 변경
		int iRslt = adminService.cancelUseUser(bunyangSeq, userId1, userId2, cancelReason, cancelBank, cancelAccount, cancelAccountHolder, cancelDepositPlanDate, surrenderValue, penaltyValue);
		bRslt = iRslt > 0;
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	
	//===============================================================================
	// 분양현황
	//===============================================================================
	/** 분양현황  URL */
	public static final String BUNYANG_STATUS_URL = "/bunyangstatus";
		
	/** 
	 * 분양현황 페이지
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value=BUNYANG_STATUS_URL)
	public Object bunyangStatusHandler(SearchVo searchVo) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU03");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU03_01");
		Map<String, Object> rtnMap = adminService.getBunyangList(searchVo);
		List<Object> bunyangList = (ArrayList<Object>)rtnMap.get("list");
		int total_count = CommonUtil.convertToInt(rtnMap.get("total_count"));
		searchVo.setTotalCount(total_count);
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
	@SuppressWarnings("unchecked")
	@RequestMapping(value=PAYMENT_STATUS_URL)
	public Object paymentStatusHandler(SearchVo searchVo) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU03");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU03_02");
		Map<String, Object> rtnMap = adminService.getBunyangList(searchVo);
		List<Object> bunyangList = (ArrayList<Object>)rtnMap.get("list");
		int total_count = CommonUtil.convertToInt(rtnMap.get("total_count"));
		searchVo.setTotalCount(total_count);
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
	@SuppressWarnings("unchecked")
	@RequestMapping(value=MAINT_PAYMENT_STATUS_URL)
	public Object maintPaymentStatusHandler(SearchVo searchVo) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU03");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU03_03");
		List<Object> maintYearList = adminService.getMaintYearList();
		if(searchVo.getMaintStatus() == null && maintYearList != null && maintYearList.size() > 0) {
			Map<String, Object> tmp = (HashMap<String, Object>)maintYearList.get(0);
			searchVo.setMaintYear(CommonUtil.convertToInt(tmp.get("yearval")));
			searchVo.setMaintStatus("ALL");
		}
		Map<String, Object> rtnMap = adminService.getMaintPaymentList(searchVo);
		List<Object> maintPaymentList = (ArrayList<Object>)rtnMap.get("list");
		int total_count = CommonUtil.convertToInt(rtnMap.get("total_count"));
		searchVo.setTotalCount(total_count);
		Map<String, Object> maintPaymentStatus = adminService.getMaintPaymentStatus(searchVo.getMaintYear());
		ModelAndView mv = new ModelAndView();
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("maintPaymentList", maintPaymentList);
		mv.addObject("maintYearList", maintYearList);
		mv.addObject("searchVo", searchVo);
		mv.addObject("maintPaymentStatus", maintPaymentStatus);
		mv.setViewName(ROOT_URL + MAINT_PAYMENT_STATUS_URL);
		return mv;
	}
	
	
	//===============================================================================
	// 일출금현황
	//===============================================================================
	/** 일출금현황  URL */
	public static final String BANK_STATUS_URL = "/bankStatus";
	
	/** 
	 * 입출금현황 페이지
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value=BANK_STATUS_URL)
	public Object bankStatusHandler(SearchVo searchVo, String paymentDivision, String paymentType, String parentCodeSeq) {
		SimpleDateFormat sf = new SimpleDateFormat("yyyyMMdd");
		// 검색기간은 default 1주일
		if(StringUtils.isEmpty(searchVo.getFromDt()) && StringUtils.isEmpty(searchVo.getToDt())) {
			Calendar cl = Calendar.getInstance();
			cl.add(Calendar.MONTH, -1);
			searchVo.setFromDt(sf.format(cl.getTime()));
			searchVo.setToDt(sf.format(new Date()));
		}
		String searchPaymentDivision = paymentDivision;
		if(StringUtils.isEmpty(searchPaymentDivision)) {
			searchPaymentDivision = parentCodeSeq;
		}
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		List<Object> depositTypeList = commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_DEPOSIT_TYPE);
		List<Object> withdrawalTypeList = commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_WITHDRAWAL_TYPE);
		Map<String, Object> rtnMap = adminService.getPaymentList(searchVo, paymentType, searchPaymentDivision);
		List<Object> depositWithDrawlList = (ArrayList<Object>)rtnMap.get("list");
		int total_count = CommonUtil.convertToInt(rtnMap.get("total_count"));
		searchVo.setTotalCount(total_count);
		ModelAndView mv = new ModelAndView();
		List<Object> bankStatusList = adminService.getBankStatusList();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU03");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU03_04");
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("searchVo", searchVo);
		mv.addObject("paymentDivision", paymentDivision);
		mv.addObject("paymentType", paymentType);
		mv.addObject("parentCodeSeq", parentCodeSeq);
		mv.addObject("depositWithDrawlList", depositWithDrawlList);
		mv.addObject("bankStatusList", bankStatusList);
		mv.addObject("depositTypeList", depositTypeList);
		mv.addObject("withdrawalTypeList", withdrawalTypeList);
		mv.setViewName(ROOT_URL + BANK_STATUS_URL);
		return mv;
	}
	
	
	//===============================================================================
	// 추모동산 사용(봉안)현황
	//===============================================================================
	/** 추모동산 사용(봉안)현황  URL */
	public static final String GRAVE_STATUS_URL = "/graveStatus";
	/** 사용(봉안)자 이름에 해당하는 정보 검색  URL */
	public static final String SEARCH_GRAVE_USER_URL = "/searchGraveUser";
	
	/** 
	 * 입출금현황 페이지
	 */
	@RequestMapping(value=GRAVE_STATUS_URL)
	public Object graveStatusHandler(SearchVo searchVo, String paymentDivision, String paymentType, String parentCodeSeq) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU03");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU03_05");
		List<Object> graveStatusList = adminService.getGraveStatusList();
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("graveStatusList", graveStatusList);
		mv.addObject("searchVo", searchVo);
		mv.setViewName(ROOT_URL + GRAVE_STATUS_URL);
		return mv;
	}
	
	/** 
	 * 사용(봉안)자 이름에 해당하는 정보 검색
	 */
	@RequestMapping(value=SEARCH_GRAVE_USER_URL)
	@ResponseBody
	public Object searchGraveUserHandler(String userName) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		Map<String, Object> resultMap = adminService.getGraveUserInfo(userName);
		rtnMap.put("result", resultMap);
		return rtnMap;
	}
	
	
	//===============================================================================
	// 공통
	//===============================================================================
	/** 분양리스트 조회용 select2 ajax URL */
	public static final String GET_BUNYANG_SELECT_LIST_URL = "/getBunyangSelectList";
	
	
	/** 
	 * 분양리스트 조회용 select2 ajax 처리
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value=GET_BUNYANG_SELECT_LIST_URL)
	@ResponseBody
	public Map<String, Object> getBunyangSelectListHandler(String searchVal, int pageIndex) {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		Map<String, Object> tmp = adminService.getBunyangSelectList(searchVal, pageIndex);
		List<Object> bunyangList = (ArrayList<Object>)tmp.get("list");
		int total_count = CommonUtil.convertToInt(tmp.get("total_count"));
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
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		ModelAndView mv = new ModelAndView();
		mv.addObject("menuList", menuList);
		mv.setViewName(ROOT_URL + MENU_MGMT_URL);
		return mv;
	}
	
	
	//===============================================================================
	// 추가분양관리
	//===============================================================================
	/** 추가분양관리 메인 페이지  URL */
	public static final String CONNECT_BUNYANG_URL = "/connectbunyang";
	/** 추가분양관리 상세 페이지  URL */
	public static final String CONNECT_DETAIL_URL = "/connectdetail";
	/** 추가분양 연결정보 해제 URL */
	public static final String DISCONNECT_BUNYANG_URL = "/disconnectbunyang";
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value=CONNECT_BUNYANG_URL)
	public Object connectBunyangHandler(SearchVo searchVo) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		List<Object> bunyangTimesList = commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_BUNYANG_TIMES);
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU01");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU01_07");
		Map<String, Object> rtnMap = adminService.getBunyangList(searchVo);
		List<Object> bunyangList = (ArrayList<Object>)rtnMap.get("list");
		int total_count = CommonUtil.convertToInt(rtnMap.get("total_count"));
		searchVo.setTotalCount(total_count);
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("menuList", menuList);
		mv.addObject("bunyangTimesList", bunyangTimesList);
		mv.addObject("bunyangList", bunyangList);
		mv.addObject("searchVo", searchVo);
		mv.setViewName(ROOT_URL + CONNECT_BUNYANG_URL);
		return mv;
	}
	
	@RequestMapping(value=CONNECT_DETAIL_URL)
	public Object connectDetailHandler(String groupSeq, String bunyangSeq, SearchVo searchVo) {
		ModelAndView mv = new ModelAndView();
		List<Object> addedBunyangList = adminService.getAddedBunyangList(groupSeq, bunyangSeq);
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		Map<String, Object> pMenuInfo = commonService.getMenuInfo("MENU01");
		Map<String, Object> menuInfo = commonService.getMenuInfo("MENU01_07");
		Map<String, Object> bunyangInfo = adminService.getBunyangInfo(bunyangSeq);
		mv.addObject("menuList", menuList);
		mv.addObject("pMenuInfo", pMenuInfo);
		mv.addObject("menuInfo", menuInfo);
		mv.addObject("addedBunyangList", addedBunyangList);
		mv.addObject("bunyangInfo", bunyangInfo);
		mv.addObject("groupSeq", groupSeq);
		mv.addObject("bunyangSeq", bunyangSeq);
		mv.addObject("searchVo", searchVo);
		mv.setViewName(ROOT_URL + CONNECT_DETAIL_URL);
		return mv;
	}
	
	@RequestMapping(value=DISCONNECT_BUNYANG_URL)
	@ResponseBody
	public Object disconnectbunyangHandler(String groupSeq, String bunyangSeq) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		boolean bRslt = false;
		int iRslt = adminService.disConnectBunyangInfo(groupSeq, bunyangSeq);
		bRslt = iRslt > 0;
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
}
