package com.calvary.admin.vo;

public class BunyangUserVo {

	private String bunyangSeq;
	private String userId;
	private String userName;
	private String birthDate;
	private String gender;
	private String email;
	private String mobile;
	private String phone;
	private String postNumber;
	private String address1;
	private String address2;
	private String refType;
	private String relationType;
	private String churchOfficer;
	private String diocese;
	private String isChurchPerson;
	private String isMove;
	private int coupleSeq = -1;
	private String editing;
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getBirthDate() {
		return birthDate;
	}
	public void setBirthDate(String birthDate) {
		this.birthDate = birthDate;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getPostNumber() {
		return postNumber;
	}
	public void setPostNumber(String postNumber) {
		this.postNumber = postNumber;
	}
	public String getAddress1() {
		return address1;
	}
	public void setAddress1(String address1) {
		this.address1 = address1;
	}
	public String getAddress2() {
		return address2;
	}
	public void setAddress2(String address2) {
		this.address2 = address2;
	}
	public String getRefType() {
		return refType;
	}
	public void setRefType(String refType) {
		this.refType = refType;
	}
	public String getRelationType() {
		return relationType;
	}
	public void setRelationType(String relationType) {
		this.relationType = relationType;
	}
	public String getBunyangSeq() {
		return bunyangSeq;
	}
	public void setBunyangSeq(String bunyangSeq) {
		this.bunyangSeq = bunyangSeq;
	}
	public String getChurchOfficer() {
		return churchOfficer;
	}
	public void setChurchOfficer(String churchOfficer) {
		this.churchOfficer = churchOfficer;
	}
	public String getDiocese() {
		return diocese;
	}
	public void setDiocese(String diocese) {
		this.diocese = diocese;
	}
	public String getIsChurchPerson() {
		return isChurchPerson;
	}
	public void setIsChurchPerson(String isChurchPerson) {
		this.isChurchPerson = isChurchPerson;
	}
	public int getCoupleSeq() {
		return coupleSeq;
	}
	public void setCoupleSeq(int coupleSeq) {
		this.coupleSeq = coupleSeq;
	}
	public String getIsMove() {
		return isMove;
	}
	public void setIsMove(String isMove) {
		this.isMove = isMove;
	}
	public String getEditing() {
		return editing;
	}
	public void setEditing(String editing) {
		this.editing = editing;
	}
	@Override
	public String toString() {
		return "BunyangUserVo [bunyangSeq=" + bunyangSeq + ", userId=" + userId + ", userName=" + userName
				+ ", birthDate=" + birthDate + ", gender=" + gender + ", email=" + email + ", mobile=" + mobile
				+ ", phone=" + phone + ", postNumber=" + postNumber + ", address1=" + address1 + ", address2="
				+ address2 + ", refType=" + refType + ", relationType=" + relationType + ", churchOfficer="
				+ churchOfficer + ", diocese=" + diocese + ", isChurchPerson=" + isChurchPerson + ", isMove=" + isMove
				+ ", coupleSeq=" + coupleSeq + ", editing=" + editing + "]";
	}
}
