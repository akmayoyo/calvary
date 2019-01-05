package com.calvary.common.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.calvary.common.dao.CommonDao;

@Service
public class CommonServiceImpl implements ICommonService {

	@Autowired
	private CommonDao commonDao;
	
	@Override
	public List<Object> getChildCodeList(String parentCodeSeq) {
		List<Object> list = commonDao.selectList("common.getChildCodeList", parentCodeSeq);
		return list;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getMenuInfo(String menuSeq) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("menuSeq", menuSeq);
		Map<String, Object> rtnMap = (HashMap<String, Object>)commonDao.selectOne("common.getMenuInfo", param);
		return rtnMap;
	}

}
