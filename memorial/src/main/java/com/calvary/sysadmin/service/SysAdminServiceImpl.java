package com.calvary.sysadmin.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.calvary.common.dao.CommonDao;
import com.calvary.sysadmin.vo.CodeInfoVo;
import com.calvary.sysadmin.vo.CodeVo;

@Service
public class SysAdminServiceImpl implements ISysAdminService {
	@Autowired
	private CommonDao commonDao;
	
	//===============================================================================
	// 코드관리
	//===============================================================================
	/** 
	 * 최상위 코드리스트 조회 
	 */
	public List<Object> getTopLevelCodeList() {
		Map<String, Object> parameter = new HashMap<String, Object>();
		List<Object> list = commonDao.selectList("sysadmin.getTopLevelCodeList", parameter); 
		return list;
	}
	
	/** 
	 * 코드 저장 
	 */
	@Transactional
	public int createCodeInfo(CodeInfoVo codeInfoVo) throws Exception {
		int iRslt = 0;
		String parentCodeSeq = codeInfoVo.getParentCodeSeq();
		List<CodeVo> codeList = codeInfoVo.getCodeList();
		if(codeList != null && codeList.size() > 0) {
			for(int i = 0; i < codeList.size(); i++) {
				Map<String, Object> parameter = new HashMap<String, Object>();
				CodeVo codeVo = codeList.get(i);
				parameter.put("codeSeq", codeVo.getCodeSeq());
				parameter.put("codeName", codeVo.getCodeName());
				parameter.put("codeDesc", codeVo.getCodeDesc());
				parameter.put("codeLevel", codeVo.getCodeLevel());
				parameter.put("displayOrder", codeVo.getDisplayOrder());
				parameter.put("codeValue", codeVo.getCodeValue());
				parameter.put("parentCodeSeq", parentCodeSeq);
				if("U".equals(codeVo.getFlag())) {
					iRslt += commonDao.update("sysadmin.updateCodeInfo", parameter);
				} else if("C".equals(codeVo.getFlag())) {
					iRslt += commonDao.insert("sysadmin.createCodeInfo", parameter);
				}
			}
		}
		return iRslt;
	}
	
	/** 
	 * 코드 삭제
	 */
	@Transactional
	public int deleteCodeInfo(CodeVo codeVo) throws Exception {
		int iRslt = 0;
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("codeSeq", codeVo.getCodeSeq());
		parameter.put("parentCodeSeq", codeVo.getParentCodeSeq());
		iRslt += commonDao.delete("sysadmin.deleteCodeInfo", parameter);
		iRslt += commonDao.delete("sysadmin.deleteChildCodeInfo", parameter);
		return iRslt;
	}
}
