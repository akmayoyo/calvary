package com.calvary.common.exception;

public class ExcelImportException extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3228169028253121753L;

	
	private String sheetName;
	private int row;
	private String col;
	private Throwable error;
	
	public String getSheetName() {
		return sheetName;
	}
	public void setSheetName(String sheetName) {
		this.sheetName = sheetName;
	}
	public int getRow() {
		return row;
	}
	public void setRow(int row) {
		this.row = row;
	}
	public String getCol() {
		return col;
	}
	public void setCol(String col) {
		this.col = col;
	}
	public Throwable getError() {
		return error;
	}
	public void setError(Throwable error) {
		this.error = error;
	}
	
	public ExcelImportException(String sheetName, int row, String col, Throwable error) {
		super(error);
		setSheetName(sheetName);
		setRow(row);
		setCol(col);
		setError(error);
	}
}
