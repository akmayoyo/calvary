package com.calvary.common.constant;

public class CalvaryConstants {
	
	/** 날짜 구분자 */
	public static final String DELIMITER_DATE = "-";
	
	/** 화면에서 1 페이지당 표시할 건수 */
	public static final int COUNT_PER_PAGE = 10;
	
	
	/** 1기당 분양가 */
	public static final int BUNYANG_PRICE_PER_UNIT = 2000000;
	
	
	/** 계약금 퍼센테이지 */
	public static final float DOWN_PAYMENT_PERCENT = 10;
	
	
	/** 코드시퀀스 : 교회직분 */
	public static final String CODE_SEQ_CHURCH_OFFICER = "CHURCH_OFFICER";
	/** 코드시퀀스 : 사용자관계 */
	public static final String CODE_SEQ_USER_RELATION = "USER_RELATION";
	
	
	/** 신청형태 : 개별형 */
	public static final String PRODUCT_TYPE_EACH = "EACH";
	/** 신청형태 : 가족형 */
	public static final String PRODUCT_TYPE_FAMILY = "FAMILY";
	
	
	/** 장묘형태 : 부부형 */
	public static final String GRAVE_TYPE_COUPLE = "COUPLE";
	/** 장묘형태 : 1인형 */
	public static final String GRAVE_TYPE_SINGLE = "SINGLE";
	
	
	/** 동산 배정 상태 : 사용중 */
	public static final String GRAVE_ASSIGN_STATUS_OCCUPIED = "OCCUPIED";
	/** 동산 배정 상태 : 사용예정 */
	public static final String GRAVE_ASSIGN_STATUS_RESERVED = "RESERVED";
	/** 동산 배정 상태 : 사용가능 */
	public static final String GRAVE_ASSIGN_STATUS_AVAILABLE = "AVAILABLE";
	
	
	/** 관리비 납부자 : 신청자 */
	public static final String SERVICE_CHARGE_TYPE_APPLY_USER = "APPLY_USER";
	/** 관리비 납부자 : 각 사용자 */
	public static final String SERVICE_CHARGE_TYPE_USE_USER = "USE_USER";
	/** 관리비 납부자 : 사용자중 1인 대표 */
	public static final String SERVICE_CHARGE_TYPE_REPRESENT = "REPRESENT";
	
	
	/** 분양정보에서 참조하는 사용자 타입 : 신청자 */
	public static final String BUNYANG_REF_TYPE_APPLY_USER = "APPLY_USER";
	/** 분양정보에서 참조하는 사용자 타입 : 사용자 */
	public static final String BUNYANG_REF_TYPE_USE_USER = "USE_USER";
	/** 분양정보에서 참조하는 사용자 타입 : 대리인 */
	public static final String BUNYANG_REF_TYPE_AGENT_USER = "AGENT_USER";
	
	
	/** 분양 진행상태 코드값 : 신청(미승인) */
	public static final String PROGRESS_STATUS_NEW = "N";
	/** 분양 진행상태 코드값 : 신청승인 */
	public static final String PROGRESS_STATUS_A = "A";
	/** 분양 진행상태 코드값 : 계약 */
	public static final String PROGRESS_STATUS_B = "B";
	/** 분양 진행상태 코드값 : 완납 */
	public static final String PROGRESS_STATUS_C = "C";
	/** 분양 진행상태 코드값 : 사용승인 */
	public static final String PROGRESS_STATUS_D = "D";
	/** 분양 진행상태 코드값 : 해약 */
	public static final String PROGRESS_STATUS_E = "E";
	/** 분양 진행상태 코드값 : 반려 */
	public static final String PROGRESS_STATUS_R = "R";
	
	
	/** 분양금 납부 타입 : 계약금 납부 */
	public static final String PAYMENT_TYPE_DOWN_PAYMENT = "DOWN_PAYMENT";
	/** 분양금 납부 타입 : 잔금납부 */
	public static final String PAYMENT_TYPE_BALANCE_PAYMENT = "BALANCE_PAYMENT";
	/** 분양금 납부 타입 : 해약에 따른 반환 */
	public static final String PAYMENT_TYPE_CANCEL_PAYMENT = "CANCEL_PAYMENT";
	
	
	/** 납부 방법 : 이체 */
	public static final String PAYMENT_METHOD_TRANSFER = "TRANSFER";
	/** 납부 방법 : 현금 */
	public static final String PAYMENT_METHOD_CASH = "CASH";
	
	
	/** 
	 * 엑셀 서식 타입 : 분양신청서 
	 */
	public static final String FILE_FORM_TYPE_APPLY = "APPLY_FORM";
	/** 
	 * 엑셀 서식 타입 : 분양신청서-사용자 
	 */
	public static final String FILE_FORM_TYPE_USE_USER = "USE_USER_FORM";
	/** 
	 * 엑셀 서식 타입 : 신청승인서
	 */
	public static final String FILE_FORM_TYPE_APPROVAL = "APPROVAL_FORM";
	/** 
	 * 엑셀 서식 타입 : 분양계약서
	 */
	public static final String FILE_FORM_TYPE_CONTRACT = "CONTRACT_FORM";
	/** 
	 * 엑셀 서식 타입 : 완납확인증명서
	 */
	public static final String FILE_FORM_TYPE_FULL_PAYMENT = "FULL_PAYMENT_FORM";
	/** 
	 * 엑셀 서식 타입 : 사용승인서
	 */
	public static final String FILE_FORM_TYPE_USE_APPROVAL = "USE_APPROVAL_FORM";
	/** 
	 * 엑셀 서식 타입 : 해약승인서
	 */
	public static final String FILE_FORM_TYPE_CANCEL_APPROVAL = "CANCEL_APPROVAL_FORM";
}
