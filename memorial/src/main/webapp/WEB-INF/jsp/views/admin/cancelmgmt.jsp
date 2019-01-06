<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@page import="com.calvary.admin.controller.AdminController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<form id="frm" method="post">
	<input type="hidden" id="pageIndex" name="pageIndex" value="${searchVo.pageIndex}">
	<input type="hidden" id="bunyangSeq" name="bunyangSeq">
	<input type="hidden" id="listUrl" name="listUrl" value="${contextPath}/admin/cancelmgmt">
	<input type="hidden" id="menuId" name="menuId" value="${menuInfo.menu_seq}">
	<!-- 그리드 샘플 -->
	<div class="col-md-9">
		<!-- 검색 -->
		<div class="bx-border p-20 mb-20">
			<div class="row">
				<div class="col-xs-4 col-md-3 pr-10">
					<select name="searchKey" class="form-control">
						<option value="apply_user_name">신청자</option>
					</select>
				</div>
				<div class="col-xs-8 col-md-9 pl-0">
					<div class="input-group">
						<input type="text" name="searchVal" class="form-control" value="${searchVo.searchVal}">
						<span class="input-group-btn pl-10">
							<button class="btn btn-primary" type="button" onclick="_search()">조회</button>
							<button class="btn btn-success" type="button" style="margin-left: 4px;" onclick="_downloadExcel()">Excel</button>
						</span>
					</div>
				</div>
			</div>
		</div>
	
		<!-- 테이블 -->
		<div class="table-responsive">
			<table id="tblList" class="table table-style">
				<thead>
					<tr>
						<th scope="col">번호</th>
						<th scope="col">신청자</th>
						<th scope="col">신청형태</th>
						<th scope="col">부부형</th>
						<th scope="col">1인형</th>
						<th scope="col">총분양대금</th>
						<th scope="col">신청일</th>
						<th scope="col">계약일</th>
						<th scope="col">완납일</th>
						<th scope="col">사용승인일</th>
						<th scope="col">해약일</th>
						<th scope="col"></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${cancelList}" var="approval">
					<c:set var="contract_price" value="${cutil:getDownPayment(approval.total_price)}"/><!-- 계약금 -->
					<tr class="clickable-row" bunyangSeq="${approval.bunyang_seq}">
	                    <td><p class="form-control-static">${approval.bunyang_seq}</p></td>
	                    <td><p class="form-control-static">${approval.apply_user_name}</p></td>
	                    <td><p class="form-control-static">${approval.product_type_name}</p></td>
	                    <td><p class="form-control-static">${approval.couple_type_count}</p></td>
	                    <td><p class="form-control-static">${approval.single_type_count}</p></td>
	                    <td><p class="form-control-static">${cutil:getThousandSeperatorFormatString(approval.total_price)}</p></td>
	                    <td><p class="form-control-static">${approval.regist_date}</p></td>
	                    <td><p class="form-control-static">${approval.contract_date}</p></td>
	                    <td><p class="form-control-static">${approval.full_payment_date}</p></td>
	                    <td><p class="form-control-static">${approval.use_approval_date}</p></td>
	                    <td><p class="form-control-static">${approval.cancel_approval_date}</p></td>
	                    <td>
	                    	<button type="button" class="btn btn-warning btn-sm" <c:if test="${approval.progress_status == 'E'}">style="visibility: hidden;"</c:if> onclick="_cancel(this, event)">해약</button>
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
<script type="text/javascript" src="${contextPath}/resources/js/jquery.fileDownload.js"></script>
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
		_detail(bunyangSeq);
	});
	
})();

/**
 * 조회
 */
function _search(pageIndex) {
	$("#pageIndex").val(pageIndex ? pageIndex : 1);
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/cancelmgmt";
	frm.submit();
}

/**
 * Excel 다운로드
 */
function _downloadExcel() {
	var excelHeaders = ["번호", "신청자", "사용자", "신청형태", "부부형", "1인형", "총 분양대금", "계약일자","완납일자","사용승인일자"];
	var excelFields = ["bunyang_seq","apply_user_name","use_user_exp","product_type_name","couple_type_count","single_type_count","total_price","contract_date","full_payment_date","use_approval_date"];
	var searchKeys = [""];
	var searchValues = [""];
	var queryId = "approval.getApprovalList";
	var fileName = "사용승인관리.xlsx";
	common.exportExcel(excelHeaders, excelFields, searchKeys, searchValues, queryId, fileName);
}

/** 
 * 상세 페이지 이동
 */
function _detail(bunyangSeq) {
	$("#bunyangSeq").val(bunyangSeq);
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/bunyanginfo";
	frm.submit();
}

/**
 * 해약
 */
function _cancel(btn, event) {
	event.stopPropagation();
	var bunyangSeq = $(btn).parent("td").parent("tr").attr("bunyangSeq");
	var winoption = {width:1024, height:690};
	var param = {bunyangSeq: bunyangSeq};
	common.openWindow("${contextPath}/popup/contractcancel", "popContractCancel", winoption, param);
	window.contractCancelCallBack = function(result) {
		common.showAlert('저장되었습니다.');
		var frm = document.getElementById("frm");
		frm.action = "${contextPath}/admin/cancelmgmt";
		frm.submit();
	}
}

</script>