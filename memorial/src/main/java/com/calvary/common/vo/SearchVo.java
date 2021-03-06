package com.calvary.common.vo;

import com.calvary.common.constant.CalvaryConstants;

public class SearchVo {

	private int pageIndex = 1;
	private int countPerPage = CalvaryConstants.COUNT_PER_PAGE;
	private long totalCount;
	
	private String searchKey;
	private String searchVal;
	private String fromDt;
	private String toDt;
	private String progressStatus;
	private int bunyangTimes;
	private int maintYear;
	private String maintStatus;
	
	public int getPageIndex() {
		return pageIndex;
	}
	public void setPageIndex(int pageIndex) {
		this.pageIndex = pageIndex;
	}
	public int getCountPerPage() {
		return countPerPage;
	}
	public void setCountPerPage(int countPerPage) {
		this.countPerPage = countPerPage;
	}
	public long getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(long totalCount) {
		this.totalCount = totalCount;
	}
	public String getSearchKey() {
		return searchKey;
	}
	public void setSearchKey(String searchKey) {
		this.searchKey = searchKey;
	}
	public String getSearchVal() {
		return searchVal;
	}
	public void setSearchVal(String searchVal) {
		this.searchVal = searchVal;
	}
	public String getFromDt() {
		return fromDt;
	}
	public void setFromDt(String fromDt) {
		this.fromDt = fromDt;
	}
	public String getToDt() {
		return toDt;
	}
	public void setToDt(String toDt) {
		this.toDt = toDt;
	}
	public String getProgressStatus() {
		return progressStatus;
	}
	public void setProgressStatus(String progressStatus) {
		this.progressStatus = progressStatus;
	}
	public int getBunyangTimes() {
		return bunyangTimes;
	}
	public void setBunyangTimes(int bunyangTimes) {
		this.bunyangTimes = bunyangTimes;
	}
	public int getMaintYear() {
		return maintYear;
	}
	public void setMaintYear(int maintYear) {
		this.maintYear = maintYear;
	}
	public String getMaintStatus() {
		return maintStatus;
	}
	public void setMaintStatus(String maintStatus) {
		this.maintStatus = maintStatus;
	}
	@Override
	public String toString() {
		return "SearchVo [pageIndex=" + pageIndex + ", countPerPage=" + countPerPage + ", totalCount=" + totalCount
				+ ", searchKey=" + searchKey + ", searchVal=" + searchVal + ", fromDt=" + fromDt + ", toDt=" + toDt
				+ ", progressStatus=" + progressStatus + ", bunyangTimes=" + bunyangTimes + ", maintYear=" + maintYear
				+ ", maintStatus=" + maintStatus + "]";
	}
	
}
