package com.calvary.common.vo;

import java.io.Serializable;

public class UserVo implements Serializable{

	/** */
	private static final long serialVersionUID = 6304055526501379404L;
	
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
	private String churchOfficer;
	private String diocese;
	private String userStatus;
	private String registDate;
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
	public String getUserStatus() {
		return userStatus;
	}
	public void setUserStatus(String userStatus) {
		this.userStatus = userStatus;
	}
	public String getRegistDate() {
		return registDate;
	}
	public void setRegistDate(String registDate) {
		this.registDate = registDate;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	@Override
	public String toString() {
		return "UserVo [userId=" + userId + ", userName=" + userName + ", birthDate=" + birthDate + ", gender=" + gender
				+ ", email=" + email + ", mobile=" + mobile + ", phone=" + phone + ", postNumber=" + postNumber
				+ ", address1=" + address1 + ", address2=" + address2 + ", churchOfficer=" + churchOfficer
				+ ", diocese=" + diocese + ", userStatus=" + userStatus + ", registDate=" + registDate + "]";
	}
}
