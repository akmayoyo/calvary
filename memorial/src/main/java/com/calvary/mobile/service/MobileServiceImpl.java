package com.calvary.mobile.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.calvary.admin.service.IAdminService;
import com.calvary.admin.vo.BunyangUserVo;
import com.calvary.common.constant.CalvaryConstants;
import com.calvary.common.dao.CommonDao;
import com.calvary.common.util.CommonUtil;

@Service
public class MobileServiceImpl implements IMobileService {

	@Autowired
	private CommonDao commonDao;
	@Autowired
	private IAdminService adminService;
	
	public BunyangUserVo getBunyangUserVo(String userName, String mobile, String birthDate) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("userName", userName);
		parameter.put("mobile", mobile);
		parameter.put("birthDate", birthDate);
		BunyangUserVo userVo = (BunyangUserVo)commonDao.selectOne("mobile.getBunyangUserVo", parameter);
		return userVo;
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getReservedGraveInfo(String bunyangSeq, int userSeq, int coupleSeq) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("bunyangSeq", bunyangSeq);
		parameter.put("userSeq", userSeq);
		parameter.put("coupleSeq", coupleSeq);
		Map<String, Object> rtnMap = (HashMap<String, Object>)commonDao.selectOne("use.getReservedGraveInfo", parameter);
		return rtnMap;
	}
	
	@SuppressWarnings("unchecked")
	public int getRequiredGraveCount(String bunyangSeq) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("bunyangSeq", bunyangSeq);
		Map<String, Object> rtnMap = (HashMap<String, Object>)commonDao.selectOne("mobile.getRequiredGraveCount", parameter);
		int requiredCnt = CommonUtil.convertToInt(rtnMap.get("required_cnt"));
		return requiredCnt;
	}
	
	public List<Object> getAvailableGraveInfoAll(String graveType, int cnt) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("graveType", graveType);
		parameter.put("cnt", cnt);
		List<Object> list = commonDao.selectList("use.getAvailableGraveInfoAll", parameter);
		return list;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public int assignGrave(String productType, String bunyangSeq, int coupleSeq, int userSeq, String sectionSeq, int rowSeq, int colSeq, int isReserved) throws Exception {
		int iRslt = 0;
		Map<String, Object> usingCoupleUser = null;
		Map<String, Object> parameter = null;
		String graveType = coupleSeq > 0 ? CalvaryConstants.GRAVE_TYPE_COUPLE : CalvaryConstants.GRAVE_TYPE_SINGLE;
		int usingUserSeq = -1;
		if(isReserved == 1) {// 이미 배정받은 자리가 있는 경우
			if(coupleSeq > 0) {// 부부형인 경우
				parameter = new HashMap<String, Object>();
				parameter.put("bunyangSeq", bunyangSeq);
				parameter.put("coupleSeq", coupleSeq);
				usingCoupleUser = (HashMap<String, Object>)commonDao.selectOne("use.getUsingCoupleUserSeq", parameter);
				if(usingCoupleUser != null) {// 배우자가 이미 사용중인 경우
					usingUserSeq = CommonUtil.convertToInt(usingCoupleUser.get("use_user_seq1"));
					parameter = new HashMap<String, Object>();
					parameter.put("bunyangSeq", bunyangSeq);
					parameter.put("coupleSeq", coupleSeq);
					parameter.put("useUserSeq1", usingUserSeq);
					parameter.put("useUserSeq2", userSeq);
					parameter.put("assignStatus", CalvaryConstants.GRAVE_ASSIGN_STATUS_OCCUPIED);
					parameter.put("sectionSeq", sectionSeq);
					parameter.put("rowSeq", rowSeq);
					parameter.put("colSeq", colSeq);
				} else {// 아닌경우
					parameter = new HashMap<String, Object>();
					parameter.put("bunyangSeq", bunyangSeq);
					parameter.put("coupleSeq", coupleSeq);
					parameter.put("useUserSeq1", userSeq);
					parameter.put("useUserSeq2", null);
					parameter.put("assignStatus", CalvaryConstants.GRAVE_ASSIGN_STATUS_HALF_OCCUPIED);
					parameter.put("sectionSeq", sectionSeq);
					parameter.put("rowSeq", rowSeq);
					parameter.put("colSeq", colSeq);
				}
			}else {// 1인형인 경우
				parameter = new HashMap<String, Object>();
				parameter.put("bunyangSeq", bunyangSeq);
				parameter.put("coupleSeq", null);
				parameter.put("useUserSeq1", userSeq);
				parameter.put("useUserSeq2", null);
				parameter.put("assignStatus", CalvaryConstants.GRAVE_ASSIGN_STATUS_OCCUPIED);
				parameter.put("sectionSeq", sectionSeq);
				parameter.put("rowSeq", rowSeq);
				parameter.put("colSeq", colSeq);
			}
			iRslt += commonDao.update("use.updateGrave", parameter);
		} else {// 배정받은 자리가 없는 경우
			
			// 가족형인 경우 미리 자리를 예약상태로 업데이트
			if(CalvaryConstants.PRODUCT_TYPE_FAMILY.equals(productType)) {
				
				List<Object> useUserList = adminService.getBunyangRefUserInfo(bunyangSeq, CalvaryConstants.BUNYANG_REF_TYPE_USE_USER);
				int requireCnt = useUserList.size();
				
				if(CalvaryConstants.GRAVE_TYPE_COUPLE.equals(graveType)) {// 부부형인 경우 두명이 한자리
					requireCnt = requireCnt/2;
				}
				parameter = new HashMap<String, Object>();
				parameter.put("sectionSeq", sectionSeq);
				parameter.put("graveType", graveType);
				parameter.put("cnt", requireCnt);
				// 가족수만큼 연속배정이 가능한 자리를 조회
				Map<String, Object> availableGraveInfo = (HashMap<String, Object>)commonDao.selectOne("use.getAvailableSectionGraveInfo", parameter);
				if(availableGraveInfo != null) {
					String section = (String)availableGraveInfo.get("section_seq");
					int row = CommonUtil.convertToInt(availableGraveInfo.get("row_seq"));
					int col = CommonUtil.convertToInt(availableGraveInfo.get("col_seq"));
					// 예약 상태로 업데이트
					for(int i = 0; i < requireCnt; i++) {
						parameter = new HashMap<String, Object>();
						parameter.put("bunyangSeq", bunyangSeq);
						parameter.put("coupleSeq", null);
						parameter.put("useUserSeq1", null);
						parameter.put("useUserSeq2", null);
						parameter.put("sectionSeq", section);
						parameter.put("rowSeq", row);
						parameter.put("colSeq", col+i);
						parameter.put("assignStatus", CalvaryConstants.GRAVE_ASSIGN_STATUS_RESERVED);
						iRslt += commonDao.update("use.updateGrave", parameter);
					}
				} else {
					throw new Exception("no available grave!!");
				}
			}
			
			if(coupleSeq > 0) {// 부부형인 경우
				parameter = new HashMap<String, Object>();
				parameter.put("bunyangSeq", bunyangSeq);
				parameter.put("coupleSeq", coupleSeq);
				parameter.put("useUserSeq1", userSeq);
				parameter.put("useUserSeq2", null);
				parameter.put("assignStatus", CalvaryConstants.GRAVE_ASSIGN_STATUS_HALF_OCCUPIED);
				parameter.put("sectionSeq", sectionSeq);
				parameter.put("rowSeq", rowSeq);
				parameter.put("colSeq", colSeq);
			} else {// 1인형인 경우
				parameter = new HashMap<String, Object>();
				parameter.put("bunyangSeq", bunyangSeq);
				parameter.put("coupleSeq", null);
				parameter.put("useUserSeq1", userSeq);
				parameter.put("useUserSeq2", null);
				parameter.put("assignStatus", CalvaryConstants.GRAVE_ASSIGN_STATUS_OCCUPIED);
				parameter.put("sectionSeq", sectionSeq);
				parameter.put("rowSeq", rowSeq);
				parameter.put("colSeq", colSeq);
			}
			iRslt += commonDao.update("use.updateGrave", parameter);
		}
		
		return iRslt;
	}
}
