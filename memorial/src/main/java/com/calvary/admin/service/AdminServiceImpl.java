package com.calvary.admin.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.calvary.admin.vo.BunyangInfoVo;
import com.calvary.admin.vo.BunyangUserVo;
import com.calvary.common.constant.CalvaryConstants;
import com.calvary.common.dao.CommonDao;
import com.calvary.common.vo.SearchVo;

@Service
public class AdminServiceImpl implements IAdminService {
	
	@Autowired
	private CommonDao commonDao;

	//===============================================================================
	// 분양신청관리
	//===============================================================================
	/** 
	 * 분양신청리스트 조회 
	 */
	public List<Object> getApplyList(SearchVo searchVo) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("pageIndex", searchVo.getPageIndex());
		parameter.put("countPerPage", searchVo.getCountPerPage());
		parameter.put(searchVo.getSearchKey(), searchVo.getSearchVal());
		List<Object> list = commonDao.selectList("admin.getApplyList", parameter); 
		return list;
	}
	
	/** 
	 * 분양 정보 조회 
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getBunyangInfo(String bunyangSeq) {
		Map<String, Object> rtn = (HashMap<String, Object>)commonDao.selectOne("admin.getBunyangInfo", bunyangSeq); 
		return rtn;
	}
	
	/** 
	 * 분양관련 사용자 정보 조회 
	 */
	public List<Object> getBunyangRefUserInfo(String bunyangSeq, String refType) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("bunyangSeq", bunyangSeq);
		parameter.put("refType", refType);
		List<Object> list = commonDao.selectList("admin.getBunyangRefUserInfo", parameter); 
		return list;
	}
	
	/** 
	 * 분양정보의 신청서,승인서등 관련 파일양식 조회
	 */
	public List<Object> getBunyangFileList(String bunyangSeq) {
		List<Object> list = commonDao.selectList("admin.getBunyangFileList", bunyangSeq); 
		return list;
	}
	
	/** 
	 * 분양신청 정보 저장
	 * @param bunyangInfoVo
	 */
	@SuppressWarnings("unchecked")
	@Transactional
	public String createBunyangInfo(BunyangInfoVo bunyangInfoVo) {
		String sRtn = "";
		BunyangUserVo applyUser = bunyangInfoVo.getApplyUser();
		BunyangUserVo agentUser = bunyangInfoVo.getAgentUser();
		Map<String, Object> param = null;
		List<BunyangUserVo> useUsers = bunyangInfoVo.getUseUsers();
		Map<String, Object> rtnMap = (HashMap<String, Object>)commonDao.selectOne("admin.getBunyangInfoSequence", ""); 
		String bunyangSeq = (String)rtnMap.get("seq");
		
		// 분양정보 생성
		param = new HashMap<String, Object>();
		param.put("bunyangSeq", bunyangSeq);
		param.put("productType", bunyangInfoVo.getProductType());
		param.put("coupleTypeCount", bunyangInfoVo.getCoupleTypeCount());
		param.put("singleTypeCount", bunyangInfoVo.getSingleTypeCount());
		param.put("serviceChargeType", bunyangInfoVo.getServiceChargeType());
		param.put("progressStatus", bunyangInfoVo.getProgressStatus());
		// TODO
		param.put("registUserSeq", "calvaryadmin");
		commonDao.insert("admin.createBunyangInfo", param);
		
		// 분양 관련 인명정보 생성(신청자)
		param = getBunyangUserParam(applyUser);
		param.put("bunyangSeq", bunyangSeq);
		commonDao.insert("admin.createBunyangRefUserInfo", param);
		
		// 분양 관련 인명정보 생성(대리인)
		if(agentUser != null) {
			param = getBunyangUserParam(agentUser);
			param.put("bunyangSeq", bunyangSeq);
			commonDao.insert("admin.createBunyangRefUserInfo", param);
		}
		
		// 분양 관련 인명정보 생성(사용자)
		if(useUsers != null && useUsers.size() > 0) {
			for(int i = 0; i < useUsers.size(); i++) {
				BunyangUserVo useUser = useUsers.get(i);
				param = getBunyangUserParam(useUser);
				param.put("bunyangSeq", bunyangSeq);
				commonDao.insert("admin.createBunyangRefUserInfo", param);
			}
		}
		sRtn = bunyangSeq;
		return sRtn;
	}
	
	/** 
	 * 분양 양식파일 고유번호 업데이트
	 */
	public int updateBunyangFileSeq(Map<String, Object> param) {
		int iRslt = commonDao.update("admin.updateBunyangFileSeq", param);
		return iRslt;
	}
	
	/** 
	 * 분양 관련 인명정보 생성을 위한 parameter 반환
	 */
	private Map<String, Object> getBunyangUserParam(BunyangUserVo bunyangUserVo) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("refType", bunyangUserVo.getRefType());
		param.put("relationType", bunyangUserVo.getRelationType());
		param.put("userId", bunyangUserVo.getUserId());
		param.put("userName", bunyangUserVo.getUserName());
		param.put("birthDate", bunyangUserVo.getBirthDate());
		param.put("gender", bunyangUserVo.getGender());
		param.put("email", bunyangUserVo.getEmail());
		param.put("mobile", bunyangUserVo.getMobile());
		param.put("phone", bunyangUserVo.getPhone());
		param.put("postNumber", bunyangUserVo.getPostNumber());
		param.put("address1", bunyangUserVo.getAddress1());
		param.put("address2", bunyangUserVo.getAddress2());
		param.put("isChurchPerson", bunyangUserVo.getIsChurchPerson());
		return param;
	}
	
	
	//===============================================================================
	// 메뉴 관리
	//===============================================================================
	
	/** 
	 * 메뉴리스트조회 
	 * @param userId 접속유저 아이디
	 */
	@Override
	@SuppressWarnings("unchecked")
	public List<Object> getMenuList(String userId) {
		List<Object> menuListAll = commonDao.selectList("menumgmt.getMenuList", userId);
		List<Object> rtnList = new ArrayList<Object>();
		// 메뉴를 Hierarchy 구조로 가공
		if(menuListAll != null && menuListAll.size() > 0) {
			for(int i = 0, iLen = menuListAll.size(); i < iLen; i++) {
				Map<String, Object> tmp = (Map<String, Object>)menuListAll.get(i);
				int menuLevel =  (int)tmp.get("menu_level");
				if(menuLevel == 1) {
					String menuSeq = (String)tmp.get("menu_seq");
					List<Map<String, Object>> children = getChildMenuList(menuSeq, menuLevel + 1, menuListAll);
					tmp.put("children", children);
					rtnList.add(tmp);
				}
			}
		}
		return rtnList;
	}
	
	/** 
	 * 특정메뉴의 하위메뉴를 재귀호출하면서 Hierarchy 구조로 반환 
	 * @param menuId 메뉴아이디
	 * @param childLevel child 메뉴 레벨
	 * @param menuListAll 전체 메뉴리스트
	 */
	@SuppressWarnings("unchecked")
	private List<Map<String, Object>> getChildMenuList(String menuId, int childLevel, List<Object> menuListAll) {
		List<Map<String, Object>> children = new ArrayList<Map<String,Object>>();
		if(menuListAll != null && menuListAll.size() > 0) {
			for(int i = 0, iLen = menuListAll.size(); i < iLen; i++) {
				Map<String, Object> tmp = (Map<String, Object>)menuListAll.get(i);
				int menuLevel =  (int)tmp.get("menu_level");
				if(menuLevel != childLevel) {
					continue;
				}
				String menuSeq = (String)tmp.get("menu_seq");
				String parentMenuSeq = (String)tmp.get("parent_menu_seq");
				if(menuId != null && menuId.equals(parentMenuSeq)) {
					List<Map<String, Object>> cchildren = getChildMenuList(menuSeq, menuLevel + 1, menuListAll);
					tmp.put("children", cchildren);
					children.add(tmp);
				}
			}
		}
		return children;
	}
	
}
