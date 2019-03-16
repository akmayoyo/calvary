package com.calvary.account.service;

import com.calvary.admin.vo.BunyangUserVo;
import com.calvary.common.vo.UserVo;

public interface IAccountService {

	public UserVo getUserVo(String userId, String password);
	
	public UserVo getUserVo(String userId);
	
	public int createUserInfo(UserVo userVo) throws Exception;
	
	public int updatePassword(String userId, String password) throws Exception;
	
	public int saveKeepLoginInfo(String userId, String sessionId, int keepDays) throws Exception;
	
	public int deleteKeepLoginInfo(String sessionId) throws Exception;
	
	public BunyangUserVo getKeepLoginInfo(String sessionId);
	
	public UserVo getUserByNameAndMobile(String userId, String userName, String mobile);
	
	public UserVo getUserByAuthNo(String userName, String mobile, String authNo);
	
	public UserVo getUserByAuthNo(String userId, String userName, String mobile, String authNo);
	
	public int createUserAuthInfo(String userId, String authNo) throws Exception;
}
