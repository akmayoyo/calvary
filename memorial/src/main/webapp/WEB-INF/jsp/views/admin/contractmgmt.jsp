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
						<th scope="col">총분양금</th>
						<th scope="col">계약금</th>
						<th scope="col">잔액납부</th>
						<th scope="col">잔금</th>
						<th scope="col">상태</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${contractList}" var="contract">
					<tr class="clickable-row" bunyangSeq="${contract.bunyang_seq}">
	                    <td><p class="form-control-static">${contract.bunyang_seq}</p></td>
	                    <td><p class="form-control-static">${contract.apply_user_name}</p></td>
	                    <c:choose>
						<c:when test="${contract.use_user_cnt > 1}">
							<td><p class="form-control-static">${contract.use_user_name}(${contract.use_user_relation_name}) 외 ${contract.use_user_cnt-1}명</p></td>
						</c:when>
						<c:otherwise>
							<td><p class="form-control-static">${contract.use_user_name}(${contract.use_user_relation_name})</p></td>
						</c:otherwise>
						</c:choose>
	                    <td><p class="form-control-static">${contract.product_type_name}</p></td>
	                    <td><p class="form-control-static">${contract.couple_type_count}</p></td>
	                    <td><p class="form-control-static">${contract.single_type_count}</p></td>
	                    <td><p class="form-control-static"><fmt:formatNumber value="${contract.total_price }" pattern="#,###" /></p></td>
	                    <td><p class="form-control-static"><fmt:formatNumber value="${contract.down_payment }" pattern="#,###" /></p></td>
	                    <td><p class="form-control-static"><fmt:formatNumber value="${contract.balance_payment }" pattern="#,###" /></p></td>
	                    <td><p class="form-control-static"><fmt:formatNumber value="${contract.balance_price }" pattern="#,###" /></p></td>
	                   <c:choose>
						<c:when test="${contract.progress_status == 'A'}">
							<td><p class="form-control-static">계약전</p></td>
						</c:when>
						<c:when test="${contract.progress_status == 'B'}">
							<td><p class="form-control-static">진행중</p></td>
						</c:when>
						<c:when test="${contract.progress_status == 'C'}">
							<td><p class="form-control-static">완납</p></td>
						</c:when>
						<c:otherwise>
							<td><p class="form-control-static">${contract.progress_status}</p></td>
						</c:otherwise>
						</c:choose>
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