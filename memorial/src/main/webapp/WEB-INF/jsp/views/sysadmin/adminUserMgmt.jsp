<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@page import="com.calvary.admin.controller.AdminController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<form id="frm" method="post">
	<input type="hidden" id="pageIndex" name="pageIndex" value="${searchVo.pageIndex}">
	<input type="hidden" id="userId" name="userId">
	<!-- 그리드 샘플 -->
	<div class="col-md-9">
		<!-- 검색 -->
		<div class="bx-border p-20 mb-20">
			<div class="row">
				<div class="col-xs-4 col-md-3 pr-10">
					<select name="searchKey" class="form-control">
						<option value="userName">사용자명</option>
					</select>
				</div>
				<div class="col-xs-8 col-md-9 pl-0">
					<div class="input-group">
						<input type="text" name="searchVal" class="form-control" value="${searchVo.searchVal}">
						<span class="input-group-btn pl-10">
							<button class="btn btn-primary" type="button" style="margin-left: 4px;" onclick="_search()">조회</button>
							<button class="btn btn-success" type="button" style="margin-left: 4px;" onclick="_downloadExcel()">Excel</button>
						</span>
					</div>
				</div>
			</div>
		</div>
	
		<!-- 테이블 -->
		<div class="table-responsive">
			<table id="tblList" class="table table-style table-bordered">
				<colgroup>
					<col width="13%">
					<col width="13%">
					<col width="13%">
					<col width="13%">
					<col width="13%">
					<col width="13%">
					<col width="13%">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">아이디</th>
						<th scope="col">성명</th>
						<th scope="col">생년월일</th>
						<th scope="col">휴대폰</th>
						<th scope="col">직분</th>
						<th scope="col">교구</th>
						<th scope="col">상태</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${userList}" var="rowItem">
					<tr class="clickable-row" userId="${rowItem.user_id}">
	                    <td>${rowItem.user_id }</td>
	                    <td>${rowItem.user_name }</td>
	                    <td>${rowItem.birth_date }</td>
	                    <td>${rowItem.mobile }</td>
	                    <td>${rowItem.church_officer_name }</td>
	                    <td>${rowItem.diocese }</td>
	                    <td>${rowItem.user_status_exp }</td>
					</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	
		<!-- 페이징 -->
		<div id="divPagination" class="text-center">
		</div>
	
	</div>
</form>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript">
(function(){
	// 페이징 표시 설정
	$('#divPagination').bootpag({
	   total: Math.ceil(${searchVo.totalCount/searchVo.countPerPage}),
	   page: ${searchVo.pageIndex},
	   maxVisible: 5
	}).on('page', function(event, num){
		_search(num);
	});
	
	// 그리드 로우 선택시
	$('#tblList').on('click', '.clickable-row', function(event) {
		var userId = $(this).attr("userId");
		_detail(userId);
	});
	
})();

/**
 * 조회
 */
function _search(pageIndex) {
	$("#pageIndex").val(pageIndex ? pageIndex : 1);
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/sysadmin/adminUserMgmt";
	frm.submit();
}

/**
 * Excel 다운로드
 */
function _downloadExcel() {
	var excelHeaders = ["아이디", "성명", "생년월일", "휴대폰", "전화", "주소", "직분", "교구", "이메일", "상태"];
	var excelFields = ["user_id","user_name","birth_date","mobile","phone","fulladdress","church_officer_name", "diocese", "email","user_status_exp"];
	var searchKeys = ["userName"];
	var searchValues = ["${searchVo.searchVal}"];
	var queryId = "sysadmin.getAdminUserList";
	var title = "갈보리 시스템 사용자 리스트";
	var fileName = title + ".xlsx";
	var sheetName = title;
	common.exportExcel(excelHeaders, excelFields, searchKeys, searchValues, queryId, fileName, title, sheetName);
}

/** 
 * 상세 페이지 이동
 */
function _detail(userId) {
	$('#userId').val(userId);
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/sysadmin/adminUserDetail";
	frm.submit();
}


</script>