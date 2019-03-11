package com.calvary.sysadmin.vo;

public class MenuVo {
	private String menuSeq;
	private String menuName;
	private String menuUrl;
	private int menuLevel;
	private int displayOrder;
	private String parentMenuSeq;
	private String useYn;
	private String hasAuth;
	private String flag;// C:생성, U:업데이트
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
	public String getMenuUrl() {
		return menuUrl;
	}
	public void setMenuUrl(String menuUrl) {
		this.menuUrl = menuUrl;
	}
	public int getMenuLevel() {
		return menuLevel;
	}
	public void setMenuLevel(int menuLevel) {
		this.menuLevel = menuLevel;
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
	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}
	public String getHasAuth() {
		return hasAuth;
	}
	public void setHasAuth(String hasAuth) {
		this.hasAuth = hasAuth;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}
	@Override
	public String toString() {
		return "MenuVo [menuSeq=" + menuSeq + ", menuName=" + menuName + ", menuUrl=" + menuUrl + ", menuLevel="
				+ menuLevel + ", displayOrder=" + displayOrder + ", parentMenuSeq=" + parentMenuSeq + ", useYn="
				+ useYn + ", hasAuth=" + hasAuth + ", flag=" + flag + "]";
	}
	
}
