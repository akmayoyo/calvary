<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@page import="com.calvary.admin.controller.AdminController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<form id="frm" method="post">
	<input type="hidden" id="pageIndex" name="pageIndex" value="${searchVo.pageIndex}">
	<input type="hidden" id="bunyangSeq" name="bunyangSeq">
	<!-- 그리드 샘플 -->
	<div class="col-md-9">
	
		<!-- 검색 -->
		<div class="bx-border p-20 mb-20">
			<div class="row">
				<div class="col-xs-2 col-md-2 pr-10">
					<select name="bunyangTimes" class="form-control">
						<option value="0">분양차수 : 전체</option>
						<c:forEach items="${bunyangTimesList}" var="bunyangTimesItem">
						<option value="${bunyangTimesItem.code_seq}" <c:if test="${searchVo.bunyangTimes == bunyangTimesItem.code_seq}">selected</c:if>>분양차수 : ${bunyangTimesItem.code_name}</option>
						</c:forEach>
					</select>
				</div>
				<div class="col-xs-2 col-md-2 pr-10 pl-0">
					<select name="progressStatus" class="form-control">
						<option value="All">전체</option>
						<option value="B0" <c:if test="${searchVo.progressStatus == 'B0'}">selected</c:if>>계약미승인</option>
						<option value="<%=CalvaryConstants.PROGRESS_STATUS_B %>" <c:if test="${searchVo.progressStatus == 'B'}">selected</c:if>>계약완료</option>
						<option value="<%=CalvaryConstants.PROGRESS_STATUS_E %>" <c:if test="${searchVo.progressStatus == 'E'}">selected</c:if>>계약해약</option>
					</select>
				</div>
				<div class="col-xs-8 col-md-8 pl-0">
					<div class="input-group">
						<input type="text" name="searchVal" class="form-control" value="${searchVo.searchVal}">
						<span class="input-group-btn pl-10">
							<button class="btn btn-primary" type="button" onclick="_search()" style="width: 70px;">조회</button>
							<button class="btn btn-success" type="button" style="margin-left: 4px; width: 70px;" onclick="_downloadExcel()">Excel</button>
						</span>
					</div>
				</div>
			</div>
		</div>
	
		<!-- 테이블 -->
		<div class="table-responsive">
			<table id="tblList" class="table table-style table-bordered">
				<thead>
					<tr>
						<th scope="col">번호</th>
						<th scope="col">신청자</th>
						<th scope="col">사용자</th>
						<th scope="col">신청형태</th>
						<th scope="col">부부형</th>
						<th scope="col">1인형</th>
						<th scope="col">총분양대금</th>
						<th scope="col">상태</th>
						<th scope="col">납부금액</th>
						<th scope="col">계약금<br>납부여부</th>
						<th scope="col">완납여부</th>
						<th scope="col">계약/해약일</th>
						<th scope="col">비고</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${contractList}" var="contract">
					<tr class="clickable-row" bunyangSeq="${contract.bunyang_seq}">
	                    <td>${contract.bunyang_no}</td>
	                    <td>${contract.apply_user_name}</td>
	                    <td>${contract.use_user_exp}</td>
	                    <td>${contract.product_type_name}</td>
	                    <td>${contract.couple_type_count}</td>
	                    <td>${contract.single_type_count}</td>
	                    <td>${cutil:getThousandSeperatorFormatString(contract.total_price)}</td>
	                    <td>${contract.progress_status_exp}</td>
	                    <td>${cutil:getThousandSeperatorFormatString(contract.total_payment)}</td>
	                    <td><c:if test="${contract.contract_yn == 'Y'}">O</c:if></td>
	                    <td><c:if test="${contract.full_payment_yn == 'Y'}">O</c:if></td>
	                    <td>${contract.action_date}</td>
	                    <td>
	                    <c:choose>
	                    	<c:when test="${contract.progress_status eq 'E'}">해약반환금 : ${cutil:getThousandSeperatorFormatString(contract.cancel_payment)}</c:when>
	                    </c:choose>
	                    </td>
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
		var bunyangSeq = $(this).attr("bunyangSeq");
		_contractorDetail(bunyangSeq);
	});
	
})();

/**
 * 조회
 */
function _search(pageIndex) {
	$("#pageIndex").val(pageIndex ? pageIndex : 1);
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/contractormgmt";
	frm.submit();
}

/**
 * Excel 다운로드
 */
function _downloadExcel() {
	var excelHeaders = ["번호","신청자","연락처","사용자","신청형태","부부형","1인형","총분양대금","상태","납부금액","계약여부","완납여부","계약/해약일"];
	var excelFields = ["bunyang_no","apply_user_name","apply_user_mobile","use_user_exp","product_type_name","couple_type_count","single_type_count","total_price","progress_status_exp","total_payment","contract_yn","full_payment_yn","action_date"];
	var searchKeys = ["apply_user_name", "progressStatus", "bunyangTimes"];
	var searchValues = ["${searchVo.searchVal}", "${searchVo.progressStatus}", "${searchVo.bunyangTimes}"];
	var queryId = "contractor.getContractorList";
	var title = "갈보리부활동산 계약자관리현황";
	var fileName = title + ".xlsx";
	var sheetName = title;
	common.exportExcel(excelHeaders, excelFields, searchKeys, searchValues, queryId, fileName, title, sheetName);
}

/** 
 * 상세 페이지 이동
 */
function _contractorDetail(bunyangSeq) {
	$("#bunyangSeq").val(bunyangSeq);
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/contractordetail";
	frm.submit();
}

</script>