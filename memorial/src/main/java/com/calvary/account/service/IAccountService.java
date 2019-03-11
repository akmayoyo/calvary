package com.calvary.account.service;

import com.calvary.admin.vo.BunyangUserVo;
import com.calvary.common.vo.UserVo;

public interface IAccountService {

	public UserVo getUserVo(String userId, String password);
	
	public int saveKeepLoginInfo(String userId, String sessionId, int keepDays) throws Exception;
	
	public int deleteKeepLoginInfo(String sessionId) throws Exception;
	
	public BunyangUserVo getKeepLoginInfo(String sessionId);
}
