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
						<th scope="col">사용자</th>
						<th scope="col">신청형태</th>
						<th scope="col">부부형</th>
						<th scope="col">1인형</th>
						<th scope="col">총분양대금</th>
						<th scope="col">납부금액</th>
						<th scope="col">계약여부</th>
						<th scope="col">완납여부</th>
						<th scope="col"></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${contractList}" var="contract">
					<tr class="clickable-row" bunyangSeq="${contract.bunyang_seq}">
	                    <td>${contract.bunyang_seq}</td>
	                    <td>${contract.apply_user_name}</td>
	                    <c:choose>
						<c:when test="${contract.use_user_cnt > 1}">
							<td>${contract.use_user_name}(${contract.use_user_relation_name}) 외 ${contract.use_user_cnt-1}명</td>
						</c:when>
						<c:otherwise>
							<td>${contract.use_user_name}(${contract.use_user_relation_name})</td>
						</c:otherwise>
						</c:choose>
						<c:set var="contract_price" value="${cutil:getDownPayment(contract.total_price)}"/><!-- 계약금 -->
	                    <td>${contract.product_type_name}</td>
	                    <td>${contract.couple_type_count}</td>
	                    <td>${contract.single_type_count}</td>
	                    <td>${cutil:getThousandSeperatorFormatString(contract.total_price)}</td>
	                    <td>${cutil:getThousandSeperatorFormatString(contract.down_payment + contract.balance_payment)}</td>
	                    <td>
	                    <c:choose>
						<c:when test="${contract.progress_status == 'A'}">
							<span class="label label-warning" style="margin-left: 5px; ">미납</span>
						</c:when>
						<c:otherwise>
							<span class="label label-info" style="margin-left: 5px; ">완납</span>
						</c:otherwise>
						</c:choose>
	                    </td>
	                    <td>
                    	<c:choose>
						<c:when test="${contract.progress_status == 'C'}">
							<span class="label label-info">완납</span>
						</c:when>
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
		_contractDetail(bunyangSeq);
	});
	
})();

/**
 * 조회
 */
function _search(pageIndex) {
	$("#pageIndex").val(pageIndex ? pageIndex : 1);
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/contractmgmt";
	frm.submit();
}

/**
 * Excel 다운로드
 */
function _downloadExcel() {
	var excelHeaders = ["번호","신청자","신청형태"];
	var excelFields = ["bunyang_seq","apply_user_name","product_type_name"];
	var searchKeys = ["apply_user_name"];
	var searchValues = ["이영준"];
	var queryId = "contract.getContractList";
	var fileName = "분양신청정보.xlsx";
	common.exportExcel(excelHeaders, excelFields, searchKeys, searchValues, queryId, fileName);
}

/** 
 * 상세 페이지 이동
 */
function _contractDetail(bunyangSeq) {
	$("#bunyangSeq").val(bunyangSeq);
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/contractdetail";
	frm.submit();
}

</script>