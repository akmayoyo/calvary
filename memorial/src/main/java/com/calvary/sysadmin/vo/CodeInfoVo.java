package com.calvary.sysadmin.vo;

import java.util.List;

public class CodeInfoVo {

	private String parentCodeSeq;
	private List<CodeVo> codeList;
	public String getParentCodeSeq() {
		return parentCodeSeq;
	}
	public void setParentCodeSeq(String parentCodeSeq) {
		this.parentCodeSeq = parentCodeSeq;
	}
	public List<CodeVo> getCodeList() {
		return codeList;
	}
	public void setCodeList(List<CodeVo> codeList) {
		this.codeList = codeList;
	}
	@Override
	public String toString() {
		return "CodeInfoVo [parentCodeSeq=" + parentCodeSeq + ", codeList=" + codeList + "]";
	}
	
}
