package com.calvary.common.vo;

import com.calvary.common.constant.CalvaryConstants;

public class SearchVo {

	private int pageIndex = 1;
	private int countPerPage = CalvaryConstants.COUNT_PER_PAGE;
	private long totalCount;
	
	private String searchKey;
	private String searchVal;
	
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
	@Override
	public String toString() {
		return "SearchVo [pageIndex=" + pageIndex + ", countPerPage=" + countPerPage + ", totalCount=" + totalCount
				+ ", searchKey=" + searchKey + ", searchVal=" + searchVal + "]";
	}
	
}
