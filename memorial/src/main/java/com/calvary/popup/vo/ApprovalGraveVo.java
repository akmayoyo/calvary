package com.calvary.popup.vo;

import java.util.List;

public class ApprovalGraveVo {

	private String assignStatus;
	private String bunyangSeq;
	private String userSeq;
	private int coupleSeq = -1;
	private List<GraveInfoVo> requestGraveList;
	private List<GraveInfoVo> approvalGraveList;
	public String getAssignStatus() {
		return assignStatus;
	}
	public void setAssignStatus(String assignStatus) {
		this.assignStatus = assignStatus;
	}
	public String getBunyangSeq() {
		return bunyangSeq;
	}
	public void setBunyangSeq(String bunyangSeq) {
		this.bunyangSeq = bunyangSeq;
	}
	public String getUserSeq() {
		return userSeq;
	}
	public void setUserSeq(String userSeq) {
		this.userSeq = userSeq;
	}
	public int getCoupleSeq() {
		return coupleSeq;
	}
	public void setCoupleSeq(int coupleSeq) {
		this.coupleSeq = coupleSeq;
	}
	public List<GraveInfoVo> getRequestGraveList() {
		return requestGraveList;
	}
	public void setRequestGraveList(List<GraveInfoVo> requestGraveList) {
		this.requestGraveList = requestGraveList;
	}
	public List<GraveInfoVo> getApprovalGraveList() {
		return approvalGraveList;
	}
	public void setApprovalGraveList(List<GraveInfoVo> approvalGraveList) {
		this.approvalGraveList = approvalGraveList;
	}
	@Override
	public String toString() {
		return "ApprovalGraveVo [assignStatus=" + assignStatus + ", bunyangSeq=" + bunyangSeq + ", userSeq=" + userSeq
				+ ", coupleSeq=" + coupleSeq + ", requestGraveList=" + requestGraveList + ", approvalGraveList="
				+ approvalGraveList + "]";
	}
	
}
