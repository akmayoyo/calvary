package com.calvary.common.vo;

public class ResultSmsVo {

	private String result;
	private String count;
	public String getResult() {
		return result;
	}
	public void setResult(String result) {
		this.result = result;
	}
	public String getCount() {
		return count;
	}
	public void setCount(String count) {
		this.count = count;
	}
	@Override
	public String toString() {
		return "ResultSmsVo [result=" + result + ", count=" + count + "]";
	}
	
}
