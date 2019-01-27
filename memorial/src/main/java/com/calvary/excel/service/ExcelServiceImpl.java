package com.calvary.excel.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.calvary.admin.service.IAdminService;
import com.calvary.common.constant.CalvaryConstants;
import com.calvary.common.dao.CommonDao;
import com.calvary.common.service.ICommonService;
import com.calvary.common.util.CommonUtil;
import com.calvary.common.util.FileUtil;
import com.calvary.excel.ExcelForms;
import com.calvary.file.controller.FileController;
import com.calvary.file.service.IFileService;

@Service
public class ExcelServiceImpl implements IExcelService {
	
	/** */
	private static final Logger logger = LoggerFactory.getLogger("ERROR_LOGGER");
	
	@Autowired
	private CommonDao commonDao;
	@Autowired
	private IFileService fileService;
	@Autowired
	private ICommonService commonService;
	@Autowired
	private IAdminService adminService;
	
	/** 
	 * 엑셀파일의 특정셀 값을 업데이트
	 * @param excelFile 엑셀파일
	 * @param sheetnums sheet번호 
	 * @param rownums 행번호 
	 * @param cellnums 셀번호 
	 * @param cellvalues 셀값
	 * @return true/false 
	 */
	@Override
	public boolean updateExcelCellValue(File excelFile, List<Integer> sheetnums, List<Integer> rownums, List<Integer> cellnums, List<String> cellvalues) {
		FileInputStream fis = null;
		FileOutputStream fos = null;
		XSSFWorkbook workbook = null;
		boolean bRslt = false;
		try {
			fis = new FileInputStream(excelFile);
            workbook = new XSSFWorkbook(fis);
            if(sheetnums != null && sheetnums.size() > 0) {
            	for(int i = 0; i < sheetnums.size(); i++) {
            		int sheetnum = sheetnums.get(i);
            		int rownum = rownums.get(i);
            		int cellnum = cellnums.get(i);
            		String cellvalue = cellvalues.get(i);
            		XSSFSheet sheet = workbook.getSheetAt(sheetnum);
                    XSSFRow row = sheet.getRow(rownum);
                    XSSFCell cell = null;
                    if(row == null) {
                    	row = sheet.createRow(rownum);
                    }
                    cell = row.getCell(cellnum);
                    if(cell == null) {
                    	cell = row.createCell(cellnum);
                    }
                    cell.setCellValue(cellvalue);
            	}
            }
            fos =new FileOutputStream(excelFile);
            workbook.write(fos);
            bRslt = true;
        } catch (FileNotFoundException e) {
        	logger.error("exceldownload FileNotFoundException occured!!", e);
        } catch (IOException e) {
        	logger.error("exceldownload IOException occured!!", e);
        } finally {
        	if(fis != null) {
        		try {
					fis.close();
				} catch (IOException e) {}
        	}
        	if(fos != null) {
        		try {
        			fos.close();
        		} catch (IOException e) {}
        	}
        	if(workbook != null) {
        		try {
					workbook.close();
				} catch (IOException e) {
					
				}
        	}
        }
		return bRslt;
	}

	/** 
	 * Export 할 데이터 리스트 조회  
	 */
	@Override
	public List<Object> getExportDataList(String queryId, Map<String, Object> queryParam) {
		List<Object> list = commonDao.selectList(queryId, queryParam);
		return list;
	}
	
	/** 
	 * 분양 파일 서식 정보 생성 또는 업데이트 
	 */
	@SuppressWarnings("unchecked")
	public String createBunyangExcelForm(ExcelForms excelForm, String bunyangSeq, String fileSeq) {
		String rtn = "";
		String fileFormType = "";
		String destFilePath = FileController.ROOT_DIR + "/bunyang";
		int i;
		
		List<Integer> sheetnums = new ArrayList<Integer>();
		List<Integer> rownums = new ArrayList<Integer>();
		List<Integer> cellnums = new ArrayList<Integer>();
		List<String> cellvalues = new ArrayList<String>();
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("bunyangSeq", bunyangSeq);
		
		// 분양정보
		Map<String, Object> bunyangInfo = (HashMap<String, Object>) commonDao.selectOne("admin.getBunyangInfo", bunyangSeq);
		// 신청자정보
		param.put("refType", CalvaryConstants.BUNYANG_REF_TYPE_APPLY_USER);
		Map<String, Object> applyUser = (HashMap<String, Object>) commonDao.selectOne("admin.getBunyangRefUserInfo",  param);
		// 대리인정보
		param.put("refType", CalvaryConstants.BUNYANG_REF_TYPE_AGENT_USER);
		Map<String, Object> agentUser = (HashMap<String, Object>) commonDao.selectOne("admin.getBunyangRefUserInfo",  param);
		
		// 부부형
		int coupleTypeCount = (int)bunyangInfo.get("couple_type_count");
		// 1인형
		int singleTypeCount = (int)bunyangInfo.get("single_type_count");
		// 총기수
		int bunyangCnt = coupleTypeCount*2+singleTypeCount;
		// 기수당 단가
		int pricePerCount = (int)bunyangInfo.get("price_per_count");
		// 총분양대금
		int totalPrice = bunyangCnt * pricePerCount;
		// 계약금
		int contractPrice = (int)totalPrice/10;
		// 잔금
		int balancePrice = totalPrice - contractPrice;
		// 번호(승인이후부터 생성됨)
		String bunyangNo = (String)bunyangInfo.get("bunyang_no");
		
		int downPayment = CommonUtil.convertToInt(bunyangInfo.get("down_payment"));// 납부계약금
		int balancePayment = CommonUtil.convertToInt(bunyangInfo.get("balance_payment"));// 납부잔금
		
		// 금액 한글변환명
		String totalPriceH = CommonUtil.convertPriceToHangul(totalPrice);
		String contractPriceH = CommonUtil.convertPriceToHangul(contractPrice);
		String balancePriceH = CommonUtil.convertPriceToHangul(balancePrice);
		String downPaymentH = CommonUtil.convertPriceToHangul(downPayment);
		String balancePaymentH = CommonUtil.convertPriceToHangul(balancePayment);
		// 금액 세자리콤마
		String totalPriceF = CommonUtil.getThousandSeperatorFormatString(totalPrice);
		String contractPriceF = CommonUtil.getThousandSeperatorFormatString(contractPrice);
		String balancePriceF = CommonUtil.getThousandSeperatorFormatString(balancePrice);
		String downPaymentF = CommonUtil.getThousandSeperatorFormatString(downPayment);
		String balancePaymentF = CommonUtil.getThousandSeperatorFormatString(balancePayment);
		
		if(ExcelForms.APPLY_FORM.equals(excelForm) || ExcelForms.APPROVAL_FORM.equals(excelForm)) {// 분양신청서, 신청승인서
			
			if(ExcelForms.APPLY_FORM.equals(excelForm)) {
				fileFormType = CalvaryConstants.FILE_FORM_TYPE_APPLY;
				destFilePath += "/apply";
			}else if(ExcelForms.APPROVAL_FORM.equals(excelForm)) {
				fileFormType = CalvaryConstants.FILE_FORM_TYPE_APPROVAL;
				destFilePath += "/approval";
			}
			
			//============= 업데이트할 셀정보 설정 =============//
			// 승인번호
			if(ExcelForms.APPROVAL_FORM.equals(excelForm)) {
				sheetnums.add(0);
				rownums.add(5);
				cellnums.add(13);
				cellvalues.add(bunyangNo);
			}
			
			// 신청자성명
			sheetnums.add(0);
			rownums.add(8);
			cellnums.add(1);
			cellvalues.add((String)applyUser.get("user_name"));
			// 신청자 생년월일
			sheetnums.add(0);
			rownums.add(8);
			cellnums.add(4);
			cellvalues.add((String)applyUser.get("birth_date"));
			// 신청자 직분
			sheetnums.add(0);
			rownums.add(8);
			cellnums.add(7);
			cellvalues.add((String)applyUser.get("church_officer_name"));
			
			// 신청자  교구
			sheetnums.add(0);
			rownums.add(8);
			cellnums.add(10);
			cellvalues.add((String)applyUser.get("diocese"));
			
			// 신청자  휴대전화
			sheetnums.add(0);
			rownums.add(8);
			cellnums.add(11);
			cellvalues.add((String)applyUser.get("mobile"));
			
			// 신청자  우편번호
			sheetnums.add(0);
			rownums.add(10);
			cellnums.add(1);
			cellvalues.add((String)applyUser.get("post_number"));
			
			// 신청자  주소
			sheetnums.add(0);
			rownums.add(10);
			cellnums.add(2);
			cellvalues.add(CommonUtil.nullToEmpty(applyUser.get("address1")) + CommonUtil.nullToEmpty(applyUser.get("address2")));
			
			// 전화
			sheetnums.add(0);
			rownums.add(10);
			cellnums.add(convertColAlphabetToIndex("K"));
			cellvalues.add((String)applyUser.get("phone"));
			
			// 신청자  이메일
			sheetnums.add(0);
			rownums.add(10);
			cellnums.add(11);
			cellvalues.add((String)applyUser.get("email"));
			
			// 신청형태
			String productionType = (String)bunyangInfo.get("product_type");
			if(CalvaryConstants.PRODUCT_TYPE_EACH.equals(productionType)) {// 개별형
				sheetnums.add(0);
				rownums.add(19);
				cellnums.add(8);
				cellvalues.add("O");
			}else if(CalvaryConstants.PRODUCT_TYPE_FAMILY.equals(productionType)) {// 가족형
				sheetnums.add(0);
				rownums.add(19);
				cellnums.add(11);
				cellvalues.add("O");
			}
			
			if(coupleTypeCount > 0) {
				sheetnums.add(0);
				rownums.add(20);
				cellnums.add(8);
				cellvalues.add(String.valueOf(coupleTypeCount));
			}
			
			if(singleTypeCount > 0) {
				sheetnums.add(0);
				rownums.add(20);
				cellnums.add(11);
				cellvalues.add(String.valueOf(singleTypeCount));
			}
			
			// 관리비 납부형태
			String serviceChargeType = (String)bunyangInfo.get("service_charge_type");
			if(CalvaryConstants.SERVICE_CHARGE_TYPE_APPLY_USER.equals(serviceChargeType)) {// 신청자
				sheetnums.add(0);
				rownums.add(25);
				cellnums.add(3);
				cellvalues.add("O");
			}else if(CalvaryConstants.SERVICE_CHARGE_TYPE_USE_USER.equals(serviceChargeType)) {// 각 사용자별 납부
				sheetnums.add(0);
				rownums.add(25);
				cellnums.add(6);
				cellvalues.add("O");
			}else if(CalvaryConstants.SERVICE_CHARGE_TYPE_REPRESENT.equals(serviceChargeType)) {// 사용자 중 1인 대표
				sheetnums.add(0);
				rownums.add(25);
				cellnums.add(11);
				cellvalues.add("O");
				// 관리비 납부 사용자명
				sheetnums.add(0);
				rownums.add(26);
				cellnums.add(convertColAlphabetToIndex("M"));
				cellvalues.add((String)bunyangInfo.get("maint_charger_name"));
			}
			
			// 신청일
			sheetnums.add(0);
			rownums.add(30);
			cellnums.add(6);
			if(ExcelForms.APPLY_FORM.equals(excelForm)) {// 분양신청서는 신청일
				cellvalues.add((String)bunyangInfo.get("regist_date"));
			}else if(ExcelForms.APPROVAL_FORM.equals(excelForm)) {// 신청승인서는 승인일
				cellvalues.add(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
			}else {
				cellvalues.add("");
			}
			
			if(ExcelForms.APPLY_FORM.equals(excelForm)) {// 신청자는 분양신청서만
				// 신청자
				sheetnums.add(0);
				rownums.add(32);
				cellnums.add(3);
				cellvalues.add((String)applyUser.get("user_name"));
			}
			
			if(ExcelForms.APPROVAL_FORM.equals(excelForm)) {// 총기수, 분양가, 계약금은 신청승인서만
				// 총기수
				sheetnums.add(0);
				rownums.add(21);
				cellnums.add(1);
				cellvalues.add(String.valueOf(bunyangCnt));
				
				// 총분양가
				sheetnums.add(0);
				rownums.add(37);
				cellnums.add(5);
				cellvalues.add(String.format("%,d", totalPrice));
				
				// 총계약금
				sheetnums.add(0);
				rownums.add(38);
				cellnums.add(5);
				cellvalues.add(String.format("%,d", contractPrice));
			}
			
			// 대리인신청시 대리인 정보
			if(agentUser != null) {
				// 성명
				sheetnums.add(0);
				rownums.add(13);
				cellnums.add(1);
				cellvalues.add((String)agentUser.get("user_name"));
				
				// 생년월일
				sheetnums.add(0);
				rownums.add(13);
				cellnums.add(4);
				cellvalues.add((String)agentUser.get("birth_date"));
				
				// 신청자와의 관계
				sheetnums.add(0);
				rownums.add(13);
				cellnums.add(7);
				cellvalues.add((String)agentUser.get("relation_type_name"));
				
				// 휴대전화
				sheetnums.add(0);
				rownums.add(13);
				cellnums.add(11);
				cellvalues.add((String)agentUser.get("mobile"));
				
				// 우편번호
				sheetnums.add(0);
				rownums.add(15);
				cellnums.add(1);
				cellvalues.add((String)agentUser.get("post_number"));
				
				// 주소
				sheetnums.add(0);
				rownums.add(15);
				cellnums.add(2);
				cellvalues.add(CommonUtil.nullToEmpty(agentUser.get("address1")) + CommonUtil.nullToEmpty(agentUser.get("address2")));
				
				// 이메일
				sheetnums.add(0);
				rownums.add(15);
				cellnums.add(11);
				cellvalues.add((String)agentUser.get("email"));
				
				if(ExcelForms.APPLY_FORM.equals(excelForm)) {// 신청자는 분양신청서만
					// 신청자(대리인)
					sheetnums.add(0);
					rownums.add(34);
					cellnums.add(3);
					cellvalues.add((String)agentUser.get("user_name"));
				}
			}
			
		}else if(ExcelForms.USE_USER_FORM.equals(excelForm)) {// 분양신청서-사용자
			param = new HashMap<String, Object>();
			param.put("bunyangSeq", bunyangSeq);
			param.put("refType", CalvaryConstants.BUNYANG_REF_TYPE_USE_USER);
			// 사용자정보
			List<Object> useUserList = commonDao.selectList("admin.getBunyangRefUserInfo",  param);
			
			fileFormType = CalvaryConstants.FILE_FORM_TYPE_USE_USER;
			destFilePath += "/useUser";
			
			int startRowNum = 10;
			
			if(useUserList != null && useUserList.size() > 0) {
				// 신청자 성명
				sheetnums.add(0);
				rownums.add(6);
				cellnums.add(3);
				cellvalues.add((String)applyUser.get("user_name"));
				for(i = 0; i < useUserList.size(); i++, startRowNum++) {
					Map<String, Object> userMap = (HashMap<String, Object>)useUserList.get(i);
					// 사용자성명
					sheetnums.add(0);
					rownums.add(startRowNum);
					cellnums.add(2);
					cellvalues.add((String)userMap.get("user_name"));
					// 관계
					sheetnums.add(0);
					rownums.add(startRowNum);
					cellnums.add(3);
					cellvalues.add((String)userMap.get("relation_type_name"));
					// 생년월일
					sheetnums.add(0);
					rownums.add(startRowNum);
					cellnums.add(4);
					cellvalues.add((String)userMap.get("birth_date"));
					// 우편번호
					sheetnums.add(0);
					rownums.add(startRowNum);
					cellnums.add(6);
					cellvalues.add((String)userMap.get("post_number"));
					// 주소
					sheetnums.add(0);
					rownums.add(startRowNum);
					cellnums.add(7);
					cellvalues.add(CommonUtil.nullToEmpty(userMap.get("address1")) + CommonUtil.nullToEmpty(userMap.get("address2")));
					// 신청유형 TODO
					// 부부표시 TODO
					// 갈보리 교인여부
					String isChurchPerson = (String)userMap.get("is_church_person");
					if("Y".equals(isChurchPerson)) {
						sheetnums.add(0);
						rownums.add(startRowNum);
						cellnums.add(12);
						cellvalues.add("O");
					}
					// 휴대전화
					sheetnums.add(0);
					rownums.add(startRowNum);
					cellnums.add(13);
					cellvalues.add((String)userMap.get("mobile"));
					// 이메일
					sheetnums.add(0);
					rownums.add(startRowNum);
					cellnums.add(16);
					cellvalues.add((String)userMap.get("email"));
				}
			}
		}else if(ExcelForms.CONTRACT_FORM.equals(excelForm)) {// 분양계약서
			
			fileFormType = CalvaryConstants.FILE_FORM_TYPE_CONTRACT;
			destFilePath += "/contract";
			
			// 계약번호
			sheetnums.add(0);
			rownums.add(5);
			cellnums.add(convertColAlphabetToIndex("O"));
			cellvalues.add(bunyangSeq);
			// 신청자성명
			sheetnums.add(0);
			rownums.add(8);
			cellnums.add(convertColAlphabetToIndex("C"));
			cellvalues.add((String)applyUser.get("user_name"));
			sheetnums.add(0);
			rownums.add(50);
			cellnums.add(convertColAlphabetToIndex("E"));
			cellvalues.add((String)applyUser.get("user_name"));
			// 신청자 생년월일
			sheetnums.add(0);
			rownums.add(8);
			cellnums.add(convertColAlphabetToIndex("F"));
			cellvalues.add((String)applyUser.get("birth_date"));
			sheetnums.add(0);
			rownums.add(52);
			cellnums.add(convertColAlphabetToIndex("E"));
			cellvalues.add((String)applyUser.get("birth_date"));
			// 신청자 직분
			sheetnums.add(0);
			rownums.add(8);
			cellnums.add(convertColAlphabetToIndex("I"));
			cellvalues.add((String)applyUser.get("church_officer_name"));
			
			// 신청자  교구
			sheetnums.add(0);
			rownums.add(8);
			cellnums.add(convertColAlphabetToIndex("L"));
			cellvalues.add((String)applyUser.get("diocese"));
			
			// 신청자  휴대전화
			sheetnums.add(0);
			rownums.add(8);
			cellnums.add(convertColAlphabetToIndex("M"));
			cellvalues.add((String)applyUser.get("mobile"));
			
			// 신청자  우편번호
			sheetnums.add(0);
			rownums.add(10);
			cellnums.add(convertColAlphabetToIndex("C"));
			cellvalues.add((String)applyUser.get("post_number"));
			
			// 신청자  주소
			sheetnums.add(0);
			rownums.add(10);
			cellnums.add(convertColAlphabetToIndex("D"));
			cellvalues.add(CommonUtil.nullToEmpty(applyUser.get("address1")) + CommonUtil.nullToEmpty(applyUser.get("address2")));
			sheetnums.add(0);
			rownums.add(54);
			cellnums.add(convertColAlphabetToIndex("E"));
			cellvalues.add(CommonUtil.nullToEmpty(applyUser.get("address1")) + CommonUtil.nullToEmpty(applyUser.get("address2")));
			
			// 신청자  이메일
			sheetnums.add(0);
			rownums.add(10);
			cellnums.add(convertColAlphabetToIndex("M"));
			cellvalues.add((String)applyUser.get("email"));
			
			// 신청형태
			String productionType = (String)bunyangInfo.get("product_type");
			if(CalvaryConstants.PRODUCT_TYPE_EACH.equals(productionType)) {// 개별형
				sheetnums.add(0);
				rownums.add(14);
				cellnums.add(convertColAlphabetToIndex("J"));
				cellvalues.add("O");
			}else if(CalvaryConstants.PRODUCT_TYPE_FAMILY.equals(productionType)) {// 가족형
				sheetnums.add(0);
				rownums.add(14);
				cellnums.add(convertColAlphabetToIndex("M"));
				cellvalues.add("O");
			}
			if(coupleTypeCount > 0) {
				sheetnums.add(0);
				rownums.add(15);
				cellnums.add(convertColAlphabetToIndex("J"));
				cellvalues.add(String.valueOf(coupleTypeCount));
			}
			if(singleTypeCount > 0) {
				sheetnums.add(0);
				rownums.add(15);
				cellnums.add(convertColAlphabetToIndex("M"));
				cellvalues.add(String.valueOf(singleTypeCount));
			}
			
			// 총기수
			sheetnums.add(0);
			rownums.add(16);
			cellnums.add(convertColAlphabetToIndex("C"));
			cellvalues.add(String.valueOf(bunyangCnt));
			
			// 총분양가
			sheetnums.add(0);
			rownums.add(17);
			cellnums.add(convertColAlphabetToIndex("E"));
			cellvalues.add("일금:" + totalPriceH + "원");
			sheetnums.add(0);
			rownums.add(17);
			cellnums.add(convertColAlphabetToIndex("H"));
			cellvalues.add("(₩" + totalPriceF + ")");
			
			// 총계약금
			sheetnums.add(0);
			rownums.add(18);
			cellnums.add(convertColAlphabetToIndex("E"));
			cellvalues.add("일금:" + contractPriceH + "원");
			sheetnums.add(0);
			rownums.add(18);
			cellnums.add(convertColAlphabetToIndex("H"));
			cellvalues.add("(₩" + contractPriceF + ")");
			
			// 잔금
			sheetnums.add(0);
			rownums.add(19);
			cellnums.add(convertColAlphabetToIndex("E"));
			cellvalues.add("일금:" + balancePriceH + "원");
			sheetnums.add(0);
			rownums.add(19);
			cellnums.add(convertColAlphabetToIndex("H"));
			cellvalues.add("(₩" + balancePriceF + ")");
			
			// 계약금 납부내역
			List<Object> downPaymentList = adminService.getPaymentHistory(bunyangSeq, CalvaryConstants.PAYMENT_TYPE_DOWN_PAYMENT);
			Map<String, Object> tmp = null;
			int paymentRnum = 67;
			if(downPaymentList != null && downPaymentList.size() > 0) {
				for(i = 0; i < downPaymentList.size(); i++) {
					tmp = (HashMap<String, Object>)downPaymentList.get(i);
					String paymentDate = (String)tmp.get("payment_date");
					int paymentAmount = CommonUtil.convertToInt(tmp.get("payment_amount"));
					String paymentMethod = (String)tmp.get("payment_method");
					String createUser = (String)tmp.get("create_user_name");
					String createDate = (String)tmp.get("create_date");
					
					// 납부일자
					sheetnums.add(0);
					rownums.add(22);
					cellnums.add(convertColAlphabetToIndex("D"));
					cellvalues.add(paymentDate);
					sheetnums.add(0);
					rownums.add(paymentRnum);
					cellnums.add(convertColAlphabetToIndex("I"));
					cellvalues.add(paymentDate);
					// 납부금액
					sheetnums.add(0);
					rownums.add(22);
					cellnums.add(convertColAlphabetToIndex("K"));
					cellvalues.add("일금:" + CommonUtil.convertPriceToHangul(paymentAmount) + "원");
					sheetnums.add(0);
					rownums.add(22);
					cellnums.add(convertColAlphabetToIndex("M"));
					cellvalues.add("(₩" + CommonUtil.getThousandSeperatorFormatString(paymentAmount) + ")");
					sheetnums.add(0);
					rownums.add(paymentRnum);
					cellnums.add(convertColAlphabetToIndex("L"));
					cellvalues.add("₩" + CommonUtil.getThousandSeperatorFormatString(paymentAmount));
					
					// 납부방법
					if(CalvaryConstants.PAYMENT_METHOD_TRANSFER.equals(paymentMethod)) {// 이체
						sheetnums.add(0);
						rownums.add(24);
						cellnums.add(convertColAlphabetToIndex("H"));
						cellvalues.add("O");
					}else if(CalvaryConstants.PAYMENT_METHOD_CASH.equals(paymentMethod)) {// 현금
						sheetnums.add(0);
						rownums.add(24);
						cellnums.add(convertColAlphabetToIndex("N"));
						cellvalues.add("O");
					}
					
					// 확인일자
					sheetnums.add(0);
					rownums.add(26);
					cellnums.add(convertColAlphabetToIndex("D"));
					cellvalues.add(createDate);
					sheetnums.add(0);
					rownums.add(46);
					cellnums.add(convertColAlphabetToIndex("H"));
					cellvalues.add(createDate);
					
					// 확인자
					sheetnums.add(0);
					rownums.add(26);
					cellnums.add(convertColAlphabetToIndex("J"));
					cellvalues.add(createUser);
					
					paymentRnum++;
				}
			}
			
			// 잔금 납부내역
			List<Object> balancePaymentList = adminService.getPaymentHistory(bunyangSeq, CalvaryConstants.PAYMENT_TYPE_BALANCE_PAYMENT);
			if(balancePaymentList != null && balancePaymentList.size() > 0) {
				for(i = 0; i < balancePaymentList.size(); i++) {
					tmp = (HashMap<String, Object>)balancePaymentList.get(i);
					String paymentDate = (String)tmp.get("payment_date");
					int paymentAmount = CommonUtil.convertToInt(tmp.get("payment_amount"));
					
					// 납부일자
					sheetnums.add(0);
					rownums.add(paymentRnum);
					cellnums.add(convertColAlphabetToIndex("I"));
					cellvalues.add(paymentDate);
					// 납부금액
					sheetnums.add(0);
					rownums.add(68+i);
					cellnums.add(convertColAlphabetToIndex("L"));
					cellvalues.add("₩" + CommonUtil.getThousandSeperatorFormatString(paymentAmount));
					
					paymentRnum++;
				}
			}
		}else if(ExcelForms.FULL_PAYMENT_FORM.equals(excelForm)) {// 완납확인증명서
			fileFormType = CalvaryConstants.FILE_FORM_TYPE_FULL_PAYMENT;
			destFilePath += "/fullPayment";
			
			// 계약번호
			sheetnums.add(0);
			rownums.add(5);
			cellnums.add(convertColAlphabetToIndex("O"));
			cellvalues.add(bunyangSeq);
			// 신청자성명
			sheetnums.add(0);
			rownums.add(8);
			cellnums.add(convertColAlphabetToIndex("C"));
			cellvalues.add((String)applyUser.get("user_name"));
			// 신청자 생년월일
			sheetnums.add(0);
			rownums.add(8);
			cellnums.add(convertColAlphabetToIndex("F"));
			cellvalues.add((String)applyUser.get("birth_date"));
			// 신청자 직분
			sheetnums.add(0);
			rownums.add(8);
			cellnums.add(convertColAlphabetToIndex("I"));
			cellvalues.add((String)applyUser.get("church_officer_name"));
			
			// 신청자  교구
			sheetnums.add(0);
			rownums.add(8);
			cellnums.add(convertColAlphabetToIndex("L"));
			cellvalues.add((String)applyUser.get("diocese"));
			
			// 신청자  휴대전화
			sheetnums.add(0);
			rownums.add(8);
			cellnums.add(convertColAlphabetToIndex("M"));
			cellvalues.add((String)applyUser.get("mobile"));
			
			// 신청자  우편번호
			sheetnums.add(0);
			rownums.add(10);
			cellnums.add(convertColAlphabetToIndex("C"));
			cellvalues.add((String)applyUser.get("post_number"));
			
			// 신청자  주소
			sheetnums.add(0);
			rownums.add(10);
			cellnums.add(convertColAlphabetToIndex("D"));
			cellvalues.add(CommonUtil.nullToEmpty(applyUser.get("address1")) + CommonUtil.nullToEmpty(applyUser.get("address2")));
			
			// 신청자  이메일
			sheetnums.add(0);
			rownums.add(10);
			cellnums.add(convertColAlphabetToIndex("M"));
			cellvalues.add((String)applyUser.get("email"));
			
			// 신청형태
			String productionType = (String)bunyangInfo.get("product_type");
			if(CalvaryConstants.PRODUCT_TYPE_EACH.equals(productionType)) {// 개별형
				sheetnums.add(0);
				rownums.add(14);
				cellnums.add(convertColAlphabetToIndex("J"));
				cellvalues.add("O");
			}else if(CalvaryConstants.PRODUCT_TYPE_FAMILY.equals(productionType)) {// 가족형
				sheetnums.add(0);
				rownums.add(14);
				cellnums.add(convertColAlphabetToIndex("M"));
				cellvalues.add("O");
			}
			if(coupleTypeCount > 0) {
				sheetnums.add(0);
				rownums.add(15);
				cellnums.add(convertColAlphabetToIndex("J"));
				cellvalues.add(String.valueOf(coupleTypeCount));
			}
			if(singleTypeCount > 0) {
				sheetnums.add(0);
				rownums.add(15);
				cellnums.add(convertColAlphabetToIndex("M"));
				cellvalues.add(String.valueOf(singleTypeCount));
			}
			
			// 총기수
			sheetnums.add(0);
			rownums.add(16);
			cellnums.add(convertColAlphabetToIndex("C"));
			cellvalues.add(String.valueOf(bunyangCnt));
			
			// 총분양가
			sheetnums.add(0);
			rownums.add(17);
			cellnums.add(convertColAlphabetToIndex("E"));
			cellvalues.add("일금:" + totalPriceH + "원");
			sheetnums.add(0);
			rownums.add(17);
			cellnums.add(convertColAlphabetToIndex("H"));
			cellvalues.add("(₩" + totalPriceF + ")");
			
			// 총계약금
			sheetnums.add(0);
			rownums.add(18);
			cellnums.add(convertColAlphabetToIndex("E"));
			cellvalues.add("일금:" + contractPriceH + "원");
			sheetnums.add(0);
			rownums.add(18);
			cellnums.add(convertColAlphabetToIndex("H"));
			cellvalues.add("(₩" + contractPriceF + ")");
			
			// 잔금
			sheetnums.add(0);
			rownums.add(19);
			cellnums.add(convertColAlphabetToIndex("E"));
			cellvalues.add("일금:" + balancePriceH + "원");
			sheetnums.add(0);
			rownums.add(19);
			cellnums.add(convertColAlphabetToIndex("H"));
			cellvalues.add("(₩" + balancePriceF + ")");
			
			// 완납문구
			sheetnums.add(0);
			rownums.add(19);
			cellnums.add(convertColAlphabetToIndex("L"));
			cellvalues.add("완납");
			
			// 확인일자
			sheetnums.add(0);
			rownums.add(25);
			cellnums.add(convertColAlphabetToIndex("D"));
			cellvalues.add(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
			sheetnums.add(0);
			rownums.add(29);
			cellnums.add(convertColAlphabetToIndex("G"));
			cellvalues.add(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
		}else if(ExcelForms.USE_APPROVAL_FORM.equals(excelForm)) {// 사용승인서
			fileFormType = CalvaryConstants.FILE_FORM_TYPE_USE_APPROVAL;
			destFilePath += "/useApproval";
			
			// 계약번호
			sheetnums.add(0);
			rownums.add(16);
			cellnums.add(convertColAlphabetToIndex("O"));
			cellvalues.add(bunyangSeq);
			// 신청자성명
			sheetnums.add(0);
			rownums.add(18);
			cellnums.add(convertColAlphabetToIndex("C"));
			cellvalues.add((String)applyUser.get("user_name"));
			// 신청자 생년월일
			sheetnums.add(0);
			rownums.add(18);
			cellnums.add(convertColAlphabetToIndex("F"));
			cellvalues.add((String)applyUser.get("birth_date"));
			// 신청자 직분
			sheetnums.add(0);
			rownums.add(18);
			cellnums.add(convertColAlphabetToIndex("I"));
			cellvalues.add((String)applyUser.get("church_officer_name"));
			
			// 신청자  교구
			sheetnums.add(0);
			rownums.add(18);
			cellnums.add(convertColAlphabetToIndex("L"));
			cellvalues.add((String)applyUser.get("diocese"));
			
			// 신청자  휴대전화
			sheetnums.add(0);
			rownums.add(18);
			cellnums.add(convertColAlphabetToIndex("M"));
			cellvalues.add((String)applyUser.get("mobile"));
			
			// 신청자  우편번호
			sheetnums.add(0);
			rownums.add(20);
			cellnums.add(convertColAlphabetToIndex("C"));
			cellvalues.add((String)applyUser.get("post_number"));
			
			// 신청자  주소
			sheetnums.add(0);
			rownums.add(20);
			cellnums.add(convertColAlphabetToIndex("D"));
			cellvalues.add(CommonUtil.nullToEmpty(applyUser.get("address1")) + CommonUtil.nullToEmpty(applyUser.get("address2")));
			
			// 신청자  이메일
			sheetnums.add(0);
			rownums.add(20);
			cellnums.add(convertColAlphabetToIndex("M"));
			cellvalues.add((String)applyUser.get("email"));
			
			// 신청형태
			String productionType = (String)bunyangInfo.get("product_type");
			if(CalvaryConstants.PRODUCT_TYPE_EACH.equals(productionType)) {// 개별형
				sheetnums.add(0);
				rownums.add(21);
				cellnums.add(convertColAlphabetToIndex("J"));
				cellvalues.add("O");
			}else if(CalvaryConstants.PRODUCT_TYPE_FAMILY.equals(productionType)) {// 가족형
				sheetnums.add(0);
				rownums.add(21);
				cellnums.add(convertColAlphabetToIndex("M"));
				cellvalues.add("O");
			}
			if(coupleTypeCount > 0) {
				sheetnums.add(0);
				rownums.add(22);
				cellnums.add(convertColAlphabetToIndex("J"));
				cellvalues.add(String.valueOf(coupleTypeCount));
			}
			if(singleTypeCount > 0) {
				sheetnums.add(0);
				rownums.add(22);
				cellnums.add(convertColAlphabetToIndex("M"));
				cellvalues.add(String.valueOf(singleTypeCount));
			}
			
			// 총기수
			sheetnums.add(0);
			rownums.add(23);
			cellnums.add(convertColAlphabetToIndex("C"));
			cellvalues.add(String.valueOf(bunyangCnt));
			
			// 확인일자
			sheetnums.add(0);
			rownums.add(31);
			cellnums.add(convertColAlphabetToIndex("G"));
			cellvalues.add(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
		}else if(ExcelForms.CANCEL_APPROVAL_FORM.equals(excelForm)) {// 해약승인서
			fileFormType = CalvaryConstants.FILE_FORM_TYPE_CANCEL_APPROVAL;
			destFilePath += "/cancelApproval";
			
			// 해약승인번호
			sheetnums.add(0);
			rownums.add(5);
			cellnums.add(convertColAlphabetToIndex("O"));
			cellvalues.add(bunyangSeq);
			// 신청자성명
			sheetnums.add(0);
			rownums.add(8);
			cellnums.add(convertColAlphabetToIndex("C"));
			cellvalues.add((String)applyUser.get("user_name"));
			// 신청자 생년월일
			sheetnums.add(0);
			rownums.add(8);
			cellnums.add(convertColAlphabetToIndex("F"));
			cellvalues.add((String)applyUser.get("birth_date"));
			// 신청자 직분
			sheetnums.add(0);
			rownums.add(8);
			cellnums.add(convertColAlphabetToIndex("I"));
			cellvalues.add((String)applyUser.get("church_officer_name"));
			
			// 신청자  교구
			sheetnums.add(0);
			rownums.add(8);
			cellnums.add(convertColAlphabetToIndex("L"));
			cellvalues.add((String)applyUser.get("diocese"));
			
			// 신청자  휴대전화
			sheetnums.add(0);
			rownums.add(8);
			cellnums.add(convertColAlphabetToIndex("M"));
			cellvalues.add((String)applyUser.get("mobile"));
			
			// 신청자  우편번호
			sheetnums.add(0);
			rownums.add(10);
			cellnums.add(convertColAlphabetToIndex("C"));
			cellvalues.add((String)applyUser.get("post_number"));
			
			// 신청자  주소
			sheetnums.add(0);
			rownums.add(10);
			cellnums.add(convertColAlphabetToIndex("D"));
			cellvalues.add(CommonUtil.nullToEmpty(applyUser.get("address1")) + CommonUtil.nullToEmpty(applyUser.get("address2")));
			
			// 신청자  이메일
			sheetnums.add(0);
			rownums.add(10);
			cellnums.add(convertColAlphabetToIndex("M"));
			cellvalues.add((String)applyUser.get("email"));
			
			// 신청형태
			String productionType = (String)bunyangInfo.get("product_type");
			if(CalvaryConstants.PRODUCT_TYPE_EACH.equals(productionType)) {// 개별형
				sheetnums.add(0);
				rownums.add(14);
				cellnums.add(convertColAlphabetToIndex("J"));
				cellvalues.add("O");
			}else if(CalvaryConstants.PRODUCT_TYPE_FAMILY.equals(productionType)) {// 가족형
				sheetnums.add(0);
				rownums.add(14);
				cellnums.add(convertColAlphabetToIndex("M"));
				cellvalues.add("O");
			}
			if(coupleTypeCount > 0) {
				sheetnums.add(0);
				rownums.add(15);
				cellnums.add(convertColAlphabetToIndex("J"));
				cellvalues.add(String.valueOf(coupleTypeCount));
			}
			if(singleTypeCount > 0) {
				sheetnums.add(0);
				rownums.add(15);
				cellnums.add(convertColAlphabetToIndex("M"));
				cellvalues.add(String.valueOf(singleTypeCount));
			}
			
			// 총기수
			sheetnums.add(0);
			rownums.add(16);
			cellnums.add(convertColAlphabetToIndex("C"));
			cellvalues.add(String.valueOf(bunyangCnt));
			
			// 총분양가
			sheetnums.add(0);
			rownums.add(17);
			cellnums.add(convertColAlphabetToIndex("E"));
			cellvalues.add("일금:" + totalPriceH + "원");
			sheetnums.add(0);
			rownums.add(17);
			cellnums.add(convertColAlphabetToIndex("H"));
			cellvalues.add("(₩" + totalPriceF + ")");
			
			// 총계약금
			sheetnums.add(0);
			rownums.add(18);
			cellnums.add(convertColAlphabetToIndex("E"));
			cellvalues.add("일금:" + downPaymentH + "원");
			sheetnums.add(0);
			rownums.add(18);
			cellnums.add(convertColAlphabetToIndex("H"));
			cellvalues.add("(₩" + downPaymentF + ")");
			
			// 잔금
			sheetnums.add(0);
			rownums.add(19);
			cellnums.add(convertColAlphabetToIndex("E"));
			cellvalues.add("일금:" + balancePaymentH + "원");
			sheetnums.add(0);
			rownums.add(19);
			cellnums.add(convertColAlphabetToIndex("H"));
			cellvalues.add("(₩" + balancePaymentF + ")");
			
			// 해약신청일자
			sheetnums.add(0);
			rownums.add(24);
			cellnums.add(convertColAlphabetToIndex("G"));
			cellvalues.add(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
			
			String cancelReason = (String)bunyangInfo.get("cancel_reason");
			String cancelBank = (String)bunyangInfo.get("cancel_bank");
			String cancelAccount = (String)bunyangInfo.get("cancel_account");
			String cancelAccountHoler = (String)bunyangInfo.get("cancel_account_holder");
			String cancelDepositPlanDate = (String)bunyangInfo.get("cancel_deposit_plan_date");
			int penalty = downPayment/2;// 위약금
			int cancelReturn = downPayment + balancePayment - penalty;// 해약반환금
			String penaltyH = CommonUtil.convertPriceToHangul(penalty);
			String penaltyF = CommonUtil.getThousandSeperatorFormatString(penalty);
			String cancelReturnH = CommonUtil.convertPriceToHangul(cancelReturn);
			String cancelReturnF = CommonUtil.getThousandSeperatorFormatString(cancelReturn);
			
			// 해약사유
			sheetnums.add(0);
			rownums.add(20);
			cellnums.add(convertColAlphabetToIndex("D"));
			cellvalues.add(cancelReason);
			
			// 해약반환금
			sheetnums.add(0);
			rownums.add(21);
			cellnums.add(convertColAlphabetToIndex("E"));
			cellvalues.add("일금:" + cancelReturnH + "원");
			sheetnums.add(0);
			rownums.add(34);
			cellnums.add(convertColAlphabetToIndex("G"));
			cellvalues.add("일금:" + cancelReturnH + "원");
			sheetnums.add(0);
			rownums.add(21);
			cellnums.add(convertColAlphabetToIndex("H"));
			cellvalues.add("(₩" + cancelReturnF + ")");
			sheetnums.add(0);
			rownums.add(34);
			cellnums.add(convertColAlphabetToIndex("L"));
			cellvalues.add("(₩" + cancelReturnF + ")");
			
			// 입금은행
			sheetnums.add(0);
			rownums.add(22);
			cellnums.add(convertColAlphabetToIndex("E"));
			cellvalues.add(cancelBank);
			
			// 입금계좌번호
			sheetnums.add(0);
			rownums.add(22);
			cellnums.add(convertColAlphabetToIndex("J"));
			cellvalues.add(cancelAccount);
			
			// 예금주명
			sheetnums.add(0);
			rownums.add(22);
			cellnums.add(convertColAlphabetToIndex("O"));
			cellvalues.add(cancelAccountHoler);
			
			// 해약위약금
			sheetnums.add(0);
			rownums.add(33);
			cellnums.add(convertColAlphabetToIndex("G"));
			cellvalues.add("일금:" + penaltyH + "원");
			sheetnums.add(0);
			rownums.add(33);
			cellnums.add(convertColAlphabetToIndex("L"));
			cellvalues.add("(₩" + penaltyF + ")");
			
			// 입금예정일자
			sheetnums.add(0);
			rownums.add(35);
			cellnums.add(convertColAlphabetToIndex("G"));
			cellvalues.add(cancelDepositPlanDate);
		}
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		String realPath = request.getSession().getServletContext().getRealPath("/");
		File destFile = null;
		String destFileName = null;
		
		if(StringUtils.isEmpty(fileSeq)) {// 신규 생성일 경우 엑셀 서식을 복사
			// 엑셀 서식 정보 조회
			param = new HashMap<String, Object>();
			param.put("fileFormType", fileFormType);
			Map<String, Object> map = (HashMap<String, Object>)commonDao.selectOne("common.getBunyangFileForm", param);
			// 엑셀 서식 복사 
			String srcFilePath = (String)map.get("file_path");
			String srcFileName = (String)map.get("file_name");
			String srcRealFileName = (String)map.get("real_file_name");
			destFileName = FileUtil.appendToFileName(srcFileName, (String)applyUser.get("user_name"));// 파일명에 사용자 이름추가
			destFileName = FileUtil.appendCurrDtToFileName(destFileName);// 파일명에 현재날짜 추가
			File srcFile = new File(realPath + srcFilePath, srcRealFileName);
			destFile = new File(realPath + destFilePath, destFileName);
			try {
				FileUtils.copyFile(srcFile, destFile);
				fileSeq = String.valueOf(commonService.getSeqNexVal("FILE_SEQ"));
				String fileType = Files.probeContentType(destFile.toPath());
				String fileSize = Long.toString(destFile.length());
				fileService.createFileInfo(fileSeq, fileType, fileSize, destFilePath, srcFileName, destFileName);
			} catch (IOException e) {
				logger.error("createBunyangExcelForm error occured!!", e);
			}
		} else {
			Map<String, Object> fileInfo = fileService.getSysFileInfo(fileSeq);
			destFilePath = (String)fileInfo.get("file_path");
			destFileName = (String)fileInfo.get("real_file_name");
			destFile = new File(realPath + destFilePath, destFileName);
		}
		
		updateExcelCellValue(destFile, sheetnums, rownums, cellnums, cellvalues);
		
		rtn = fileSeq;
		
		return rtn;
	}
	
	/** 
	 * 엑셀의 컬럼 영문명을 0으로 시작하는 index 로 변환 
	 */
	private int convertColAlphabetToIndex(String alphabet) {
		int colIdx = 0;
		if(!StringUtils.isEmpty(alphabet)) {
			alphabet = alphabet.toLowerCase();
			colIdx = (int)alphabet.charAt(0);
			colIdx -= 97;
		}
		return colIdx;
	}
	
}
