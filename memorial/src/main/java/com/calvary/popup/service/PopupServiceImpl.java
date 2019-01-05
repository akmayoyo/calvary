package com.calvary.popup.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.calvary.common.constant.CalvaryConstants;
import com.calvary.common.dao.CommonDao;
import com.calvary.common.vo.SearchVo;
import com.calvary.common.vo.UserSearchVo;

@Service
public class PopupServiceImpl implements IPopupService {

	@Autowired
	private CommonDao commonDao;
	
	@Override
	public List<Object> getUserList(SearchVo searchVo) {
		Map<String, Object> searchParam = new HashMap<String, Object>();
		searchParam.put(searchVo.getSearchKey(), searchVo.getSearchVal());
		searchParam.put("start", (1-searchVo.getPageIndex()) * searchVo.getCountPerPage());
		searchParam.put("count", searchVo.getCountPerPage());
		List<Object> list = commonDao.selectList("common.getUserList", searchParam);
		return list;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getUserByNameAndBirthDate(String userName, String birthDate) {
		Map<String, Object> searchParam = new HashMap<String, Object>();
		searchParam.put("userName", userName);
		searchParam.put("birthDate", birthDate);
		Map<String, Object> map = (HashMap<String, Object>)commonDao.selectOne("common.getUserByNameAndBirthDate", searchParam);
		return map;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public boolean checkDuplicatedUser(String userName, String birthDate) {
		boolean isDuplicated = false;
		Map<String, Object> searchParam = new HashMap<String, Object>();
		searchParam.put("userName", userName);
		searchParam.put("birthDate", birthDate);
		Map<String, Object> map = (HashMap<String, Object>)commonDao.selectOne("common.checkDuplicatedUser", searchParam);
		if(map != null && map.containsKey("cnt")) {
			isDuplicated = (long)map.get("cnt") > 0;
		}
		return isDuplicated;
	}

}
