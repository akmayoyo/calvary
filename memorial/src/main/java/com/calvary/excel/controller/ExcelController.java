package com.calvary.excel.controller;

import java.awt.Color;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

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
			@RequestParam(value="fileName") String fileName
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
        
        int rowIdx = 2;
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
        
        XSSFFont bFont = workbook.createFont();
        bFont.setBold(true);
        Color borderColor = new Color(153, 153, 153);
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
        headerStyle.setFont(bFont);
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
        rowStyle.setAlignment(HorizontalAlignment.CENTER);
        rowStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        
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
                		cell.setCellValue(String.valueOf(objTmp));
                	}else if(objTmp instanceof String) {
                		cell.setCellValue((String)objTmp);
                	}else if(objTmp instanceof Long) {
                		cell.setCellValue(String.valueOf(objTmp));
                	}else {
                		cell.setCellValue((String)objTmp);
                	}
                }
        	}
        }
        
        // 너비 조정
        for(colIdx = 0; colIdx < excelHeaders.length; colIdx++) {
        	sheet.setColumnWidth(colIdx, 4500);
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
	
	@RequestMapping(value="/importExcel", method=RequestMethod.POST)
	public ResponseEntity<String> importExcel(MultipartHttpServletRequest request) throws Exception{
		MultipartFile file = request.getFile("file");
		InputStream is = null;
		String importType = request.getParameter("importType");
		try {
			is = file.getInputStream();
			XSSFWorkbook wb = new XSSFWorkbook(is);
			XSSFSheet sheet = null;
			XSSFRow row = null;
			XSSFCell cell = null;
			Map<String, Object> param = null;
			int rowindex = 0;
			int rows = 0;
			
			// 사용자정보 엑셀을 tb_com_user 로 import
			if("user".equals(importType)) {
				sheet = wb.getSheetAt(0);
				rows = sheet.getPhysicalNumberOfRows();
				for(rowindex=0;rowindex<rows;rowindex++){
				    row=sheet.getRow(rowindex);
				    if(row !=null){
				    	param = new HashMap<String, Object>();
				    	param.put("userName", getCellValue(row.getCell(2)));
				    	getCellValue(row.getCell(3));
				    	getCellValue(row.getCell(4));
				    	getCellValue(row.getCell(5));
//				    	param.put("birthDate", row.getCell(3).getDateCellValue());
//				    	param.put("gender", row.getCell(4).getStringCellValue());
//				    	param.put("churchOfficer", row.getCell(5).getStringCellValue());
//				    	param.put("diocese", row.getCell(6).getStringCellValue());
//				    	param.put("mobile", row.getCell(11).getStringCellValue());
//				    	param.put("postNumber", row.getCell(12).getStringCellValue());
//				    	param.put("address1", row.getCell(13).getStringCellValue());
//				    	param.put("email", row.getCell(16).getStringCellValue());
				    	System.out.println(param.toString());	
				    }
				}
			}
		} catch (Exception e) {
			
		} finally {
			if(is != null) {
				is.close();
			}
		}
		HttpHeaders headers = new HttpHeaders();
		headers.add("Content-Type", "text/html;charset=UTF-8");
		return new ResponseEntity<String>("true", headers, HttpStatus.CREATED) ;
	}
	
	private Object getCellValue(XSSFCell cell) {
		Object rtn = null;
		System.out.println(cell.getCellType().toString());
		return rtn;
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
			List<String> cellvalues
			) {
		File file = new File(filePath);
		excelService.updateExcelCellValue(file, sheetnums, rownums, cellnums, cellvalues);
		return String.valueOf(true);
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// TEST
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	@RequestMapping(value="/createRequestForm")
	@ResponseBody
	public String createFileFormTestHandler(String bunyangSeq, String fileSeq) {
		String rtn = excelService.createBunyangExcelForm(ExcelForms.APPLY_FORM, bunyangSeq, fileSeq);
		return rtn;
	}
		
}
