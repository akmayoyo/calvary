package com.calvary.account.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.calvary.common.dao.CommonDao;
import com.calvary.common.vo.UserVo;

@Service
public class AccountServiceImpl implements IAccountService {

	@Autowired
	private CommonDao commonDao;
	
	@Override
	public UserVo getUserVo(String userId, String password) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("password", password);
		UserVo userVo = (UserVo)commonDao.selectOne("account.getUserVo", param);
		return userVo;
	}

}
