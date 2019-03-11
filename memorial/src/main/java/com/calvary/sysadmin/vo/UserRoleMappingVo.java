package com.calvary.sysadmin.vo;

import java.util.List;

public class UserRoleMappingVo {

	private String roleId;
	private List<String> userIds;
	public String getRoleId() {
		return roleId;
	}
	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}
	public List<String> getUserIds() {
		return userIds;
	}
	public void setUserIds(List<String> userIds) {
		this.userIds = userIds;
	}
	@Override
	public String toString() {
		return "UserRoleMappingVo [roleId=" + roleId + ", userIds=" + userIds + "]";
	}
	
}
