package com.calvary.excel.service;

import java.io.File;
import java.util.List;
import java.util.Map;

import com.calvary.admin.vo.BunyangInfoVo;
import com.calvary.excel.ExcelForms;

public interface IExcelService {

	/** 
	 * 엑셀파일의 특정셀 값을 업데이트
	 * @param excelFile 엑셀파일
	 * @param sheetnums sheet번호 
	 * @param rownums 행번호 
	 * @param cellnums 셀번호 
	 * @param cellvalues 셀값
	 * @return true/false 
	 */
	public boolean updateExcelCellValue(File excelFile, List<Integer> sheetnums, List<Integer> rownums, List<Integer> cellnums, List<Object> cellvalues);
	
	/** 
	 * Export 할 데이터 리스트 조회  
	 */
	public List<Object> getExportDataList(String queryId, Map<String, Object> queryParam);
	
	/** 
	 * 분양 파일 서식 정보 생성 또는 업데이트 
	 */
	public String createBunyangExcelForm(ExcelForms excelForm, String bunyangSeq, String fileSeq);
	
}
