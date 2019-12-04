package com.calvary.popup.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.LoggerFactory;
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
import com.calvary.popup.service.IPopupService;
import com.calvary.popup.vo.ApprovalGraveVo;
import com.calvary.popup.vo.GraveInfoVo;
import com.calvary.popup.vo.SelectUserVo;
import com.calvary.popup.vo.UpdateBunyangVo;
import com.calvary.sysadmin.service.ISysAdminService;

@Controller
@RequestMapping(value=PopupController.ROOT_URL)
public class PopupController {

	/** */
	public static final String ROOT_URL = "/popup";
	
	public static final String SELECT_USER_URL = "/selectuser";
	public static final String SUCCEED_CONTRACTOR_URL = "/succeedcontractor";
	public static final String CHANGE_REF_USER_INFO_URL = "/changeRefUserInfo";
	public static final String REGIST_USE_USER_URL = "/registuseuser";
	public static final String CHECK_DUPLICATED_USER_URL = "/checkduplicateduser";
	public static final String CONTRACT_CANCEL_URL = "/contractcancel";
	public static final String USE_USER_CANCEL_URL = "/useUserCancel";
	public static final String USE_APPLY_URL = "/useapply";
	public static final String SELECT_USE_USER = "/selectuseuser";
	public static final String ASSIGN_GRAVE = "/assigngrave";
	public static final String REGIST_PAYMENT = "/registpayment";
	public static final String SAVE_PAYMENT = "/savepayment";
	public static final String SAVE_MANUAL_PAYMENT = "/saveManualPayment";
	public static final String UPDATE_BUNYANG_PROGRESS = "/updateBunyangProgress";
	public static final String SAVE_PAYMENT_ONE = "/savepaymentone";
	public static final String APPROVAL_REQUEST_GRAVE = "/approvalRequestGrave";
	public static final String SAVE_APPROVAL_REQUEST_GRAVE = "/saveApprovalRequestGrave";
	/** 분양상세정보 페이지  URL */
	public static final String BUNYANG_INFO_URL = "/bunyanginfo";
	/** comment 입력 팝업 URL */
	public static final String REGIST_COMMENT_URL = "/registcomment";
	/** 날짜 입력 팝업 URL */
	public static final String REGIST_DATE_URL = "/registdate";
	/** 분양정보 엑셀업로드 등록 팝업 URL */
	public static final String REGIST_BUNYANG_EXCEL_URL = "/registBunyangExcel";
	/** 입출금 엑셀업로드 등록 팝업 URL */
	public static final String REGIST_PAYMENT_EXCEL_URL = "/registPaymentExcel";
	/** 분양대금 입출금 대장 엑셀업로드 등록 팝업 URL */
	public static final String REGIST_MANUAL_EXCEL_URL = "/registManualExcel";
	/** 관리비 납부/미납 상세정보 표시 */
	public static final String MAINT_PAYMENT_DETAIL_INFO_URL = "/maintPaymentDetailInfo";
	/** 관리비 청구대상 표시 */
	public static final String MAINT_PAYMENT_CLAIM_URL = "/maintPaymentClaim";
	/** 코드등록 팝업 */
	public static final String REGIST_CODE_URL = "/registCode";
	/** 메뉴권한 등록 팝업 */
	public static final String SELECT_MENU_ROLE_URL = "/selectMenuRole";
	/** 사용자권한 등록 팝업 */
	public static final String SELECT_USER_ROLE_URL = "/selectUserRole";
	/** 아이디/비밀번호 찾기 팝업 */
	public static final String FIND_ID_PWD_URL = "/findIdPwd";
	/** 추가분양 선택 팝업 */
	public static final String SELECT_CONNECT_BUNYANG_URL = "/selectConnectBunyang";
	/** 선택분양을 추가분양으로 연결 */
	public static final String CONNECT_SELECTED_BUNYANG_URL = "/connectSelectedBunyang";
	
	@Autowired
	private IPopupService popupService;
	@Autowired
	private ICommonService commonService;
	@Autowired
	private IAdminService adminService;
	@Autowired
	private ISysAdminService sysAdminService;
	@Autowired
	private IExcelService excelService;
	
	@RequestMapping(value=SELECT_USER_URL)
	public Object selectUserHandler(SelectUserVo selectUserVo) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("yearList", commonService.getYearList());
		mv.addObject("officerList", commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_CHURCH_OFFICER));// 직분코드
		mv.addObject("relationList", commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_USER_RELATION));// 관계코드
		mv.addObject("users", selectUserVo.getUsers());
		mv.addObject("popupTitle", selectUserVo.getPopupTitle());
		mv.addObject("popupType", selectUserVo.getPopupType());
		mv.addObject("selectedUserId", selectUserVo.getSelectedUserId());
		mv.setViewName(ROOT_URL + SELECT_USER_URL);
		return mv;
	}
	
	@RequestMapping(value=SUCCEED_CONTRACTOR_URL)
	public Object succeedContractorHandler(String bunyangSeq) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("bunyangSeq", bunyangSeq);
		mv.addObject("yearList", commonService.getYearList());
		mv.addObject("officerList", commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_CHURCH_OFFICER));// 직분코드
		mv.addObject("relationList", commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_USER_RELATION));// 관계코드
		mv.setViewName(ROOT_URL + SUCCEED_CONTRACTOR_URL);
		return mv;
	}
	
	@RequestMapping(value=CHANGE_REF_USER_INFO_URL)
	public Object changeRefUserInfoHandler(String bunyangSeq, String refType, String userId, String popupTitle) {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> refUserInfo = adminService.getBunyangRefUserInfo(bunyangSeq, refType, userId);
		mv.addObject("refUserInfo", refUserInfo);
		mv.addObject("bunyangSeq", bunyangSeq);
		mv.addObject("refType", refType);
		mv.addObject("popupTitle", popupTitle);
		mv.addObject("yearList", commonService.getYearList());
		mv.addObject("officerList", commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_CHURCH_OFFICER));// 직분코드
		mv.addObject("relationList", commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_USER_RELATION));// 관계코드
		mv.setViewName(ROOT_URL + CHANGE_REF_USER_INFO_URL);
		return mv;
	}
	
	@RequestMapping(value=REGIST_USE_USER_URL)
	public Object registUseUserHandler(SelectUserVo selectUserVo) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("yearList", commonService.getYearList());
		mv.addObject("relationList", commonService.getRelationCodeList());// 관계코드
		mv.addObject("users", selectUserVo.getUsers());
		mv.addObject("popupTitle", selectUserVo.getPopupTitle());
		mv.addObject("popupType", selectUserVo.getPopupType());
		mv.addObject("rowIdx", selectUserVo.getRowIdx());
		if("couple".equals(selectUserVo.getPopupType())) {
			mv.setViewName(ROOT_URL + "/registcoupleuser");
		}else {
			mv.setViewName(ROOT_URL + "/registsingleuser");
		}
		return mv;
	}
	
	@RequestMapping(value=CHECK_DUPLICATED_USER_URL)
	@ResponseBody
	public Object checkDuplicatedUserHandler(BunyangUserVo bunyangUserVo) {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		Map<String, Object> duplicatedUser = popupService.getRefUserByNameAndBirthDate(bunyangUserVo);
		rtnMap.put("duplicatedUser", duplicatedUser);
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
	 * 사용(봉안)자 해약
	 */
	@RequestMapping(value=USE_USER_CANCEL_URL)
	public Object useUserCancelHandler(String bunyangSeq, String userId1, String userId2) {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> bunyangInfo = adminService.getBunyangInfo(bunyangSeq);
		Map<String, Object> userInfo1 = adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_USE_USER, userId1);
		Map<String, Object> userInfo2 = null;
		if(!StringUtils.isEmpty(userId2)) {
			userInfo2 = adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_USE_USER, userId2);
		}
		mv.addObject("bunyangInfo", bunyangInfo);
		mv.addObject("userInfo1", userInfo1);
		mv.addObject("userInfo2", userInfo2);
		mv.setViewName(ROOT_URL + USE_USER_CANCEL_URL);
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
			) throws Exception {
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
		List<Object> depositTypeList = commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_DEPOSIT_TYPE);
		List<Object> withdrawalTypeList = commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_WITHDRAWAL_TYPE);
		ModelAndView mv = new ModelAndView();
		mv.setViewName(ROOT_URL + REGIST_PAYMENT);
		mv.addObject("depositTypeList", depositTypeList);
		mv.addObject("withdrawalTypeList", withdrawalTypeList);
		return mv;
	}
	
	@RequestMapping(value=SAVE_PAYMENT)
	@ResponseBody
	public Object savePaymentHandler(
			@RequestParam(value="bunyangSeqs[]") String[] bunyangSeqs,
			@RequestParam(value="paymentDates[]") String[] paymentDates,
			@RequestParam(value="paymentAmounts[]") int[] paymentAmounts,
			@RequestParam(value="paymentDivisions[]") String[] paymentDivisions,
			@RequestParam(value="paymentTypes[]") String[] paymentTypes,
			@RequestParam(value="paymentUsers[]") String[] paymentUsers,
			@RequestParam(value="paymentMethods[]") String[] paymentMethods,
			@RequestParam(value="remarks[]") String[] remarks,
			@RequestParam(value="maintSeqs[]") String[] maintSeqs,
			@RequestParam(value="contractBunyangSeqs[]", required=false) String[] contractBunyangSeqs,
			@RequestParam(value="fullPaymentBunyangSeqs[]", required=false) String[] fullPaymentBunyangSeqs,
			@RequestParam(value="sendSmsYn", required=false) String sendSmsYn
			) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		boolean bRslt = false;
		int iRslt = 0;
		int i = 0;
		String bunyangSeq = null;
		// 납입금 정보 생성
//		if(bunyangSeqs != null && bunyangSeqs.length > 0) {
//			for(i = 0; i < bunyangSeqs.length; i++) {
//				iRslt += adminService.createPaymentHistory(bunyangSeqs[i], paymentAmounts[i], paymentMethods[i], paymentDates[i], paymentDivisions[i], paymentTypes[i], paymentUsers[i], remarks[i]);
//			}
//		}
		
		iRslt = adminService.createPaymentHistory(bunyangSeqs, paymentAmounts, paymentMethods, paymentDates, paymentDivisions, paymentTypes, paymentUsers, remarks, maintSeqs, sendSmsYn);
		
		// 계약금 납부가 된 건에 대해 계약상태로 업데이트(현재는 자동 상태 변경은 안하지만 혹시몰라 남겨둠)
//		if(contractBunyangSeqs != null && contractBunyangSeqs.length > 0) {
//			for(i = 0; i < contractBunyangSeqs.length; i++) {
//				bunyangSeq = contractBunyangSeqs[i];
//				BunyangInfoVo bunyangInfoVo = new BunyangInfoVo();
//				bunyangInfoVo.setBunyangSeq(bunyangSeq);
//				bunyangInfoVo.setProgressStatus(CalvaryConstants.PROGRESS_STATUS_B);
//				iRslt += adminService.updateBunyangProgressStatus(bunyangInfoVo, SessionUtil.getCurrentUserId(), null);
//				String fileSeq = excelService.createBunyangExcelForm(ExcelForms.CONTRACT_FORM, bunyangSeq, "");
//				if(!StringUtils.isEmpty(fileSeq)) {
//					Map<String, Object> param = new HashMap<String, Object>();
//					param.put("bunyangSeq", bunyangSeq);
//					param.put("file_seq_contract", fileSeq);
//					iRslt += adminService.updateBunyangFileSeq(param);
//				}
//			}
//		}
		// 잔금 완납된 건에 대해 완납상태로 업데이트(현재는 자동 상태 변경은 안하지만 혹시몰라 남겨둠)
//		if(fullPaymentBunyangSeqs != null && fullPaymentBunyangSeqs.length > 0) {
//			for(i = 0; i < fullPaymentBunyangSeqs.length; i++) {
//				bunyangSeq = fullPaymentBunyangSeqs[i];
//				BunyangInfoVo bunyangInfoVo = new BunyangInfoVo();
//				bunyangInfoVo.setBunyangSeq(bunyangSeq);
//				bunyangInfoVo.setProgressStatus(CalvaryConstants.PROGRESS_STATUS_C);
//				iRslt += adminService.updateBunyangProgressStatus(bunyangInfoVo, SessionUtil.getCurrentUserId(), null);
//				String fileSeq = excelService.createBunyangExcelForm(ExcelForms.FULL_PAYMENT_FORM, bunyangSeq, "");
//				if(!StringUtils.isEmpty(fileSeq)) {
//					Map<String, Object> param = new HashMap<String, Object>();
//					param.put("bunyangSeq", bunyangSeq);
//					param.put("file_seq_full_payment", fileSeq);
//					iRslt += adminService.updateBunyangFileSeq(param);
//				}
//			}
//		}
		
		bRslt = iRslt > 0;
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	@RequestMapping(value=SAVE_MANUAL_PAYMENT)
	@ResponseBody
	public Object saveManualPaymentHandler(
			@RequestParam(value="bunyangNo") String bunyangNo,
			@RequestParam(value="paymentDate") String paymentDate,
			@RequestParam(value="paymentAmount") int paymentAmount,
			@RequestParam(value="paymentDivision") String paymentDivision,
			@RequestParam(value="paymentType") String paymentType,
			@RequestParam(value="paymentUser") String paymentUser,
			@RequestParam(value="remarks") String remarks
			) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		boolean bRslt = false;
		String errorMsg = "";
		try {
			int iRslt = 0;
			Map<String, Object> bunyangInfo = null;
			String progressStatus = "";
			String cancelYn = "";
			if(!StringUtils.isEmpty(bunyangNo)) {
				bunyangInfo = adminService.getBunyangInfoByNo(bunyangNo);
			}
			String bunyangSeq = "";
			if(bunyangInfo != null) {
				bunyangSeq = (String)bunyangInfo.get("bunyang_seq");
				progressStatus = (String)bunyangInfo.get("progress_status");
				cancelYn = (String)bunyangInfo.get("cancel_yn");
			}
			
			if(!StringUtils.isEmpty(bunyangNo) && StringUtils.isEmpty(bunyangSeq)) {
				errorMsg = "등록되지 않은 분양건";
			} else if("Y".equals(cancelYn)) {
				errorMsg = "취소된 분양건";
			} else if(CalvaryConstants.PROGRESS_STATUS_E.equals(progressStatus)) {
				errorMsg = "해약된 분양건";
			} else if(CalvaryConstants.PROGRESS_STATUS_R.equals(progressStatus)) {
				errorMsg = "반려된 분양건";
			} else if(CalvaryConstants.PROGRESS_STATUS_C.equals(progressStatus) || CalvaryConstants.PROGRESS_STATUS_D.equals(progressStatus)) {
				errorMsg = "이미 완납된 분양건";
			} else {
				iRslt = adminService.createPaymentHistory(bunyangSeq, paymentAmount, CalvaryConstants.PAYMENT_METHOD_TRANSFER, paymentDate, paymentDivision, paymentType, paymentUser, remarks);
				if(iRslt  > 0) {
					bRslt = true;
				} else {
					errorMsg = "업데이트실패";
				}
			}
		} catch(Exception e) {
			bRslt = false;
			errorMsg = "Exception 발생";
			LoggerFactory.getLogger("ERROR_LOGGER").error("Save Manual Payment Error Occured!!", e);
		}
		rtnMap.put("result", bRslt);
		rtnMap.put("errorMsg", errorMsg);
		return rtnMap;
	}
	
	@RequestMapping(value=UPDATE_BUNYANG_PROGRESS)
	@ResponseBody
	public Object updateBunyangProgress(@RequestBody UpdateBunyangVo vo
			) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		boolean bRslt = false;
		try {
			int iRslt = 0;
			int i = 0;
			// 계약금 및 중도금 납부된건 계약상태 또는 완납상태로 업데이트
			if(vo.getSavedBunyangNo() != null && vo.getSavedBunyangNo().length > 0) {
				for(i = 0; i < vo.getSavedBunyangNo().length; i++) {
					Map<String, Object> bunyangInfo = null;
					String bunyangNo = vo.getSavedBunyangNo()[i];
					if(!StringUtils.isEmpty(bunyangNo)) {
						bunyangInfo = adminService.getBunyangInfoByNo(bunyangNo);
						if(bunyangInfo != null) {
							String bunyangSeq = (String)bunyangInfo.get("bunyang_seq");
							String contractDate = (String)bunyangInfo.get("contract_date"); 
							String fullPaymentDate = (String)bunyangInfo.get("full_payment_date");
							String downPaymentDate = (String)bunyangInfo.get("down_payment_date");
							String balancePaymentDate = (String)bunyangInfo.get("balance_payment_date");
							int totalPrice = CommonUtil.convertToInt(bunyangInfo.get("total_price"));
							int downPayment = CommonUtil.convertToInt(bunyangInfo.get("down_payment"));
							int balancePayment = CommonUtil.convertToInt(bunyangInfo.get("balance_payment"));
							BunyangInfoVo bunyangInfoVo = null;
							// 미계약상태이고 계약금 납부된경우 계약상태로 업데이트
							if(StringUtils.isEmpty(contractDate) && (downPayment + balancePayment) >= (totalPrice/10)) {
								bunyangInfoVo = new BunyangInfoVo();
								bunyangInfoVo.setBunyangSeq(bunyangSeq);
								bunyangInfoVo.setProgressStatus(CalvaryConstants.PROGRESS_STATUS_B);
								iRslt += adminService.updateBunyangProgressStatus(bunyangInfoVo, SessionUtil.getCurrentUserId(), downPaymentDate);
								String fileSeq = excelService.createBunyangExcelForm(ExcelForms.CONTRACT_FORM, bunyangSeq, "", "");
								if(!StringUtils.isEmpty(fileSeq)) {
									Map<String, Object> param = new HashMap<String, Object>();
									param.put("bunyangSeq", bunyangSeq);
									param.put("file_seq_contract", fileSeq);
									iRslt += adminService.updateBunyangFileSeq(param);
								}
							}
							// 미완납상태이고 완납된경우 완납상태로 업데이트
							if(StringUtils.isEmpty(fullPaymentDate) && (downPayment + balancePayment)>= totalPrice) {
								bunyangInfoVo = new BunyangInfoVo();
								bunyangInfoVo.setBunyangSeq(bunyangSeq);
								bunyangInfoVo.setProgressStatus(CalvaryConstants.PROGRESS_STATUS_C);
								iRslt += adminService.updateBunyangProgressStatus(bunyangInfoVo, SessionUtil.getCurrentUserId(), balancePaymentDate);
								String fileSeq = excelService.createBunyangExcelForm(ExcelForms.FULL_PAYMENT_FORM, bunyangSeq, "", "");
								if(!StringUtils.isEmpty(fileSeq)) {
									Map<String, Object> param = new HashMap<String, Object>();
									param.put("bunyangSeq", bunyangSeq);
									param.put("file_seq_full_payment", fileSeq);
									iRslt += adminService.updateBunyangFileSeq(param);
								}
							}
						}
					}
				}
			}
			// 해약금 출금된건 해약상태로 업데이트
			if(vo.getCanceledBunyangNo() != null && vo.getCanceledBunyangNo().length > 0) {
				for(i = 0; i < vo.getCanceledBunyangNo().length; i++) {
					Map<String, Object> bunyangInfo = null;
					String bunyangNo = vo.getCanceledBunyangNo()[i];
					if(!StringUtils.isEmpty(bunyangNo)) {
						bunyangInfo = adminService.getBunyangInfoByNo(bunyangNo);
						if(bunyangInfo != null) {
							String bunyangSeq = (String)bunyangInfo.get("bunyang_seq");
							Map<String, Object> cancelInfo = adminService.getCancelPaymentInfo(bunyangSeq);
							String depositPlanDate = "";
							String depositBank = "";
							String depositAccount = "";
							String accountHolder = "";
							String cancelDate = "";
							String cancelReason = "";
							if(cancelInfo != null) {
								depositPlanDate = (String)cancelInfo.get("payment_date");
								accountHolder = (String)cancelInfo.get("payment_user");
								cancelDate = (String)cancelInfo.get("payment_date");
								cancelReason = (String)cancelInfo.get("remarks");
							}
							adminService.updateCancelManual(bunyangSeq, depositPlanDate, depositBank, depositAccount, accountHolder, cancelDate, cancelReason);
							String fileSeq = excelService.createBunyangExcelForm(ExcelForms.CANCEL_APPROVAL_FORM, bunyangSeq, "", "");
							if(!StringUtils.isEmpty(fileSeq)) {
								Map<String, Object> param = new HashMap<String, Object>();
								param.put("bunyangSeq", bunyangSeq);
								param.put("file_seq_cancel", fileSeq);
								adminService.updateBunyangFileSeq(param);
							}
						}
					}
				}
			}
			bRslt = iRslt > 0;
		} catch(Exception e) {
			LoggerFactory.getLogger("ERROR_LOGGER").error("updateBunyangProgress Error Occured!!", e);
		}
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	@RequestMapping(value=SAVE_PAYMENT_ONE)
	@ResponseBody
	public Object savePaymentOneHandler(
			@RequestParam(value="bunyangSeq") String bunyangSeq,
			@RequestParam(value="paymentDate") String paymentDate,
			@RequestParam(value="paymentAmount") int paymentAmount,
			@RequestParam(value="paymentDivision") String paymentDivision,
			@RequestParam(value="paymentType") String paymentType,
			@RequestParam(value="paymentUser") String paymentUser,
			@RequestParam(value="paymentMethod") String paymentMethod,
			@RequestParam(value="remark") String remark
			) {
		boolean bRslt = false;
		String errorMessage = "";
		try {
			int iRslt = 0;
			iRslt += adminService.createPaymentHistory(bunyangSeq, paymentAmount, paymentMethod, paymentDate, paymentDivision, paymentType, paymentUser, remark);
			bRslt = iRslt > 0;
		} catch(Exception e) {
			bRslt = false;
			errorMessage = e.getMessage();
			LoggerFactory.getLogger("ERROR_LOGGER").error("Error Occured!!", e);
		}
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("result", bRslt);
		rtnMap.put("errorMessage", errorMessage);
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
		paymentList.addAll(adminService.getPaymentHistory(bunyangSeq, CalvaryConstants.PAYMENT_TYPE_BALANCE_PAYMENT));// 분양잔금
		paymentList.addAll(adminService.getPaymentHistory(bunyangSeq, CalvaryConstants.PAYMENT_TYPE_MAINT_PAYMENT));// 관리비
		mv.addObject("paymentList", paymentList);
		mv.addObject("totalPaymentInfo", adminService.getTotalPayment(bunyangSeq));
		mv.setViewName(ROOT_URL + BUNYANG_INFO_URL);
		return mv;
	}
	
	/** 
	 * comment 입력 팝업
	 */
	@RequestMapping(value=REGIST_COMMENT_URL)
	public Object registCommentHandler(String popupTitle) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("popupTitle", popupTitle);
		mv.setViewName(ROOT_URL + REGIST_COMMENT_URL);
		return mv;
	}
	
	/** 
	 * 날짜 입력 팝업
	 */
	@RequestMapping(value=REGIST_DATE_URL)
	public Object registDateHandler(String popupTitle) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("popupTitle", popupTitle);
		mv.setViewName(ROOT_URL + REGIST_DATE_URL);
		return mv;
	}
	
	/** 
	 * 분양정보 엑셀업로드 등록 팝업
	 */
	@RequestMapping(value=REGIST_BUNYANG_EXCEL_URL)
	public Object registBunyangExcelHandler() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName(ROOT_URL + REGIST_BUNYANG_EXCEL_URL);
		return mv;
	}
	
	/** 
	 * 입출금 엑셀업로드 등록 팝업
	 */
	@RequestMapping(value=REGIST_PAYMENT_EXCEL_URL)
	public Object registPaymentExcelHandler() {
		List<Object> bankList = commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_DEPOSIT_BANK);
		List<Object> depositTypeList = commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_DEPOSIT_TYPE);
		List<Object> withdrawalTypeList = commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_WITHDRAWAL_TYPE);
		ModelAndView mv = new ModelAndView();
		mv.addObject("bankList", bankList);
		mv.addObject("depositTypeList", depositTypeList);
		mv.addObject("withdrawalTypeList", withdrawalTypeList);
		mv.setViewName(ROOT_URL + REGIST_PAYMENT_EXCEL_URL);
		return mv;
	}
	
	/** 
	 * 분양대금 입출금 대장 엑셀업로드 등록 팝업
	 */
	@RequestMapping(value=REGIST_MANUAL_EXCEL_URL)
	public Object registManualExcelHandler() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName(ROOT_URL + REGIST_MANUAL_EXCEL_URL);
		return mv;
	}
	
	/** 
	 * 관리비 납부/미납 상세정보 표시 팝업
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value=MAINT_PAYMENT_DETAIL_INFO_URL)
	public Object maintPaymentDetailInfoHandler(SearchVo searchVo, String bunyangSeq, String paymentYn, String popupTitle, String selectable) {
		Map<String, Object> rtnMap = adminService.getMaintPaymentDetailList(searchVo, bunyangSeq, paymentYn);
		List<Object> maintPaymentDetailList = (ArrayList<Object>)rtnMap.get("list");
		int total_count = CommonUtil.convertToInt(rtnMap.get("total_count"));
		searchVo.setTotalCount(total_count);
		ModelAndView mv = new ModelAndView();
		mv.addObject("maintPaymentDetailList", maintPaymentDetailList);
		mv.addObject("searchVo", searchVo);
		mv.addObject("bunyangSeq", bunyangSeq);
		mv.addObject("paymentYn", paymentYn);
		mv.addObject("popupTitle", popupTitle);
		mv.addObject("selectable", selectable);
		mv.setViewName(ROOT_URL + MAINT_PAYMENT_DETAIL_INFO_URL);
		return mv;
	}
	
	/** 
	 * 관리비 청구대상 표시 팝업
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value=MAINT_PAYMENT_CLAIM_URL)
	public Object maintPaymentClaimHandler(SearchVo searchVo) {
		Map<String, Object> rtnMap = adminService.getUnpaidMaintPaymentList(searchVo);
		List<Object> maintPaymentDetailList = (ArrayList<Object>)rtnMap.get("list");
		int total_count = CommonUtil.convertToInt(rtnMap.get("total_count"));
		searchVo.setTotalCount(total_count);
		ModelAndView mv = new ModelAndView();
		mv.addObject("maintPaymentDetailList", maintPaymentDetailList);
		mv.addObject("searchVo", searchVo);
		mv.setViewName(ROOT_URL + MAINT_PAYMENT_CLAIM_URL);
		return mv;
	}
	
	/** 
	 * 코드등록 팝업
	 */
	@RequestMapping(value=REGIST_CODE_URL)
	public Object registCodeHandler(String parentCodeSeq) {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> parentCodeInfo = commonService.getCodeInfo(parentCodeSeq);
		mv.addObject("parentCodeInfo", parentCodeInfo);
		mv.setViewName(ROOT_URL + REGIST_CODE_URL);
		return mv;
	}
	
	@RequestMapping(value=SELECT_MENU_ROLE_URL)
	public Object selectMenuRoleHandler(String roleId) {
		ModelAndView mv = new ModelAndView();
		List<Object> roleMenuList = adminService.getRoleMenuList(roleId);
		mv.addObject("roleMenuList", roleMenuList);
		mv.addObject("roleId", roleId);
		mv.setViewName(ROOT_URL + SELECT_MENU_ROLE_URL);
		return mv;
	}
	
	@RequestMapping(value=SELECT_USER_ROLE_URL)
	public Object selectUserRoleHandler(String roleId) {
		ModelAndView mv = new ModelAndView();
		List<Object> userRoleList = sysAdminService.getUserRoleList(roleId);
		mv.addObject("userRoleList", userRoleList);
		mv.addObject("roleId", roleId);
		mv.setViewName(ROOT_URL + SELECT_USER_ROLE_URL);
		return mv;
	}
	
	@RequestMapping(value=FIND_ID_PWD_URL)
	public Object findIdPwdHandler(HttpServletRequest request) {
		String findType = request.getParameter("findType");
		ModelAndView mv = new ModelAndView();
		mv.addObject("findType", findType);
		mv.setViewName(ROOT_URL + FIND_ID_PWD_URL);
		return mv;
	}
	
	@RequestMapping(value=APPROVAL_REQUEST_GRAVE)
	public Object approvalRequestGraveHandler(String bunyangSeq, String userSeq, String userId, String coupleSeq) {
		List<Object> approvalGraveList = adminService.getApprovalGraveList(bunyangSeq, userSeq, coupleSeq);
		Map<String, Object> bunyangInfo = adminService.getBunyangInfo(bunyangSeq);
		Map<String, Object> requestUserInfo = adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_USE_USER, userId);
		ModelAndView mv = new ModelAndView();
		mv.addObject("bunyangSeq", bunyangSeq);
		mv.addObject("userSeq", userSeq);
		mv.addObject("coupleSeq", coupleSeq);
		mv.addObject("approvalGraveList", approvalGraveList);
		mv.addObject("bunyangInfo", bunyangInfo);
		mv.addObject("requestUserInfo", requestUserInfo);
		mv.setViewName(ROOT_URL + APPROVAL_REQUEST_GRAVE);
		return mv;
	}
	
	@RequestMapping(value=SAVE_APPROVAL_REQUEST_GRAVE)
	@ResponseBody
	public Object saveApprovalRequestGraveHandler(@RequestBody ApprovalGraveVo vo) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		boolean bRslt = false;
		int errorCode = 0;
		int iRslt = 0;
		String bunyangSeq = vo.getBunyangSeq();
		String userSeq = vo.getUserSeq();
		// 이미 승인이 된 건인지 체크 
		int cnt = adminService.checkApprovalStatus(bunyangSeq, userSeq);
		if(cnt > 0) {
			iRslt = adminService.approvalRequestGrave(vo, null);
			bRslt = iRslt > 0;
		} else {
			errorCode = 1;
		}
		rtnMap.put("result", bRslt);
		rtnMap.put("errorCode", errorCode);
		return rtnMap;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value=SELECT_CONNECT_BUNYANG_URL)
	public Object selectConnectBunyangHandler(String groupSeq, String bunyangSeq, SearchVo searchVo) throws Exception {
		Map<String, Object> bunyangInfo = adminService.getBunyangInfo(bunyangSeq);
		List<Object> bunyangTimesList = commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_BUNYANG_TIMES);
		Map<String, Object> rtnMap = adminService.getBunyangList(searchVo);
		List<Object> bunyangList = (ArrayList<Object>)rtnMap.get("list");
		int total_count = CommonUtil.convertToInt(rtnMap.get("total_count"));
		searchVo.setTotalCount(total_count);
		ModelAndView mv = new ModelAndView();
		mv.addObject("groupSeq", groupSeq);
		mv.addObject("bunyangSeq", bunyangSeq);
		mv.addObject("bunyangInfo", bunyangInfo);
		mv.addObject("bunyangList", bunyangList);
		mv.addObject("bunyangTimesList", bunyangTimesList);
		mv.addObject("searchVo", searchVo);
		mv.setViewName(ROOT_URL + SELECT_CONNECT_BUNYANG_URL);
		return mv;
	}
	
	@RequestMapping(value=CONNECT_SELECTED_BUNYANG_URL)
	@ResponseBody
	public Object connectSelectedBunyangHandler(HttpServletRequest request) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String[] selectedBunyangSeq = request.getParameterValues("selectedBunyangSeq");
		String groupSeq = request.getParameter("groupSeq");
		String bunyangSeq = request.getParameter("bunyangSeq");
		boolean bRslt = false;
		if(StringUtils.isEmpty(groupSeq)) {
			groupSeq = String.valueOf(commonService.getSeqNexVal("GROUP_SEQ"));
		}
		int iRslt = adminService.createConnectBunyangInfo(groupSeq, bunyangSeq, selectedBunyangSeq);
		bRslt = iRslt > 0;
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
}
