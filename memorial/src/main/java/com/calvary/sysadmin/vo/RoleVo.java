package com.calvary.sysadmin.vo;

public class RoleVo {
	private String roleId;
	private String roleName;
	private String roleDesc;
	private String flag;// C:생성, U:업데이트
	public String getRoleId() {
		return roleId;
	}
	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}
	public String getRoleName() {
		return roleName;
	}
	public void setRoleName(String roleName) {
		this.roleName = roleName;
	}
	public String getRoleDesc() {
		return roleDesc;
	}
	public void setRoleDesc(String roleDesc) {
		this.roleDesc = roleDesc;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}
	@Override
	public String toString() {
		return "RoleVo [roleId=" + roleId + ", roleName=" + roleName + ", roleDesc=" + roleDesc + ", flag=" + flag
				+ "]";
	}
	
}
