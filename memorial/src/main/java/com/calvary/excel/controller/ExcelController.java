package com.calvary.excel.controller;

import java.awt.Color;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.calvary.admin.service.IAdminService;
import com.calvary.admin.vo.BunyangInfoVo;
import com.calvary.admin.vo.BunyangUserVo;
import com.calvary.common.constant.CalvaryConstants;
import com.calvary.common.service.ICommonService;
import com.calvary.common.util.CommonUtil;
import com.calvary.common.util.SessionUtil;
import com.calvary.excel.ExcelForms;
import com.calvary.excel.service.IExcelService;
import com.calvary.excel.vo.ExcelExportVo;

@Controller
@RequestMapping(value=ExcelController.ROOT_URL)
public class ExcelController {

	/** */
	public static final String ROOT_URL = "/excel";
	
	/** */
	public static final String ROOT_DIR = "/excel";
	
	/** */
	private static final Logger logger = LoggerFactory.getLogger("ERROR_LOGGER");
	
	@Autowired
	private IExcelService excelService;
	@Autowired
	private IAdminService adminService;
	@Autowired
	private ICommonService commonService;
	
	/** 
	 * Export 엑셀
	 */
	@SuppressWarnings("unchecked")
	@PostMapping(value="/exportExcel")
	public void exportExcelHandler(
			HttpServletRequest request,
			HttpServletResponse response,
			ExcelExportVo excelExportVo,
			@RequestParam(value="excelHeaders[]") String[] excelHeaders,
			@RequestParam(value="excelFields[]") String[] excelFields,
			@RequestParam(value="searchKeys[]") String[] searchKeys,
			@RequestParam(value="searchValues[]") String[] searchValues,
			@RequestParam(value="queryId") String queryId,
			@RequestParam(value="fileName") String fileName,
			@RequestParam(value="title") String title,
			@RequestParam(value="sheetName") String sheetName
			) {
		
		boolean bRslt = false;
		
		// 워크북 생성
        XSSFWorkbook workbook = new XSSFWorkbook();
        // 워크시트 생성
        XSSFSheet sheet = workbook.createSheet();
        // 행 생성
        XSSFRow row;
        // 셀 생성
        XSSFCell cell;
        
        int rowIdx = 1;
        int colIdx = 0;
        
        // 데이터 리스트
        Map<String, Object> queryParam = new HashMap<String, Object>();
        if(searchKeys != null && searchValues != null) {
        	for(int i = 0; i < searchKeys.length; i++) {
        		String key = searchKeys[i];
        		String value = null;
        		if(searchValues.length > i) {
        			value = searchValues[i];
        		}
        		queryParam.put(key, value);
        	}
        }
        List<Object> list = excelService.getExportDataList(queryId, queryParam);
        
        String fontName = "맑은 고딕";
        
        XSSFFont headerFont = workbook.createFont();
        XSSFFont titleFont = workbook.createFont();
        XSSFFont rowFont = workbook.createFont();
        headerFont.setBold(true);
        headerFont.setFontName(fontName);
        titleFont.setBold(true);
        titleFont.setFontName(fontName);
        titleFont.setFontHeight((short) 350);
        rowFont.setFontName(fontName);
        
        Color borderColor = new Color(153, 153, 153);
        
        XSSFCellStyle titleStyle = workbook.createCellStyle();
        titleStyle.setFillForegroundColor(new XSSFColor(new Color(197, 217, 241), workbook.getStylesSource().getIndexedColors()));
        titleStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        titleStyle.setBorderTop(BorderStyle.THIN);
        titleStyle.setBorderRight(BorderStyle.THIN);
        titleStyle.setBorderBottom(BorderStyle.THIN);
        titleStyle.setBorderLeft(BorderStyle.THIN);
        titleStyle.setTopBorderColor(new XSSFColor(borderColor, workbook.getStylesSource().getIndexedColors()));
        titleStyle.setRightBorderColor(new XSSFColor(borderColor, workbook.getStylesSource().getIndexedColors()));
        titleStyle.setBottomBorderColor(new XSSFColor(borderColor, workbook.getStylesSource().getIndexedColors()));
        titleStyle.setLeftBorderColor(new XSSFColor(borderColor, workbook.getStylesSource().getIndexedColors()));
        titleStyle.setFont(titleFont);
        titleStyle.setAlignment(HorizontalAlignment.CENTER);
        titleStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        
        XSSFCellStyle dateTitleStyle = workbook.createCellStyle();
        dateTitleStyle.setFont(headerFont);
        dateTitleStyle.setAlignment(HorizontalAlignment.CENTER);
        dateTitleStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        
        XSSFCellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFillForegroundColor(new XSSFColor(new Color(234, 234, 234), workbook.getStylesSource().getIndexedColors()));
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setBorderTop(BorderStyle.THIN);
        headerStyle.setBorderRight(BorderStyle.THIN);
        headerStyle.setBorderBottom(BorderStyle.THIN);
        headerStyle.setBorderLeft(BorderStyle.THIN);
        headerStyle.setTopBorderColor(new XSSFColor(new Color(89, 89, 89), workbook.getStylesSource().getIndexedColors()));
        headerStyle.setRightBorderColor(new XSSFColor(borderColor, workbook.getStylesSource().getIndexedColors()));
        headerStyle.setBottomBorderColor(new XSSFColor(borderColor, workbook.getStylesSource().getIndexedColors()));
        headerStyle.setLeftBorderColor(new XSSFColor(borderColor, workbook.getStylesSource().getIndexedColors()));
        headerStyle.setFont(headerFont);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);
        headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        
        XSSFCellStyle rowStyle = workbook.createCellStyle();
        rowStyle.setBorderTop(BorderStyle.THIN);
        rowStyle.setBorderRight(BorderStyle.THIN);
        rowStyle.setBorderBottom(BorderStyle.THIN);
        rowStyle.setBorderLeft(BorderStyle.THIN);
        rowStyle.setTopBorderColor(new XSSFColor(borderColor, workbook.getStylesSource().getIndexedColors()));
        rowStyle.setRightBorderColor(new XSSFColor(borderColor, workbook.getStylesSource().getIndexedColors()));
        rowStyle.setBottomBorderColor(new XSSFColor(borderColor, workbook.getStylesSource().getIndexedColors()));
        rowStyle.setLeftBorderColor(new XSSFColor(borderColor, workbook.getStylesSource().getIndexedColors()));
        rowStyle.setFont(rowFont);
        rowStyle.setAlignment(HorizontalAlignment.CENTER);
        rowStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        
        XSSFDataFormat format = workbook.createDataFormat();
        
        XSSFCellStyle numericStyle = workbook.createCellStyle();
        numericStyle.setBorderTop(BorderStyle.THIN);
        numericStyle.setBorderRight(BorderStyle.THIN);
        numericStyle.setBorderBottom(BorderStyle.THIN);
        numericStyle.setBorderLeft(BorderStyle.THIN);
        numericStyle.setTopBorderColor(new XSSFColor(borderColor, workbook.getStylesSource().getIndexedColors()));
        numericStyle.setRightBorderColor(new XSSFColor(borderColor, workbook.getStylesSource().getIndexedColors()));
        numericStyle.setBottomBorderColor(new XSSFColor(borderColor, workbook.getStylesSource().getIndexedColors()));
        numericStyle.setLeftBorderColor(new XSSFColor(borderColor, workbook.getStylesSource().getIndexedColors()));
        numericStyle.setFont(rowFont);
        numericStyle.setDataFormat(format.getFormat("#,##0"));
        numericStyle.setAlignment(HorizontalAlignment.RIGHT);
        numericStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        
        // 시트명
        workbook.setSheetName(workbook.getSheetIndex(sheet), sheetName);
        
        // 타이틀 생성
        colIdx = 0;
        row = sheet.createRow(rowIdx);
        row.setHeightInPoints((3 * sheet.getDefaultRowHeightInPoints()));
        for(colIdx = 0; colIdx < excelHeaders.length; colIdx++) {
        	cell = row.createCell(colIdx);
        	cell.setCellStyle(titleStyle);
        	if(colIdx == 0) {
        		cell.setCellValue(title);
        	}
        }
        CellRangeAddress titleMergeRegion = new CellRangeAddress(rowIdx, rowIdx, 0, colIdx-1);
        sheet.addMergedRegion(titleMergeRegion);
        
        rowIdx++;
        
        // 엑셀 출력일자 표시
        row = sheet.createRow(rowIdx++);
        cell = row.createCell(excelHeaders.length-1);
    	cell.setCellStyle(dateTitleStyle);
    	cell.setCellValue("일자 : " + new SimpleDateFormat("yy-MM-dd HH:mm:ss").format(new Date()));
        
        // 헤더 생성
        row = sheet.createRow(rowIdx++);
        row.setHeightInPoints((2 * sheet.getDefaultRowHeightInPoints()));
        for(colIdx = 0; colIdx < excelHeaders.length; colIdx++) {
        	cell = row.createCell(colIdx);
        	cell.setCellValue(excelHeaders[colIdx]);
        	cell.setCellStyle(headerStyle);
        }
        
        // 데이터 Row 생성
        if(list != null && list.size() > 0) {
        	for(Object obj : list) {
        		Map<String, Object> map = (HashMap<String, Object>)obj;
        		row = sheet.createRow(rowIdx++);
        		for(colIdx = 0; colIdx < excelFields.length; colIdx++) {
                	cell = row.createCell(colIdx);
                	cell.setCellStyle(rowStyle);
                	Object objTmp = map.get(excelFields[colIdx]);
                	if(objTmp instanceof Integer) {
                		cell.setCellStyle(numericStyle);
                		cell.setCellType(CellType.NUMERIC);
                		cell.setCellValue((double)(int)objTmp);
                	}else if(objTmp instanceof String) {
                		cell.setCellValue((String)objTmp);
                	}else if(objTmp instanceof Long) {
                		cell.setCellStyle(numericStyle);
                		cell.setCellType(CellType.NUMERIC);
                		cell.setCellValue((double)(long)objTmp);
                	}else if(objTmp instanceof BigDecimal) {
                		cell.setCellStyle(numericStyle);
                		cell.setCellType(CellType.NUMERIC);
                		cell.setCellValue(objTmp == null ? null : ((BigDecimal)objTmp).doubleValue());
                	}else {
                		cell.setCellValue((String)objTmp);
                	}
                }
        	}
        }
        
        // 너비 조정
        for(colIdx = 0; colIdx < excelHeaders.length; colIdx++) {
        	if(colIdx == excelHeaders.length -1) {
        		sheet.setColumnWidth(colIdx, 5500);
        	} else {
        		sheet.setColumnWidth(colIdx, 4500);
        	}
        }
        
        try {
        	fileName = URLEncoder.encode(fileName,"UTF-8").replaceAll("\\+", "%20");
            response.setContentType("ms-vnd/excel");
            response.setHeader("Content-Disposition", "attachment;filename=" + fileName);
            workbook.write(response.getOutputStream());
            bRslt = true;
        } catch (Exception e) {
        	logger.error("exceldownload error occured!!", e);
        } finally {
        	response.setHeader("Set-Cookie", "fileDownload=" + String.valueOf(bRslt) + "; path=/");
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            try {
                if(workbook!=null) workbook.close();
            } catch (IOException e) {
            	logger.error("exceldownload IOException occured!!", e);
            }
        }
    }
	
	/** 
	 * 분양신청 Excel 파일을 읽어 분양신청 정보를 생성
	 */
	@RequestMapping(value="/importBunyangExcel", method=RequestMethod.POST)
	@ResponseBody
	public String importBunyangExcel(MultipartHttpServletRequest request) throws Exception{
		MultipartFile file = request.getFile("file");
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		InputStream is = null;
		boolean bRslt = false;
		BunyangInfoVo bunyangInfoVo = null;
		List<Object> relationCodeList = commonService.getRelationCodeList();// 관계(본인,배우자...) 코드리스트
		List<Object> churchOfficerCodeList = commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_CHURCH_OFFICER);// 직분 코드리스트
		XSSFWorkbook wb = null;
		XSSFSheet sheet = null;
		String bunyangSeq = null;
		String resultCode = null;
		boolean isSuccessExcel = false;// 엑셀업로드 정상여부
		boolean isSuccessSave = false;// 분양신청 정보 DB저장 정상여부
		boolean isDuplicated = false;// 분양신청 정보 중복여부
		try {
			is = file.getInputStream();
			wb = new XSSFWorkbook(is);
			Map<String, Object> param = null;
			Map<String, Object> tmp = null;
			String dateFmt = "yyyy-MM-dd";
			int sheetIdx = 0;
			int rows = 0;
			int idx = 0;
			int startRow = 0;
			int rowIdx = 0;
			String userName = null;
			String maintChargerName = null;
			String phone = null;
			String requestDate = null;
			
			bunyangInfoVo = new BunyangInfoVo();
			
			
			//============================== Sheet1. 분양신청서 ==============================//
			sheet = wb.getSheetAt(sheetIdx++);
			
			
			phone = sheet.getRow(10).getCell(convertColAlphabetToIndex("J")).getStringCellValue();
			if(!StringUtils.isEmpty(phone)) {
				phone += "-" + sheet.getRow(10).getCell(convertColAlphabetToIndex("K")).getStringCellValue();
			}
			
			//////////////////////////// 신청자 ////////////////////////////
			BunyangUserVo applyUserVo = new BunyangUserVo();
			applyUserVo.setUserName(sheet.getRow(8).getCell(convertColAlphabetToIndex("B")).getStringCellValue());// 신청자성명
			applyUserVo.setBirthDate(getExcelDateValue(sheet.getRow(8).getCell(convertColAlphabetToIndex("E")).getDateCellValue(), dateFmt));// 생년월일
			applyUserVo.setGender(String.valueOf((int)sheet.getRow(8).getCell(convertColAlphabetToIndex("G")).getNumericCellValue()));// 성별
			applyUserVo.setChurchOfficer(codeNameToCodeSeq(sheet.getRow(8).getCell(convertColAlphabetToIndex("H")).getStringCellValue(), churchOfficerCodeList));// 직분
			applyUserVo.setDiocese(String.valueOf((int)sheet.getRow(8).getCell(convertColAlphabetToIndex("K")).getNumericCellValue()));// 교구
			applyUserVo.setMobile(getMobile(sheet.getRow(8).getCell(convertColAlphabetToIndex("L"))));// 휴대전화
			applyUserVo.setPostNumber(getStringByCellType(sheet.getRow(10).getCell(convertColAlphabetToIndex("B"))));// 우편번호
			applyUserVo.setAddress1(sheet.getRow(10).getCell(convertColAlphabetToIndex("C")).getStringCellValue());// 주소
			applyUserVo.setPhone(phone);// 전화
			applyUserVo.setEmail(sheet.getRow(10).getCell(convertColAlphabetToIndex("L")).getStringCellValue());// 이메일
			applyUserVo.setIsChurchPerson("Y");// 교인여부
			applyUserVo.setRefType(CalvaryConstants.BUNYANG_REF_TYPE_APPLY_USER);
			bunyangInfoVo.setApplyUser(applyUserVo);
			
			//////////////////////////// 분양신청정보 ////////////////////////////
			if("O".equals(sheet.getRow(19).getCell(convertColAlphabetToIndex("I")).getStringCellValue())) {// 개별형
				bunyangInfoVo.setProductType(CalvaryConstants.PRODUCT_TYPE_EACH);
			}else if("O".equals(sheet.getRow(19).getCell(convertColAlphabetToIndex("L")).getStringCellValue())) {// 가족형
				bunyangInfoVo.setProductType(CalvaryConstants.PRODUCT_TYPE_FAMILY);
			}
			bunyangInfoVo.setCoupleTypeCount((int)sheet.getRow(20).getCell(convertColAlphabetToIndex("I")).getNumericCellValue());// 부부형기수
			bunyangInfoVo.setSingleTypeCount((int)sheet.getRow(20).getCell(convertColAlphabetToIndex("L")).getNumericCellValue());// 1인형기수
			if("O".equals(sheet.getRow(25).getCell(convertColAlphabetToIndex("D")).getStringCellValue())) {// 관리비납부 신청자
				bunyangInfoVo.setServiceChargeType(CalvaryConstants.SERVICE_CHARGE_TYPE_APPLY_USER);
			}else if("O".equals(sheet.getRow(25).getCell(convertColAlphabetToIndex("G")).getStringCellValue())) {// 관리비납부 각사용자
				bunyangInfoVo.setServiceChargeType(CalvaryConstants.SERVICE_CHARGE_TYPE_USE_USER);
			}else if("O".equals(sheet.getRow(25).getCell(convertColAlphabetToIndex("L")).getStringCellValue())) {// 관리비납부 사용자중 1인대표
				bunyangInfoVo.setServiceChargeType(CalvaryConstants.SERVICE_CHARGE_TYPE_REPRESENT);
				maintChargerName = sheet.getRow(26).getCell(convertColAlphabetToIndex("N")).getStringCellValue();
			}
			bunyangInfoVo.setProgressStatus(CalvaryConstants.PROGRESS_STATUS_NEW);// 신청상태
			// TODO
			bunyangInfoVo.setBunyangTimes(1);// 분양차수
			bunyangInfoVo.setPricePerCount(2000000);// 1기당가격
			
			requestDate = getExcelDateValue(sheet.getRow(30).getCell(convertColAlphabetToIndex("G")).getDateCellValue(), dateFmt);// 신청일
			
			//////////////////////////// 대리인 ////////////////////////////
			userName = sheet.getRow(13).getCell(convertColAlphabetToIndex("B")).getStringCellValue();
			if(!StringUtils.isEmpty(userName)) {
				phone = sheet.getRow(15).getCell(convertColAlphabetToIndex("J")).getStringCellValue();
				if(!StringUtils.isEmpty(phone)) {
					phone += "-" + sheet.getRow(15).getCell(convertColAlphabetToIndex("K")).getStringCellValue();
				}
				BunyangUserVo agentUserVo = new BunyangUserVo();
				agentUserVo.setUserName(userName);// 대리인명
				agentUserVo.setBirthDate(getExcelDateValue(sheet.getRow(13).getCell(convertColAlphabetToIndex("E")).getDateCellValue(), dateFmt));// 생년월일
				agentUserVo.setGender(String.valueOf((int)sheet.getRow(13).getCell(convertColAlphabetToIndex("G")).getNumericCellValue()));// 성별
				agentUserVo.setRelationType(codeNameToCodeSeq(sheet.getRow(13).getCell(convertColAlphabetToIndex("H")).getStringCellValue(), relationCodeList));// 신청자와의 관계
				agentUserVo.setMobile(getMobile(sheet.getRow(13).getCell(convertColAlphabetToIndex("L"))));// 휴대전화
				agentUserVo.setPostNumber(getStringByCellType(sheet.getRow(15).getCell(convertColAlphabetToIndex("B"))));// 우편번호
				agentUserVo.setAddress1(sheet.getRow(15).getCell(convertColAlphabetToIndex("C")).getStringCellValue());// 주소
				agentUserVo.setPhone(phone);// 전화
				agentUserVo.setEmail(sheet.getRow(15).getCell(convertColAlphabetToIndex("L")).getStringCellValue());// 이메일
				agentUserVo.setRefType(CalvaryConstants.BUNYANG_REF_TYPE_AGENT_USER);
				
				bunyangInfoVo.setAgentUser(agentUserVo);
			}
			
			
			//============================== Sheet2. 분양신청서-사용자 ==============================// 
			sheet = wb.getSheetAt(sheetIdx++);
			List<BunyangUserVo> useUsers = new ArrayList<BunyangUserVo>();
			
			rows = sheet.getPhysicalNumberOfRows();
			startRow = 10;
			int coupleSeq = 0;
			boolean isIncremented = false;
			
			//////////////////////////// 사용자 ////////////////////////////
			for(idx=0; idx < rows; idx++){
				rowIdx = startRow + idx;
				userName = sheet.getRow(rowIdx).getCell(convertColAlphabetToIndex("C")).getStringCellValue();
				if(StringUtils.isEmpty(userName)) {
					break;
				}
				BunyangUserVo useUser = new BunyangUserVo();
				useUser.setUserName(userName);
				if(!StringUtils.isEmpty(maintChargerName) && maintChargerName.equals(userName)) {
					useUser.setIsMaintCharger("Y");
				}
				useUser.setRelationType(codeNameToCodeSeq(sheet.getRow(rowIdx).getCell(convertColAlphabetToIndex("D")).getStringCellValue(), relationCodeList));
				useUser.setBirthDate(getExcelDateValue(sheet.getRow(rowIdx).getCell(convertColAlphabetToIndex("E")).getDateCellValue(), dateFmt));
				useUser.setGender(String.valueOf((int)sheet.getRow(rowIdx).getCell(convertColAlphabetToIndex("F")).getNumericCellValue()));
				useUser.setPostNumber(getStringByCellType(sheet.getRow(rowIdx).getCell(convertColAlphabetToIndex("G"))));
				useUser.setAddress1(sheet.getRow(rowIdx).getCell(convertColAlphabetToIndex("H")).getStringCellValue());
				// 부부형
				if("O".equals(sheet.getRow(rowIdx).getCell(convertColAlphabetToIndex("I")).getStringCellValue())) {
					// 부부둘중 첫번째 행에서 시퀀스 증가시켜줘서 부부형 두명이 하나의 seq로 묶일수있도록함
					if(!isIncremented) {
						coupleSeq++;
						isIncremented = true;
					} else {
						isIncremented = false;
					}
					useUser.setCoupleSeq(coupleSeq);
				}
				useUser.setIsChurchPerson(excelValToYN(sheet.getRow(rowIdx).getCell(convertColAlphabetToIndex("M")).getStringCellValue()));
				useUser.setMobile(sheet.getRow(rowIdx).getCell(convertColAlphabetToIndex("N")).getStringCellValue());
				phone = sheet.getRow(rowIdx).getCell(convertColAlphabetToIndex("O")).getStringCellValue();
				if(!StringUtils.isEmpty(phone)) {
					phone += "-" + sheet.getRow(rowIdx).getCell(convertColAlphabetToIndex("P")).getStringCellValue();
					useUser.setPhone(phone);
				}
				useUser.setEmail(sheet.getRow(rowIdx).getCell(convertColAlphabetToIndex("Q")).getStringCellValue());
				useUser.setIsMove(excelValToYN(sheet.getRow(rowIdx).getCell(convertColAlphabetToIndex("R")).getStringCellValue()));
				useUser.setRefType(CalvaryConstants.BUNYANG_REF_TYPE_USE_USER);
				useUsers.add(useUser);
			}
			bunyangInfoVo.setUseUsers(useUsers);
			
			
			
			//============================== Sheet3. 신청승인서 ==============================// 
			sheet = wb.getSheetAt(sheetIdx++);
			String bunyangNo = String.valueOf((int)sheet.getRow(5).getCell(convertColAlphabetToIndex("N")).getNumericCellValue());// 승인번호
			String approvalDate = getExcelDateValue(sheet.getRow(30).getCell(convertColAlphabetToIndex("G")).getDateCellValue(), dateFmt);// 승인일자
			
			
			
			//============================== Sheet4. 분양계약서 ==============================//
			sheet = wb.getSheetAt(sheetIdx++);
			int bunyangPrice = (int)sheet.getRow(17).getCell(convertColAlphabetToIndex("H")).getNumericCellValue();// 총분양대금
			int contractPrice = (int)sheet.getRow(18).getCell(convertColAlphabetToIndex("H")).getNumericCellValue();// 계약금
			
			
			int downPaymentAmount = 0;// 계약금 납부금액
			String downPaymentDate = null;// 계약금 납부일자
			String downPaymentConfirmDate = null;// 계약금 확인일자
			String contractDate = null;// 계약일자
			String downPaymentMethod = null;// 계약금 납부방법
			
			boolean isContracted = false;// 계약여부
			boolean isFullPayment = false;// 완납여부
			
			int paymentAmount = 0;// 납부금액
			String paymentDate = null;// 납부일자
			String paymentMethod = "";// 납부방법
			
			int sumBalancePayment = 0;// 납부된 잔금합계
			List<Integer> balancePaymentAmounts = new ArrayList<Integer>();// 잔금 납부금액
			List<String> balancePaymentDates = new ArrayList<String>();// 잔금 납부일자
			List<String> balancePaymentMethods = new ArrayList<String>();// 잔금 납부방법
			
			// 계약금
			downPaymentAmount = (int)sheet.getRow(67).getCell(convertColAlphabetToIndex("L")).getNumericCellValue();// 납부금액
			downPaymentDate = getExcelDateValue(sheet.getRow(67).getCell(convertColAlphabetToIndex("I")).getDateCellValue(), dateFmt);// 납부일자
			downPaymentConfirmDate = getExcelDateValue(sheet.getRow(26).getCell(convertColAlphabetToIndex("D")).getDateCellValue(), dateFmt);// 확인일자
			contractDate = getExcelDateValue(sheet.getRow(46).getCell(convertColAlphabetToIndex("H")).getDateCellValue(), dateFmt);// 계약일자
			if("O".equals(sheet.getRow(24).getCell(convertColAlphabetToIndex("H")).getStringCellValue())) {// 무통장입금/계좌이체
				downPaymentMethod = CalvaryConstants.PAYMENT_METHOD_TRANSFER;
			}else if("O".equals(sheet.getRow(24).getCell(convertColAlphabetToIndex("N")).getStringCellValue())) {// 현금납부
				downPaymentMethod = CalvaryConstants.PAYMENT_METHOD_CASH;
			}
			
			if(downPaymentAmount >= contractPrice) {// 계약여부
				isContracted = true;
			}
			
			// 잔금
			startRow = 68;
			if("O".equals(sheet.getRow(62).getCell(convertColAlphabetToIndex("H")).getStringCellValue())) {// 무통장입금/계좌이체
				paymentMethod = CalvaryConstants.PAYMENT_METHOD_TRANSFER;
			}else if("O".equals(sheet.getRow(62).getCell(convertColAlphabetToIndex("N")).getStringCellValue())) {// 현금납부
				paymentMethod = CalvaryConstants.PAYMENT_METHOD_CASH;
			}
			for(idx=0; idx < rows; idx++){
				rowIdx = startRow + idx;
				if(sheet.getRow(rowIdx).getCell(convertColAlphabetToIndex("I")).getDateCellValue() == null) {
					break;
				}
				paymentDate = getExcelDateValue(sheet.getRow(rowIdx).getCell(convertColAlphabetToIndex("I")).getDateCellValue(), dateFmt);//실납입일
				paymentAmount = (int)sheet.getRow(rowIdx).getCell(convertColAlphabetToIndex("L")).getNumericCellValue();// 납입금
				sumBalancePayment += paymentAmount;
				balancePaymentDates.add(paymentDate);
				balancePaymentAmounts.add(paymentAmount);
				balancePaymentMethods.add(paymentMethod);
			}
			
			if(downPaymentAmount + sumBalancePayment >= bunyangPrice) {// 완납여부
				isFullPayment = true;
			}
			
			
			//============================== Sheet5. 완납확인증명서 ==============================//
			String fullPaymentDate = null;
			sheet = wb.getSheetAt(sheetIdx++);
			if(isFullPayment) {
				fullPaymentDate = getExcelDateValue(sheet.getRow(29).getCell(convertColAlphabetToIndex("G")).getDateCellValue(), dateFmt);// 완납 확인일자
			}
			
			
			isSuccessExcel = true;
			
			
			//============================== Excel 정보 DB 저장 ==============================//
			if(!StringUtils.isEmpty(bunyangNo)) {
				// 동일 승인번호가 이미 등록중인지 체크
				tmp = adminService.getBunyangInfoByNo(bunyangNo);
				if(tmp != null) {
					isDuplicated = true;
					throw new Exception("duplicated bunyang no!!");
				}
			}
			
			// 1.분양 신청 정보 생성
			bunyangSeq = adminService.createBunyangInfo(bunyangInfoVo, requestDate);
			int iRslt = 0;
			if(!StringUtils.isEmpty(bunyangSeq)) {
				bunyangInfoVo.setBunyangSeq(bunyangSeq);
				String applyFileSeq = excelService.createBunyangExcelForm(ExcelForms.APPLY_FORM, bunyangSeq, "", "");
				String useUserFileSeq = excelService.createBunyangExcelForm(ExcelForms.USE_USER_FORM, bunyangSeq, "", "");
				if(!StringUtils.isEmpty(applyFileSeq) && !StringUtils.isEmpty(useUserFileSeq)) {
					param = new HashMap<String, Object>();
					param.put("bunyangSeq", bunyangSeq);
					param.put("file_seq_apply", applyFileSeq);
					param.put("file_seq_use_user", useUserFileSeq);
					iRslt = adminService.updateBunyangFileSeq(param);
				}
			}
			
			// 2.신청승인 정보 생성
			if(!StringUtils.isEmpty(bunyangNo)) {
				bunyangInfoVo.setBunyangNo(bunyangNo);
				bunyangInfoVo.setProgressStatus(CalvaryConstants.PROGRESS_STATUS_A);
				iRslt = adminService.updateBunyangProgressStatus(bunyangInfoVo, SessionUtil.getCurrentUserId(), approvalDate);
				String approvalFileSeq = null;
				if(iRslt > 0) {
					approvalFileSeq = excelService.createBunyangExcelForm(ExcelForms.APPROVAL_FORM, bunyangInfoVo.getBunyangSeq(), "", "");
					if(!StringUtils.isEmpty(approvalFileSeq)) {
						param = new HashMap<String, Object>();
						param.put("bunyangSeq", bunyangInfoVo.getBunyangSeq());
						param.put("file_seq_approval", approvalFileSeq);
						iRslt = adminService.updateBunyangFileSeq(param);
					}
				}
			}
			
			// 3.계약금 납부처리
			if(downPaymentAmount > 0) {
				if(isContracted) {
					bunyangInfoVo.setProgressStatus(CalvaryConstants.PROGRESS_STATUS_B);
				}
				iRslt = adminService.updateDownPayment(bunyangSeq, downPaymentAmount, downPaymentMethod, downPaymentDate, downPaymentConfirmDate, contractDate, isContracted);
				if(iRslt > 0) {
					String fileSeq = excelService.createBunyangExcelForm(ExcelForms.CONTRACT_FORM, bunyangSeq, "", "");
					if(!StringUtils.isEmpty(fileSeq)) {
						param = new HashMap<String, Object>();
						param.put("bunyangSeq", bunyangSeq);
						param.put("file_seq_contract", fileSeq);
						iRslt = adminService.updateBunyangFileSeq(param);
					}
				}
			}
			
			// 4.잔금 납부처리
			if(sumBalancePayment > 0) {
				iRslt = adminService.updateBalancePayment(
						bunyangSeq, 
						balancePaymentAmounts.stream().mapToInt(i->i).toArray(), 
						balancePaymentMethods.stream().toArray(String[]::new),
						balancePaymentDates.stream().toArray(String[]::new),
						fullPaymentDate,
						isFullPayment
						);
				if(iRslt > 0) {
					String fileSeq = excelService.createBunyangExcelForm(ExcelForms.CONTRACT_FORM, bunyangSeq, "", "");
					if(!StringUtils.isEmpty(fileSeq)) {
						param = new HashMap<String, Object>();
						param.put("bunyangSeq", bunyangSeq);
						param.put("file_seq_contract", fileSeq);
						iRslt = adminService.updateBunyangFileSeq(param);
					}
					if(isFullPayment) {
						fileSeq = excelService.createBunyangExcelForm(ExcelForms.FULL_PAYMENT_FORM, bunyangSeq, "", "");
						if(!StringUtils.isEmpty(fileSeq)) {
							param = new HashMap<String, Object>();
							param.put("bunyangSeq", bunyangSeq);
							param.put("file_seq_full_payment", fileSeq);
							iRslt = adminService.updateBunyangFileSeq(param);
						}
					}
				}
			}
			
			isSuccessSave = true;
			
			bRslt = true;
			
		} catch (Exception e) {
			// 에러 발생시 저장된 정보 모두 삭제
			if(bunyangInfoVo != null && !StringUtils.isEmpty(bunyangInfoVo.getBunyangSeq())) {
				adminService.deleteBunyangInfo(bunyangInfoVo, SessionUtil.getCurrentUserId());
			}
			logger.error("bunyang excel upload failed!!", e);
		} finally {
			if(is != null) {
				is.close();
			}
			if(wb != null) {
				wb.close();
			}
			
			if(!bRslt) {// 실패
				if(!isSuccessExcel) {// 엑셀업로드 실패
					resultCode = "-100";
				} else if(!isSuccessSave) {
					if(isDuplicated) {// 분양 승인번호 중복
						resultCode = "-200";
					} else {// 기타 에러
						resultCode = "-300";
					}
				}
			} else {// 성공
				resultCode = bunyangSeq;
			}
		}
		return resultCode;
	}
	
	
	/** 
	 * 입출금 Excel 파일을 읽어 리스트 반환
	 */
	@RequestMapping(value="/importPaymentExcel", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> importPaymentExcel(MultipartHttpServletRequest request) throws Exception{
		MultipartFile file = request.getFile("file");
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		boolean isError = false;
		List<Object> rtnList = new ArrayList<Object>();
		InputStream is = null;
		XSSFWorkbook wb = null;
		XSSFSheet sheet = null;
		try {
			is = file.getInputStream();
			wb = new XSSFWorkbook(is);
			SimpleDateFormat ymd = null;
			int rows = 0;
			int startRow = 1;
			int rowIdx = 0;
			
			String bank = request.getParameter("bank");
			Date fromDt = null;
			Date toDt = null;
			
			// 신한은행 엑셀
			if("SHINHAN".equals(bank)) {
				ymd = new SimpleDateFormat("yyyyMMddHHmmss");
				fromDt = ymd.parse(request.getParameter("fromDt") + "000000");
				toDt = ymd.parse(request.getParameter("toDt") + "235959");
				
				sheet = wb.getSheetAt(0);
				rows = sheet.getPhysicalNumberOfRows();
				for(rowIdx = startRow; rowIdx < rows; rowIdx++) {
					XSSFRow row = sheet.getRow(rowIdx);
					String paymentDateOrg = row.getCell(convertColAlphabetToIndex("A")).getStringCellValue();
					String paymentDate = paymentDateOrg;
					if(!StringUtils.isEmpty(paymentDate)) {
						paymentDate = paymentDate.replaceAll("\\D", "");
					}
					if(StringUtils.isEmpty(paymentDate)) {
						continue;
					}
					Date tmpDate = ymd.parse(paymentDate);
					if(tmpDate.compareTo(fromDt) < 0 || toDt.compareTo(tmpDate) < 0) {
						continue;
					}
					int paymentAmount = 0;
					String paymentDivision = "";
					int depositAmount = (int)row.getCell(convertColAlphabetToIndex("C")).getNumericCellValue();
					int withdrawalAmount = (int)row.getCell(convertColAlphabetToIndex("D")).getNumericCellValue();
					if(depositAmount > 0) {
						paymentAmount = depositAmount;
						paymentDivision = CalvaryConstants.PAYMENT_DIVISION_DEPOSIT;
					}else if(withdrawalAmount > 0) {
						paymentAmount = withdrawalAmount;
						paymentDivision = CalvaryConstants.PAYMENT_DIVISION_WITHDRAWAL;
					}
					String content = row.getCell(convertColAlphabetToIndex("E")).getStringCellValue();
					// 내용으로부터  신청자,계약번호를 추출
					String applyUserName = content;
					String bunyangNo = "";
					content = CommonUtil.nullToEmpty(content);
					content = content.replaceAll("\\p{Z}","");// 공백제거
					Pattern pattern = Pattern.compile("[ABCD]?[0-9]{4}[ABCD]?");
					Matcher matcher = pattern.matcher(content);
					if(matcher.find()) {
						bunyangNo = matcher.group();
						if(!StringUtils.isEmpty(bunyangNo)) {
							applyUserName = applyUserName.replace(bunyangNo, "");
							bunyangNo = bunyangNo.replaceAll("\\D", "");
						}
					}
					List<Object> bunyangInfoList = adminService.getExcelBunyangSelectList(applyUserName, bunyangNo);
					Map<String, Object> tmp = new HashMap<String, Object>();
					tmp.put("paymentDate", paymentDateOrg);
					tmp.put("paymentAmount", paymentAmount);
					tmp.put("paymentDivision", paymentDivision);
					tmp.put("content", content);
					tmp.put("bunyangNo", bunyangNo);
					tmp.put("bunyangInfoList", bunyangInfoList);
					rtnList.add(tmp);
				}
			}
		} catch (Exception e) {
			isError = true;
			logger.error("payment excel upload failed!!", e);
		} finally {
			if(is != null) {
				is.close();
			}
			if(wb != null) {
				wb.close();
			}
		}
		rtnMap.put("isError", isError);
		rtnMap.put("rtnList", rtnList);
		return rtnMap;
	}
	
	
	/** 
	 * 엑셀업데이트
	 */
	@RequestMapping(value="/updateExcel")
	@ResponseBody
	public String updateExcelHandler(
			HttpServletRequest request,
			HttpServletResponse response,
			String filePath,
			List<Integer> sheetnums, 
			List<Integer> rownums, 
			List<Integer> cellnums, 
			List<Object> cellvalues
			) {
		File file = new File(filePath);
		excelService.updateExcelCellValue(file, sheetnums, rownums, cellnums, cellvalues);
		return String.valueOf(true);
	}
	
	/** 
	 * 
	 */
	private String getExcelDateValue(Date val, String fmt) {
		String sRtn = "";
		if(val != null) {
			sRtn = new SimpleDateFormat(fmt).format(val);
		}
		return sRtn;
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
	
	/**
	 * 코드명 -> 코드값 변환
	 */
	@SuppressWarnings("unchecked")
	private String codeNameToCodeSeq(String codeName, List<Object> codeList) {
		String sRtn = codeName;
		if(codeList != null) {
			for(int i = 0; i < codeList.size(); i++) {
				Map<String, Object> tmp = (HashMap<String, Object>)codeList.get(i);
				String codeSeq = (String)tmp.get("code_seq");
				String codeNm = (String)tmp.get("code_name");
				if(codeNm != null && codeNm.equals(codeName)) {
					sRtn = codeSeq;
					break;
				}
			}
		}
		return sRtn;
	}
	
	/**
	 * 
	 */
	private String excelValToYN(String value) {
		String sRtn = "";
		if("O".equals(value)) {
			sRtn = "Y";
		} else {
			sRtn = "N";
		}
		return sRtn;
	}
	
	private String getMobile(XSSFCell cell) {
		String sRtn = "";
		if(cell.getCellType() == CellType.NUMERIC) {
			sRtn = CommonUtil.getMobileFormatString("0" + String.valueOf((int)cell.getNumericCellValue()));
		} else if(cell.getCellType() == CellType.STRING) {
			sRtn = cell.getStringCellValue();
		}
		return sRtn;
	}
	
	private String getStringByCellType(XSSFCell cell) {
		String sRtn = "";
		if(cell.getCellType() == CellType.NUMERIC) {
			sRtn = String.valueOf((int)cell.getNumericCellValue());
		} else if(cell.getCellType() == CellType.STRING) {
			sRtn = cell.getStringCellValue();
		}
		return sRtn;
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// TEST
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	@RequestMapping(value="/createRequestForm")
	@ResponseBody
	public String createFileFormTestHandler(String bunyangSeq, String fileSeq) {
		String rtn = excelService.createBunyangExcelForm(ExcelForms.APPLY_FORM, bunyangSeq, fileSeq, "");
		return rtn;
	}
		
}
