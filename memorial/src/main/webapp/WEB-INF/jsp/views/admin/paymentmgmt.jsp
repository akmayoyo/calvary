<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@page import="com.calvary.admin.controller.AdminController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<form id="frm" method="post">
	<input type="hidden" id="pageIndex" name="pageIndex" value="${searchVo.pageIndex}">
	<input type="hidden" id="searchKey" name="searchKey" value="bunyangSeq">
	<input type="hidden" id="fromDt" name="fromDt" value="${searchVo.fromDt}">
	<input type="hidden" id="toDt" name="toDt" value="${searchVo.toDt}">
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
	            		<th style="background-color: #f5f5f5;"><p class="form-control-static">신청번호</p></th>
	            		<td><input name="searchVal" class="form-control" type="text" style="width: 225px;" value="${searchVo.searchVal}"></td>
	            		<th style="background-color: #f5f5f5;"><p class="form-control-static">납부유형</p></th>
	            		<td>
	            			<select name="paymentType" class="form-control" style="width: 225px;">
	            				<option value="">전체</option>
	            				<option value="DOWN_PAYMENT" <c:if test="${paymentType == 'DOWN_PAYMENT'}">selected</c:if>>계약금</option>
	            				<option value="BALANCE_PAYMENT" <c:if test="${paymentType == 'BALANCE_PAYMENT'}">selected</c:if>>분양잔금</option>
	            				<option value="MAINT_PAYMENT" <c:if test="${paymentType == 'MAINT_PAYMENT'}">selected</c:if>>관리비</option>
	            				<option value="CANCEL_PAYMENT" <c:if test="${paymentType == 'CANCEL_PAYMENT'}">selected</c:if>>해약금</option>
	            			</select>
	            		</td>
	            	</tr>
	            	<tr>
	            		<th style="background-color: #f5f5f5;"><p class="form-control-static">납부기간</p></th>
	            		<td colspan="3">
	            			<div class="input-group date" data-provide="datepicker" style="width: 225px;">
							    <input id="tiPaymentDate" type="text" class="form-control">
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
	    	<button class="btn btn-primary" type="button" onclick="_search()">조회</button>
			<button class="btn btn-primary" type="button" onclick="_registPayment()">등록</button>
			<button class="btn btn-success" type="button" onclick="_downloadExcel()">Excel</button>
	    </div>
	    
		<!-- 테이블 -->
		<div class="table-responsive" style="margin-top: 10px;">
			<table id="tblApplyList" class="table table-style">
				<thead>
					<tr>
						<th scope="col">신청번호</th>
						<th scope="col">납부유형</th>
						<th scope="col">납부금액</th>
						<th scope="col">납부일</th>
						<th scope="col">확인자</th>
						<th scope="col">확인일</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${paymentList}" var="payment">
					<tr>
						<td>${payment.bunyang_seq }</td>
						<td>
						<c:set var="paymentType" value="${payment.payment_type}"/>
						<c:choose>
							<c:when test="${paymentType == 'DOWN_PAYMENT'}">계약금</c:when>
							<c:when test="${paymentType == 'BALANCE_PAYMENT'}">분양잔금</c:when>
							<c:when test="${paymentType == 'CANCEL_PAYMENT'}">해약금</c:when>
							<c:when test="${paymentType == 'MAINT_PAYMENT'}">관리비</c:when>
							<c:otherwise>${paymentType}</c:otherwise>
						</c:choose>
						</td>
						<td>₩${cutil:getThousandSeperatorFormatString(payment.payment_amount)}원</td>
						<td>${payment.payment_date }</td>
						<td>${payment.create_user_name }</td>
						<td>${payment.create_date }</td>
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
	common.datePicker($("#tiPaymentDate"),option);
	
})();

/**
 * 조회
 */
function _search(pageIndex) {
	var dateData = $('#tiPaymentDate').data('daterangepicker');
	var fromDt = '';
	var toDt = '';
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
	frm.action = "${contextPath}/admin/paymentmgmt";
	frm.submit();
}

/**
 * 납입금 입력 팝업 표시
 */
function _registPayment() {
	var winoption = {width:1390, height:750};
	common.openWindow("${contextPath}/popup/registpayment", "popRegistPayment", winoption, {});
	// callback 함수
	window.saveCallBack = function(result) {
		if(result && result.result) {
			_search();
    	}
	};
}

/**
 * Excel 다운로드
 */
function _downloadExcel() {
	var excelHeaders = ["번호","신청자","사용자","신청형태","부부형","1인형","신청일자","신청상태"];
	var excelFields = ["bunyang_seq","apply_user_name","use_user_exp","product_type_name","couple_type_count","single_type_count","regist_date","progress_status_exp"];
	var searchKeys = [""];
	var searchValues = [""];
	var queryId = "admin.getApplyList";
	var fileName = "분양신청관리.xlsx";
	common.exportExcel(excelHeaders, excelFields, searchKeys, searchValues, queryId, fileName);
}

</script>