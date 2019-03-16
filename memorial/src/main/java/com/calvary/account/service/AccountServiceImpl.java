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
	
	@Override
	public UserVo getUserVo(String userId) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		UserVo userVo = (UserVo)commonDao.selectOne("account.getUserById", param);
		return userVo;
	}
	
	public int createUserInfo(UserVo userVo) throws Exception {
		int iRslt = 0;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userVo.getUserId());
		param.put("password", userVo.getPassword());
		param.put("userName", userVo.getUserName());
		param.put("birthDate", userVo.getBirthDate());
		param.put("gender", userVo.getGender());
		param.put("email", userVo.getEmail());
		param.put("mobile", userVo.getMobile());
		param.put("phone", userVo.getPhone());
		param.put("postNumber", userVo.getPostNumber());
		param.put("address1", userVo.getAddress1());
		param.put("address2", userVo.getAddress2());
		param.put("churchOfficer", userVo.getChurchOfficer());
		param.put("diocese", userVo.getDiocese());
		iRslt += commonDao.insert("account.createUserInfo", param);
		return iRslt;
	}
	
	public int updatePassword(String userId, String password) throws Exception {
		int iRslt = 0;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("password", password);
		iRslt += commonDao.update("account.updatePassword", param);
		return iRslt;
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
	
	public UserVo getUserByNameAndMobile(String userId, String userName, String mobile) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("userName", userName);
		param.put("mobile", mobile);
		UserVo userVo = (UserVo)commonDao.selectOne("account.getUserByNameAndMobile", param);
		return userVo;
	}
	
	public UserVo getUserByAuthNo(String userName, String mobile, String authNo) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userName", userName);
		param.put("mobile", mobile);
		param.put("authNo", authNo);
		UserVo userVo = (UserVo)commonDao.selectOne("account.getUserByAuthNo", param);
		return userVo;
	}
	
	public UserVo getUserByAuthNo(String userId, String userName, String mobile, String authNo) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("userName", userName);
		param.put("mobile", mobile);
		param.put("authNo", authNo);
		UserVo userVo = (UserVo)commonDao.selectOne("account.getUserByAuthNo2", param);
		return userVo;
	}
	
	@Transactional
	public int createUserAuthInfo(String userId, String authNo) throws Exception{
		int iRslt = 0;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("authNo", authNo);
		iRslt += commonDao.delete("account.deleteUserAuthInfo", param);
		iRslt += commonDao.insert("account.insertUserAuthInfo", param);
		return iRslt;
	}

}
