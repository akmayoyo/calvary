package com.calvary.scheduler;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.calvary.admin.service.IAdminService;
import com.calvary.common.constant.CalvaryConstants;
import com.calvary.common.dao.CommonDao;
import com.calvary.common.util.CommonUtil;
import com.calvary.popup.vo.ApprovalGraveVo;
import com.calvary.popup.vo.GraveInfoVo;

@Component
public class ApprovalGraveScheduler {
	
	private static final Logger logger = LoggerFactory.getLogger(ApprovalGraveScheduler.class);
	private static final Logger errLogger = LoggerFactory.getLogger("ERROR_LOGGER");

	@Autowired
	private IAdminService adminService;
	
	@Autowired
	private CommonDao commonDao;
	
	@SuppressWarnings("unchecked")
	@Scheduled(fixedDelay=1000*60)
	public void run() {
		
		try {
			
			List<Object> notApprovalList = adminService.getNotApprovalGraveList();
			
			Map<String, Object> param = new HashMap<String, Object>();
			
			if(notApprovalList != null && notApprovalList.size() > 0) {
				
				logger.info("======================== 사용(봉안)신청 자동승인 시작 ========================");
				
				for(int i = 0; i < notApprovalList.size(); i++) {
					try {
						Map<String, Object> tmp = (HashMap<String, Object>)notApprovalList.get(i);
						String bunyangSeq = (String)tmp.get("bunyang_seq");
						String sectionSeq = (String)tmp.get("section_seq");
						String rowSeq = String.valueOf(CommonUtil.convertToInt(tmp.get("row_seq")));
						String colSeq = String.valueOf(CommonUtil.convertToInt(tmp.get("col_seq")));
						String assignStatus = (String)tmp.get("assign_status");
						String userSeq = String.valueOf(CommonUtil.convertToInt(tmp.get("use_user_seq")));
						int coupleSeq = CommonUtil.convertToInt(tmp.get("couple_seq"));
						String userName = (String)tmp.get("user_name");
						String bunyangNo = (String)tmp.get("bunyang_no");
						String productType = (String)tmp.get("product_type");
						
						ApprovalGraveVo vo = new ApprovalGraveVo();
						vo.setBunyangSeq(bunyangSeq);
						vo.setAssignStatus(assignStatus);
						vo.setUserSeq(userSeq);
						vo.setCoupleSeq(coupleSeq);
						
						List<GraveInfoVo> requestGraveList = new ArrayList<GraveInfoVo>();
						List<GraveInfoVo> approvalGraveList = new ArrayList<GraveInfoVo>();
						GraveInfoVo infoVo = null;
						
						// 부부형 배우자가 이미 사용중인 신청건
						if(CalvaryConstants.GRAVE_ASSIGN_STATUS_HALF_OCCUPIED.equals(assignStatus) ||
								CalvaryConstants.GRAVE_ASSIGN_STATUS_RESERVED.equals(assignStatus)) {
							infoVo = new GraveInfoVo();
							infoVo.setSectionSeq(sectionSeq);
							infoVo.setRowSeq(rowSeq);
							infoVo.setColSeq(colSeq);
							requestGraveList.add(infoVo);
							approvalGraveList.add(infoVo);
						} else if(CalvaryConstants.GRAVE_ASSIGN_STATUS_REQUESTED.equals(assignStatus)) {// 신규신청된 경우
							infoVo = new GraveInfoVo();
							infoVo.setSectionSeq(sectionSeq);
							infoVo.setRowSeq(rowSeq);
							infoVo.setColSeq(colSeq);
							requestGraveList.add(infoVo);
							approvalGraveList.add(infoVo);
							// 가족형의 경우 가족자리까지 미리 신청하기때문에 해당정보 조회
							if(CalvaryConstants.PRODUCT_TYPE_FAMILY.equals(productType)) {
								param = new HashMap<String, Object>();
								param.put("bunyangSeq", bunyangSeq);
								List<Object> familyRequestList = commonDao.selectList("use.getFamilyRequestGraveList", param);
								if(familyRequestList != null && familyRequestList.size() > 0) {
									for(int j = 0; j < familyRequestList.size(); j++) {
										Map<String, Object> familyRequestInfo = (HashMap<String, Object>)familyRequestList.get(j);
										infoVo = new GraveInfoVo();
										infoVo.setSectionSeq((String)familyRequestInfo.get("section_seq"));
										infoVo.setRowSeq(String.valueOf(CommonUtil.convertToInt(familyRequestInfo.get("row_seq"))));
										infoVo.setColSeq(String.valueOf(CommonUtil.convertToInt(familyRequestInfo.get("col_seq"))));
										requestGraveList.add(infoVo);
										approvalGraveList.add(infoVo);
									}
								}
							}
						}
						
						vo.setRequestGraveList(requestGraveList);
						vo.setApprovalGraveList(approvalGraveList);
						
						String result;
						try {
							int iRslt = adminService.approvalRequestGrave(vo, "SYSTEM");
							result = iRslt > 0 ? "정상" : "실패";
						} catch(Exception e) {
							result = "에러";
							errLogger.error("사용(봉안)신청 자동승인 에러발생!!", e);
						}
						logger.info(String.format("분양번호:%s, 사용(봉안)자:%s, 승인위치:%s, 생성결과:%s", bunyangNo, userName, sectionSeq + "/" + rowSeq + "/" + colSeq, result));
					} catch (Exception e) {
						errLogger.error("ApprovalGraveScheduler Loop Error Occured!!", e);
					}
				}
				
				logger.info("======================== 사용(봉안)신청 자동승인 종료 ========================");
				
			}
		} catch (Exception e) {
			errLogger.error("ApprovalGraveScheduler Error Occured!!", e);
		}
	}
}
