package com.calvary.admin.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.calvary.admin.vo.BunyangInfoVo;
import com.calvary.admin.vo.BunyangUserVo;
import com.calvary.common.constant.CalvaryConstants;
import com.calvary.common.dao.CommonDao;
import com.calvary.common.service.ICommonService;
import com.calvary.common.util.CommonUtil;
import com.calvary.common.util.SMSUtil;
import com.calvary.common.util.SessionUtil;
import com.calvary.common.vo.ResultSmsVo;
import com.calvary.common.vo.SearchVo;
import com.calvary.common.vo.SendSmsVo;
import com.calvary.popup.vo.ApprovalGraveVo;
import com.calvary.popup.vo.GraveInfoVo;

@Service
public class AdminServiceImpl implements IAdminService {
	
	@Autowired
	private CommonDao commonDao;
	@Autowired
	private ICommonService commonService;
	
	private static final Logger logger = LoggerFactory.getLogger(AdminServiceImpl.class);
	private static final Logger errLogger = LoggerFactory.getLogger("ERROR_LOGGER");
	
	
	//===============================================================================
	// Common
	//===============================================================================
	/** 
	 * 분양리스트 조회 
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getBunyangList(SearchVo searchVo) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("start", (searchVo.getPageIndex()-1) * searchVo.getCountPerPage());
		parameter.put("count", searchVo.getCountPerPage());
		parameter.put(searchVo.getSearchKey(), searchVo.getSearchVal());
		List<Object> list = commonDao.selectList("admin.getBunyangList", parameter); 
		Map<String, Object> countMap = (HashMap<String, Object>)commonDao.selectOne("totalcount.getBunyangList", parameter);
		int total_count = 0;
		if(countMap != null) {
			total_count = CommonUtil.convertToInt(countMap.get("total_count"));
		}
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("list", list);
		rtnMap.put("total_count", total_count);
		return rtnMap;
	}
	
	/** 
	 * 분양리스트 조회 
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getBunyangSelectList(String searchVal, int pageIndex) {
		int countPerPage = 10;
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("start", (pageIndex-1) * countPerPage);
		parameter.put("count", countPerPage);
		parameter.put("searchVal", searchVal);
		List<Object> list = commonDao.selectList("admin.getBunyangList", parameter);
		Map<String, Object> countMap = (HashMap<String, Object>)commonDao.selectOne("totalcount.getBunyangList", parameter);
		int total_count = 0;
		if(countMap != null) {
			total_count = CommonUtil.convertToInt(countMap.get("total_count"));
		}
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("list", list);
		rtnMap.put("total_count", total_count);
		return rtnMap;
	}
	
	

	//===============================================================================
	// 분양신청관리
	//===============================================================================
	/** 
	 * 분양신청리스트 조회 
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getApplyList(SearchVo searchVo) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("start", (searchVo.getPageIndex()-1) * searchVo.getCountPerPage());
		parameter.put("count", searchVo.getCountPerPage());
		parameter.put("apply_user_name", searchVo.getSearchVal());
		parameter.put("progressStatus", searchVo.getProgressStatus());
		parameter.put("bunyangTimes", searchVo.getBunyangTimes());
		List<Object> list = commonDao.selectList("admin.getApplyList", parameter);
		Map<String, Object> countMap = (HashMap<String, Object>)commonDao.selectOne("totalcount.getApplyList", parameter);
		int total_count = 0;
		if(countMap != null) {
			total_count = CommonUtil.convertToInt(countMap.get("total_count"));
		}
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("list", list);
		rtnMap.put("total_count", total_count);
		return rtnMap;
	}
	
	/** 
	 * 분양 정보 조회 
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getBunyangInfo(String bunyangSeq) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("bunyangSeq", bunyangSeq);
		Map<String, Object> rtn = (HashMap<String, Object>)commonDao.selectOne("admin.getBunyangInfo", param); 
		return rtn;
	}
	
	/** 
	 * 분양 정보 조회 
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getBunyangInfoByNo(String bunyangNo) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("bunyangNo", bunyangNo);
		Map<String, Object> rtn = (HashMap<String, Object>)commonDao.selectOne("admin.getBunyangInfo", param); 
		return rtn;
	}
	
	/** 
	 * 분양관련 사용자 정보 조회 
	 */
	public List<Object> getBunyangRefUserInfo(String bunyangSeq, String refType) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("bunyangSeq", bunyangSeq);
		parameter.put("refType", refType);
		List<Object> list = commonDao.selectList("admin.getBunyangRefUserInfo", parameter); 
		return list;
	}
	
	/** 
	 * 분양관련 사용자 정보 조회 
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getBunyangRefUserInfo(String bunyangSeq, String refType, String userId) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("bunyangSeq", bunyangSeq);
		parameter.put("refType", refType);
		parameter.put("userId", userId);
		Map<String, Object> rtnMap = (HashMap<String, Object>)commonDao.selectOne("admin.getBunyangRefUserInfo", parameter); 
		return rtnMap;
	}
	
	/** 
	 * 배우자 정보 조회 
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getCoupleUserInfo(String bunyangSeq, String refType, String userId, int coupleSeq) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("bunyangSeq", bunyangSeq);
		parameter.put("refType", refType);
		parameter.put("userId", userId);
		parameter.put("coupleSeq", coupleSeq);
		Map<String, Object> rtnMap = (HashMap<String, Object>)commonDao.selectOne("admin.getCoupleUserInfo", parameter); 
		return rtnMap;
	}
	
	/** 
	 * 분양정보의 신청서,승인서등 관련 파일양식 조회
	 */
	public List<Object> getBunyangFileList(String bunyangSeq) {
		List<Object> list = commonDao.selectList("admin.getBunyangFileList", bunyangSeq); 
		return list;
	}
	
	/** 
	 * 분양신청 정보 저장
	 * @param bunyangInfoVo
	 */
	@Transactional
	public String createBunyangInfo(BunyangInfoVo bunyangInfoVo, String updateDate) throws Exception {
		String sRtn = "";
		BunyangUserVo applyUser = bunyangInfoVo.getApplyUser();
		BunyangUserVo agentUser = bunyangInfoVo.getAgentUser();
		Map<String, Object> param = null;
		List<BunyangUserVo> useUsers = bunyangInfoVo.getUseUsers();
		String bunyangSeq = String.valueOf(commonService.getSeqNexVal("BUNYANG_SEQ"));
		
		// 분양정보 생성
		param = new HashMap<String, Object>();
		param.put("bunyangSeq", bunyangSeq);
		param.put("productType", bunyangInfoVo.getProductType());
		param.put("coupleTypeCount", bunyangInfoVo.getCoupleTypeCount());
		param.put("singleTypeCount", bunyangInfoVo.getSingleTypeCount());
		param.put("serviceChargeType", bunyangInfoVo.getServiceChargeType());
		param.put("progressStatus", bunyangInfoVo.getProgressStatus());
		param.put("bunyangTimes", bunyangInfoVo.getBunyangTimes());
		param.put("pricePerCount", bunyangInfoVo.getPricePerCount());
		param.put("registUserId", SessionUtil.getCurrentUserId());
		param.put("updateDate", updateDate);
		param.put("userId", SessionUtil.getCurrentUserId());
		commonDao.insert("admin.createBunyangInfo", param);
		commonDao.insert("admin.createBunyangHistory", param);
		
		// 분양 관련 인명정보 생성(신청자)
		param = getBunyangUserParam(applyUser, 1);
		param.put("bunyangSeq", bunyangSeq);
		commonDao.insert("admin.createBunyangRefUserInfo", param);
		
		// 분양 관련 인명정보 생성(대리인)
		if(agentUser != null) {
			param = getBunyangUserParam(agentUser, 1);
			param.put("bunyangSeq", bunyangSeq);
			commonDao.insert("admin.createBunyangRefUserInfo", param);
		}
		
		// 분양 관련 인명정보 생성(사용자)
		if(useUsers != null && useUsers.size() > 0) {
			for(int i = 0; i < useUsers.size(); i++) {
				BunyangUserVo useUser = useUsers.get(i);
				param = getBunyangUserParam(useUser, i+1);
				param.put("bunyangSeq", bunyangSeq);
				commonDao.insert("admin.createBunyangRefUserInfo", param);
			}
		}
		sRtn = bunyangSeq;
		return sRtn;
	}
	
	/** 
	 * 분양 양식파일 고유번호 업데이트
	 */
	public int updateBunyangFileSeq(Map<String, Object> param) throws Exception {
		int iRslt = commonDao.update("admin.updateBunyangFileSeq", param);
		return iRslt;
	}
	
	/** 
	 * 사용(봉안)자 사용승인서 파일seq 업데이트
	 */
	public int updateUseUserFileSeq(String fileSeq, String bunyangSeq, String userId) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("fileSeq", fileSeq);
		param.put("bunyangSeq", bunyangSeq);
		param.put("userId", userId);
		int iRslt = commonDao.update("admin.updateUseUserFileSeq", param);
		return iRslt;
	}
	
	/** 
	 * 분양정보 진행상태 업데이트
	 */
	@Transactional
	public int updateBunyangProgressStatus(BunyangInfoVo bunyangInfoVo, String updateUser, String updateDate) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("bunyangNo", bunyangInfoVo.getBunyangNo());
		param.put("bunyangSeq", bunyangInfoVo.getBunyangSeq());
		param.put("progressStatus", bunyangInfoVo.getProgressStatus());
		param.put("userId", updateUser);
		param.put("updateDate", updateDate);
		param.put("remarks", bunyangInfoVo.getRemarks());
		int iRslt = 0;
		// 진행상태 업데이트
		iRslt += commonDao.update("admin.updateBunyangProgressStatus", param);
		// 변경이력
		iRslt += commonDao.insert("admin.createBunyangHistory", param);
		return iRslt;
	}
	
	/** 
	 * 분양취소
	 */
	@Transactional
	public int cancelBunyangInfo(BunyangInfoVo bunyangInfoVo, String updateUser) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("bunyangSeq", bunyangInfoVo.getBunyangSeq());
		param.put("progressStatus", CalvaryConstants.PROGRESS_STATUS_CA);
		param.put("remarks", bunyangInfoVo.getRemarks());
		param.put("userId", updateUser);
		int iRslt = 0;
		iRslt += commonDao.update("admin.cancelBunyangInfo", param);
		// 변경이력
		iRslt += commonDao.insert("admin.createBunyangHistory", param);
		return iRslt;
	}
	
	/** 
	 * 분양정보삭제
	 */
	@Transactional
	public int deleteBunyangInfo(BunyangInfoVo bunyangInfoVo, String updateUser) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("bunyangSeq", bunyangInfoVo.getBunyangSeq());
		param.put("progressStatus", CalvaryConstants.PROGRESS_STATUS_DEL);
		param.put("remarks", bunyangInfoVo.getRemarks());
		param.put("userId", updateUser);
		int iRslt = 0;
		iRslt += commonDao.delete("admin.deleteBunyangInfo", param);
		iRslt += commonDao.delete("admin.deleteBunyangRefUser", param);
		// 변경이력
		iRslt += commonDao.insert("admin.createBunyangHistory", param);
		return iRslt;
	}
	
	/**
	 * 분양차수중 최종 분양번호 +1 반환
	 * @param bunyangTimes
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String getNextBunyangNo(int bunyangTimes) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("bunyangTimes", bunyangTimes);
		Map<String, Object> rtnMap = (HashMap<String, Object>)commonDao.selectOne("admin.getNextBunyangNo", param);
		String bunyangNo = (String)rtnMap.get("bunyang_no");
		return bunyangNo;
	}
	
	/** 
	 * 분양 관련 인명정보 생성을 위한 parameter 반환
	 */
	private Map<String, Object> getBunyangUserParam(BunyangUserVo bunyangUserVo, int userSeq) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("refType", bunyangUserVo.getRefType());
		param.put("relationType", bunyangUserVo.getRelationType());
		param.put("churchOfficer", bunyangUserVo.getChurchOfficer());
		param.put("diocese", bunyangUserVo.getDiocese());
		param.put("userId", bunyangUserVo.getUserId());
		param.put("userName", bunyangUserVo.getUserName());
		param.put("birthDate", bunyangUserVo.getBirthDate());
		param.put("gender", bunyangUserVo.getGender());
		param.put("email", bunyangUserVo.getEmail());
		param.put("mobile", bunyangUserVo.getMobile());
		param.put("phone", bunyangUserVo.getPhone());
		param.put("postNumber", bunyangUserVo.getPostNumber());
		param.put("address1", bunyangUserVo.getAddress1());
		param.put("address2", bunyangUserVo.getAddress2());
		param.put("isChurchPerson", bunyangUserVo.getIsChurchPerson());
		param.put("isMove", bunyangUserVo.getIsMove());
		param.put("isMaintCharger", bunyangUserVo.getIsMaintCharger());
		if(bunyangUserVo.getCoupleSeq() >= 0) {
			param.put("coupleSeq", bunyangUserVo.getCoupleSeq());
		}
		param.put("userSeq", userSeq);
		return param;
	}
	
	
	
	//===============================================================================
	// 사용계약관리
	//===============================================================================
	/** 
	 * 사용계약리스트 조회 
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getContractList(SearchVo searchVo) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("start", (searchVo.getPageIndex()-1) * searchVo.getCountPerPage());
		parameter.put("count", searchVo.getCountPerPage());
		parameter.put("apply_user_name", searchVo.getSearchVal());
		parameter.put("progressStatus", searchVo.getProgressStatus());
		parameter.put("bunyangTimes", searchVo.getBunyangTimes());
		List<Object> list = commonDao.selectList("contract.getContractList", parameter); 
		Map<String, Object> countMap = (HashMap<String, Object>)commonDao.selectOne("totalcount.getContractList", parameter);
		int total_count = 0;
		if(countMap != null) {
			total_count = CommonUtil.convertToInt(countMap.get("total_count"));
		}
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("list", list);
		rtnMap.put("total_count", total_count);
		return rtnMap;
	}
	
	/** 
	 * 대금납부내역조회
	 */
	public List<Object> getPaymentHistory(String bunyangSeq, String paymentType) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("bunyangSeq", bunyangSeq);
		param.put("paymentType", paymentType);
		List<Object> list = commonDao.selectList("contract.getPaymentHistory", param); 
		return list;
	}
	
	/** 
	 * 총대금납부금액조회
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getTotalPayment(String bunyangSeq) {
		Map<String, Object> rtn = (HashMap<String, Object>)commonDao.selectOne("contract.getTotalPayment", bunyangSeq); 
		return rtn;
	}
	
	/** 
	 * 계약금 납부 내역 업데이트
	 */
	@Transactional
	public int updateDownPayment(String bunyangSeq, int paymentAmount, String paymentMethod, String paymentDate, String createDate, String updateDate, boolean isContracted) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		int iRslt = 0;
		// 계약금 납부 정보 업데이트
		param.put("bunyangSeq", bunyangSeq);
		param.put("paymentType", CalvaryConstants.PAYMENT_TYPE_DOWN_PAYMENT);
		param.put("paymentAmount", paymentAmount);
		param.put("paymentMethod", paymentMethod);
		param.put("paymentDate", paymentDate);
		param.put("createDate", createDate);
		param.put("createUser", SessionUtil.getCurrentUser().getUserId());
		iRslt += commonDao.delete("contract.deleteDownPayment", param);
		iRslt += commonDao.insert("contract.insertDownPayment", param);
		if(isContracted) {
			// 분양상태를 계약상태로 업데이트
			BunyangInfoVo bunyangInfoVo = new BunyangInfoVo();
			bunyangInfoVo.setBunyangSeq(bunyangSeq);
			bunyangInfoVo.setProgressStatus(CalvaryConstants.PROGRESS_STATUS_B);
			iRslt += updateBunyangProgressStatus(bunyangInfoVo, SessionUtil.getCurrentUserId(), updateDate);
		}
		return iRslt;
	}
	
	/** 
	 * 잔금 납부 내역 업데이트
	 */
	@Transactional
	public int updateBalancePayment(String bunyangSeq, int[] paymentAmount, String[] paymentMethod, String[] paymentDate, String createDate, boolean isFullPayment) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		int iRslt = 0;
		param.put("bunyangSeq", bunyangSeq);
		param.put("paymentType", CalvaryConstants.PAYMENT_TYPE_BALANCE_PAYMENT);
		param.put("createUser", SessionUtil.getCurrentUser().getUserId());
		// 일단삭제
		iRslt += commonDao.delete("contract.deleteDownPayment", param);
		// 신규로 생성
		if(paymentAmount != null &&paymentAmount.length > 0) {
			for(int i = 0; i < paymentAmount.length; i++) {
				param.put("paymentAmount", paymentAmount[i]);
				param.put("paymentMethod", paymentMethod[i]);
				param.put("paymentDate", paymentDate[i]);
				param.put("createDate", null);
				iRslt += commonDao.insert("contract.insertDownPayment", param);
			}
		}	
		if(isFullPayment) {
			// 분양상태를 완납상태로 업데이트
			BunyangInfoVo bunyangInfoVo = new BunyangInfoVo();
			bunyangInfoVo.setBunyangSeq(bunyangSeq);
			bunyangInfoVo.setProgressStatus(CalvaryConstants.PROGRESS_STATUS_C);
			iRslt += updateBunyangProgressStatus(bunyangInfoVo, SessionUtil.getCurrentUserId(), createDate);
		}
		return iRslt;
	}
	
	/** 
	 * 분양관련 입출금(계약금,잔금,관리비..) 정보 생성
	 */
	public int createPaymentHistory(String bunyangSeq, int paymentAmount, String paymentMethod, String paymentDate, String paymentDivision, String paymentType, String paymentUser, String remark) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		int iRslt = 0;
		// 계약금 납부 정보 업데이트
		param.put("bunyangSeq", bunyangSeq);
		param.put("paymentDivision", paymentDivision);
		param.put("paymentType", paymentType);
		param.put("paymentUser", paymentUser);
		param.put("paymentAmount", paymentAmount);
		param.put("paymentMethod", paymentMethod);
		param.put("paymentDate", paymentDate);
		param.put("remark", remark);
		param.put("createUser", SessionUtil.getCurrentUser().getUserId());
		iRslt = commonDao.insert("contract.insertDownPayment", param);
		return iRslt;
	}
	
	/** 
	 * 분양관련 입출금(계약금,잔금,관리비..) 정보 생성
	 */
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class)
	public int createPaymentHistory(String[] bunyangSeqs, int[] paymentAmounts, String[] paymentMethods, String[] paymentDates, String[] paymentDivisions, String[] paymentTypes, String[] paymentUsers, String[] remarks, String[] maintSeqs, String sendSmsYn) throws Exception {
		int iRslt = 0;
		if(bunyangSeqs != null && bunyangSeqs.length > 0) {
			for(int i = 0; i < bunyangSeqs.length; i++) {
				Map<String, Object> param = new HashMap<String, Object>();
				String paymentDivision = paymentDivisions[i];
				String paymentType = paymentTypes[i];
				int paymentAmount = paymentAmounts[i];
				// 분양잔금 입금시 계약금 완납이 안된 경우 입금해야할 계약금만큼 제하고 분양잔금 입금처리함
				if(CalvaryConstants.PAYMENT_DIVISION_DEPOSIT.equals(paymentDivision)
						&& CalvaryConstants.PAYMENT_TYPE_BALANCE_PAYMENT.equals(paymentType)) {
					boolean bExistContract = false;
					// 일단 리스트중에 같은 분양건의 계약금 입금 내역이 있는지 조회
					for(int j = 0; j < bunyangSeqs.length; j++) {
						if(bunyangSeqs[j] != null && bunyangSeqs[j].equals(bunyangSeqs[i]) && CalvaryConstants.PAYMENT_TYPE_DOWN_PAYMENT.equals(paymentTypes[j])) {
							bExistContract = true;
							break;
						}
					}
					if(!bExistContract) {
						param = new HashMap<String, Object>();
						param.put("bunyangSeq", bunyangSeqs[i]);
						Map<String, Object> tmp = (HashMap<String, Object>)commonDao.selectOne("contract.getRequiredContractPrice", param);
						if(tmp != null) {
							int requiredContractPrice = CommonUtil.convertToInt(tmp.get("required_contract_price"));
							// 입금해야할 계약금이 있을경우
							if(requiredContractPrice > 0) {
								if(requiredContractPrice >= paymentAmount) {
									requiredContractPrice = paymentAmount;
								}
								param = new HashMap<String, Object>();
								param.put("bunyangSeq", bunyangSeqs[i]);
								param.put("paymentDivision", CalvaryConstants.PAYMENT_DIVISION_DEPOSIT);
								param.put("paymentType", CalvaryConstants.PAYMENT_TYPE_DOWN_PAYMENT);
								param.put("paymentUser", paymentUsers[i]);
								param.put("paymentAmount", requiredContractPrice);
								param.put("paymentMethod", paymentMethods[i]);
								param.put("paymentDate", paymentDates[i]);
								param.put("remark", remarks[i]);
								param.put("maintSeq", maintSeqs[i]);
								param.put("createUser", SessionUtil.getCurrentUser().getUserId());
								iRslt += insertPaymentAndSendSms(param, sendSmsYn);
								paymentAmount = paymentAmount - requiredContractPrice;
							}
						}
					}
				}
				
				if(paymentAmount <= 0) {
					continue;
				}
				
				param = new HashMap<String, Object>();
				param.put("bunyangSeq", bunyangSeqs[i]);
				param.put("paymentDivision", paymentDivision);
				param.put("paymentType", paymentType);
				param.put("paymentUser", paymentUsers[i]);
				param.put("paymentAmount", paymentAmount);
				param.put("paymentMethod", paymentMethods[i]);
				param.put("paymentDate", paymentDates[i]);
				param.put("remark", remarks[i]);
				param.put("maintSeq", maintSeqs[i]);
				param.put("createUser", SessionUtil.getCurrentUser().getUserId());
				iRslt += insertPaymentAndSendSms(param, sendSmsYn);
				// 관리비 납부의 경우 관리비 납부 대상 정보도 납부상태로 업데이트 해줌
				if(CalvaryConstants.PAYMENT_DIVISION_DEPOSIT.equals(paymentDivision)
						&& CalvaryConstants.PAYMENT_TYPE_MAINT_PAYMENT.equals(paymentType)) {
					iRslt += commonDao.update("contract.updateMaintPaymentInfo", param);
				}
				
				//createPaymentHistory(bunyangSeqs[i], paymentAmounts[i], paymentMethods[i], paymentDates[i], paymentDivisions[i], paymentTypes[i], paymentUsers[i], remarks[i]);
			}
		}
		return iRslt;
	}
	
	@SuppressWarnings("unchecked")
	private int insertPaymentAndSendSms(Map<String, Object> param, String sendSmsYn) throws Exception {
		int iRslt = 0;
		iRslt = commonDao.insert("contract.insertDownPayment", param);
		try {
			if(iRslt > 0 && "Y".equals(sendSmsYn)) {
				String bunyangSeq = (String)param.get("bunyangSeq");
				if(CalvaryConstants.PAYMENT_DIVISION_DEPOSIT.equals(param.get("paymentDivision"))) {
					List<Object> applyUserList = getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_APPLY_USER);
					if(applyUserList != null && applyUserList.size() > 0) {
						Map<String, Object> applyUser = (HashMap<String, Object>)applyUserList.get(0);
						String mobile = (String)applyUser.get("mobile");
						Map<String, Object> tmp = commonService.getSmsMsg("M0004");
						if(tmp != null && !StringUtils.isEmpty(mobile)) {
							String msgContents = (String)tmp.get("msg_contents");
							String msgType = (String)tmp.get("msg_type");
							String subject = (String)tmp.get("msg_subject");
							SendSmsVo smsVo = new SendSmsVo();
							String paymentDate = (String)param.get("paymentDate");
							if(!StringUtils.isEmpty(paymentDate) && paymentDate.length() >= 8) {
								paymentDate = paymentDate.substring(2, 4) + "/" + paymentDate.substring(4, 6) + "/" + paymentDate.substring(6, 8);
							}
							String paymentAmount = CommonUtil.getThousandSeperatorFormatString(CommonUtil.convertToInt(param.get("paymentAmount"))) + "원";
							String[] sequences = new String[] {(String)applyUser.get("user_name"), paymentDate, paymentAmount};
							msgContents = SMSUtil.getMsgContents(msgContents, sequences);
							smsVo.setMsgContents(msgContents);
							smsVo.setMsgType(msgType);
							smsVo.setReceivers(mobile);
							smsVo.setSubject(subject);
							SMSUtil.sendSms(smsVo);
						}
					}
				}
			}
		} catch (Exception e) {
			errLogger.error("insertPaymentAndSendSms error occured!!", e);
		}
		return iRslt;
	}
	
	
	//===============================================================================
	// 사용승인관리
	//===============================================================================
	/** 
	 * 사용승인리스트 조회 
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getApprovalList(SearchVo searchVo) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("start", (searchVo.getPageIndex()-1) * searchVo.getCountPerPage());
		parameter.put("count", searchVo.getCountPerPage());
		parameter.put("apply_user_name", searchVo.getSearchVal());
		parameter.put("progressStatus", searchVo.getProgressStatus());
		parameter.put("bunyangTimes", searchVo.getBunyangTimes());
		List<Object> list = commonDao.selectList("approval.getApprovalList", parameter); 
		Map<String, Object> countMap = (HashMap<String, Object>)commonDao.selectOne("totalcount.getApprovalList", parameter);
		int total_count = 0;
		if(countMap != null) {
			total_count = CommonUtil.convertToInt(countMap.get("total_count"));
		}
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("list", list);
		rtnMap.put("total_count", total_count);
		return rtnMap;
	}
	
	/** 
	 *  사용(봉안)자 승인
	 */
	public int approvalUser(String bunyangSeq, String userId, String approvalNo, String yonginNo, String approvalDate) throws Exception{
		Map<String, Object> param = new HashMap<String, Object>();
		int iRslt = 0;
		param.put("bunyangSeq", bunyangSeq);
		param.put("userId", userId);
		param.put("approvalNo", approvalNo);
		param.put("yonginNo", yonginNo);
		param.put("approvalDate", approvalDate);
		iRslt += commonDao.update("approval.approvalUser", param);
		return iRslt; 
	}
	
	/** 
	 *  용인공원 확약번호 중복 체크
	 */
	@SuppressWarnings("unchecked")
	public int checkDuplicatedYonginNo(String yonginNo) {
		int count = 0;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("yonginNo", yonginNo);
		Map<String, Object> countMap = (HashMap<String, Object>)commonDao.selectOne("approval.checkDuplicatedYonginNo", param);
		if(countMap != null) {
			count = CommonUtil.convertToInt(countMap.get("cnt"));
		}
		return count; 
	}
	
	/** 
	 *  사용(봉안)자 승인서 출력일자 업데이트
	 */
	public int updateApprovalAssignDate(String bunyangSeq, String userId) throws Exception{
		Map<String, Object> param = new HashMap<String, Object>();
		int iRslt = 0;
		param.put("bunyangSeq", bunyangSeq);
		param.put("userId", userId);
		iRslt += commonDao.update("approval.updateApprovalAssignDate", param);
		return iRslt; 
	}
	
	/** 
	 * 특정 분양차수의 분양시작일을 조회
	 */
	@SuppressWarnings("unchecked")
	public String getBunyangStartDate(int bunyangTimes) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("bunyangTimes", bunyangTimes);
		Map<String, Object> tmpMap = (HashMap<String, Object>)commonDao.selectOne("approval.getBunyangStartDate", param);
		String startDate = (String)tmpMap.get("start_date");
		return startDate;
	}
	
	/**
	 * 관리비 납부 정보 생성 
	 */
//	@SuppressWarnings("unchecked")
//	@Transactional
//	public int createMaintPaymentInfo(String bunyangSeq) throws Exception {
//		int iRslt = 0;
//		// 사용(봉안)자 리스트 조회
//		List<Object> userList = getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_USE_USER);
//		if(userList != null && userList.size() > 0) {
//			for(int i = 0; i < userList.size(); i++) {
//				Map<String, Object> userInfo = (Map<String, Object>)userList.get(i);
//				int userSeq = CommonUtil.convertToInt(userInfo.get("user_seq"));
//				String cancelSeq = (String)userInfo.get("cancel_seq");
//				if(!StringUtils.isEmpty(cancelSeq)) {// 해약된건
//					continue;
//				}
//				Map<String, Object> param = new HashMap<String, Object>();
//				param.put("bunyangSeq", bunyangSeq);
//				param.put("userSeq", userSeq);
//				Map<String, Object> tmp = (HashMap<String, Object>)commonDao.selectOne("admin.getMaintPaymentCount", param);
//				int cnt = 0;
//				if(tmp != null) {
//					cnt = CommonUtil.convertToInt(tmp.get("cnt"));
//				}
//				if(cnt == 0) {
//					String maintSeq = String.valueOf(commonService.getSeqNexVal("MAINT_SEQ"));
//					param.put("maintSeq", maintSeq);
//					iRslt += commonDao.insert("admin.createMaintPaymentInfo", param);
//				}
//			}
//		}
//		return iRslt;
//	}
	
	/**
	 * 관리비 납부 정보 생성 
	 */
	@SuppressWarnings("unchecked")
	@Transactional
	public int createMaintPaymentInfo(String bunyangSeq, String approvalDate) throws Exception {
		int iRslt = 0;
		// 사용(봉안)자 리스트 조회
		List<Object> userList = getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_USE_USER);
		if(userList != null && userList.size() > 0) {
			for(int i = 0; i < userList.size(); i++) {
				Map<String, Object> userInfo = (Map<String, Object>)userList.get(i);
				int userSeq = CommonUtil.convertToInt(userInfo.get("user_seq"));
				String cancelSeq = (String)userInfo.get("cancel_seq");
				if(!StringUtils.isEmpty(cancelSeq)) {// 해약된건
					continue;
				}
				String maintSeq = String.valueOf(commonService.getSeqNexVal("MAINT_SEQ"));
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("bunyangSeq", bunyangSeq);
				param.put("approvalDate", approvalDate);
				param.put("userSeq", userSeq);
				param.put("maintSeq", maintSeq);
				iRslt += commonDao.insert("admin.createMaintPaymentInfo", param);
			}
		}
		return iRslt;
	}
	
	
	//===============================================================================
	// 계약자관리
	//===============================================================================
	/** 
	 * 계약자관리 리스트 조회
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getContractorList(SearchVo searchVo) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("start", (searchVo.getPageIndex()-1) * searchVo.getCountPerPage());
		parameter.put("count", searchVo.getCountPerPage());
		parameter.put("apply_user_name", searchVo.getSearchVal());
		parameter.put("progressStatus", searchVo.getProgressStatus());
		parameter.put("bunyangTimes", searchVo.getBunyangTimes());
		List<Object> list = commonDao.selectList("contractor.getContractorList", parameter); 
		Map<String, Object> countMap = (HashMap<String, Object>)commonDao.selectOne("totalcount.getContractorList", parameter);
		int total_count = 0;
		if(countMap != null) {
			total_count = CommonUtil.convertToInt(countMap.get("total_count"));
		}
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("list", list);
		rtnMap.put("total_count", total_count);
		return rtnMap;
	}
	
	/** 
	 * 대리인 정보 삭제
	 */
	public int deleteAgentUser(String bunyangSeq) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		int iRslt = 0;
		param.put("bunyangSeq", bunyangSeq);
		iRslt += commonDao.update("contractor.deleteAgentUser", param);
		return iRslt;
	}
	
	/** 
	 * 신청자/대리인/사용자 정보 변경 
	 */
	public int updateContractUser(BunyangUserVo userVo) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		int iRslt = 0;
		param.put("userId", userVo.getUserId());
		param.put("relationType", userVo.getRelationType());
		param.put("userName", userVo.getUserName());
		param.put("birthDate", userVo.getBirthDate());
		param.put("gender", userVo.getGender());
		param.put("email", userVo.getEmail());
		param.put("mobile", userVo.getMobile());
		param.put("phone", userVo.getPhone());
		param.put("postNumber", userVo.getPostNumber());
		param.put("address1", userVo.getAddress1());
		param.put("address2", userVo.getAddress2());
		param.put("isChurchPerson", userVo.getIsChurchPerson());
		param.put("churchOfficer", userVo.getChurchOfficer());
		param.put("diocese", userVo.getDiocese());
		param.put("isMove", userVo.getIsMove());
		param.put("isMaintCharger", userVo.getIsMaintCharger());
		iRslt += commonDao.update("contractor.updateContractUser", param);
		return iRslt;
	}
	
	/** 
	 * 계약정보 및 관련 사용자 정보 업데이트
	 */
	@Transactional
	public int updateContractInfo(BunyangInfoVo bunyangInfoVo) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		int iRslt = 0;
		String bunyangSeq = bunyangInfoVo.getBunyangSeq();
		// 분양정보가 변경된 경우
		if(!StringUtils.isEmpty(bunyangSeq)) {
			param.put("bunyangSeq", bunyangSeq);
			param.put("serviceChargeType", bunyangInfoVo.getServiceChargeType());
			iRslt += commonDao.update("contractor.updateContractInfo", param);
		}
		// 신청자 정보가 변경된 경우
		if(bunyangInfoVo.getApplyUser() != null) {
			iRslt += updateContractUser(bunyangInfoVo.getApplyUser());
		}
		// 대리인 정보가 변경된 경우
		if(bunyangInfoVo.getAgentUser() != null) {
			if(!StringUtils.isEmpty(bunyangInfoVo.getAgentUser().getUserId())) {// 업데이트
				iRslt += updateContractUser(bunyangInfoVo.getAgentUser());
			} else {// 생성
				param = getBunyangUserParam(bunyangInfoVo.getAgentUser(), 1);
				param.put("bunyangSeq", bunyangSeq);
				iRslt += commonDao.insert("admin.createBunyangRefUserInfo", param);
			}
		} else {// 삭제
			iRslt += deleteAgentUser(bunyangSeq);
		}
		// 사용자 정보가 변경된 경우
		if(bunyangInfoVo.getUseUsers() != null && bunyangInfoVo.getUseUsers().size() > 0) {
			for(int i = 0; i < bunyangInfoVo.getUseUsers().size(); i++) {
				iRslt += updateContractUser(bunyangInfoVo.getUseUsers().get(i));
			}
		}
		return iRslt;
	}
	
	
	//===============================================================================
	// 해약관리
	//===============================================================================
	/** 
	 * 해약관리 대상 조회
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getCancelList(SearchVo searchVo) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("start", (searchVo.getPageIndex()-1) * searchVo.getCountPerPage());
		parameter.put("count", searchVo.getCountPerPage());
		parameter.put(searchVo.getSearchKey(), searchVo.getSearchVal());
		List<Object> list = commonDao.selectList("cancel.getCancelList", parameter);
		Map<String, Object> countMap = (HashMap<String, Object>)commonDao.selectOne("totalcount.getCancelList", parameter);
		int total_count = 0;
		if(countMap != null) {
			total_count = CommonUtil.convertToInt(countMap.get("total_count"));
		}
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("list", list);
		rtnMap.put("total_count", total_count);
		return rtnMap;
	}
	
	/** 
	 * 해약 승인 내역 업데이트
	 */
	@Transactional
	public int updateCancel(String bunyangSeq
			,int depositAmount
			,String depositPlanDate
			,String depositBank
			,String depositAccount
			,String accountHolder
			,String cancelDate
			,String cancelReason) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		int iRslt = 0;
		// 해약정보 업데이트
		param = new HashMap<String, Object>();
		param.put("bunyangSeq", bunyangSeq);
		param.put("cancelReason", cancelReason);
		param.put("cancelBank", depositBank);
		param.put("cancelAccount", depositAccount);
		param.put("cancelAccountHolder", accountHolder);
		param.put("cancelDepositPlanDate", depositPlanDate);
		iRslt += commonDao.update("cancel.updateCancel", param);
		
		param = new HashMap<String, Object>();
		param.put("bunyangSeq", bunyangSeq);
		param.put("progressStatus", CalvaryConstants.PROGRESS_STATUS_E);
		param.put("userId", SessionUtil.getCurrentUserId());
		param.put("updateDate", cancelDate);
		param.put("remarks", cancelReason);
		// 상태 업데이트
		iRslt += commonDao.update("admin.updateBunyangProgressStatus", param);
		// 변경이력
		iRslt += commonDao.insert("admin.createBunyangHistory", param);
		
		// 해약금 출금내역 업데이트
		int paymentAmount = depositAmount;
		String paymentMethod = CalvaryConstants.PAYMENT_METHOD_TRANSFER;
		String paymentDate = depositPlanDate;
		String paymentDivision = CalvaryConstants.PAYMENT_DIVISION_WITHDRAWAL;
		String paymentType = CalvaryConstants.PAYMENT_TYPE_CANCEL_PAYMENT;
		String paymentUser = accountHolder;
		String remark = cancelReason;
		
		iRslt += createPaymentHistory(bunyangSeq, paymentAmount, paymentMethod, paymentDate, paymentDivision, paymentType, paymentUser, remark);
		return iRslt;
	}
	
	/** 
	 * 해약 승인 내역 업데이트
	 */
	@Transactional
	public int updateCancelManual(String bunyangSeq
			,String depositPlanDate
			,String depositBank
			,String depositAccount
			,String accountHolder
			,String cancelDate
			,String cancelReason) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		int iRslt = 0;
		// 해약정보 업데이트
		param = new HashMap<String, Object>();
		param.put("bunyangSeq", bunyangSeq);
		param.put("cancelReason", cancelReason);
		param.put("cancelBank", depositBank);
		param.put("cancelAccount", depositAccount);
		param.put("cancelAccountHolder", accountHolder);
		param.put("cancelDepositPlanDate", depositPlanDate);
		iRslt += commonDao.update("cancel.updateCancel", param);
		
		param = new HashMap<String, Object>();
		param.put("bunyangSeq", bunyangSeq);
		param.put("progressStatus", CalvaryConstants.PROGRESS_STATUS_E);
		param.put("userId", SessionUtil.getCurrentUserId());
		param.put("updateDate", cancelDate);
		param.put("remarks", cancelReason);
		// 상태 업데이트
		iRslt += commonDao.update("admin.updateBunyangProgressStatus", param);
		// 변경이력
		iRslt += commonDao.insert("admin.createBunyangHistory", param);
		
		return iRslt;
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getCancelPaymentInfo(String bunyangSeq) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("bunyangSeq", bunyangSeq);
		Map<String, Object> rtnMap = (HashMap<String, Object>)commonDao.selectOne("admin.getCancelPaymentInfo", parameter);
		return rtnMap;
	}
	
	
	//===============================================================================
	// 납부관리
	//===============================================================================
	/** 
	 * 납부내역조회 
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getPaymentList(SearchVo searchVo, String paymentType, String paymentDivision) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("start", (searchVo.getPageIndex()-1) * searchVo.getCountPerPage());
		parameter.put("count", searchVo.getCountPerPage());
		parameter.put(searchVo.getSearchKey(), searchVo.getSearchVal());
		parameter.put("paymentType", paymentType);
		parameter.put("paymentDivision", paymentDivision);
		parameter.put("fromDt", searchVo.getFromDt());
		parameter.put("toDt", searchVo.getToDt());
		List<Object> list = commonDao.selectList("payment.getPaymentList", parameter); 
		Map<String, Object> countMap = (HashMap<String, Object>)commonDao.selectOne("totalcount.getPaymentList", parameter);
		int total_count = 0;
		if(countMap != null) {
			total_count = CommonUtil.convertToInt(countMap.get("total_count"));
		}
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("list", list);
		rtnMap.put("total_count", total_count);
		return rtnMap;
	}
	
	/** 
	 * 입출금 엑셀업로드에서 계약정보 선택을 위한 리스트 조회 
	 */
	public List<Object> getExcelBunyangSelectList(String applyUserName, String bunyangNo) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("apply_user_name", applyUserName);
		parameter.put("bunyang_no", bunyangNo);
		List<Object> list = commonDao.selectList("payment.getExcelBunyangSelectList", parameter); 
		return list;
	}
	
	
	//===============================================================================
	// 사용(봉안) 관리
	//===============================================================================
	/** 
	 * 사용신청 리스트 조회
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getGraveRequestList(SearchVo searchVo, String requestStatus) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("start", (searchVo.getPageIndex()-1) * searchVo.getCountPerPage());
		parameter.put("count", searchVo.getCountPerPage());
		parameter.put(searchVo.getSearchKey(), searchVo.getSearchVal());
		parameter.put("requestStatus", requestStatus);
		List<Object> list = commonDao.selectList("use.getGraveRequestList", parameter);
		Map<String, Object> countMap = (HashMap<String, Object>)commonDao.selectOne("totalcount.getGraveRequestList", parameter);
		int total_count = 0;
		if(countMap != null) {
			total_count = CommonUtil.convertToInt(countMap.get("total_count"));
		}
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("list", list);
		rtnMap.put("total_count", total_count);
		return rtnMap;
	}
	
	/** 
	 * 사용신청된 정보로부터 승인해야할 동산 정보 리스트 조회
	 */
	public List<Object> getApprovalGraveList(String bunyangSeq, String userSeq, String coupleSeq) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("bunyangSeq", bunyangSeq);
		parameter.put("userSeq", userSeq);
		parameter.put("coupleSeq", coupleSeq);
		
		// 부부형 배우자가 이미 사용중이거나 가족형의 구성원이 미리 예약한 자리가 있으면 해당 정보 반환
		List<Object> approvalGraveList = commonDao.selectList("use.getReservedGraveInfo2", parameter);
		
		// 배정된 자리가 없을 경우 신청된 정보 반환
		if(approvalGraveList == null || approvalGraveList.size() == 0) {
			approvalGraveList = commonDao.selectList("use.getApprovalGraveList", parameter);
		}
		return approvalGraveList;
	}
	
	/** 
	 * 사용신청 승인
	 */
	@Transactional
	public int approvalRequestGrave(ApprovalGraveVo vo, String approvalUser) throws Exception {
		int iRslt = 0;
		Map<String, Object> parameter = null;
		GraveInfoVo info = null;
		// 신규 신청된건
		if(CalvaryConstants.GRAVE_ASSIGN_STATUS_REQUESTED.equals(vo.getAssignStatus())) {
			
			for(int i = 0; i < vo.getRequestGraveList().size(); i++) {
				info = vo.getRequestGraveList().get(i);
				parameter = new HashMap<String, Object>();
				parameter.put("sectionSeq", info.getSectionSeq());
				parameter.put("rowSeq", info.getRowSeq());
				parameter.put("colSeq", info.getColSeq());
				iRslt += commonDao.update("use.clearRequestGrave", parameter);
			}
			for(int i = 0; i < vo.getApprovalGraveList().size(); i++) {
				info = vo.getApprovalGraveList().get(i);
				parameter = new HashMap<String, Object>();
				parameter.put("bunyangSeq", vo.getBunyangSeq());
				if(i == 0) {
					parameter.put("useUserSeq1", vo.getUserSeq());
					parameter.put("coupleSeq", vo.getCoupleSeq() >= 0 ? vo.getCoupleSeq() : null);
					parameter.put("assignStatus", null);
				} else{
					parameter.put("useUserSeq1", null);
					parameter.put("coupleSeq", null);
					parameter.put("assignStatus", CalvaryConstants.GRAVE_ASSIGN_STATUS_RESERVED);
				}
				parameter.put("sectionSeq", info.getSectionSeq());
				parameter.put("rowSeq", info.getRowSeq());
				parameter.put("colSeq", info.getColSeq());
				iRslt += commonDao.update("use.updateRequestGrave", parameter);
			}
			parameter = new HashMap<String, Object>();
			parameter.put("bunyangSeq", vo.getBunyangSeq());
			parameter.put("useUserSeq", vo.getUserSeq());
			parameter.put("approvalUser", StringUtils.isEmpty(approvalUser) ? SessionUtil.getCurrentUserId() : approvalUser);
			iRslt += commonDao.update("use.approvalGraveRequestInfo", parameter);
			
		} else {// 부부형 또는 가족형으로 미리 배정된 자리가 있는경우
			if(vo.getApprovalGraveList() != null && vo.getApprovalGraveList().size() > 0) {
				info = vo.getApprovalGraveList().get(0);
				if(CalvaryConstants.GRAVE_ASSIGN_STATUS_RESERVED.equals(vo.getAssignStatus())) {
					parameter = new HashMap<String, Object>();
					parameter.put("bunyangSeq", vo.getBunyangSeq());
					parameter.put("useUserSeq1", vo.getUserSeq());
					parameter.put("coupleSeq", vo.getCoupleSeq() >= 0 ? vo.getCoupleSeq() : null);
					parameter.put("sectionSeq", info.getSectionSeq());
					parameter.put("rowSeq", info.getRowSeq());
					parameter.put("colSeq", info.getColSeq());
					iRslt += commonDao.update("use.updateReservedGrave", parameter);
				} else if(CalvaryConstants.GRAVE_ASSIGN_STATUS_HALF_OCCUPIED.equals(vo.getAssignStatus())) {
					parameter = new HashMap<String, Object>();
					parameter.put("bunyangSeq", vo.getBunyangSeq());
					parameter.put("useUserSeq2", vo.getUserSeq());
					parameter.put("assignStatus", CalvaryConstants.GRAVE_ASSIGN_STATUS_OCCUPIED);
					parameter.put("coupleSeq", vo.getCoupleSeq() >= 0 ? vo.getCoupleSeq() : null);
					iRslt += commonDao.update("use.updateCoupleGrave", parameter);
				}
				parameter = new HashMap<String, Object>();
				parameter.put("bunyangSeq", vo.getBunyangSeq());
				parameter.put("useUserSeq", vo.getUserSeq());
				parameter.put("approvalUser", StringUtils.isEmpty(approvalUser) ? SessionUtil.getCurrentUserId() : approvalUser);
				iRslt += commonDao.update("use.approvalGraveRequestInfo", parameter);
			}
		}
		// 30년 선납 관리비 납부정보 생성
		if(iRslt > 0) {
			String maintSeq = String.valueOf(commonService.getSeqNexVal("MAINT_SEQ"));
			parameter = new HashMap<String, Object>();
			parameter.put("bunyangSeq", vo.getBunyangSeq());
			parameter.put("approvalDate", new SimpleDateFormat("yyyyMMdd").format(new Date()));
			parameter.put("userSeq", vo.getUserSeq());
			parameter.put("maintSeq", maintSeq);
			iRslt += commonDao.insert("admin.createUseMaintPaymentInfo", parameter);
		}
		return iRslt;
	}
	
	/** 
	 * 추모동산 사용현황 리스트 조회
	 */
	public List<Object> getGraveUseList() {
		Map<String, Object> parameter = new HashMap<String, Object>();
		List<Object> list = commonDao.selectList("use.getGraveUseList", parameter); 
		return list;
	}
	
	/** 
	 * 특정 구역에 배정된 정보 조회
	 */
	public List<Object> getGraveAssignInfo(String sectionSeq, int rowSeq, int colSeq) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("sectionSeq", sectionSeq);
		parameter.put("rowSeq", rowSeq);
		parameter.put("colSeq", colSeq);
		List<Object> list = commonDao.selectList("use.getGraveAssignInfo", parameter); 
		return list;
	}
	
	/** 
	 * 특정 구역에 배정된 정보 조회
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getGraveAssignInfoBySeqNo(String sectionSeq, String seqNo) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("sectionSeq", sectionSeq);
		parameter.put("seqNo", seqNo);
		Map<String, Object> rtn = (HashMap<String, Object>)commonDao.selectOne("use.getGraveAssignInfoBySeqNo", parameter); 
		return rtn;
	}
	
	/** 
	 * 동산 사용신청 리스트 조회
	 */
	public List<Object> getUseApplyList(SearchVo searchVo) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("start", (searchVo.getPageIndex()-1) * searchVo.getCountPerPage());
		parameter.put("count", searchVo.getCountPerPage());
		parameter.put(searchVo.getSearchKey(), searchVo.getSearchVal());
		List<Object> list = commonDao.selectList("use.getUseApplyList", parameter); 
		return list;
	}
	
	/** 
	 * 사용자리스트 조회
	 */
	public List<Object> getUseUserList(String bunyangSeq) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("bunyangSeq", bunyangSeq);
		List<Object> list = commonDao.selectList("use.getUseUserList", parameter); 
		return list;
	}
	
	/** 
	 * 동산 배정(개별형)
	 */
	@SuppressWarnings("unchecked")
	@Transactional
	public int assignEachGrave(String bunyangSeq, int[] userSeqs, int[] coupleSeqs) throws Exception{
		int iRslt = 0;
		Map<String, Object> parameter = new HashMap<String, Object>();
		if(userSeqs != null && coupleSeqs != null && userSeqs.length == coupleSeqs.length) {
			for(int i = 0; i < userSeqs.length; i++) {
				int userSeq = userSeqs[i];
				int coupleSeq = coupleSeqs[i];
				int usingUserSeq = -1;
				if(coupleSeq > 0) {// 부부형
					parameter.put("bunyangSeq", bunyangSeq);
					parameter.put("coupleSeq", coupleSeq);
					Map<String, Object> usingUser = (HashMap<String, Object>)commonDao.selectOne("use.getUsingCoupleUserSeq", parameter);
					if(usingUser != null) { 
						usingUserSeq = CommonUtil.convertToInt(usingUser.get("use_user_seq1"));
					}
				}
				if(usingUserSeq > 0) {// 부부형 2기중 1기 사용중인 경우
					parameter = new HashMap<String, Object>();
					parameter.put("bunyangSeq", bunyangSeq);
					parameter.put("coupleSeq", coupleSeq);
					parameter.put("useUserSeq1", usingUserSeq);
					parameter.put("useUserSeq2", userSeq);
					parameter.put("assignStatus", CalvaryConstants.GRAVE_ASSIGN_STATUS_OCCUPIED);
					iRslt += commonDao.update("use.updateCoupleGrave", parameter);
				} else {
					String graveType = coupleSeq > 0 ? CalvaryConstants.GRAVE_TYPE_COUPLE : CalvaryConstants.GRAVE_TYPE_SINGLE;
					Map<String, Object> availableGraveInfo = getAvailableGraveInfo(graveType, 1);
					String sectionSeq = (String)availableGraveInfo.get("section_seq");
					int rowSeq = CommonUtil.convertToInt(availableGraveInfo.get("row_seq"));
					int colSeq = CommonUtil.convertToInt(availableGraveInfo.get("col_seq"));
					parameter = new HashMap<String, Object>();
					parameter.put("bunyangSeq", bunyangSeq);
					parameter.put("useUserSeq1", userSeq);
					parameter.put("useUserSeq2", null);
					parameter.put("sectionSeq", sectionSeq);
					parameter.put("rowSeq", rowSeq);
					parameter.put("colSeq", colSeq);
					parameter.put("coupleSeq", coupleSeq > 0 ? coupleSeq : null);
					parameter.put("assignStatus", coupleSeq > 0 ? CalvaryConstants.GRAVE_ASSIGN_STATUS_HALF_OCCUPIED : CalvaryConstants.GRAVE_ASSIGN_STATUS_OCCUPIED);
					parameter.put("graveType", graveType);
					iRslt += commonDao.update("use.updateGrave", parameter);
				}
			}
		}
		return iRslt;
	}
	
	/** 
	 * 동산 배정(가족형)
	 */
	@SuppressWarnings("unchecked")
	@Transactional
	public int assignFamilyGrave(String bunyangSeq, int[] userSeqs, int[] coupleSeqs) throws Exception{
		
		int i = 0;
		int iRslt = 0;
		int ERROR_NOT_AVAILABLE = -1;
		
		// 가족형의 경우 부부형 또는 1인형 둘중 하나만 가능하기 때문에 0번째 데이터만 확인
		String graveType = null;
		if(coupleSeqs != null && coupleSeqs.length > 0) {
			if(coupleSeqs[0] > 0) {
				graveType = CalvaryConstants.GRAVE_TYPE_COUPLE;
			} else {
				graveType = CalvaryConstants.GRAVE_TYPE_SINGLE;
			}
		}
		Map<String, Object> parameter = null;
		Map<String, Object> availableGraveInfo = null;
		
		// 이미 배정된 동산이 있는지 조회
		parameter = new HashMap<String, Object>();
		parameter.put("bunyangSeq", bunyangSeq);
		List<Object> graveList = commonDao.selectList("use.getBunyangSeqGraveInfo", parameter);
		
		// 가족형의 경우 연속으로 자리를 배정해야하기 때문에 배정된 동산이 없는 경우 미리 예약해둠
		if(graveList == null || graveList.size() == 0) {
			List<Object> useUserList = getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_USE_USER);
			int requireCnt = useUserList.size();
			if(CalvaryConstants.GRAVE_TYPE_COUPLE.equals(graveType)) {
				requireCnt = requireCnt/2;
			}
			// 가족수만큼 연속배정이 가능한 자리를 조회
			availableGraveInfo = getAvailableGraveInfo(graveType, requireCnt);
			
			if(availableGraveInfo != null) {
				String sectionSeq = (String)availableGraveInfo.get("section_seq");
				int rowSeq = CommonUtil.convertToInt(availableGraveInfo.get("row_seq"));
				int colSeq = CommonUtil.convertToInt(availableGraveInfo.get("col_seq"));
				// 
				for(i = 0; i < requireCnt; i++) {
					parameter = new HashMap<String, Object>();
					parameter.put("bunyangSeq", bunyangSeq);
					parameter.put("useUserSeq1", null);
					parameter.put("useUserSeq2", null);
					parameter.put("sectionSeq", sectionSeq);
					parameter.put("rowSeq", rowSeq);
					parameter.put("colSeq", colSeq+i);
					parameter.put("assignStatus", CalvaryConstants.GRAVE_ASSIGN_STATUS_RESERVED);
					iRslt += commonDao.update("use.updateGrave", parameter);
				}
			} else {// 연속배정이 가능한 자리가 없을 경우 에러
				iRslt = ERROR_NOT_AVAILABLE;
				return iRslt;
			}
		}
		if(userSeqs != null && coupleSeqs != null && userSeqs.length == coupleSeqs.length) {
			for(i = 0; i < userSeqs.length; i++) {
				int userSeq = userSeqs[i];
				int coupleSeq = coupleSeqs[i];
				int usingUserSeq = -1;
				if(coupleSeq > 0) {// 부부형
					parameter.put("bunyangSeq", bunyangSeq);
					parameter.put("coupleSeq", coupleSeq);
					Map<String, Object> usingUser = (HashMap<String, Object>)commonDao.selectOne("use.getUsingCoupleUserSeq", parameter);
					if(usingUser != null) { 
						usingUserSeq = CommonUtil.convertToInt(usingUser.get("use_user_seq1"));
					}
				}
				if(usingUserSeq > 0) {// 부부형 2기중 1기 사용중인 경우
					parameter = new HashMap<String, Object>();
					parameter.put("bunyangSeq", bunyangSeq);
					parameter.put("coupleSeq", coupleSeq);
					parameter.put("useUserSeq1", usingUserSeq);
					parameter.put("useUserSeq2", userSeq);
					parameter.put("assignStatus", CalvaryConstants.GRAVE_ASSIGN_STATUS_OCCUPIED);
					iRslt += commonDao.update("use.updateCoupleGrave", parameter);
				} else {
					parameter = new HashMap<String, Object>();
					parameter.put("bunyangSeq", bunyangSeq);
					parameter.put("graveType", graveType);
					availableGraveInfo = (HashMap<String, Object>)commonDao.selectOne("use.getAvailableFamilyGraveInfo", parameter);
					String sectionSeq = (String)availableGraveInfo.get("section_seq");
					int rowSeq = CommonUtil.convertToInt(availableGraveInfo.get("row_seq"));
					int colSeq = CommonUtil.convertToInt(availableGraveInfo.get("col_seq"));
					parameter = new HashMap<String, Object>();
					parameter.put("bunyangSeq", bunyangSeq);
					parameter.put("useUserSeq1", userSeq);
					parameter.put("useUserSeq2", null);
					parameter.put("sectionSeq", sectionSeq);
					parameter.put("rowSeq", rowSeq);
					parameter.put("colSeq", colSeq);
					parameter.put("coupleSeq", coupleSeq);
					parameter.put("assignStatus", CalvaryConstants.GRAVE_TYPE_COUPLE.equals(graveType) ? CalvaryConstants.GRAVE_ASSIGN_STATUS_HALF_OCCUPIED : CalvaryConstants.GRAVE_ASSIGN_STATUS_OCCUPIED);
					iRslt += commonDao.update("use.updateGrave", parameter);
				}
			}
		}
		return iRslt;
	}
	
	/** 
	 * 사용가능한 동산 정보 조회
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getAvailableGraveInfo(String graveType, int cnt) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("graveType", graveType);
		parameter.put("cnt", cnt);
		Map<String, Object> rtnMap = (HashMap<String, Object>)commonDao.selectOne("use.getAvailableGraveInfo", parameter); 
		return rtnMap;
	}
	
	/**
	 * 신청한 자리가 이미 배정된 자리인지 체크
	 */
	@SuppressWarnings("unchecked")
	public int checkAvaliableGrave(String bunyangSeq, String userSeq, int coupleSeq, String assignStatus, String sectionSeq, String rowSeq, String colSeq) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("bunyangSeq", bunyangSeq);
		parameter.put("userSeq", userSeq);
		parameter.put("coupleSeq", coupleSeq >= 0 ? coupleSeq : null);
		parameter.put("assignStatus", assignStatus);
		parameter.put("sectionSeq", sectionSeq);
		parameter.put("rowSeq", rowSeq);
		parameter.put("colSeq", colSeq);
		Map<String, Object> rtnMap = (HashMap<String, Object>)commonDao.selectOne("use.checkAvaliableGrave", parameter); 
		int rtnVal = 0;
		if(rtnMap != null) {
			rtnVal = CommonUtil.convertToInt(rtnMap.get("cnt"));
		}
		return rtnVal;
	}
	
	/**
	 * 사용신청건이 이미 승인됐는지 체크
	 */
	@SuppressWarnings("unchecked")
	public int checkApprovalStatus(String bunyangSeq, String userSeq) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("bunyangSeq", bunyangSeq);
		parameter.put("userSeq", userSeq);
		Map<String, Object> rtnMap = (HashMap<String, Object>)commonDao.selectOne("use.checkApprovalStatus", parameter); 
		int rtnVal = 0;
		if(rtnMap != null) {
			rtnVal = CommonUtil.convertToInt(rtnMap.get("cnt"));
		}
		return rtnVal;
	}
	
	/**
	 * 신청후 1시간이 경과된 사용신청 리스트 조회
	 */
	public List<Object> getNotApprovalGraveList() {
		Map<String, Object> parameter = new HashMap<String, Object>();
		List<Object> list = commonDao.selectList("use.getNotApprovalGraveList", parameter); 
		return list;
	}
	
	
	//===============================================================================
	// 사용계약 변경 및 해약
	//===============================================================================
	/**
	 * 사용계약 리스트 조회
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getUseChangeList(SearchVo searchVo) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("start", (searchVo.getPageIndex()-1) * searchVo.getCountPerPage());
		parameter.put("count", searchVo.getCountPerPage());
		parameter.put("apply_user_name", searchVo.getSearchVal());
		parameter.put("progressStatus", searchVo.getProgressStatus());
		parameter.put("bunyangTimes", searchVo.getBunyangTimes());
		List<Object> list = commonDao.selectList("usechange.getUseChangeList", parameter); 
		Map<String, Object> countMap = (HashMap<String, Object>)commonDao.selectOne("totalcount.getUseChangeList", parameter);
		int total_count = 0;
		if(countMap != null) {
			total_count = CommonUtil.convertToInt(countMap.get("total_count"));
		}
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("list", list);
		rtnMap.put("total_count", total_count);
		return rtnMap;
	}
	
	/**
	 * 계약자 정보를 승계신청자 정보로 변경
	 */
	@Transactional
	public int updateSucceedContractor(BunyangUserVo bunyangUserVo, String changeReason, String remarks) throws Exception{
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("relationType", bunyangUserVo.getRelationType());
		param.put("userName", bunyangUserVo.getUserName());
		param.put("birthDate", bunyangUserVo.getBirthDate());
		param.put("gender", bunyangUserVo.getGender());
		param.put("email", bunyangUserVo.getEmail());
		param.put("mobile", bunyangUserVo.getMobile());
		param.put("phone", bunyangUserVo.getPhone());
		param.put("postNumber", bunyangUserVo.getPostNumber());
		param.put("address1", bunyangUserVo.getAddress1());
		param.put("address2", bunyangUserVo.getAddress2());
		param.put("churchOfficer", bunyangUserVo.getChurchOfficer());
		param.put("diocese", bunyangUserVo.getDiocese());
		param.put("bunyangSeq", bunyangUserVo.getBunyangSeq());
		param.put("changeReason", changeReason);
		param.put("remarks", remarks);
		// 변경전 이력정보 생성
		int iRslt = commonDao.insert("usechange.insertSucceedChangeHistory", param);
		// 계약자 정보를 승계신청자 정보로 업데이트
		iRslt += commonDao.update("usechange.updateSucceedContractor", param);
		return iRslt;
	}
	
	/**
	 * 사용자 정보 변경
	 */
	@Transactional
	public int updateRefUserInfo(BunyangUserVo bunyangUserVo) throws Exception{
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", bunyangUserVo.getUserId());
		param.put("email", bunyangUserVo.getEmail());
		param.put("mobile", bunyangUserVo.getMobile());
		param.put("phone", bunyangUserVo.getPhone());
		param.put("postNumber", bunyangUserVo.getPostNumber());
		param.put("address1", bunyangUserVo.getAddress1());
		param.put("address2", bunyangUserVo.getAddress2());
		param.put("churchOfficer", bunyangUserVo.getChurchOfficer());
		param.put("diocese", bunyangUserVo.getDiocese());
		param.put("bunyangSeq", bunyangUserVo.getBunyangSeq());
		param.put("refType", bunyangUserVo.getRefType());
		// 변경전 이력정보 생성
		int iRslt = commonDao.insert("usechange.insertRefUserChangeHistory", param);
		// 사용자 정보 변경
		iRslt += commonDao.update("usechange.updateRefUserInfo", param);
		return iRslt;
	}
	
	/**
	 * 관리비 납부자 변경
	 */
	public int updateServiceCharger(String bunyangSeq, String serviceChargeType, String maintCharger) throws Exception{
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("bunyangSeq", bunyangSeq);
		param.put("serviceChargeType", serviceChargeType);
		param.put("maintCharger", maintCharger);
		// 변경전 이력정보 생성
		int iRslt = commonDao.insert("usechange.insertServiceChargerChangeHistory", param);
		// 관리비 납부자 변경
		iRslt += commonDao.update("usechange.updateServiceChargeType", param);
		iRslt += commonDao.update("usechange.updateMaintCharger", param);
		return iRslt;
	}
	
	/**
	 * 사용(봉안)자 해약 처리
	 * @param bunyangSeq
	 * @param userId1 사용자 아이디
	 * @param userId2 부부형의 경우만 사용
	 * @param cancelReason 해약사유
	 * @param cancelBank 해약금 입금은행
	 * @param cancelAccount 해약금 입금계좌
	 * @param cancelAccountHolder 해약금 예금주
	 * @param cancelDepositPlanDate 입금예정일
	 * @param surrenderValue 해약반환금
	 * @param penaltyValue 위약금
	 * @return
	 * @throws Exception
	 */
	@Transactional
	public int cancelUseUser(String bunyangSeq
			,String userId1
			,String userId2
			,String cancelReason
			,String cancelBank
			,String cancelAccount
			,String cancelAccountHolder
			,String cancelDepositPlanDate
			,int surrenderValue
			,int penaltyValue) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		int iRslt = 0;
		
		String cancelSeq = String.valueOf(commonService.getSeqNexVal("CANCEL_SEQ"));
		
		// 해약정보 생성
		param = new HashMap<String, Object>();
		param.put("cancelSeq", cancelSeq);
		param.put("cancelReason", cancelReason);
		param.put("cancelBank", cancelBank);
		param.put("cancelAccount", cancelAccount);
		param.put("cancelAccountHolder", cancelAccountHolder);
		param.put("cancelDepositPlanDate", cancelDepositPlanDate);
		param.put("cancelType", "USE_USER");
		param.put("surrenderValue", surrenderValue);
		param.put("penaltyValue", penaltyValue);
		iRslt += commonDao.insert("usechange.insertCancelInfo", param);
		
		// 사용자 cancel_seq 업데이트
		param = new HashMap<String, Object>();
		param.put("cancelSeq", cancelSeq);
		param.put("bunyangSeq", bunyangSeq);
		param.put("userId", userId1);
		iRslt += commonDao.update("usechange.updateUseUserCancelSeq", param);
		
		Map<String, Object> userInfo = getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_USE_USER, userId1);
		
		// 배정된 동산정보가 있을 경우 삭제해줌
		param = new HashMap<String, Object>();
		param.put("bunyangSeq", bunyangSeq);
		param.put("userSeq", userInfo.get("user_seq"));
		iRslt += commonDao.update("usechange.cancelGraveAssign", param);
		
		// 부부형의 경우만
		if(!StringUtils.isEmpty(userId2)) {
			param = new HashMap<String, Object>();
			param.put("cancelSeq", cancelSeq);
			param.put("bunyangSeq", bunyangSeq);
			param.put("userId", userId2);
			iRslt += commonDao.update("usechange.updateUseUserCancelSeq", param);
			
			userInfo = getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_USE_USER, userId2);
			param = new HashMap<String, Object>();
			param.put("bunyangSeq", bunyangSeq);
			param.put("userSeq", userInfo.get("user_seq"));
			iRslt += commonDao.update("usechange.cancelGraveAssign", param);
		}
		
		// 해약금 출금내역 업데이트
		int paymentAmount = surrenderValue;
		String paymentMethod = CalvaryConstants.PAYMENT_METHOD_TRANSFER;
		String paymentDate = cancelDepositPlanDate;
		String paymentDivision = CalvaryConstants.PAYMENT_DIVISION_WITHDRAWAL;
		String paymentType = CalvaryConstants.PAYMENT_TYPE_CANCEL_PAYMENT;
		String paymentUser = cancelAccountHolder;
		String remark = cancelReason;
		
		iRslt += createPaymentHistory(bunyangSeq, paymentAmount, paymentMethod, paymentDate, paymentDivision, paymentType, paymentUser, remark);
		return iRslt;
	}
	
	
	//===============================================================================
	// 분양현황
	//===============================================================================
	/** 
	 * 장묘형태별 신청현황조회
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getStatusByGraveType() {
		Map<String, Object> rtnMap = (HashMap<String, Object>)commonDao.selectOne("bunyangstatus.getStatusByGraveType", null);
		return rtnMap;
	}
	
	/** 
	 * 개별형/가족형 별 신청현황조회
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getStatusByProductType() {
		Map<String, Object> rtnMap = (HashMap<String, Object>)commonDao.selectOne("bunyangstatus.getStatusByProductType", null);
		return rtnMap;
	}
	
	/** 
	 * 진행상태 별 신청현황조회
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getStatusByProgress() {
		Map<String, Object> rtnMap = (HashMap<String, Object>)commonDao.selectOne("bunyangstatus.getStatusByProgress", null);
		return rtnMap;
	}
	
	/** 
	 * 납부현황조회
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getPaymentStatus() {
		Map<String, Object> rtnMap = (HashMap<String, Object>)commonDao.selectOne("bunyangstatus.getPaymentStatus", null);
		return rtnMap;
	}
	
	/** 
	 * 관리비납부현황조회
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getMaintPaymentStatus(int maintYear) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("maintYear", maintYear);
		Map<String, Object> rtnMap = (HashMap<String, Object>)commonDao.selectOne("bunyangstatus.getMaintPaymentStatus", parameter);
		return rtnMap;
	}
	
	/** 
	 * 관리비납부 리스트 조회
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getMaintPaymentList(SearchVo searchVo) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("start", (searchVo.getPageIndex()-1) * searchVo.getCountPerPage());
		parameter.put("count", searchVo.getCountPerPage());
		parameter.put("apply_user_name", searchVo.getSearchVal());
		parameter.put("maintYear", searchVo.getMaintYear());
		parameter.put("maintStatus", searchVo.getMaintStatus());
		List<Object> list = commonDao.selectList("bunyangstatus.getMaintPaymentList", parameter); 
		Map<String, Object> countMap = (HashMap<String, Object>)commonDao.selectOne("totalcount.getMaintPaymentList", parameter);
		int total_count = 0;
		if(countMap != null) {
			total_count = CommonUtil.convertToInt(countMap.get("total_count"));
		}
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("list", list);
		rtnMap.put("total_count", total_count);
		return rtnMap;
	}
	
	/** 
	 * 관리비 납부/미납 상세정보 조회
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getMaintPaymentDetailList(SearchVo searchVo, String bunyangSeq, String paymentYn) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("start", (searchVo.getPageIndex()-1) * searchVo.getCountPerPage());
		parameter.put("count", searchVo.getCountPerPage());
		parameter.put("bunyangSeq", bunyangSeq);
		parameter.put("paymentYn", paymentYn);
		parameter.put("maintYear", searchVo.getMaintYear());
		List<Object> list = commonDao.selectList("bunyangstatus.getMaintPaymentDetailList", parameter); 
		Map<String, Object> countMap = (HashMap<String, Object>)commonDao.selectOne("totalcount.getMaintPaymentDetailList", parameter);
		int total_count = 0;
		if(countMap != null) {
			total_count = CommonUtil.convertToInt(countMap.get("total_count"));
		}
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("list", list);
		rtnMap.put("total_count", total_count);
		return rtnMap;
	}
	
	/** 
	 * 관리비 납부대상 리스트 조회
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getUnpaidMaintPaymentList(SearchVo searchVo) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("start", (searchVo.getPageIndex()-1) * searchVo.getCountPerPage());
		parameter.put("count", searchVo.getCountPerPage());
		parameter.put("maintYear", searchVo.getMaintYear());
		List<Object> list = commonDao.selectList("bunyangstatus.getUnpaidMaintPaymentList", parameter); 
		Map<String, Object> countMap = (HashMap<String, Object>)commonDao.selectOne("totalcount.getUnpaidMaintPaymentList", parameter);
		int total_count = 0;
		if(countMap != null) {
			total_count = CommonUtil.convertToInt(countMap.get("total_count"));
		}
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("list", list);
		rtnMap.put("total_count", total_count);
		return rtnMap;
	}
	
	/** 
	 * 관리비 납부 연도 조회(2018~최신연도)
	 */
	public List<Object> getMaintYearList() {
		Map<String, Object> parameter = new HashMap<String, Object>();
		List<Object> list = commonDao.selectList("bunyangstatus.getMaintYearList", parameter);
		return list;
	}
	
	/**
	 * 입출금 현황 조회
	 */
	public List<Object> getBankStatusList() {
		Map<String, Object> parameter = new HashMap<String, Object>();
		List<Object> list = commonDao.selectList("bunyangstatus.getBankStatusList", parameter);
		return list;
	}
	
	/**
	 * 추모동산 사용현황 조회
	 */
	public List<Object> getGraveStatusList() {
		Map<String, Object> parameter = new HashMap<String, Object>();
		List<Object> list = commonDao.selectList("bunyangstatus.getGraveStatusList", parameter);
		return list;
	}
	
	/**
	 * 사용(봉안)자 이름에 해당하는 정보 검색
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getGraveUserInfo(String userName) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("userName", userName);
		Map<String, Object> rtnMap = (Map<String, Object>)commonDao.selectOne("bunyangstatus.getGraveUserInfo", parameter); 
		return rtnMap;
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getRequestGraveInfo(String bunyangSeq, int userSeq) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("bunyangSeq", bunyangSeq);
		parameter.put("userSeq", userSeq);
		Map<String, Object> rtnMap = (Map<String, Object>)commonDao.selectOne("admin.getRequestGraveInfo", parameter); 
		return rtnMap;
	}
	@SuppressWarnings("unchecked")
	public Map<String, Object> getCoupleRequestGraveInfo(String bunyangSeq, int userSeq, int coupleSeq) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("bunyangSeq", bunyangSeq);
		parameter.put("userSeq", userSeq);
		parameter.put("coupleSeq", coupleSeq);
		Map<String, Object> rtnMap = (Map<String, Object>)commonDao.selectOne("admin.getCoupleRequestGraveInfo", parameter); 
		return rtnMap;
	}
	
	
	//===============================================================================
	// 메뉴 관리
	//===============================================================================
	
	/** 
	 * 메뉴리스트조회 
	 * @param userId 접속유저 아이디
	 */
	@Override
	@SuppressWarnings("unchecked")
	public List<Object> getMenuList(String userId) {
		List<Object> menuListAll = commonDao.selectList("menumgmt.getMenuList", userId);
		List<Object> rtnList = new ArrayList<Object>();
		// 메뉴를 Hierarchy 구조로 가공
		if(menuListAll != null && menuListAll.size() > 0) {
			for(int i = 0, iLen = menuListAll.size(); i < iLen; i++) {
				Map<String, Object> tmp = (Map<String, Object>)menuListAll.get(i);
				int menuLevel =  (int)tmp.get("menu_level");
				if(menuLevel == 1) {
					String menuSeq = (String)tmp.get("menu_seq");
					List<Map<String, Object>> children = getChildMenuList(menuSeq, menuLevel + 1, menuListAll);
					tmp.put("children", children);
					rtnList.add(tmp);
				}
			}
		}
		return rtnList;
	}
	
	/** 
	 * 특정메뉴의 하위메뉴를 재귀호출하면서 Hierarchy 구조로 반환 
	 * @param menuId 메뉴아이디
	 * @param childLevel child 메뉴 레벨
	 * @param menuListAll 전체 메뉴리스트
	 */
	@SuppressWarnings("unchecked")
	private List<Map<String, Object>> getChildMenuList(String menuId, int childLevel, List<Object> menuListAll) {
		List<Map<String, Object>> children = new ArrayList<Map<String,Object>>();
		if(menuListAll != null && menuListAll.size() > 0) {
			for(int i = 0, iLen = menuListAll.size(); i < iLen; i++) {
				Map<String, Object> tmp = (Map<String, Object>)menuListAll.get(i);
				int menuLevel =  (int)tmp.get("menu_level");
				if(menuLevel != childLevel) {
					continue;
				}
				String menuSeq = (String)tmp.get("menu_seq");
				String parentMenuSeq = (String)tmp.get("parent_menu_seq");
				if(menuId != null && menuId.equals(parentMenuSeq)) {
					List<Map<String, Object>> cchildren = getChildMenuList(menuSeq, menuLevel + 1, menuListAll);
					tmp.put("children", cchildren);
					children.add(tmp);
				}
			}
		}
		return children;
	}
	
	/** 
	 * 메뉴리스트조회 
	 * @param roleId 사용자그룹
	 */
	@SuppressWarnings("unchecked")
	public List<Object> getRoleMenuList(String roleId) {
		List<Object> menuListAll = commonDao.selectList("menumgmt.getRoleMenuList", roleId);
		List<Object> rtnList = new ArrayList<Object>();
		// 메뉴를 Hierarchy 구조로 가공
		if(menuListAll != null && menuListAll.size() > 0) {
			for(int i = 0, iLen = menuListAll.size(); i < iLen; i++) {
				Map<String, Object> tmp = (Map<String, Object>)menuListAll.get(i);
				int menuLevel =  (int)tmp.get("menu_level");
				if(menuLevel == 1) {
					String menuSeq = (String)tmp.get("menu_seq");
					List<Map<String, Object>> children = getChildMenuList(menuSeq, menuLevel + 1, menuListAll);
					tmp.put("children", children);
					rtnList.add(tmp);
				}
			}
		}
		return rtnList;
	}
	
}
