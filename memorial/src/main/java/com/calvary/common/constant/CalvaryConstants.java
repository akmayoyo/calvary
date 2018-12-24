package com.calvary.common.constant;

public class CalvaryConstants {
	
	/** 화면에서 1 페이지당 표시할 건수 */
	public static final int COUNT_PER_PAGE = 10;
	
	
	/** 코드시퀀스 : 교회직분 */
	public static final String CODE_SEQ_CHURCH_OFFICER = "CHURCH_OFFICER";
	/** 코드시퀀스 : 사용자관계 */
	public static final String CODE_SEQ_USER_RELATION = "USER_RELATION";
	
	
	/** 신청형태 : 개별형 */
	public static final String PRODUCT_TYPE_EACH = "EACH";
	/** 신청형태 : 가족형 */
	public static final String PRODUCT_TYPE_FAMILY = "FAMILY";
	
	
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
	/** 분양 진행상태 코드값 : 사용승인 */
	public static final String PROGRESS_STATUS_C = "C";
	/** 분양 진행상태 코드값 : 사용신청 */
	public static final String PROGRESS_STATUS_D = "D";
	/** 분양 진행상태 코드값 : 반려 */
	public static final String PROGRESS_STATUS_E = "E";
	
	
	/** 
	 * 엑셀 서식 타입 : 분양신청서 
	 */
	public static final String FILE_FORM_TYPE_APPLY = "APPLY_FORM";
	/** 
	 * 엑셀 서식 타입 : 분양신청서-사용자 
	 */
	public static final String FILE_FORM_TYPE_USE_USER = "USE_USER_FORM";
}
