package com.calvary.popup.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.calvary.common.constant.CalvaryConstants;
import com.calvary.common.dao.CommonDao;
import com.calvary.common.vo.UserSearchVo;

@Service
public class PopupServiceImpl implements IPopupService {

	@Autowired
	private CommonDao commonDao;
	
	@Override
	public List<Object> getUserList(UserSearchVo searchVo) {
		Map<String, Object> searchParam = new HashMap<String, Object>();
		searchParam.put("userName", searchVo.getUserName());
		searchParam.put("pageIndex", searchVo.getPageIndex());
		searchParam.put("countPerPage", searchVo.getCountPerPage());
		List<Object> list = commonDao.selectList("common.getUserList", searchParam);
		return list;
	}

}
