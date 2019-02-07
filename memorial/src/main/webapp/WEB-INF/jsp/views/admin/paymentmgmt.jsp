<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@page import="com.calvary.admin.controller.AdminController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<form id="frm" method="post">
	<input type="hidden" id="pageIndex" name="pageIndex" value="${searchVo.pageIndex}">
	<input type="hidden" id="searchKey" name="searchKey" value="bunyangNo">
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
	            		<th style="background-color: #f5f5f5;"><p class="form-control-static">입출구분</p></th>
	            		<td>
	            			<select name="paymentDivision" class="form-control" style="width: 225px;">
	            				<option value="">전체</option>
	            				<option value="DEPOSIT" <c:if test="${paymentDivision == 'DEPOSIT'}">selected</c:if>>입금</option>
	            				<option value="WITHDRAWAL" <c:if test="${paymentDivision == 'WITHDRAWAL'}">selected</c:if>>출금</option>
	            			</select>
	            		</td>
	            		<th style="background-color: #f5f5f5;"><p class="form-control-static">입출금유형</p></th>
	            		<td>
	            			<select name="paymentType" class="form-control" style="width: 225px;">
	            				
	            			</select>
	            		</td>
	            	</tr>
	            	<tr>
	            		<th style="background-color: #f5f5f5;"><p class="form-control-static">납부기간</p></th>
	            		<td>
	            			<div class="input-group date" data-provide="datepicker" style="width: 225px;">
							    <input id="tiPaymentDate" type="text" class="form-control">
							    <div class="input-group-addon">
							        <span class="glyphicon glyphicon-calendar"></span>
							    </div>
							</div>
	            		</td>
	            		<th style="background-color: #f5f5f5;"><p class="form-control-static">계약번호</p></th>
	            		<td><input name="searchVal" class="form-control" type="text" style="width: 225px;" value="${searchVo.searchVal}"></td>
	            	</tr>
	            </tbody>
	        </table>
	    </div>
	    
	    <div class="text-right" style="margin-top: 10px;">
	    	<button class="btn btn-primary" type="button" onclick="_search()" style="width: 70px;">조회</button>
			<button class="btn btn-primary" type="button" style="width: 70px;" onclick="_registPayment()">등록</button>
			<button class="btn btn-primary" type="button" onclick="_registPaymentExcel()">엑셀등록</button>
			<button class="btn btn-success" type="button" style="width: 70px;" onclick="_downloadExcel()">Excel</button>
	    </div>
	    
		<!-- 테이블 -->
		<div class="table-responsive" style="margin-top: 10px;">
			<table id="tblApplyList" class="table table-style table-bordered">
				<colgroup>
	        		<col width="10%">
	        		<col width="10%">
	        		<col width="10%">
	        		<col width="10%">
	        		<col width="10%">
	        		<col width="10%">
	        		<col width="25%">
	        	</colgroup>
				<thead>
					<tr>
						<th scope="col">입출일자</th>
						<th scope="col">금액</th>
						<th scope="col">입출구분</th>
						<th scope="col">계약번호</th>
						<th scope="col">입금자</th>
						<th scope="col">입출금유형</th>
						<th scope="col">비고</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${paymentList}" var="payment">
					<tr>
						<td>${payment.payment_date}</td>
						<td align="right">${cutil:getThousandSeperatorFormatString(payment.payment_amount)}</td>
						<td>${payment.payment_division_name}</td>
						<td>${payment.bunyang_no}</td>
						<td>${payment.payment_user}</td>
						<td>${payment.payment_type_name}</td>
						<td align="left">${payment.remarks}</td>
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

<ul id="DEPOSITList" style="display: none;">
	<c:forEach items="${depositTypeList}" var="typeItem">
	<li code_seq="${typeItem.code_seq}" code_name="${typeItem.code_name}"></li>
	</c:forEach>
</ul>
<ul id="WITHDRAWALList" style="display: none;">
	<c:forEach items="${withdrawalTypeList}" var="typeItem">
	<li code_seq="${typeItem.code_seq}" code_name="${typeItem.code_name}"></li>
	</c:forEach>
</ul>

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
	
	$('select[name="paymentDivision"]').change(function(e) {
		var paymentTypeList = '<option value="">전체</option>';
		var selected = $(this).find('option:selected').val();
		if(selected) {
			$('#'+selected+'List li').each(function(idx) {
				paymentTypeList += '<option value="' + $(this).attr('code_seq') + '">' + $(this).attr('code_name') + '</option>';
			});
		}else {
			$('#DEPOSITList li').each(function(idx) {
				paymentTypeList += '<option value="' + $(this).attr('code_seq') + '">' + $(this).attr('code_name') + '</option>';
			});
			$('#WITHDRAWALList li').each(function(idx) {
				paymentTypeList += '<option value="' + $(this).attr('code_seq') + '">' + $(this).attr('code_name') + '</option>';
			});
		}
		$('select[name="paymentType"]').html(paymentTypeList);
	});
	
	$('select[name="paymentDivision"]').trigger('change');
	
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
 * 등록 팝업 표시
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
 * 엑셀등록 팝업 표시
 */
function _registPaymentExcel() {
	var winoption = {width:1390, height:750};
	common.openWindow("${contextPath}/popup/registPaymentExcel", "popRegistPaymentExcel", winoption, {});
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