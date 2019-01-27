package com.calvary.popup.vo;

import java.util.List;

import com.calvary.admin.vo.BunyangUserVo;

public class SelectUserVo {

	private String popupTitle;
	private String popupType;
	private int rowIdx = -1;
	List<BunyangUserVo> users;
	public String getPopupTitle() {
		return popupTitle;
	}
	public void setPopupTitle(String popupTitle) {
		this.popupTitle = popupTitle;
	}
	public String getPopupType() {
		return popupType;
	}
	public void setPopupType(String popupType) {
		this.popupType = popupType;
	}
	public int getRowIdx() {
		return rowIdx;
	}
	public void setRowIdx(int rowIdx) {
		this.rowIdx = rowIdx;
	}
	public List<BunyangUserVo> getUsers() {
		return users;
	}
	public void setUsers(List<BunyangUserVo> users) {
		this.users = users;
	}
	@Override
	public String toString() {
		return "SelectUserVo [popupTitle=" + popupTitle + ", popupType=" + popupType + ", rowIdx=" + rowIdx + ", users="
				+ users + "]";
	}
	
}
