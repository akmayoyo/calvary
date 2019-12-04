<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@page import="com.calvary.admin.controller.AdminController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<form id="frm" method="post">
	<input type="hidden" id="pageIndex" name="pageIndex" value="${searchVo.pageIndex}">
	<input type="hidden" id="searchKey" name="searchKey" value="userName">
	
	<!-- 그리드 샘플 -->
	<div class="col-md-9">
		
		<div class="bx-border p-20 mb-20">
			<div class="row">
				<div class="col-xs-3 col-md-3 pr-10">
					<select name="requestStatus" class="form-control">
						<option value="">전체</option>
						<option value="REQUESTED" <c:if test="${requestStatus == 'REQUESTED'}">selected</c:if>>승인대기</option>
						<option value="APPROVAL" <c:if test="${requestStatus == 'APPROVAL'}">selected</c:if>>승인완료</option>
					</select>
				</div>
				<div class="col-xs-9 col-md-9 pl-0">
					<div class="input-group">
						<input type="text" name="searchVal" class="form-control" value="${searchVo.searchVal}">
						<span class="input-group-btn pl-10">
							<button class="btn btn-primary" type="button" onclick="_search()" style="width: 90px;">조회</button>
							<button class="btn btn-primary" type="button" style="margin-left: 4px; width: 90px;" onclick="_modifyGrave()">위치수정</button>
							<button class="btn btn-success" type="button" style="margin-left: 4px; width: 90px;" onclick="_downloadExcel()">Excel</button>
						</span>
					</div>
				</div>
			</div>
		</div>
		
	    <div class="table-responsive">
	        <table id="tblAssignInfo" class="table table-style table-bordered">
	            <thead>
	                <tr>
	                    <th scope="col">계약번호</th>
	                    <th scope="col">사용(봉안)자</th>
	                    <th scope="col">신청일시</th>
	                    <th scope="col">신청위치</th>
	                    <th scope="col">승인자</th>
	                    <th scope="col">승인일시</th>
	                    <th scope="col">승인위치</th>
	                    <th scope="col">상태</th>
	                    <th scope="col"></th>
	                </tr>
	            </thead>
	            <tbody>
	            <c:forEach items="${graveRequestList}" var="rowItem">
					<tr bunyangSeq="${rowItem.bunyang_seq}" userSeq="${rowItem.use_user_seq}" coupleSeq="${rowItem.couple_seq}" userId="${rowItem.user_id}">
						<td><a href="#" class="tbllink" onclick="_showBunyangInfo(this)">${rowItem.bunyang_no}</a></td>
	                    <td>${rowItem.user_name}</td>
	                    <td>${rowItem.request_date}</td>
	                    <td>${rowItem.request_grave}</td>
	                    <td>${rowItem.approval_user_name}</td>
	                    <td>
	                    	<c:choose>
	                    		<c:when test="${empty rowItem.assign_date}">-</c:when>
	                    		<c:otherwise>${rowItem.assign_date}</c:otherwise>
	                    	</c:choose>
	                    </td>
	                    <td>
	                    	<c:choose>
	                    		<c:when test="${empty rowItem.approval_grave}">-</c:when>
	                    		<c:otherwise>${rowItem.approval_grave}</c:otherwise>
	                    	</c:choose>
	                    </td>
	                    <td>${rowItem.request_status_exp}</td>
	                    <td>
	                    	<c:if test="${rowItem.request_status == 'REQUESTED'}">
	                    		<button type="button" class="btn btn-primary btn-sm" onclick="approvalRequestGrave(this)">승인</button>
	                    	</c:if>
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
<script type="text/javascript" src="${contextPath}/resources/js/d3.min.js"></script>
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
	
})();

/**
 * 조회
 */
function _search(pageIndex) {
	$("#pageIndex").val(pageIndex ? pageIndex : 1);
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/usemgmt";
	frm.submit();
}

/**
 * 분양 상세정보를 팝업으로 표시
 */
function _showBunyangInfo(el) {
	var bunyangSeq = $(el).parent('td').parent('tr').attr('bunyangSeq');
	var winoption = {width:1120, height:750};
	common.openWindow("${contextPath}/popup/bunyanginfo", "popBunyangInfo", winoption, {bunyangSeq:bunyangSeq});
}

/**
 * Excel 다운로드
 */
function _downloadExcel() {
	var excelHeaders = ["계약번호","사용(봉안)자","신청일자","신청위치","승인일자","승인위치","상태"];
	var excelFields = ["bunyang_no","user_name","request_date","request_grave","assign_date","approval_grave","request_status_exp"];
	var searchKeys = ["requestStatus", "userName"];
	var requestStatus = $('select[name="requestStatus"] option:selected').val();
	var userName = $('input[name="searchVal"]').val();
	var searchValues = [requestStatus, userName];
	var queryId = "use.getGraveRequestList";
	var title = "사용(봉안)신청 리스트";
	var fileName = title + ".xlsx";
	var sheetName = title;
	common.exportExcel(excelHeaders, excelFields, searchKeys, searchValues, queryId, fileName, title, sheetName);
}

/**
 * 동산 신청 승인
 */
function approvalRequestGrave(btn) {
	var tr = $(btn).parent('td').parent('tr');
	var bunyangSeq = tr.attr('bunyangSeq');
	var userSeq = tr.attr('userSeq');
	var coupleSeq = tr.attr('coupleSeq');
	var userId = tr.attr('userId');
	var winoption = {width:1024, height:890};
	var param = {bunyangSeq: bunyangSeq, userSeq: userSeq, userId: userId, coupleSeq: coupleSeq};
	common.openWindow("${contextPath}/popup/approvalRequestGrave", "popApprovalRequestGrave", winoption, param);
	window.approvalGraveCallBack = function(result) {
		var frm = document.getElementById("frm");
		frm.action = "${contextPath}/admin/usemgmt";
		frm.submit();
	}
}

/**
 * 위치수정
 */
function _modifyGrave() {
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/modifyGrave";
	frm.submit();
}

</script>