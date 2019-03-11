<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@page import="com.calvary.admin.controller.AdminController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<form id="frm" method="post">
	<input type="hidden" id="pageIndex" name="pageIndex" value="${searchVo.pageIndex}">
	<input type="hidden" id="fromDt" name="fromDt" value="${searchVo.fromDt}">
	<input type="hidden" id="toDt" name="toDt" value="${searchVo.toDt}">
	<input type="hidden" name="searchKey" value="deviceType">
	<!-- 그리드 샘플 -->
	<div class="col-md-9">
		<!-- 검색 -->
		<div class="table-responsive" style="border-top: 1px solid #999;">
	        <table class="table table-style" style="border-top: 0;">
	        	<colgroup>
	        		<col width="15%">
	        		<col width="35%">
	        		<col width="15%">
	        		<col width="35%">
	        	</colgroup>
	            <tbody>
	            	<tr>
	            		<th style="background-color: #f5f5f5;"><p class="form-control-static">구분</p></th>
	            		<td>
	            			<select name="searchVal" class="form-control" style="width: 225px;">
	            				<option value="">전체</option>
	            				<option value="WEB" <c:if test="${searchVo.searchVal == 'WEB'}">selected</c:if>>WEB</option>
	            				<option value="MOBILE" <c:if test="${searchVo.searchVal == 'MOBILE'}">selected</c:if>>MOBILE</option>
	            			</select>
	            		</td>
	            		<th style="background-color: #f5f5f5;"><p class="form-control-static">접속기간</p></th>
	            		<td>
	            			<div class="input-group date" data-provide="datepicker" style="width: 225px;">
							    <input id="tiSearchDate" type="text" class="form-control">
							    <div class="input-group-addon">
							        <span class="glyphicon glyphicon-calendar"></span>
							    </div>
							</div>
	            		</td>
	            	</tr>
	            </tbody>
	        </table>
	    </div>
	    
	    <div class="text-right" style="margin-top: 10px;">
	    	<button class="btn btn-primary" type="button" onclick="_search()" style="width: 70px;">조회</button>
			<button class="btn btn-success" type="button" style="width: 70px;" onclick="_downloadExcel()">Excel</button>
	    </div>
	    
		<!-- 테이블 -->
		<div class="table-responsive" style="margin-top: 10px;">
			<table id="tblApplyList" class="table table-style table-bordered">
				<colgroup>
	        		<col width="16%">
	        		<col width="16%">
	        		<col width="16%">
	        		<col width="16%">
	        		<col width="16%">
	        	</colgroup>
				<thead>
					<tr>
						<th scope="col">메뉴그룹</th>
						<th scope="col">메뉴명</th>
						<th scope="col">접속IP</th>
						<th scope="col">사용자명</th>
						<th scope="col">접속시간</th>
						<th scope="col">구분</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${menuLogList}" var="rowItem">
					<tr>
						<td align="left">${rowItem.parent_menu_name}</td>
						<td align="left">${rowItem.menu_name}</td>
						<td>${rowItem.login_ip}</td>
						<td>${rowItem.login_user_name}</td>
						<td>${rowItem.access_time}</td>
						<td>${rowItem.device_type}</td>
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
<script type="text/javascript" src="${contextPath}/resources/js/moment.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/daterangepicker.js"></script>
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
	
	var fromDt = $("#fromDt").val();
	var toDt = $("#toDt").val();
	
	var option = {};
	option['singleDatePicker'] = false;
	if(fromDt && toDt) {
		option['startDate'] = fromDt;
		option['endDate'] = toDt;
	}
	common.datePicker($("#tiSearchDate"),option);
	
})();

/**
 * 조회
 */
function _search(pageIndex) {
	var dateData = $('#tiSearchDate').data('daterangepicker');
	var fromDt = '', toDt = '', paymentDivision = '', paymentType = '', parentCodeSeq = '';
	
	if(dateData) {
		if(dateData.startDate) {
			fromDt = dateData.startDate.format('YYYYMMDD');
		}
		if(dateData.endDate) {
			toDt = dateData.endDate.format('YYYYMMDD');
		}
	}
	$("#pageIndex").val(pageIndex ? pageIndex : 1);
	$("#fromDt").val(fromDt);
	$("#toDt").val(toDt);
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/sysadmin/menuLog";
	frm.submit();
}

/**
 * Excel 다운로드
 */
function _downloadExcel() {
	var excelHeaders = ["메뉴그룹","메뉴명","접속IP","사용자명","접속시간","구분"];
	var excelFields = ["parent_menu_name","menu_name","login_ip","login_user_name","access_time","device_type"];
	var searchKeys = ["deviceType", "fromDt", "toDt"];
	var searchValues = ["${searchVo.searchVal}", "${searchVo.fromDt}", "${searchVo.toDt}"];
	var queryId = "sysadmin.getMenuLogList";
	var title = "갈보리추모동산 메뉴사용이력";
	var fileName = title + ".xlsx";
	var sheetName = title;
	common.exportExcel(excelHeaders, excelFields, searchKeys, searchValues, queryId, fileName, title, sheetName);
}

</script>