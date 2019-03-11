package com.calvary.common.vo;

import com.calvary.admin.vo.BunyangUserVo;

public class SessionVo {

	private UserVo userVo;
	
	private BunyangUserVo bunyangUserVo;

	public UserVo getUserVo() {
		return userVo;
	}

	public void setUserVo(UserVo userVo) {
		this.userVo = userVo;
	}

	public BunyangUserVo getBunyangUserVo() {
		return bunyangUserVo;
	}
	public void setBunyangUserVo(BunyangUserVo bunyangUserVo) {
		this.bunyangUserVo = bunyangUserVo;
	}
	
}
