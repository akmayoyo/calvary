package com.calvary.common.service;

import java.util.List;
import java.util.Map;

public interface ICommonService {

	public List<Object> getChildCodeList(String parentCodeSeq);
	
	public Map<String, Object> getMenuInfo(String menuSeq);
}
