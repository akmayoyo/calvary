package com.calvary.popup.vo;

public class GraveInfoVo {

	private String sectionSeq;
	private String rowSeq;
	private String colSeq;
	private String seqNo;
	public String getSectionSeq() {
		return sectionSeq;
	}
	public void setSectionSeq(String sectionSeq) {
		this.sectionSeq = sectionSeq;
	}
	public String getRowSeq() {
		return rowSeq;
	}
	public void setRowSeq(String rowSeq) {
		this.rowSeq = rowSeq;
	}
	public String getColSeq() {
		return colSeq;
	}
	public void setColSeq(String colSeq) {
		this.colSeq = colSeq;
	}
	public String getSeqNo() {
		return seqNo;
	}
	public void setSeqNo(String seqNo) {
		this.seqNo = seqNo;
	}
	@Override
	public String toString() {
		return "GraveInfoVo [sectionSeq=" + sectionSeq + ", rowSeq=" + rowSeq + ", colSeq=" + colSeq + ", seqNo="
				+ seqNo + "]";
	}
	
}