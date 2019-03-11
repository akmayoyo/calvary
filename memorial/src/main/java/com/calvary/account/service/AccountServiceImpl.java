package com.calvary.account.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.calvary.admin.vo.BunyangUserVo;
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
	
	@Transactional
	public int saveKeepLoginInfo(String userId, String sessionId, int keepDays) throws Exception{
		int iRslt = 0;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("sessionId", sessionId);
		param.put("keepDays", keepDays);
		iRslt += commonDao.delete("account.deleteKeepLoginInfo", param);
		iRslt += commonDao.insert("account.insertKeepLoginInfo", param);
		return iRslt;
	}
	
	public int deleteKeepLoginInfo(String sessionId) throws Exception {
		int iRslt = 0;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("sessionId", sessionId);
		iRslt += commonDao.delete("account.deleteKeepLoginInfo", param);
		return iRslt;
	}
	
	public BunyangUserVo getKeepLoginInfo(String sessionId) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("sessionId", sessionId);
		BunyangUserVo bunyangUserVo = (BunyangUserVo)commonDao.selectOne("mobile.getKeepLoginInfo", param);
		return bunyangUserVo;
	}

}
