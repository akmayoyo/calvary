package com.calvary.account.service;

import com.calvary.common.vo.UserVo;

public interface IAccountService {

	public UserVo getUserVo(String userId, String password);
}
