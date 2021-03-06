package com.calvary.mobile.service;

import java.util.ArrayList;
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
import com.calvary.common.util.SessionUtil;

@Service
public class MobileServiceImpl implements IMobileService {

	@Autowired
	private CommonDao commonDao;
	@Autowired
	private IAdminService adminService;

	public BunyangUserVo getBunyangUserVo(String userName, String birthDate) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("userName", userName);
		parameter.put("birthDate", birthDate);
		BunyangUserVo userVo = (BunyangUserVo)commonDao.selectOne("mobile.getBunyangUserVo", parameter);
		return userVo;
	}

	public List<Object> getReservedGraveInfo(String bunyangSeq, int userSeq, int coupleSeq, String graveType) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("bunyangSeq", bunyangSeq);
		parameter.put("userSeq", userSeq);
		parameter.put("coupleSeq", coupleSeq);
		parameter.put("graveType", graveType);
		List<Object> list = commonDao.selectList("use.getReservedGraveInfo", parameter);
		return list;
	}

	public List<Object> getCoupleReservedGraveInfo(String bunyangSeq, int coupleSeq) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("bunyangSeq", bunyangSeq);
		parameter.put("coupleSeq", coupleSeq);
		List<Object> list = commonDao.selectList("use.getCoupleReservedGraveInfo", parameter);
		return list;
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getFamilyGraveRequestInfo(String bunyangSeq) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("bunyangSeq", bunyangSeq);
		Map<String, Object> rtnMap = (HashMap<String, Object>)commonDao.selectOne("use.getFamilyGraveRequestInfo", parameter);
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

	public List<Object> getRequiredGraveList(String bunyangSeq) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("bunyangSeq", bunyangSeq);
		List<Object> list = commonDao.selectList("mobile.getRequiredGraveList", parameter);
		return list;
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

	@SuppressWarnings("unchecked")
	@Transactional
	public int requestGrave(String productType, String groupSeq, String bunyangSeq, int coupleSeq, int userSeq, String sectionSeq, int rowSeq, int colSeq, int firstColSeq, int isReserved) throws Exception {
		int iRslt = 0;
		Map<String, Object> parameter = null;
		Map<String, Object> parameter2 = null;
		String requestUserId = null;
		if(SessionUtil.getCurrentBunyangUser() != null) {
			requestUserId = SessionUtil.getCurrentBunyangUser().getUserId();
		}
		// 신청정보 저장
		parameter2 = new HashMap<String, Object>();
		parameter2.put("bunyangSeq", bunyangSeq);
		parameter2.put("sectionSeq", sectionSeq);
		parameter2.put("rowSeq", rowSeq);
		parameter2.put("colSeq", colSeq);
		parameter2.put("useUserSeq", userSeq);
		parameter2.put("requestUser", requestUserId);
		iRslt += commonDao.insert("use.createGraveRequestInfo", parameter2);

		// 추모동산 배치현황의 상태값을 신청상태로 변경
		String graveType = coupleSeq > 0 ? CalvaryConstants.GRAVE_TYPE_COUPLE : CalvaryConstants.GRAVE_TYPE_SINGLE;
		if(isReserved == 1) {// 배우자 또는 가족구성원이 이미 신청한 경우 예약된 자리가 있기 때문에 별도 처리안함
			// 신청하려는 자리의 분양건이 신청건과 다른 경우 두개의 자리 분양 seq 를 스왑
			List<Object> tmpList = getBunyangSeqOfGrave(sectionSeq, String.valueOf(rowSeq), String.valueOf(colSeq));
			Map<String, Object> tmpMap = null;
			if(tmpList != null && tmpList.size() > 0) {
				tmpMap = (HashMap<String, Object>)tmpList.get(0);
				String bunyangSeq2 = String.valueOf(tmpMap.get("bunyang_seq"));
				if(!bunyangSeq.equals(bunyangSeq2)) {
					// 신청 분양 seq로 예약된 자리중 첫번째 자리의 분양 seq 업데이트
					tmpList = getFirstReservedInfo(bunyangSeq);
					if(tmpList != null && tmpList.size() > 0) {
						// 신청 자리의 분양 seq 업데이트
						updateGraveBunyangSeq(sectionSeq, String.valueOf(rowSeq), String.valueOf(colSeq), bunyangSeq);
						tmpMap = (HashMap<String, Object>)tmpList.get(0);
						updateGraveBunyangSeq(
								String.valueOf(tmpMap.get("section_seq"))
								, String.valueOf(tmpMap.get("row_seq"))
								, String.valueOf(tmpMap.get("col_seq"))
								, bunyangSeq2
						);
					}

				}
			}
		} else {// 배정받은 자리가 없는 경우
			List<Object> requireList = getRequiredGraveList(bunyangSeq);
			int requireCnt = 1;
			// 가족형인 경우 가족 구성원 자리까지 신청상태로함
			if(CalvaryConstants.PRODUCT_TYPE_FAMILY.equals(productType)) {
				requireCnt = getRequiredGraveCount(bunyangSeq);
			}
			// 신청 페이지 표시후 신청까지 경과 시간이 있기때문에 현재도 사용가능한지 한번더 체크
			parameter = new HashMap<String, Object>();
			parameter.put("sectionSeq", sectionSeq);
			parameter.put("graveType", graveType);
			parameter.put("cnt", requireCnt);
			Map<String, Object> availableGraveInfo = (HashMap<String, Object>)commonDao.selectOne("use.getAvailableSectionGraveInfo", parameter);
			if(availableGraveInfo != null) {
				int col = CommonUtil.convertToInt(availableGraveInfo.get("col_seq"));
				if(col != firstColSeq) {
					// 동일메서드 Exception Transaction 안걸려서 수동으로 삭제해줌
					commonDao.delete("use.deleteGraveRequestInfo", parameter2);
					throw new Exception("requested col seq is not available!! col : " + col + ", colSeq : " + firstColSeq);
				}
			} else {
				// 동일메서드 Exception Transaction 안걸려서 수동으로 삭제해줌
				commonDao.delete("use.deleteGraveRequestInfo", parameter2);
				throw new Exception("no available grave!! sectionSeq : " + sectionSeq);
			}

			if(CalvaryConstants.PRODUCT_TYPE_FAMILY.equals(productType)) {
				int i = 0, j = 0;
				List<Integer> reservedColSeqs = new ArrayList<Integer>();
				for(i = 0; i < requireCnt; i++) {
					if(colSeq != firstColSeq+i) {
						reservedColSeqs.add(firstColSeq+i);
					}
				}
				int idx = 0;
				for(i = 0; i < requireList.size(); i++) {
					Map<String, Object> tmp = (HashMap<String, Object>)requireList.get(i);
					String tBunyangSeq = String.valueOf(tmp.get("bunyang_seq"));
					int tRequireCnt = Integer.parseInt(String.valueOf(tmp.get("require_cnt")));
					if(bunyangSeq.equals(tBunyangSeq)) {
						tRequireCnt -= 1;
					}
					for(j = 0; j < tRequireCnt; j++) {
						parameter = new HashMap<String, Object>();
						parameter.put("groupSeq", groupSeq);
						parameter.put("bunyangSeq", tBunyangSeq);
						parameter.put("coupleSeq", null);
						parameter.put("useUserSeq1", null);
						parameter.put("useUserSeq2", null);
						parameter.put("sectionSeq", sectionSeq);
						parameter.put("rowSeq", rowSeq);
						parameter.put("colSeq", reservedColSeqs.get(idx));
						parameter.put("assignStatus", CalvaryConstants.GRAVE_ASSIGN_STATUS_REQUESTED);
						iRslt += commonDao.update("use.updateGraveRequestInfo", parameter);
						idx++;
					}
				}
				parameter = new HashMap<String, Object>();
				parameter.put("groupSeq", groupSeq);
				parameter.put("bunyangSeq", bunyangSeq);
				parameter.put("coupleSeq", CalvaryConstants.GRAVE_TYPE_COUPLE.equals(graveType) ? coupleSeq : null);
				parameter.put("useUserSeq1", userSeq);
				parameter.put("useUserSeq2", null);
				parameter.put("sectionSeq", sectionSeq);
				parameter.put("rowSeq", rowSeq);
				parameter.put("colSeq", colSeq);
				parameter.put("assignStatus", CalvaryConstants.GRAVE_ASSIGN_STATUS_REQUESTED);
				iRslt += commonDao.update("use.updateGraveRequestInfo", parameter);
			} else {
				parameter = new HashMap<String, Object>();
				parameter.put("groupSeq", groupSeq);
				parameter.put("bunyangSeq", bunyangSeq);
				parameter.put("coupleSeq", (CalvaryConstants.GRAVE_TYPE_COUPLE.equals(graveType)) ? coupleSeq : null);
				parameter.put("useUserSeq1", userSeq);
				parameter.put("useUserSeq2", null);
				parameter.put("sectionSeq", sectionSeq);
				parameter.put("rowSeq", rowSeq);
				parameter.put("colSeq", colSeq);
				parameter.put("assignStatus", CalvaryConstants.GRAVE_ASSIGN_STATUS_REQUESTED);
				iRslt += commonDao.update("use.updateGraveRequestInfo", parameter);
			}
		}
		return iRslt;
	}

	public List<Object> getContractMinister(String bunyangSeq) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("bunyangSeq", bunyangSeq);
		List<Object> rtnList = commonDao.selectList("mobile.getContractMinister", parameter);
		return rtnList;
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getContract(String codeSeq) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("codeSeq", codeSeq);
		Map<String, Object> rtnMap = (HashMap<String, Object>)commonDao.selectOne("mobile.getContract", parameter);
		return rtnMap;
	}

	public List<Object> getContractList(String codeSeq) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("codeSeq", codeSeq);
		List<Object> rtnList = commonDao.selectList("mobile.getContractList", parameter);
		return rtnList;
	}

	public List<Object> getBunyangSeqOfGrave(String section_seq, String row_seq, String col_seq) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("section_seq", section_seq);
		parameter.put("row_seq", row_seq);
		parameter.put("col_seq", col_seq);
		List<Object> rtnList = commonDao.selectList("mobile.getBunyangSeqOfGrave", parameter);
		return rtnList;
	}

	public List<Object> getFirstReservedInfo(String bunyang_seq) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("bunyang_seq", bunyang_seq);
		List<Object> rtnList = commonDao.selectList("mobile.getFirstReservedInfo", parameter);
		return rtnList;
	}

	@Transactional
	public int updateGraveBunyangSeq(String section_seq, String row_seq, String col_seq, String bunyang_seq) throws Exception {
		int iRslt = 0;
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("bunyang_seq", bunyang_seq);
		parameter.put("section_seq", section_seq);
		parameter.put("row_seq", row_seq);
		parameter.put("col_seq", col_seq);
		iRslt += commonDao.update("mobile.updateGraveBunyangSeq", parameter);
		return iRslt;
	}

	@Transactional
	public int createGraveNotice(String bunyangSeq, String useUserSeq, String requestUser, String borneOutDate, String deathDate) throws Exception {
		int iRslt = 0;
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("bunyangSeq", bunyangSeq);
		parameter.put("useUserSeq", useUserSeq);
		parameter.put("requestUser", requestUser);
		parameter.put("borneOutDate", borneOutDate);
		parameter.put("deathDate", deathDate);
		iRslt += commonDao.insert("common.createGraveNotice", parameter);
		return iRslt;
	}
}
