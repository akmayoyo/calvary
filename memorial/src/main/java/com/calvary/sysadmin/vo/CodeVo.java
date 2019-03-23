package com.calvary.sysadmin.vo;

public class CodeVo {

	private String codeSeq;
	private String codeName;
	private String codeDesc;
	private int codeLevel;
	private String parentCodeSeq;
	private int displayOrder;
	private String codeValue;
	private String codeValue1;
	private String flag;// C:생성, U:업데이트
	public String getCodeSeq() {
		return codeSeq;
	}
	public void setCodeSeq(String codeSeq) {
		this.codeSeq = codeSeq;
	}
	public String getCodeName() {
		return codeName;
	}
	public void setCodeName(String codeName) {
		this.codeName = codeName;
	}
	public String getCodeDesc() {
		return codeDesc;
	}
	public void setCodeDesc(String codeDesc) {
		this.codeDesc = codeDesc;
	}
	public int getCodeLevel() {
		return codeLevel;
	}
	public void setCodeLevel(int codeLevel) {
		this.codeLevel = codeLevel;
	}
	public String getParentCodeSeq() {
		return parentCodeSeq;
	}
	public void setParentCodeSeq(String parentCodeSeq) {
		this.parentCodeSeq = parentCodeSeq;
	}
	public int getDisplayOrder() {
		return displayOrder;
	}
	public void setDisplayOrder(int displayOrder) {
		this.displayOrder = displayOrder;
	}
	public String getCodeValue() {
		return codeValue;
	}
	public void setCodeValue(String codeValue) {
		this.codeValue = codeValue;
	}
	public String getCodeValue1() {
		return codeValue1;
	}
	public void setCodeValue1(String codeValue1) {
		this.codeValue1 = codeValue1;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}
	@Override
	public String toString() {
		return "CodeVo [codeSeq=" + codeSeq + ", codeName=" + codeName + ", codeDesc=" + codeDesc + ", codeLevel="
				+ codeLevel + ", parentCodeSeq=" + parentCodeSeq + ", displayOrder=" + displayOrder + ", codeValue="
				+ codeValue + ", codeValue1=" + codeValue1 + ", flag=" + flag + "]";
	}
	
}
