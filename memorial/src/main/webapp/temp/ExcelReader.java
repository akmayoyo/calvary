package com.cs.site.common.util;

import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.util.CellReference;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ExcelReader {

	public List<?> readXls(InputStream file) throws Exception {

		// Workbook
		HSSFWorkbook wb = new HSSFWorkbook(file);

		String result = "";
		Map<String, String> map = null;
		List<Map<String, String>> resultList = new ArrayList<Map<String, String>>();

		FormulaEvaluator evaluator = wb.getCreationHelper().createFormulaEvaluator();

		// 엑셀 파일 전체 읽어오는부분
		//for (int i = 0; i < wb.getNumberOfSheets(); i++) {
		//하나의 Sheet
		for (Row row : wb.getSheetAt(0)) {

			//각쉬트 로우 한줄 읽어오는 부분
			map = new HashMap<String, String>();
			for (int i=0; i<row.getLastCellNum(); i++) {

				Cell cell = row.getCell(i);

				//셀서식이 문제가 있을때 초기화 시켜주기
				if(cell == null) {
					result = "";
				} else {
					// Cell Reference
					CellReference cellRef = new CellReference(row.getRowNum(), cell.getColumnIndex());

					//System.out.print(cellRef.formatAsString());
					//System.out.print(" - ");

					switch (cell.getCellType()) {
					case Cell.CELL_TYPE_STRING:
						//System.out.println("[Cell.CELL_TYPE_STRING] value: " + cell.getRichStringCellValue().getString());

						result = "" + cell.getRichStringCellValue().getString();

						break;
					case Cell.CELL_TYPE_NUMERIC:
						if (DateUtil.isCellDateFormatted(cell)) {
							//System.out.println("[Cell.CELL_TYPE_NUMERIC/Date] value: " + cell.getDateCellValue());

							result = "" + cell.getDateCellValue();
						} else {
							//System.out.println("[Cell.CELL_TYPE_NUMERIC] value: " + cell.getNumericCellValue());

							result = "" + cell.getNumericCellValue();
						}

						break;
					case Cell.CELL_TYPE_BOOLEAN:
						//System.out.println("[Cell.CELL_TYPE_BOOLEAN] value: " + cell.getBooleanCellValue());

						result = "" + cell.getBooleanCellValue();

						break;
					case Cell.CELL_TYPE_BLANK:
						//System.out.println("[Cell.CELL_TYPE_BLANK] value: " + "blank");

						result = "";

						break;
					case Cell.CELL_TYPE_ERROR:
						//System.out.println("[Cell.CELL_TYPE_ERROR] value: " + cell.getErrorCellValue());

						result = "" + cell.getErrorCellValue();

						break;
					case Cell.CELL_TYPE_FORMULA:
						int evalCellType = evaluator.evaluateFormulaCell(cell);

						switch (evalCellType) {
						case Cell.CELL_TYPE_STRING:
							//System.out.println("[Cell.CELL_TYPE_FORMULA/Cell.CELL_TYPE_STRING] value: " + cell.getRichStringCellValue().getString());

							result = "" + cell.getRichStringCellValue().getString();

							break;
						case Cell.CELL_TYPE_NUMERIC:
							if (DateUtil.isCellDateFormatted(cell)) {
								//System.out.println("[Cell.CELL_TYPE_FORMULA/Cell.CELL_TYPE_NUMERIC/Date] value: " + cell.getDateCellValue());

								result = "" + cell.getDateCellValue();
							} else {
								//System.out.println("[Cell.CELL_TYPE_FORMULA/Cell.CELL_TYPE_NUMERIC] value: " + cell.getNumericCellValue());

								result = "" + cell.getNumericCellValue();
							}

							break;
						case Cell.CELL_TYPE_BOOLEAN:
							//System.out.println("[Cell.CELL_TYPE_FORMULA/Cell.CELL_TYPE_BOOLEAN] value: " + cell.getBooleanCellValue());

							result = "" + cell.getBooleanCellValue();

							break;
						default:
							//System.out.println(">>>>>>[" + evalCellType + "] value: " + cell.toString());
						}

						break;
					default:
						//System.out.println();
					}
				} // if end
				result = result.trim();
				map.put("c"+i, result);
			} // for end
			//System.out.println(">>>>>>>>>>>>>>>> " + map.toString());

			resultList.add(map);
		}
		//}

		return resultList;
	}

	public List<?> readXlsX(InputStream file) throws Exception {

		String result = "";
		Map<String, String> map = null;
		List<Map<String, String>> resultList = new ArrayList<Map<String, String>>();

		// Workbook
		XSSFWorkbook wb = new XSSFWorkbook(file);

		FormulaEvaluator evaluator = wb.getCreationHelper().createFormulaEvaluator();

		// 엑셀 파일 전체 읽어오는부분
		//for (int i = 0; i < wb.getNumberOfSheets(); i++) {

		//하나의 Sheet
		XSSFSheet sheet = wb.getSheetAt(0);
		XSSFRow row = null;

		SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddHHmmss");

		//System.out.println("sheet.getLastRowNum() >>>>>" + sheet.getLastRowNum());

		for (int i=0; i<=sheet.getLastRowNum(); i++) {

			row = sheet.getRow(i);

			//각쉬트 로우 한줄 읽어오는 부분
			map = new HashMap<String, String>();

			//System.out.println(row.getLastCellNum()+"마지막 행의 줄 값");

			if(row != null) {
				for (int j=0; j<row.getLastCellNum(); j++) {

					XSSFCell cell = row.getCell(j);
					//셀서식이 문제가 있을때 초기화 시켜주기
					if(cell == null) {
						result = "";
					} else {
						// Cell Reference
						CellReference cellRef = new CellReference(row.getRowNum(), cell.getColumnIndex());

						//System.out.print(cellRef.formatAsString());
						//System.out.print(" - ");

						switch (cell.getCellType()) {
						case Cell.CELL_TYPE_STRING:
							//System.out.println("[Cell.CELL_TYPE_STRING] value: " + cell.getRichStringCellValue().getString());

							result = "" + cell.getRichStringCellValue().getString();

							break;
						case Cell.CELL_TYPE_NUMERIC:
							if (DateUtil.isCellDateFormatted(cell)) {
								//System.out.println("[Cell.CELL_TYPE_NUMERIC/Date] value: " + cell.getDateCellValue());
								if(cell.getDateCellValue() != null) {
									result = sf.format(cell.getDateCellValue());
								} else {
									result = "";
								}
							} else {
								//System.out.println("[Cell.CELL_TYPE_NUMERIC] value: " + cell.getNumericCellValue());

								result = "" + (int)cell.getNumericCellValue();
							}

							break;
						case Cell.CELL_TYPE_BOOLEAN:
							//System.out.println("[Cell.CELL_TYPE_BOOLEAN] value: " + cell.getBooleanCellValue());

							result = "" + cell.getBooleanCellValue();

							break;
						case Cell.CELL_TYPE_BLANK:
							//System.out.println("[Cell.CELL_TYPE_BLANK] value: " + "blank");

							result = "";

							break;
						case Cell.CELL_TYPE_ERROR:
							//System.out.println("[Cell.CELL_TYPE_ERROR] value: " + cell.getErrorCellValue());

							result = "" + cell.getErrorCellValue();

							break;
						case Cell.CELL_TYPE_FORMULA:
							int evalCellType = evaluator.evaluateFormulaCell(cell);

							switch (evalCellType) {
							case Cell.CELL_TYPE_STRING:
								//System.out.println("[Cell.CELL_TYPE_FORMULA/Cell.CELL_TYPE_STRING] value: " + cell.getRichStringCellValue().getString());

								result = "" + cell.getRichStringCellValue().getString();

								break;
							case Cell.CELL_TYPE_NUMERIC:
								if (DateUtil.isCellDateFormatted(cell)) {
									//System.out.println("[Cell.CELL_TYPE_FORMULA/Cell.CELL_TYPE_NUMERIC/Date] value: " + cell.getDateCellValue());

									result = "" + cell.getDateCellValue();
								} else {
									//System.out.println("[Cell.CELL_TYPE_FORMULA/Cell.CELL_TYPE_NUMERIC] value: " + cell.getNumericCellValue());

									result = "" + (int)cell.getNumericCellValue();
								}

								break;
							case Cell.CELL_TYPE_BOOLEAN:
								//System.out.println("[Cell.CELL_TYPE_FORMULA/Cell.CELL_TYPE_BOOLEAN] value: " + cell.getBooleanCellValue());

								result = "" + cell.getBooleanCellValue();

								break;
							default:
								//System.out.println(">>>>>>[" + evalCellType + "] value: " + cell.toString());
							}

							break;
						default:
							//System.out.println();
						}
					} // if end
					result = result.trim();
					map.put("c"+j, result);
				} // for end

			} // if end

			//System.out.println(">>>>>>>>>>>>>>>> " + map.toString());

			resultList.add(map);
		}

		return resultList;
	}

}
