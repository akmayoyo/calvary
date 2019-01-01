package com.calvary.excel.controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.catalina.servlet4preview.http.HttpServletRequest;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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
        
        // 헤더 생성
        row = sheet.createRow(rowIdx++);
        for(colIdx = 0; colIdx < excelHeaders.length; colIdx++) {
        	cell = row.createCell(colIdx);
        	cell.setCellValue(excelHeaders[colIdx]);
        }
        // 데이터 Row 생성
        if(list != null && list.size() > 0) {
        	for(Object obj : list) {
        		Map<String, Object> map = (HashMap<String, Object>)obj;
        		row = sheet.createRow(rowIdx++);
        		for(colIdx = 0; colIdx < excelFields.length; colIdx++) {
                	cell = row.createCell(colIdx);
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
