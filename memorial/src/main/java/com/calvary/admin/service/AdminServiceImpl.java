package com.calvary.admin.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.calvary.admin.vo.BunyangInfoVo;
import com.calvary.admin.vo.BunyangUserVo;
import com.calvary.common.constant.CalvaryConstants;
import com.calvary.common.dao.CommonDao;
import com.calvary.common.service.ICommonService;
import com.calvary.common.util.CommonUtil;
import com.calvary.common.util.SessionUtil;
import com.calvary.common.vo.SearchVo;

@Service
public class AdminServiceImpl implements IAdminService {
	
	@Autowired
	private CommonDao commonDao;
	@Autowired
	private ICommonService commonService;
	
	
	//===============================================================================
	// Common
	//===============================================================================
	/** 
	 * 분양리스트 조회 
	 */
	public List<Object> getBunyangList(SearchVo searchVo) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("start", (searchVo.getPageIndex()-1) * searchVo.getCountPerPage());
		parameter.put("count", searchVo.getCountPerPage());
		parameter.put(searchVo.getSearchKey(), searchVo.getSearchVal());
		List<Object> list = commonDao.selectList("admin.getBunyangList", parameter); 
		return list;
	}
	
	/** 
	 * 분양리스트 조회 
	 */
	public List<Object> getBunyangSelectList(String searchVal, int pageIndex) {
		int countPerPage = 10;
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("start", (pageIndex-1) * countPerPage);
		parameter.put("count", countPerPage);
		parameter.put("searchVal", searchVal);
		List<Object> list = commonDao.selectList("admin.getBunyangList", parameter); 
		return list;
	}
	
	

	//===============================================================================
	// 분양신청관리
	//===============================================================================
	/** 
	 * 분양신청리스트 조회 
	 */
	public List<Object> getApplyList(SearchVo searchVo) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("start", (searchVo.getPageIndex()-1) * searchVo.getCountPerPage());
		parameter.put("count", searchVo.getCountPerPage());
		parameter.put("apply_user_name", searchVo.getSearchVal());
		parameter.put("progressStatus", searchVo.getProgressStatus());
		parameter.put("bunyangTimes", searchVo.getBunyangTimes());
		List<Object> list = commonDao.selectList("admin.getApplyList", parameter); 
		return list;
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
	public String createBunyangInfo(BunyangInfoVo bunyangInfoVo, String updateDate) {
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
	public int updateBunyangFileSeq(Map<String, Object> param) {
		int iRslt = commonDao.update("admin.updateBunyangFileSeq", param);
		return iRslt;
	}
	
	/** 
	 * 분양정보 진행상태 업데이트
	 */
	@Transactional
	public int updateBunyangProgressStatus(BunyangInfoVo bunyangInfoVo, String updateUser, String updateDate) {
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
	public int cancelBunyangInfo(BunyangInfoVo bunyangInfoVo, String updateUser) {
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
	public int deleteBunyangInfo(BunyangInfoVo bunyangInfoVo, String updateUser) {
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
	public List<Object> getContractList(SearchVo searchVo) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("start", (searchVo.getPageIndex()-1) * searchVo.getCountPerPage());
		parameter.put("count", searchVo.getCountPerPage());
		parameter.put(searchVo.getSearchKey(), searchVo.getSearchVal());
		List<Object> list = commonDao.selectList("contract.getContractList", parameter); 
		return list;
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
	public int updateDownPayment(String bunyangSeq, int paymentAmount, String paymentMethod, String paymentDate, String createDate, String updateDate, boolean isContracted) {
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
	public int updateBalancePayment(String bunyangSeq, int[] paymentAmount, String[] paymentMethod, String[] paymentDate, String createDate, boolean isFullPayment) {
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
	 * 분양관련 납입금(계약금,잔금,관리비..) 정보 생성
	 */
	public int createPaymentHistory(String bunyangSeq, int paymentAmount, String paymentMethod, String paymentDate, String paymentType) {
		Map<String, Object> param = new HashMap<String, Object>();
		int iRslt = 0;
		// 계약금 납부 정보 업데이트
		param.put("bunyangSeq", bunyangSeq);
		param.put("paymentType", paymentType);
		param.put("paymentAmount", paymentAmount);
		param.put("paymentMethod", paymentMethod);
		param.put("paymentDate", paymentDate);
		param.put("createUser", SessionUtil.getCurrentUser().getUserId());
		iRslt = commonDao.insert("contract.insertDownPayment", param);
		return iRslt;
	}
	
	
	//===============================================================================
	// 사용승인관리
	//===============================================================================
	/** 
	 * 사용승인리스트 조회 
	 */
	public List<Object> getApprovalList(SearchVo searchVo) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("start", (searchVo.getPageIndex()-1) * searchVo.getCountPerPage());
		parameter.put("count", searchVo.getCountPerPage());
		parameter.put(searchVo.getSearchKey(), searchVo.getSearchVal());
		List<Object> list = commonDao.selectList("approval.getApprovalList", parameter); 
		return list;
	}
	
	
	//===============================================================================
	// 계약자관리
	//===============================================================================
	/** 
	 * 계약자변경 
	 */
	public int updateApplyUser(String bunyangSeq, String userId) {
		Map<String, Object> param = new HashMap<String, Object>();
		int iRslt = 0;
		param.put("bunyangSeq", bunyangSeq);
		param.put("userId", userId);
		iRslt += commonDao.delete("contractor.updateApplyUser", param);
		return iRslt;
	}
	
	
	//===============================================================================
	// 해약관리
	//===============================================================================
	/** 
	 * 해약관리 대상 조회
	 */
	public List<Object> getCancelList(SearchVo searchVo) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("start", (searchVo.getPageIndex()-1) * searchVo.getCountPerPage());
		parameter.put("count", searchVo.getCountPerPage());
		parameter.put(searchVo.getSearchKey(), searchVo.getSearchVal());
		List<Object> list = commonDao.selectList("cancel.getCancelList", parameter); 
		return list;
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
		param.put("remarks", "");
		// 상태 업데이트
		iRslt += commonDao.update("admin.updateBunyangProgressStatus", param);
		// 변경이력
		iRslt += commonDao.insert("admin.createBunyangHistory", param);
		
		// 계약금 납부 정보 업데이트
		param = new HashMap<String, Object>();
		param.put("bunyangSeq", bunyangSeq);
		param.put("paymentType", CalvaryConstants.PAYMENT_TYPE_CANCEL_PAYMENT);
		param.put("paymentAmount", depositAmount);
		param.put("paymentMethod", CalvaryConstants.PAYMENT_METHOD_TRANSFER);
		param.put("paymentDate", depositPlanDate);
		param.put("createUser", SessionUtil.getCurrentUserId());
		iRslt += commonDao.insert("cancel.insertCancelPayment", param);
		return iRslt;
	}
	
	
	//===============================================================================
	// 납부관리
	//===============================================================================
	/** 
	 * 납부내역조회 
	 */
	public List<Object> getPaymentList(SearchVo searchVo, String paymentType) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("start", (searchVo.getPageIndex()-1) * searchVo.getCountPerPage());
		parameter.put("count", searchVo.getCountPerPage());
		parameter.put(searchVo.getSearchKey(), searchVo.getSearchVal());
		parameter.put("paymentType", paymentType);
		parameter.put("fromDt", searchVo.getFromDt());
		parameter.put("toDt", searchVo.getToDt());
		List<Object> list = commonDao.selectList("payment.getPaymentList", parameter); 
		return list;
	}
	
	
	//===============================================================================
	// 사용(봉안) 관리
	//===============================================================================
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
	public int assignEachGrave(String bunyangSeq, int[] userSeqs, int[] coupleSeqs) {
		int iRslt = 0;
		Map<String, Object> parameter = new HashMap<String, Object>();
		if(userSeqs != null && coupleSeqs != null && userSeqs.length == coupleSeqs.length) {
			for(int i = 0; i < userSeqs.length; i++) {
				int userSeq = userSeqs[i];
				int coupleSeq = coupleSeqs[i];
				int usingUserSeq = -1;
				if(coupleSeq >= 0) {// 부부형
					parameter.put("bunyangSeq", bunyangSeq);
					parameter.put("coupleSeq", coupleSeq);
					Map<String, Object> usingUser = (HashMap<String, Object>)commonDao.selectOne("use.getUsingCoupleUserSeq", parameter);
					if(usingUser != null) { 
						usingUserSeq = CommonUtil.convertToInt(usingUser.get("use_user_seq1"));
					}
				}
				if(usingUserSeq >= 0) {// 부부형 2기중 1기 사용중인 경우
					parameter = new HashMap<String, Object>();
					parameter.put("bunyangSeq", bunyangSeq);
					parameter.put("coupleSeq", coupleSeq);
					parameter.put("useUserSeq1", usingUserSeq);
					parameter.put("useUserSeq2", userSeq);
					iRslt += commonDao.update("use.updateCoupleGrave", parameter);
				} else {
					String graveType = coupleSeq >= 0 ? CalvaryConstants.GRAVE_TYPE_COUPLE : CalvaryConstants.GRAVE_TYPE_SINGLE;
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
					parameter.put("assignStatus", CalvaryConstants.GRAVE_ASSIGN_STATUS_OCCUPIED);
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
	public int assignFamilyGrave(String bunyangSeq, int[] userSeqs, int[] coupleSeqs) {
		
		int i = 0;
		int iRslt = 0;
		int ERROR_NOT_AVAILABLE = -1;
		
		// 가족형의 경우 부부형 또는 1인형 둘중 하나만 가능하기 때문에 0번째 데이터만 확인
		String graveType = null;
		if(coupleSeqs != null && coupleSeqs.length > 0) {
			if(coupleSeqs[0] >= 0) {
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
			if(graveType == CalvaryConstants.GRAVE_TYPE_COUPLE) {
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
				if(coupleSeq >= 0) {// 부부형
					parameter.put("bunyangSeq", bunyangSeq);
					parameter.put("coupleSeq", coupleSeq);
					Map<String, Object> usingUser = (HashMap<String, Object>)commonDao.selectOne("use.getUsingCoupleUserSeq", parameter);
					if(usingUser != null) { 
						usingUserSeq = CommonUtil.convertToInt(usingUser.get("use_user_seq1"));
					}
				}
				if(usingUserSeq >= 0) {// 부부형 2기중 1기 사용중인 경우
					parameter = new HashMap<String, Object>();
					parameter.put("bunyangSeq", bunyangSeq);
					parameter.put("coupleSeq", coupleSeq);
					parameter.put("useUserSeq1", usingUserSeq);
					parameter.put("useUserSeq2", userSeq);
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
					parameter.put("assignStatus", CalvaryConstants.GRAVE_ASSIGN_STATUS_OCCUPIED);
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
	public Map<String, Object> getMaintPaymentStatus() {
		Map<String, Object> rtnMap = (HashMap<String, Object>)commonDao.selectOne("bunyangstatus.getMaintPaymentStatus", null);
		return rtnMap;
	}
	
	/** 
	 * 관리비납부 리스트 조회
	 */
	public List<Object> getMaintPaymentList(SearchVo searchVo) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("start", (searchVo.getPageIndex()-1) * searchVo.getCountPerPage());
		parameter.put("count", searchVo.getCountPerPage());
		parameter.put(searchVo.getSearchKey(), searchVo.getSearchVal());
		List<Object> list = commonDao.selectList("bunyangstatus.getMaintPaymentList", parameter); 
		return list;
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
	
}
