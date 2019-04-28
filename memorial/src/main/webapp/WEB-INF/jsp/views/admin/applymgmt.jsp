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
						<option value="<%=CalvaryConstants.PROGRESS_STATUS_NEW %>" <c:if test="${searchVo.progressStatus == 'N'}">selected</c:if>>신청자</option>
						<option value="<%=CalvaryConstants.PROGRESS_STATUS_A %>" <c:if test="${searchVo.progressStatus == 'A'}">selected</c:if>>승인자</option>
						<option value="<%=CalvaryConstants.PROGRESS_STATUS_R %>" <c:if test="${searchVo.progressStatus == 'R'}">selected</c:if>>반려</option>
						<option value="CA" <c:if test="${searchVo.progressStatus == 'CA'}">selected</c:if>>취소</option>
					</select>
				</div>
				<div class="col-xs-8 col-md-8 pl-0">
					<div class="input-group">
						<input type="text" name="searchVal" class="form-control" value="${searchVo.searchVal}">
						<span class="input-group-btn pl-10">
							<button class="btn btn-primary" type="button" onclick="_search()" style="width: 70px;">조회</button>
							<button class="btn btn-primary" type="button" style="margin-left: 4px; padding: 6px 8px 6px 12px; width: 70px;" onclick="_applyRegist()">
								등록
							</button>
							<button class="btn btn-primary" type="button" style="margin-left: 4px; padding: 6px 8px 6px 12px;" onclick="_registBunyangExcel()">
								엑셀등록
							</button>
							<button class="btn btn-success" type="button" style="margin-left: 4px; width: 70px;" onclick="_downloadExcel()">Excel</button>
						</span>
					</div>
				</div>
			</div>
		</div>
	
		<!-- 테이블 -->
		<div class="table-responsive">
			<table id="tblApplyList" class="table table-style table-bordered">
				<thead>
					<tr>
						<th scope="col" class="col-xs-1">승인번호</th>
						<th scope="col" class="col-xs-1">신청자</th>
						<th scope="col" class="col-xs-2">사용자</th>
						<th scope="col" class="col-xs-1">신청형태</th>
						<th scope="col" class="col-xs-1">부부형</th>
						<th scope="col" class="col-xs-1">1인형</th>
						<th scope="col" class="col-xs-1">신청일자</th>
						<th scope="col" class="col-xs-1">신청상태</th>
						<th scope="col" class="col-xs-2">비고</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${applyList}" var="apply">
					<tr class="clickable-row" bunyangSeq="${apply.bunyang_seq}">
	                    <td>
	                    	<p class="form-control-static">
	                    		<c:choose>
	                    			<c:when test="${not empty apply.bunyang_no}">${apply.bunyang_no}</c:when>
	                    			<c:otherwise>-</c:otherwise>
	                    		</c:choose>
	                    	</p>
	                    </td>
	                    <td><p class="form-control-static">${apply.apply_user_name}</p></td>
	                    <td><p class="form-control-static">${apply.use_user_exp}</p></td>
	                    <td><p class="form-control-static">${apply.product_type_name}</p></td>
	                    <td><p class="form-control-static">${apply.couple_type_count}</p></td>
	                    <td><p class="form-control-static">${apply.single_type_count}</p></td>
	                    <td><p class="form-control-static">${apply.regist_date}</p></td>
	                    <td><p class="form-control-static">${apply.progress_status_exp}</p></td>
	                    <td align="left"><p class="form-control-static">${apply.remarks_exp}</p>
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
	var excelHeaders = ["승인번호","신청자","연락처","사용자","신청형태","부부형","1인형","신청일자","신청상태","비고"];
	var excelFields = ["bunyang_no","apply_user_name","use_user_exp","product_type_name","couple_type_count","single_type_count","regist_date","progress_status_exp","remarks_exp"];
	var searchKeys = ["bunyangTimes", "progressStatus", "apply_user_name"];
	var bunyangTimes = $('select[name="bunyangTimes"] option:selected').val();
	var progressStatus = $('select[name="progressStatus"] option:selected').val();
	var apply_user_name = $('input[name="searchVal"]').val();
	var searchValues = [bunyangTimes, progressStatus, apply_user_name];
	var queryId = "admin.getApplyList";
	var title = "갈보리추모동산 신청현황";
	var fileName = title + ".xlsx";
	var sheetName = title;
	title += " (" + $('select[name="bunyangTimes"] option:selected').text() + ")";
	common.exportExcel(excelHeaders, excelFields, searchKeys, searchValues, queryId, fileName, title, sheetName);
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
function _approval(btn, event) {
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
function _reject(btn) {
	event.stopPropagation();
	if(confirm("반려하시겠습니까?")) {
		var bunyangSeq = $(btn).parent("td").parent("tr").attr("bunyangSeq");
		var bunyangInfo = {};
		bunyangInfo["bunyangSeq"] = bunyangSeq;
		bunyangInfo["progressStatus"] = "<%=CalvaryConstants.PROGRESS_STATUS_R%>";
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

/**
 * 분양정보 등록(엑셀업로드)
 */
function _registBunyangExcel() {
	var winoption = {width:600, height:300};
	common.openWindow("${contextPath}/popup/registBunyangExcel", "popRegistBunyangExcel", winoption, {});
}

</script>