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
		param.put("refType", CalvaryConstants.REF_TYPE_REQUESTER);
		
		// 분양정보
		BunyangInfoVo vo = (BunyangInfoVo) commonDao.selectOne("admin.getBunyangInfo", bunyangSeq);
		// 신청자정보
		BunyangUserVo requesterVo = (BunyangUserVo) commonDao.selectOne("admin.getBunyangRefUserInfo",  param);
		
		if(ExcelForms.REQUEST_FORM.equals(excelForm)) {// 분양신청서
			fileFormType = CalvaryConstants.FILE_FORM_TYPE_REQUEST;
			destFilePath += "/request";
			//============= 업데이트할 셀정보 설정 =============//
			// 신청자성명
			sheetnums.add(0);
			rownums.add(8);
			cellnums.add(1);
			cellvalues.add(requesterVo.getUserName());
			// 신청자 생년월일
			sheetnums.add(0);
			rownums.add(8);
			cellnums.add(4);
			cellvalues.add(requesterVo.getBirthDate());
			
		}else if(ExcelForms.REQUEST_USER_FORM.equals(excelForm)) {// 분양신청서-사용자
			param = new HashMap<String, Object>();
			param.put("bunyangSeq", bunyangSeq);
			param.put("refType", CalvaryConstants.REF_TYPE_USER);
			// 사용자정보
			List<Object> userList = commonDao.selectList("admin.getBunyangRefUserInfo",  param);
			
			fileFormType = CalvaryConstants.FILE_FORM_TYPE_REQUEST_USER;
			destFilePath += "/requestUser";
			
			if(userList != null) {
				for(i = 0; i < userList.size(); i++) {
					BunyangUserVo userVo = (BunyangUserVo)userList.get(i);
					// 사용자성명
					sheetnums.add(0);
					rownums.add(8);
					cellnums.add(1);
					cellvalues.add(userVo.getUserName());
					// 생년월일
					sheetnums.add(0);
					rownums.add(8);
					cellnums.add(4);
					cellvalues.add(userVo.getBirthDate());
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
			destFileName = FileUtil.appendToFileName(srcFileName, requesterVo.getUserName());// 파일명에 사용자 이름추가
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
