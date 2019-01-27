package com.calvary.popup.service;

import java.util.List;
import java.util.Map;

import com.calvary.admin.vo.BunyangUserVo;
import com.calvary.common.vo.SearchVo;
import com.calvary.common.vo.UserSearchVo;

public interface IPopupService {

	public List<Object> getUserList(SearchVo searchVo);
	public long getUserListTotalCount(SearchVo searchVo);
	
	public Map<String, Object> getRefUserByNameAndBirthDate(BunyangUserVo bunyangUserVo);
	public Map<String, Object> getUserByNameAndBirthDate(String userName, String birthDate);
	
	public boolean checkDuplicatedUser(BunyangUserVo bunyangUserVo);
}
