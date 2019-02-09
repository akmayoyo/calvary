package com.calvary.common.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class CommonDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	/** 
	 * insert
	 * @param queryId mapping query id
	 * @param parameter query parameter 
	 */
	public int insert(String queryId, Object parameter) throws Exception {
		return sqlSessionTemplate.insert(queryId, parameter);
	}
	
	/** 
	 * update
	 * @param queryId mapping query id
	 * @param parameter query parameter 
	 */
	public int update(String queryId, Object parameter) {
		return sqlSessionTemplate.update(queryId, parameter);
	}
	
	/** 
	 * delete
	 * @param queryId mapping query id
	 * @param parameter query parameter 
	 */
	public int delete(String queryId, Object parameter) {
		return sqlSessionTemplate.delete(queryId, parameter);
	}
	
	/** 
	 * selectList
	 * @param queryId mapping query id
	 * @param parameter query parameter 
	 */
	public List<Object> selectList(String queryId, Object parameter) {
		return sqlSessionTemplate.selectList(queryId, parameter);
	}
	
	/** 
	 * selectOne
	 * @param queryId mapping query id
	 * @param parameter query parameter 
	 */
	public Object selectOne(String queryId, Object parameter) {
		Object rtn = sqlSessionTemplate.selectOne(queryId, parameter); 
		return rtn;
	}
}
