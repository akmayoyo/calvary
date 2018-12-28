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
							<button class="btn btn-primary" type="button" style="margin-left: 4px;" onclick="_applyRegist()">신청</button>
							<button class="btn btn-success" type="button" style="margin-left: 4px;" onclick="_downloadExcel()">Excel</button>
						</span>
					</div>
				</div>
			</div>
		</div>
	
		<!-- 테이블 -->
		<div class="table-responsive">
			<table id="tblApplyList" class="table table-style">
				<thead>
					<tr>
						<th scope="col">번호</th>
						<th scope="col">신청자</th>
						<th scope="col">사용자</th>
						<th scope="col">신청형태</th>
						<th scope="col">부부형</th>
						<th scope="col">1인형</th>
						<th scope="col">신청일자</th>
						<th scope="col">신청상태</th>
						<th scope="col"></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${applyList}" var="apply">
					<tr class="clickable-row" bunyangSeq="${apply.bunyang_seq}">
	                    <td><p class="form-control-static">${apply.bunyang_seq}</p></td>
	                    <td><p class="form-control-static">${apply.apply_user_name}</p></td>
	                    <c:choose>
						<c:when test="${apply.use_user_cnt > 1}">
							<td><p class="form-control-static">${apply.use_user_name}(${apply.use_user_relation_name}) 외 ${apply.use_user_cnt-1}명</p></td>
						</c:when>
						<c:otherwise>
							<td><p class="form-control-static">${apply.use_user_name}(${apply.use_user_relation_name})</p></td>
						</c:otherwise>
						</c:choose>
	                    <td><p class="form-control-static">${apply.product_type_name}</p></td>
	                    <td><p class="form-control-static">${apply.couple_type_count}</p></td>
	                    <td><p class="form-control-static">${apply.single_type_count}</p></td>
	                    <td><p class="form-control-static">${apply.regist_date}</p></td>
	                    <c:choose>
						<c:when test="${apply.progress_status == 'N'}">
							<td><p class="form-control-static">신청(미승인)</p></td>
						</c:when>
						<c:when test="${apply.progress_status == 'A'}">
							<td><p class="form-control-static">승인</p></td>
						</c:when>
						<c:when test="${apply.progress_status == 'E'}">
							<td><p class="form-control-static">반려</p></td>
						</c:when>
						<c:otherwise>
							<td><p class="form-control-static">${apply.progress_status}</p></td>
						</c:otherwise>
						</c:choose>
						<td style="text-decoration: none;">
						<c:choose>
							<c:when test="${apply.progress_status == 'N'}">
							<button type="button" class="btn btn-info btn-sm" onclick="approval(this, event)">승인</button>
							<button type="button" class="btn btn-warning btn-sm" onclick="reject(this, event)">반려</button>
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
	$('#tblApplyList').on('click', '.clickable-row', function(event) {
		var bunyangSeq = $(this).attr("bunyangSeq");
		_applyDetail(bunyangSeq);
	});
	
})();

/**
 * 조회
 */
function _search(pageIndex) {
	$("#pageIndex").val(pageIndex ? pageIndex : 1);
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/applymgmt";
	frm.submit();
}

/**
 * 신청
 */
function _applyRegist() {
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/applyregist";
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
	var queryId = "admin.getApplyList";
	var fileName = "분양신청정보.xlsx";
	common.exportExcel(excelHeaders, excelFields, searchKeys, searchValues, queryId, fileName);
}

/** 
 * 상세 페이지 이동
 */
function _applyDetail(bunyangSeq) {
	$("#bunyangSeq").val(bunyangSeq);
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/applydetail";
	frm.submit();
}

/**
 * 승인
 */
function approval(btn, event) {
	event.stopPropagation();
	if(confirm("승인하시겠습니까?")) {
		var bunyangSeq = $(btn).parent("td").parent("tr").attr("bunyangSeq");
		var bunyangInfo = {};
		bunyangInfo["bunyangSeq"] = bunyangSeq;
		bunyangInfo["progressStatus"] = "<%=CalvaryConstants.PROGRESS_STATUS_A%>";
		// 저장 호출
		common.ajax({
			url:"${contextPath}/admin/approval", 
			data:JSON.stringify(bunyangInfo),
			contentType: 'application/json',
			success: function(result) {
				if(result && result.result) {
					common.showAlert("승인되었습니다.");
					var frm = document.getElementById("frm");
					frm.action = "${contextPath}/admin/applymgmt";
					frm.submit();
				}
			}
		});
	}
}

/**
 * 반려
 */
function reject(btn) {
	event.stopPropagation();
	if(confirm("반려하시겠습니까?")) {
		var bunyangSeq = $(btn).parent("td").parent("tr").attr("bunyangSeq");
		var bunyangInfo = {};
		bunyangInfo["bunyangSeq"] = bunyangSeq;
		bunyangInfo["progressStatus"] = "<%=CalvaryConstants.PROGRESS_STATUS_E%>";
		// 저장 호출
		common.ajax({
			url:"${contextPath}/admin/reject", 
			data:JSON.stringify(bunyangInfo),
			contentType: 'application/json',
			success: function(result) {
				if(result && result.result) {
					common.showAlert("반려처리 되었습니다.");
					var frm = document.getElementById("frm");
					frm.action = "${contextPath}/admin/applymgmt";
					frm.submit();
				}
			}
		});
	}
}

</script>