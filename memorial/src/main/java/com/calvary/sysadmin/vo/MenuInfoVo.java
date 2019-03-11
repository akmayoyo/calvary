package com.calvary.sysadmin.vo;

import java.util.List;

public class MenuInfoVo {
	private String parentMenuSeq;
	private List<MenuVo> menuList;
	public String getParentMenuSeq() {
		return parentMenuSeq;
	}
	public void setParentMenuSeq(String parentMenuSeq) {
		this.parentMenuSeq = parentMenuSeq;
	}
	public List<MenuVo> getMenuList() {
		return menuList;
	}
	public void setMenuList(List<MenuVo> menuList) {
		this.menuList = menuList;
	}
	@Override
	public String toString() {
		return "MenuInfoVo [parentMenuSeq=" + parentMenuSeq + ", menuList=" + menuList + "]";
	}
	
}
