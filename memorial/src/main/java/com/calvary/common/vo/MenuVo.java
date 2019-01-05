package com.calvary.common.vo;

public class MenuVo {

	private String menuSeq;
	private String menuName;
	private int menuLevel;
	private String menuType;
	private int displayOrder;
	private String parentMenuSeq;
	private String userYn;
	public String getMenuSeq() {
		return menuSeq;
	}
	public void setMenuSeq(String menuSeq) {
		this.menuSeq = menuSeq;
	}
	public String getMenuName() {
		return menuName;
	}
	public void setMenuName(String menuName) {
		this.menuName = menuName;
	}
	public int getMenuLevel() {
		return menuLevel;
	}
	public void setMenuLevel(int menuLevel) {
		this.menuLevel = menuLevel;
	}
	public String getMenuType() {
		return menuType;
	}
	public void setMenuType(String menuType) {
		this.menuType = menuType;
	}
	public int getDisplayOrder() {
		return displayOrder;
	}
	public void setDisplayOrder(int displayOrder) {
		this.displayOrder = displayOrder;
	}
	public String getParentMenuSeq() {
		return parentMenuSeq;
	}
	public void setParentMenuSeq(String parentMenuSeq) {
		this.parentMenuSeq = parentMenuSeq;
	}
	public String getUserYn() {
		return userYn;
	}
	public void setUserYn(String userYn) {
		this.userYn = userYn;
	}
	@Override
	public String toString() {
		return "MenuVo [menuSeq=" + menuSeq + ", menuName=" + menuName + ", menuLevel=" + menuLevel + ", menuType="
				+ menuType + ", displayOrder=" + displayOrder + ", parentMenuSeq=" + parentMenuSeq + ", userYn="
				+ userYn + "]";
	}
	
}
