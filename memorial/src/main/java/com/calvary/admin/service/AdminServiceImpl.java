package com.calvary.admin.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.calvary.common.dao.CommonDao;

@Service
public class AdminServiceImpl implements IAdminService {
	
	@Autowired
	private CommonDao commonDao;

	
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
