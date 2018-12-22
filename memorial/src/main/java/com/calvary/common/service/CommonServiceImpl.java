package com.calvary.common.service;

import java.util.List;

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

}
