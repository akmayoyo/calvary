package com.calvary.excel.vo;

import java.util.List;

public class ExcelExportVo {
	private List<String> headers;
	private List<String> fields;
	private String fileName;
	private String queryId;
	private List<String> paramKeys;
	private List<String> paramValues;
	
	public List<String> getHeaders() {
		return headers;
	}
	public void setHeaders(List<String> headers) {
		this.headers = headers;
	}
	public List<String> getFields() {
		return fields;
	}
	public void setFields(List<String> fields) {
		this.fields = fields;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getQueryId() {
		return queryId;
	}
	public void setQueryId(String queryId) {
		this.queryId = queryId;
	}
	public List<String> getParamKeys() {
		return paramKeys;
	}
	public void setParamKeys(List<String> paramKeys) {
		this.paramKeys = paramKeys;
	}
	public List<String> getParamValues() {
		return paramValues;
	}
	public void setParamValues(List<String> paramValues) {
		this.paramValues = paramValues;
	}
	@Override
	public String toString() {
		return "ExcelVo [headers=" + headers + ", fields=" + fields + ", fileName=" + fileName + ", queryId=" + queryId
				+ ", paramKeys=" + paramKeys + ", paramValues=" + paramValues + "]";
	}
	
}
