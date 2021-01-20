package com.calvary.mobile.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.calvary.admin.service.IAdminService;
import com.calvary.admin.vo.BunyangUserVo;
import com.calvary.common.constant.CalvaryConstants;
import com.calvary.common.util.CommonUtil;
import com.calvary.common.util.SessionUtil;
import com.calvary.mobile.service.IMobileService;

@Controller
@RequestMapping(value=MobileController.ROOT_URL)
public class MobileController {

	/** */
	public static final String ROOT_URL = "/mobile";

	@Autowired
	private IMobileService mobileService;
	@Autowired
	private IAdminService adminService;

	/** 메인 페이지  URL */
	public static final String MAIN = "/main";

	/** 사용신청  URL */
	public static final String REQUEST_GRAVE = "/requestGrave";

	/** 동산배정  URL */
	public static final String ASSIGN_GRAVE = "/assignGrave";

	/** 사용신청 정보 저장  URL */
	public static final String SAVE_REQUEST_GRAVE = "/saveRequestGrave";

	/** 부고알림을 위한 장례정보 입력  URL */
	public static final String REGIST_FUNERAL_INFO = "/registFuneralInfo";

	/** 추모동산 사용현황 리스트 조회  URL */
	public static final String GET_GRAVE_USE_LIST = "/getGraveUseList";

	private static final Logger logger = LoggerFactory.getLogger(MobileController.class);


	/**
	 * 메인 페이지
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value=MAIN)
	public Object mainHandler() {
		BunyangUserVo userVo = SessionUtil.getCurrentBunyangUser();
		String bunyangSeq = userVo.getBunyangSeq();
		Map<String, Object> bunyangInfo = adminService.getBunyangInfo(bunyangSeq);
		List<Object> connectBunyangInfo = adminService.getConnectBunyangInfo(bunyangSeq);
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
		List<Object> useUserList = adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_USE_USER);
		List<Object> connectUseUserList = adminService.getConnectBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_USE_USER);

		if(useUserList != null && connectUseUserList != null) {
			useUserList.addAll(connectUseUserList);
		}

		List<Object> paymentList = adminService.getPaymentHistory(bunyangSeq, CalvaryConstants.PAYMENT_TYPE_DOWN_PAYMENT);// 계약금 납부내역
		paymentList.addAll(adminService.getPaymentHistory(bunyangSeq, CalvaryConstants.PAYMENT_TYPE_BALANCE_PAYMENT));// 분양잔금
		paymentList.addAll(adminService.getPaymentHistory(bunyangSeq, CalvaryConstants.PAYMENT_TYPE_MAINT_PAYMENT));// 관리비

		Map<String, Object> familyGraveRequestInfo = mobileService.getFamilyGraveRequestInfo(bunyangSeq);

		ModelAndView mv = new ModelAndView();
		mv.setViewName(ROOT_URL + MAIN);
		mv.addObject("userVo", userVo);
		mv.addObject("bunyangInfo", bunyangInfo);
		mv.addObject("connectBunyangInfo", connectBunyangInfo);
		mv.addObject("applyUser", applyUser);
		mv.addObject("agentUser", agentUser);
		mv.addObject("useUserList", useUserList);
		mv.addObject("connectUseUserList", connectUseUserList);
		mv.addObject("paymentList", paymentList);
		mv.addObject("familyGraveRequestInfo", familyGraveRequestInfo);
		return mv;
	}

	/**
	 * 사용신청 페이지
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value=REQUEST_GRAVE)
	public Object requestGraveHandler(String bunyangSeq, String userId) {
		Map<String, Object> familyGraveRequestInfo = mobileService.getFamilyGraveRequestInfo(bunyangSeq);
		Map<String, Object> bunyangInfo = adminService.getBunyangInfo(bunyangSeq);
		Map<String, Object> useUserInfo = adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_USE_USER, userId);

		int userSeq = CommonUtil.convertToInt(useUserInfo.get("user_seq"));
		int coupleSeq = CommonUtil.convertToInt(useUserInfo.get("couple_seq"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName(ROOT_URL + REQUEST_GRAVE);

		String errorCode = "";

		if(familyGraveRequestInfo != null) {// 가족형 최초 신청건이 승인대기중인 경우
			errorCode = "1";
		}else {
			Map<String, Object> requestInfo = adminService.getRequestGraveInfo(bunyangSeq, userSeq);
			if(requestInfo != null) {
				String requestStatus = (String)requestInfo.get("request_status");
				if("REQUESTED".equals(requestStatus)) {// 이미 신청해서 승인대기중인경우
					errorCode = "4";
				} else if("APPROVAL".equals(requestStatus)) {// 이미 사용중
					errorCode = "2";
				}
			}
			// 부부형일 경우 배우자 신청건이 승인중인지 체크
			if(StringUtils.isEmpty(errorCode) && coupleSeq > 0) {
				requestInfo = adminService.getCoupleRequestGraveInfo(bunyangSeq, userSeq, coupleSeq);
				if(requestInfo != null) {
					String requestStatus = (String)requestInfo.get("request_status");
					if("REQUESTED".equals(requestStatus)) {// 배우자 신청건이 승인대기중인경우
						errorCode = "3";
					}
				}
			}
			if(StringUtils.isEmpty(errorCode)) {
				String graveType = null;
				if(coupleSeq > 0) {
					graveType = CalvaryConstants.GRAVE_TYPE_COUPLE;
				} else {
					graveType = CalvaryConstants.GRAVE_TYPE_SINGLE;
				}

				String connect_product_type = (String)bunyangInfo.get("connect_product_type");

				// 이미 배정된 자리가 있는지 조회
				List<Object> assignedGraveList = null;
				Map<String, Object> assignedGraveInfo = null;
				String coupuleReserved = "0";

				if(CalvaryConstants.PRODUCT_TYPE_FAMILY.equals(connect_product_type)) {
					assignedGraveList = mobileService.getReservedGraveInfo(bunyangSeq, userSeq, coupleSeq, graveType);
				} else {
					if(CalvaryConstants.GRAVE_TYPE_COUPLE.equals(graveType)) {
						assignedGraveList = mobileService.getCoupleReservedGraveInfo(bunyangSeq, coupleSeq);
					}
				}

				if(assignedGraveList != null && assignedGraveList.size() > 0) {
					assignedGraveInfo = (Map<String, Object>)assignedGraveList.get(0);
					for(int i = 0; i < assignedGraveList.size(); i++) {
						Map<String, Object> tmp = (Map<String, Object>)assignedGraveList.get(i);
						if("1".equals(String.valueOf(tmp.get("couple_reserved")))) {
							coupuleReserved = "1";
							break;
						}
					}
				}

				int requiredCnt = mobileService.getRequiredGraveCount(bunyangSeq);// 필요한 묘개수
				if(!CalvaryConstants.PRODUCT_TYPE_FAMILY.equals(connect_product_type)) {// 개별형인 경우 1개만 신청할 수 있기 때문에
					requiredCnt = 1;
				}

				List<Object> avaliableGraveList = null;

				// 배정된 자리가 없는 경우 사용가능한 자리 조회
				if(assignedGraveInfo == null) {
					avaliableGraveList = mobileService.getAvailableGraveInfoAll(graveType, requiredCnt);
				}
				mv.addObject("coupuleReserved", coupuleReserved);
				mv.addObject("requiredCnt", requiredCnt);
				mv.addObject("bunyangInfo", bunyangInfo);
				mv.addObject("useUserInfo", useUserInfo);
				mv.addObject("assignedGraveList", assignedGraveList);
				mv.addObject("assignedGraveInfo", assignedGraveInfo);
				mv.addObject("avaliableGraveList", avaliableGraveList);
				mv.addObject("bunyangSeq", bunyangSeq);
				mv.addObject("userId", userId);
			}
		}
		mv.addObject("errorCode", errorCode);

		Map<String, Object> contract1 = mobileService.getContract("CONTRACT_01");// 교회행정담당
		Map<String, Object> contract2 = mobileService.getContract("CONTRACT_02");// 용인공원 장례담당
		mv.addObject("contract1", contract1);
		mv.addObject("contract2", contract2);
		return mv;
	}

	/**
	 * 사용신청정보 저장
	 */
	@RequestMapping(value=ASSIGN_GRAVE)
	@ResponseBody
	public Object assignGraveHandler(String productType, String bunyangSeq, int coupleSeq, int userSeq, String sectionSeq, int rowSeq, int colSeq, int isReserved) throws Exception{
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		boolean bRslt = false;
		int iRslt = mobileService.assignGrave(productType, bunyangSeq, coupleSeq, userSeq, sectionSeq, rowSeq, colSeq, isReserved);
		bRslt = iRslt > 0;
		rtnMap.put("result", bRslt);
		return rtnMap;
	}

	/**
	 * 사용신청정보 저장
	 */
	@RequestMapping(value=SAVE_REQUEST_GRAVE)
	@ResponseBody
	public Object saveRequestGraveHandler(
			String productType,
			String bunyangSeq,
			int coupleSeq,
			int userSeq,
			String userId,
			String sectionSeq,
			int rowSeq,
			int colSeq,
			int firstColSeq,
			int isReserved
			) throws Exception{
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		boolean bRslt = false;
		String errorCode = "";

		Map<String, Object> familyGraveRequestInfo = mobileService.getFamilyGraveRequestInfo(bunyangSeq);

		if(familyGraveRequestInfo != null) {// 가족형 최초 신청건이 승인대기중인 경우
			errorCode = "1";
		}else {
			Map<String, Object> requestInfo = adminService.getRequestGraveInfo(bunyangSeq, userSeq);
			if(requestInfo != null) {
				String requestStatus = (String)requestInfo.get("request_status");
				if("REQUESTED".equals(requestStatus)) {// 이미 신청해서 승인대기중인경우
					errorCode = "4";
				} else if("APPROVAL".equals(requestStatus)) {// 이미 사용중
					errorCode = "2";
				}
			}
			// 부부형일 경우 배우자 신청건이 승인중인지 체크
			if(StringUtils.isEmpty(errorCode) && coupleSeq > 0) {
				requestInfo = adminService.getCoupleRequestGraveInfo(bunyangSeq, userSeq, coupleSeq);
				if(requestInfo != null) {
					String requestStatus = (String)requestInfo.get("request_status");
					if("REQUESTED".equals(requestStatus)) {// 배우자 신청건이 승인대기중인경우
						errorCode = "3";
					}
				}
			}
		}
		if(StringUtils.isEmpty(errorCode)) {
			Map<String, Object> bunyangInfo = adminService.getBunyangInfo(bunyangSeq);
			String groupSeq = (String)bunyangInfo.get("group_seq");

			int iRslt = mobileService.requestGrave(productType, groupSeq, bunyangSeq, coupleSeq, userSeq, sectionSeq, rowSeq, colSeq, firstColSeq, isReserved);
			bRslt = iRslt > 0;
		}
		rtnMap.put("result", bRslt);
		rtnMap.put("errorCode", errorCode);
		return rtnMap;
	}

	@RequestMapping(value=REGIST_FUNERAL_INFO)
	public Object registFuneralInfoHandler(
			@RequestParam(value="bunyangSeq", required=true) String bunyangSeq,
			@RequestParam(value="userId", required=true) String userId,
			@RequestParam(value="sectionSeq", required=true) String sectionSeq,
			@RequestParam(value="seqNo", required=true) String seqNo,
			@RequestParam(value="deathDate", required=true) String deathDate,
			@RequestParam(value="borneOutDate", required=true) String borneOutDate
			) {
		Map<String, Object> useUserInfo = adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_USE_USER, userId);
		Map<String, Object> graveInfo = adminService.getGraveAssignInfoBySeqNo(sectionSeq, seqNo);

		List<Object> contractMinister = mobileService.getContractMinister(bunyangSeq);
		Map<String, Object> contract1 = mobileService.getContract("CONTRACT_01");// 교회행정담당
		Map<String, Object> contract2 = mobileService.getContract("CONTRACT_02");// 용인공원 장례담당
		List<Object> contract3 = mobileService.getContractList("CONTRACT_03");// 용인공원 라이프
		// 봉안신청시 공지 팝업 표시를 위해 해당 정보 저장
		try {
			String requestUser = "";
			if(SessionUtil.getCurrentBunyangUser() != null) {
				requestUser = SessionUtil.getCurrentBunyangUser().getUserId();
			}
			mobileService.createGraveNotice(bunyangSeq, String.valueOf(useUserInfo.get("user_seq")), requestUser, borneOutDate, deathDate);
		} catch (Exception e) {
			logger.error("createGraveNotice error occured!!", e);
		}
		ModelAndView mv = new ModelAndView();
		mv.addObject("useUserInfo", useUserInfo);
		mv.addObject("graveInfo", graveInfo);
		mv.addObject("contractMinister", contractMinister);
		mv.addObject("contract1", contract1);
		mv.addObject("contract2", contract2);
		mv.addObject("contract3", contract3);
		mv.addObject("deathDate", deathDate);
		mv.addObject("borneOutDate", borneOutDate);
		mv.setViewName(ROOT_URL + REGIST_FUNERAL_INFO);
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
}
