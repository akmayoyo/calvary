<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@page import="com.calvary.admin.controller.AdminController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<form id="frm" method="post">
	<input type="hidden" id="parentCodeSeq" name="parentCodeSeq" value="${parentCodeSeq}">
	
	<!-- 그리드 샘플 -->
	<div class="col-md-9">
	
		<!-- 테이블 -->
		<div class="table-responsive">
			<table id="tblTopLevelCode" class="table table-style table-bordered">
				<thead>
					<tr>
						<th scope="col">CODE</th>
						<th scope="col">코드명</th>
						<th scope="col">코드설명</th>
						<th scope="col">코드값</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${topLevelCodeList}" var="rowItem">
					<tr class="clickable-row" codeSeq="${rowItem.code_seq}">
	                    <td>${rowItem.code_seq}</td>
	                    <td>${rowItem.code_name}</td>
	                    <td>${rowItem.code_desc}</td>
	                    <td>${rowItem.code_value}</td>
					</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</form>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript">
(function(){
	
	// 그리드 로우 선택시
	$('#tblTopLevelCode').on('click', '.clickable-row', function(event) {
		var parentCodeSeq = $(this).attr("codeSeq");
		searchChildCodeList(parentCodeSeq);
	});
	
})();

/** 
 * 상세 코드 리스트 조회
 */
function searchChildCodeList(parentCodeSeq) {
	$('#parentCodeSeq').val(parentCodeSeq);
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/sysadmin/codemgmt";
	frm.submit();
}

/**
 * Excel 다운로드
 */
function _downloadExcel() {
	var excelHeaders = ["승인번호","신청자","사용자","신청형태","부부형","1인형","신청일자","신청상태","비고"];
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

</script>