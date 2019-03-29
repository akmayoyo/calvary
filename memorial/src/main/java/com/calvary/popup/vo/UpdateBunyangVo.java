package com.calvary.popup.vo;

import java.util.Arrays;

public class UpdateBunyangVo {

	private String[] savedBunyangNo;
	private String[] canceledBunyangNo;
	public String[] getSavedBunyangNo() {
		return savedBunyangNo;
	}
	public void setSavedBunyangNo(String[] savedBunyangNo) {
		this.savedBunyangNo = savedBunyangNo;
	}
	public String[] getCanceledBunyangNo() {
		return canceledBunyangNo;
	}
	public void setCanceledBunyangNo(String[] canceledBunyangNo) {
		this.canceledBunyangNo = canceledBunyangNo;
	}
	@Override
	public String toString() {
		return "UpdateBunyangVo [savedBunyangNo=" + Arrays.toString(savedBunyangNo) + ", canceledBunyangNo="
				+ Arrays.toString(canceledBunyangNo) + "]";
	}
	
}
