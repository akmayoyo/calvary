package com.calvary.excel.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
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

import com.calvary.admin.vo.BunyangInfoVo;
import com.calvary.admin.vo.BunyangUserVo;
import com.calvary.common.constant.CalvaryConstants;
import com.calvary.common.dao.CommonDao;
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
		
		if(ExcelForms.APPLY_FORM.equals(excelForm)) {// 분양신청서
			fileFormType = CalvaryConstants.FILE_FORM_TYPE_APPLY;
			destFilePath += "/apply";
			//============= 업데이트할 셀정보 설정 =============//
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
			cellvalues.add((String)applyUser.get("address1") + (String)applyUser.get("address2"));
			
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
			
			// 부부형
			int coupleTypeCount = (int)bunyangInfo.get("couple_type_count");
			if(coupleTypeCount > 0) {
				sheetnums.add(0);
				rownums.add(20);
				cellnums.add(8);
				cellvalues.add(String.valueOf(coupleTypeCount));
			}
			
			// 1인형
			int singleTypeCount = (int)bunyangInfo.get("single_type_count");
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
			}
			
			// 신청일
			sheetnums.add(0);
			rownums.add(30);
			cellnums.add(6);
			cellvalues.add((String)bunyangInfo.get("regist_date"));
			
			// 신청자
			sheetnums.add(0);
			rownums.add(32);
			cellnums.add(3);
			cellvalues.add((String)applyUser.get("user_name"));
			
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
				cellvalues.add((String)agentUser.get("address1") + (String)agentUser.get("address2"));
				
				// 이메일
				sheetnums.add(0);
				rownums.add(15);
				cellnums.add(11);
				cellvalues.add((String)agentUser.get("email"));
				
				// 신청자(대리인)
				sheetnums.add(0);
				rownums.add(34);
				cellnums.add(3);
				cellvalues.add((String)agentUser.get("user_name"));
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
					cellvalues.add((String)userMap.get("address1") + (String)userMap.get("address2"));
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
				fileSeq = fileService.getFileSequence();
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
	
}
