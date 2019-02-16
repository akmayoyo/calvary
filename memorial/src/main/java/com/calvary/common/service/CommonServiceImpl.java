package com.calvary.common.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.calvary.common.dao.CommonDao;
import com.calvary.common.util.CommonUtil;

@Service
public class CommonServiceImpl implements ICommonService {

	@Autowired
	private CommonDao commonDao;
	
	@Override
	public List<Object> getYearList() {
		List<Object> list = commonDao.selectList("common.getYearList", null);
		return list;
	}
	
	@Override
	public List<Object> getChildCodeList(String parentCodeSeq) {
		List<Object> list = commonDao.selectList("common.getChildCodeList", parentCodeSeq);
		return list;
	}
	
	public List<Object> getRelationCodeList() {
		List<Object> list = commonDao.selectList("common.getRelationCodeList", null);
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
	
	@SuppressWarnings("unchecked")
	@Override
	@Transactional
	public long getSeqNexVal(String seqType) throws Exception{
		long seq = 0;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("seqType", seqType);
		int iRslt = commonDao.update("common.updateSeqNexVal", param);
		if(iRslt > 0) {
			Map<String, Object> rtnMap = (HashMap<String, Object>)commonDao.selectOne("common.getSeqNexVal", param);
			if(rtnMap != null && rtnMap.containsKey("seq")) {
				seq = (long)rtnMap.get("seq");
			}
		}
		return seq;
	}
	
	/**
	 * 페이징에서 사용할 전제 행 개수를 반환
	 * 각 쿼리에 SQL_CALC_FOUND_ROWS 를 정의한후 해당 함수 호출해야 정상 동작함
	 */
	@SuppressWarnings("unchecked")
	public int getTotalCount() {
		int iRtn = 0;
		Map<String, Object> map = (HashMap<String, Object>)commonDao.selectOne("common.getTotalCount", null);
		if(map != null) {
			iRtn = CommonUtil.convertToInt(map.get("total_count"));
		}
		return iRtn;
	}

}
