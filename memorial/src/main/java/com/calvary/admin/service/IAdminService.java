package com.calvary.admin.service;

import java.util.List;
import java.util.Map;

import com.calvary.admin.vo.BunyangInfoVo;
import com.calvary.admin.vo.BunyangUserVo;
import com.calvary.common.vo.SearchVo;

public interface IAdminService {

	//===============================================================================
	// Common
	//===============================================================================
	/** 
	 * 분양리스트 조회 
	 */
	public Map<String, Object> getBunyangList(SearchVo searchVo);
	
	/** 
	 * 분양리스트 조회 
	 */
	public Map<String, Object> getBunyangSelectList(String searchVal, int pageIndex);
	
	
	//===============================================================================
	// 분양신청관리
	//===============================================================================
	/** 
	 * 분양신청리스트 조회 
	 */
	public Map<String, Object> getApplyList(SearchVo searchVo);
	
	/** 
	 * 분양 정보 조회 
	 */
	public Map<String, Object> getBunyangInfo(String bunyangSeq);
	
	/** 
	 * 분양 정보 조회 
	 */
	public Map<String, Object> getBunyangInfoByNo(String bunyangNo);
	
	/** 
	 * 분양관련 사용자 정보 조회 
	 */
	public List<Object> getBunyangRefUserInfo(String bunyangSeq, String refType);
	
	/** 
	 * 분양관련 사용자 정보 조회 
	 */
	public Map<String, Object> getBunyangRefUserInfo(String bunyangSeq, String refType, String userId);
	
	/** 
	 * 배우자 정보 조회 
	 */
	public Map<String, Object> getCoupleUserInfo(String bunyangSeq, String refType, String userId, int coupleSeq);
	
	/** 
	 * 분양정보의 신청서,승인서등 관련 파일양식 조회
	 */
	public List<Object> getBunyangFileList(String bunyangSeq);
	
	/** 
	 * 분양신청 정보 저장
	 * @param bunyangInfoVo
	 */
	public String createBunyangInfo(BunyangInfoVo bunyangInfoVo, String updateDate) throws Exception;
	
	/** 
	 * 분양 양식파일 고유번호 업데이트
	 */
	public int updateBunyangFileSeq(Map<String, Object> param) throws Exception;
	
	/** 
	 * 사용(봉안)자 사용승인서 파일seq 업데이트
	 */
	public int updateUseUserFileSeq(String fileSeq, String bunyangSeq, String userId) throws Exception;
	
	/** 
	 * 분양정보 진행상태 업데이트
	 */
	public int updateBunyangProgressStatus(BunyangInfoVo bunyangInfoVo, String updateUser, String updateDate) throws Exception;
	
	/** 
	 * 분양취소
	 */
	public int cancelBunyangInfo(BunyangInfoVo bunyangInfoVo, String updateUser) throws Exception;
	
	/** 
	 * 분양정보삭제
	 */
	public int deleteBunyangInfo(BunyangInfoVo bunyangInfoVo, String updateUser) throws Exception;
	
	/**
	 * 분양차수중 최종 분양번호 +1 반환
	 * @param bunyangTimes
	 * @return
	 */
	public String getNextBunyangNo(int bunyangTimes);
	
	
	
	//===============================================================================
	// 사용계약관리
	//===============================================================================
	/** 
	 * 사용계약리스트 조회 
	 */
	public Map<String, Object> getContractList(SearchVo searchVo);
	/** 
	 * 대금납부내역조회
	 */
	public List<Object> getPaymentHistory(String bunyangSeq, String paymentType);
	/** 
	 * 총대금납부금액조회
	 */
	public Map<String, Object> getTotalPayment(String bunyangSeq);
	/** 
	 * 계약금 납부 내역 업데이트
	 */
	public int updateDownPayment(String bunyangSeq, int paymentAmount, String paymentMethod, String paymentDate, String createDate, String updateDate, boolean isContracted) throws Exception;
	/** 
	 * 잔금 납부 내역 업데이트
	 */
	public int updateBalancePayment(String bunyangSeq, int[] paymentAmount, String[] paymentMethod, String[] paymentDate, String createDate, boolean isFullPayment) throws Exception;
	/** 
	 * 분양관련 납입금(계약금,잔금,관리비..) 정보 생성
	 */
	public int createPaymentHistory(String bunyangSeq, int paymentAmount, String paymentMethod, String paymentDate, String paymentDivision, String paymentType, String paymentUser, String remark) throws Exception;
	
	/** 
	 * 분양관련 납입금(계약금,잔금,관리비..) 정보 생성
	 */
	public int createPaymentHistory(String[] bunyangSeqs, int[] paymentAmounts, String[] paymentMethods, String[] paymentDates, String[] paymentDivisions, String[] paymentTypes, String[] paymentUsers, String[] remarks, String[] maintSeqs) throws Exception;
	
	
	//===============================================================================
	// 사용승인관리
	//===============================================================================
	/** 
	 * 사용승인리스트 조회 
	 */
	public Map<String, Object> getApprovalList(SearchVo searchVo);
	
	/** 
	 *  사용(봉안)자 승인
	 */
	public int approvalUser(String bunyangSeq, String userId, String approvalNo, String yonginNo, String approvalDate) throws Exception;
	
	/** 
	 *  용인공원 확약번호 중복 체크
	 */
	public int checkDuplicatedYonginNo(String yonginNo);
	
	/** 
	 *  사용(봉안)자 승인서 출력일자 업데이트
	 */
	public int updateApprovalAssignDate(String bunyangSeq, String userId) throws Exception;
	
	/** 
	 * 특정 분양차수의 분양시작일을 조회
	 */
	public String getBunyangStartDate(int bunyangTimes);
	
	/**
	 * 관리비 납부 정보 생성 
	 */
	public int createMaintPaymentInfo(String bunyangSeq, String approvalDate) throws Exception;
	
	
	//===============================================================================
	// 계약자관리
	//===============================================================================
	/** 
	 * 계약자관리 리스트 조회 
	 */
	public Map<String, Object> getContractorList(SearchVo searchVo);
	
	/** 
	 * 대리인 정보 삭제
	 */
	public int deleteAgentUser(String bunyangSeq) throws Exception;
	
	/** 
	 * 신청자/대리인/사용자 정보 변경 
	 */
	public int updateContractUser(BunyangUserVo userVo) throws Exception;
	
	/** 
	 * 계약정보 및 관련 사용자 정보 업데이트
	 */
	public int updateContractInfo(BunyangInfoVo bunyangInfoVo) throws Exception;
	
	
	//===============================================================================
	// 해약관리
	//===============================================================================
	/** 
	 * 해약관리 대상 조회
	 */
	public Map<String, Object> getCancelList(SearchVo searchVo);
	
	/** 
	 * 해약 승인 내역 업데이트
	 */
	public int updateCancel(String bunyangSeq
			,int depositAmount
			,String depositPlanDate
			,String depositBank
			,String depositAccount
			,String accountHolder
			,String cancelDate
			,String cancelReason) throws Exception;
	
	/** 
	 * 해약 승인 내역 업데이트
	 */
	public int updateCancelManual(String bunyangSeq
			,String depositPlanDate
			,String depositBank
			,String depositAccount
			,String accountHolder
			,String cancelDate
			,String cancelReason) throws Exception;
	
	public Map<String, Object> getCancelPaymentInfo(String bunyangSeq);
	
	
	//===============================================================================
	// 납부관리
	//===============================================================================
	/** 
	 * 납부내역조회 
	 */
	public Map<String, Object> getPaymentList(SearchVo searchVo, String paymentType, String paymentDivision);
	
	/** 
	 * 입출금 엑셀업로드에서 계약정보 선택을 위한 리스트 조회 
	 */
	public List<Object> getExcelBunyangSelectList(String applyUserName, String bunyangNo);
	
	
	//===============================================================================
	// 사용(봉안) 관리
	//===============================================================================
	/** 
	 * 추모동산 사용현황 리스트 조회
	 */
	public List<Object> getGraveUseList();
	
	/** 
	 * 특정 구역에 배정된 정보 조회
	 */
	public List<Object> getGraveAssignInfo(String sectionSeq, int rowSeq, int colSeq);
	
	/** 
	 * 특정 구역에 배정된 정보 조회
	 */
	public Map<String, Object> getGraveAssignInfoBySeqNo(String sectionSeq, String seqNo);
	
	/** 
	 * 동산 사용신청 리스트 조회
	 */
	public List<Object> getUseApplyList(SearchVo searchVo);
	
	/** 
	 * 사용자리스트 조회
	 */
	public List<Object> getUseUserList(String bunyangSeq);
	
	/** 
	 * 동산 배정(개별형)
	 */
	public int assignEachGrave(String bunyangSeq, int[] userSeqs, int[] coupleSeqs) throws Exception;
	
	/** 
	 * 동산 배정(가족형)
	 */
	public int assignFamilyGrave(String bunyangSeq, int[] userSeqs, int[] coupleSeqs) throws Exception;
	
	/** 
	 * 사용가능한 동산 정보 조회
	 */
	public Map<String, Object> getAvailableGraveInfo(String graveType, int cnt);
	
	
	
	//===============================================================================
	// 사용계약 변경 및 해약
	//===============================================================================
	/**
	 * 사용계약 리스트 조회
	 */
	public Map<String, Object> getUseChangeList(SearchVo searchVo);
	
	/**
	 * 계약자 정보를 승계신청자 정보로 변경
	 */
	public int updateSucceedContractor(BunyangUserVo bunyangUserVo, String changeReason, String remarks) throws Exception;
	/**
	 * 사용자 정보 변경
	 */
	public int updateRefUserInfo(BunyangUserVo bunyangUserVo) throws Exception;
	/**
	 * 관리비 납부자 변경
	 */
	public int updateServiceCharger(String bunyangSeq, String serviceChargeType, String maintCharger) throws Exception;
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
	public int cancelUseUser(String bunyangSeq
			,String userId1
			,String userId2
			,String cancelReason
			,String cancelBank
			,String cancelAccount
			,String cancelAccountHolder
			,String cancelDepositPlanDate
			,int surrenderValue
			,int penaltyValue) throws Exception;
	
	
	//===============================================================================
	// 분양현황
	//===============================================================================
	/** 
	 * 장묘형태별 신청현황조회
	 */
	public Map<String, Object> getStatusByGraveType();
	/** 
	 * 개별형/가족형 별 신청현황조회
	 */
	public Map<String, Object> getStatusByProductType();
	/** 
	 * 진행상태 별 신청현황조회
	 */
	public Map<String, Object> getStatusByProgress();
	/** 
	 * 납부현황조회
	 */
	public Map<String, Object> getPaymentStatus();
	/** 
	 * 관리비납부현황조회
	 */
	public Map<String, Object> getMaintPaymentStatus(int maintYear);
	/** 
	 * 관리비납부 리스트 조회
	 */
	public Map<String, Object> getMaintPaymentList(SearchVo searchVo);
	/** 
	 * 관리비 납부/미납 상세정보 조회
	 */
	public Map<String, Object> getMaintPaymentDetailList(SearchVo searchVo, String bunyangSeq, String paymentYn);
	/** 
	 * 관리비 납부대상 리스트 조회
	 */
	public Map<String, Object> getUnpaidMaintPaymentList(SearchVo searchVo);
	/** 
	 * 관리비 납부 연도 조회(2018~최신연도)
	 */
	public List<Object> getMaintYearList();
	
	/**
	 * 입출금 현황 조회
	 */
	public List<Object> getBankStatusList();
	
	/**
	 * 추모동산 사용현황 조회
	 */
	public List<Object> getGraveStatusList();
	
	//===============================================================================
	// 메뉴 관리
	//===============================================================================
	
	/** 
	 * 메뉴리스트조회 
	 * @param userId 접속유저 아이디
	 */
	public List<Object> getMenuList(String userId);
	
	/** 
	 * 메뉴리스트조회 
	 * @param roleId 사용자그룹
	 */
	public List<Object> getRoleMenuList(String roleId);
}
