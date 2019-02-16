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
						<option value="">전체</option>
						<option value="<%=CalvaryConstants.PROGRESS_STATUS_C %>" <c:if test="${searchVo.progressStatus == 'C'}">selected</c:if>>미승인</option>
						<option value="<%=CalvaryConstants.PROGRESS_STATUS_D %>" <c:if test="${searchVo.progressStatus == 'D'}">selected</c:if>>승인</option>
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
			<table id="tblList" class="table table-style">
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
						<th scope="col">계약일자</th>
						<th scope="col">완납일자</th>
						<th scope="col">사용승인일자</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${approvalList}" var="approval">
					<c:set var="contract_price" value="${cutil:getDownPayment(approval.total_price)}"/><!-- 계약금 -->
					<tr class="clickable-row" bunyangSeq="${approval.bunyang_seq}">
	                    <td>${approval.bunyang_no}</td>
	                    <td>${approval.apply_user_name}</td>
	                    <td>${approval.use_user_exp}</td>
	                    <td>${approval.product_type_name}</td>
	                    <td>${approval.couple_type_count}</td>
	                    <td>${approval.single_type_count}</td>
	                    <td>${cutil:getThousandSeperatorFormatString(approval.total_price)}</td>
	                    <td>${approval.progress_status_exp}</td>
	                    <td>${approval.contract_date}</td>
	                    <td>${approval.full_payment_date}</td>
	                    <td>${approval.use_approval_date}</td>
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
		_approvalDetail(bunyangSeq);
	});
	
})();

/**
 * 조회
 */
function _search(pageIndex) {
	$("#pageIndex").val(pageIndex ? pageIndex : 1);
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/approvalmgmt";
	frm.submit();
}

/**
 * Excel 다운로드
 */
function _downloadExcel() {
	var excelHeaders = [
		"번호", "신청자", "신청형태", "부부형", "1인형"
		,"총 분양대금","상태", "계약일자","완납일자","사용승인일자"
		,"사용(봉안)자","관계","생년월일","승인번호","연락처","우편번호","주소"
		];
	var excelFields = [
		"bunyang_no","apply_user_name","product_type_name","couple_type_count","single_type_count"
		,"total_price","progress_status_exp","contract_date","full_payment_date","use_approval_date"
		,"use_user_name","use_user_relation_name","use_user_birth_date","use_user_approval_no","use_user_mobile","use_user_post_number","use_user_address"
		];
	var searchKeys = ["apply_user_name", "progressStatus", "bunyangTimes"];
	var searchValues = ["${searchVo.searchVal}", "${searchVo.progressStatus}", "${searchVo.bunyangTimes}"];
	var queryId = "approval.getApprovalExcelList";
	var title = "갈보리추모동산 사용승인현황";
	var fileName = title + ".xlsx";
	var sheetName = title;
	common.exportExcel(excelHeaders, excelFields, searchKeys, searchValues, queryId, fileName, title, sheetName);
}

/** 
 * 상세 페이지 이동
 */
function _approvalDetail(bunyangSeq) {
	$("#bunyangSeq").val(bunyangSeq);
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/approvaldetail";
	frm.submit();
}

/**
 * 사용승인
 */
function _approval(btn, event) {
	event.stopPropagation();
	if(confirm('사용승인하시겠습니까?')) {
		var bunyangSeq = $(btn).parent("td").parent("tr").attr("bunyangSeq");
		var data = {};
		data["bunyangSeq"] = bunyangSeq;
		// 저장 호출
		common.ajax({
			url:"${contextPath}/admin/useapproval", 
			data:data,
			success: function(result) {
				if(result && result.result) {
					common.showAlert("사용승인되었습니다.");
					var frm = document.getElementById("frm");
					frm.action = "${contextPath}/admin/approvalmgmt";
					frm.submit();
				}
			}
		});
	}
}

</script>