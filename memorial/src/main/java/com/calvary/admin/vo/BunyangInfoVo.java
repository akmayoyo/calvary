package com.calvary.admin.vo;

import java.util.List;

public class BunyangInfoVo {
	private String bunyangSeq;
	private String requestUserSeq;
	private String productType;
	private int coupleTypeCount;
	private int singleTypeCount;
	private String serviceChargeType;
	private String reqApprovalSeq;
	private String contractSeq;
	private String useApprovalSeq;
	private String progressStatus;
	private String registUserSeq;
	private String registDate;
	
	private BunyangUserVo applyUser;// 신청자
	private List<BunyangUserVo> useUsers;// 사용자
	
	public String getBunyangSeq() {
		return bunyangSeq;
	}
	public void setBunyangSeq(String bunyangSeq) {
		this.bunyangSeq = bunyangSeq;
	}
	public String getRequestUserSeq() {
		return requestUserSeq;
	}
	public void setRequestUserSeq(String requestUserSeq) {
		this.requestUserSeq = requestUserSeq;
	}
	public String getProductType() {
		return productType;
	}
	public void setProductType(String productType) {
		this.productType = productType;
	}
	public int getCoupleTypeCount() {
		return coupleTypeCount;
	}
	public void setCoupleTypeCount(int coupleTypeCount) {
		this.coupleTypeCount = coupleTypeCount;
	}
	public int getSingleTypeCount() {
		return singleTypeCount;
	}
	public void setSingleTypeCount(int singleTypeCount) {
		this.singleTypeCount = singleTypeCount;
	}
	public String getServiceChargeType() {
		return serviceChargeType;
	}
	public void setServiceChargeType(String serviceChargeType) {
		this.serviceChargeType = serviceChargeType;
	}
	public String getReqApprovalSeq() {
		return reqApprovalSeq;
	}
	public void setReqApprovalSeq(String reqApprovalSeq) {
		this.reqApprovalSeq = reqApprovalSeq;
	}
	public String getContractSeq() {
		return contractSeq;
	}
	public void setContractSeq(String contractSeq) {
		this.contractSeq = contractSeq;
	}
	public String getUseApprovalSeq() {
		return useApprovalSeq;
	}
	public void setUseApprovalSeq(String useApprovalSeq) {
		this.useApprovalSeq = useApprovalSeq;
	}
	public String getProgressStatus() {
		return progressStatus;
	}
	public void setProgressStatus(String progressStatus) {
		this.progressStatus = progressStatus;
	}
	public String getRegistUserSeq() {
		return registUserSeq;
	}
	public void setRegistUserSeq(String registUserSeq) {
		this.registUserSeq = registUserSeq;
	}
	public String getRegistDate() {
		return registDate;
	}
	public void setRegistDate(String registDate) {
		this.registDate = registDate;
	}
	public BunyangUserVo getApplyUser() {
		return applyUser;
	}
	public void setApplyUser(BunyangUserVo applyUser) {
		this.applyUser = applyUser;
	}
	public List<BunyangUserVo> getUseUsers() {
		return useUsers;
	}
	public void setUseUsers(List<BunyangUserVo> useUsers) {
		this.useUsers = useUsers;
	}
	@Override
	public String toString() {
		return "BunyangInfoVo [bunyangSeq=" + bunyangSeq + ", requestUserSeq=" + requestUserSeq + ", productType="
				+ productType + ", coupleTypeCount=" + coupleTypeCount + ", singleTypeCount=" + singleTypeCount
				+ ", serviceChargeType=" + serviceChargeType + ", reqApprovalSeq=" + reqApprovalSeq + ", contractSeq="
				+ contractSeq + ", useApprovalSeq=" + useApprovalSeq + ", progressStatus=" + progressStatus
				+ ", registUserSeq=" + registUserSeq + ", registDate=" + registDate + ", applyUser=" + applyUser
				+ ", useUsers=" + useUsers + "]";
	}
}
