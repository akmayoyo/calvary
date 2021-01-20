package com.calvary.main.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.calvary.common.dao.CommonDao;

@Service
public class MainServiceImpl implements IMainService{

	@Autowired
	private CommonDao commonDao;

	public List<Object> getGraveNotice() {
		Map<String, Object> parameter = new HashMap<String, Object>();
		List<Object> list = commonDao.selectList("common.getGraveNotice", parameter);
		return list;
	}
}
