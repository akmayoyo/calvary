package com.calvary.sysadmin.vo;

import java.util.List;

public class RoleInfoVo {

	private List<RoleVo> roleList;

	public List<RoleVo> getRoleList() {
		return roleList;
	}
	public void setRoleList(List<RoleVo> roleList) {
		this.roleList = roleList;
	}

	@Override
	public String toString() {
		return "RoleInfoVo [roleList=" + roleList + "]";
	}
	
}
