package com.calvary.admin.service;

import java.util.List;
import java.util.Map;

import com.calvary.admin.vo.BunyangInfoVo;
import com.calvary.common.vo.SearchVo;

public interface IAdminService {

	//===============================================================================
	// Common
	//===============================================================================
	/** 
	 * 분양리스트 조회 
	 */
	public List<Object> getBunyangList(SearchVo searchVo);
	
	/** 
	 * 분양리스트 조회 
	 */
	public List<Object> getBunyangSelectList(String searchVal, int pageIndex);
	
	
	//===============================================================================
	// 분양신청관리
	//===============================================================================
	/** 
	 * 분양신청리스트 조회 
	 */
	public List<Object> getApplyList(SearchVo searchVo);
	
	/** 
	 * 분양 정보 조회 
	 */
	public Map<String, Object> getBunyangInfo(String bunyangSeq);
	
	/** 
	 * 분양관련 사용자 정보 조회 
	 */
	public List<Object> getBunyangRefUserInfo(String bunyangSeq, String refType);
	
	/** 
	 * 분양정보의 신청서,승인서등 관련 파일양식 조회
	 */
	public List<Object> getBunyangFileList(String bunyangSeq);
	
	/** 
	 * 분양신청 정보 저장
	 * @param bunyangInfoVo
	 */
	public String createBunyangInfo(BunyangInfoVo bunyangInfoVo);
	
	/** 
	 * 분양 양식파일 고유번호 업데이트
	 */
	public int updateBunyangFileSeq(Map<String, Object> param);
	
	/** 
	 * 분양정보 진행상태 업데이트
	 */
	public int updateBunyangProgressStatus(String bunyangSeq, String progressStatus, String updateUser);
	
	
	
	//===============================================================================
	// 사용계약관리
	//===============================================================================
	/** 
	 * 사용계약리스트 조회 
	 */
	public List<Object> getContractList(SearchVo searchVo);
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
	public int updateDownPayment(String bunyangSeq, int paymentAmount, String paymentMethod, String paymentDate);
	/** 
	 * 잔금 납부 내역 업데이트
	 */
	public int updateBalancePayment(String bunyangSeq, int[] paymentAmount, String[] paymentMethod, String[] paymentDate, boolean isFullPayment);
	/** 
	 * 분양관련 납입금(계약금,잔금,관리비..) 정보 생성
	 */
	public int createPaymentHistory(String bunyangSeq, int paymentAmount, String paymentMethod, String paymentDate, String paymentType);
	
	
	//===============================================================================
	// 사용승인관리
	//===============================================================================
	/** 
	 * 사용승인리스트 조회 
	 */
	public List<Object> getApprovalList(SearchVo searchVo);
	
	
	//===============================================================================
	// 계약자관리
	//===============================================================================
	/** 
	 * 계약자변경 
	 */
	public int updateApplyUser(String bunyangSeq, String userId);
	
	
	//===============================================================================
	// 해약관리
	//===============================================================================
	/** 
	 * 해약관리 대상 조회
	 */
	public List<Object> getCancelList(SearchVo searchVo);
	
	/** 
	 * 해약 승인 내역 업데이트
	 */
	public int updateCancel(String bunyangSeq
			,int depositAmount
			,String depositPlanDate
			,String depositBank
			,String depositAccount
			,String accountHolder
			,String cancelReason) throws Exception;
	
	
	//===============================================================================
	// 납부관리
	//===============================================================================
	/** 
	 * 납부내역조회 
	 */
	public List<Object> getPaymentList(SearchVo searchVo, String paymentType);
	
	
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
	public int assignEachGrave(String bunyangSeq, int[] userSeqs, int[] coupleSeqs);
	
	/** 
	 * 동산 배정(가족형)
	 */
	public int assignFamilyGrave(String bunyangSeq, int[] userSeqs, int[] coupleSeqs);
	
	/** 
	 * 사용가능한 동산 정보 조회
	 */
	public Map<String, Object> getAvailableGraveInfo(String graveType, int cnt);
	
	
	//===============================================================================
	// 메뉴 관리
	//===============================================================================
	
	/** 
	 * 메뉴리스트조회 
	 * @param userId 접속유저 아이디
	 */
	public List<Object> getMenuList(String userId);
}
