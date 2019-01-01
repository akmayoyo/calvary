package com.calvary.admin.service;

import java.util.List;
import java.util.Map;

import com.calvary.admin.vo.BunyangInfoVo;
import com.calvary.common.vo.SearchVo;

public interface IAdminService {

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
	public int updateBunyangProgressStatus(String bunyangSeq, String progressStatus);
	
	
	
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
	 * 계약금 납부 내역 업데이트
	 */
	public int updateDownPayment(String bunyangSeq, int paymentAmount, String paymentMethod, String paymentDate);
	/** 
	 * 잔금 납부 내역 업데이트
	 */
	public int updateBalancePayment(String bunyangSeq, int[] paymentAmount, String[] paymentMethod, String[] paymentDate);
	
	
	
	//===============================================================================
	// 메뉴 관리
	//===============================================================================
	
	/** 
	 * 메뉴리스트조회 
	 * @param userId 접속유저 아이디
	 */
	public List<Object> getMenuList(String userId);
}
