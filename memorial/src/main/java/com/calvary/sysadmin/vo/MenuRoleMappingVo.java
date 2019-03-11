package com.calvary.sysadmin.vo;

import java.util.List;

public class MenuRoleMappingVo {

	private String roleId;
	private List<String> menuIds;
	public String getRoleId() {
		return roleId;
	}
	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}
	public List<String> getMenuIds() {
		return menuIds;
	}
	public void setMenuIds(List<String> menuIds) {
		this.menuIds = menuIds;
	}
	@Override
	public String toString() {
		return "MenuRollMappingVo [roleId=" + roleId + ", menuIds=" + menuIds + "]";
	}
	
}
