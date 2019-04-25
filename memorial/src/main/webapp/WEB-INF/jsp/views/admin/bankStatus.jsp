<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@page import="com.calvary.admin.controller.AdminController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<form id="frm" method="post">
	<input type="hidden" id="pageIndex" name="pageIndex" value="${searchVo.pageIndex}">
	<input type="hidden" id="searchKey" name="searchKey" value="bunyangNo">
	<input type="hidden" id="fromDt" name="fromDt" value="${searchVo.fromDt}">
	<input type="hidden" id="toDt" name="toDt" value="${searchVo.toDt}">
	<input type="hidden" id="paymentDivision" name="paymentDivision" value="${paymentDivision}">
	<input type="hidden" id="paymentType" name="paymentType" value="${paymentType}">
	<input type="hidden" id="parentCodeSeq" name="parentCodeSeq" value="${parentCodeSeq}">
	<!-- 그리드 샘플 -->
	<div class="col-md-9">
	
		<div class="pull-left"><h3 style="margin-top: 0;">입출 현황</h3></div>
    	<div class="clearfix"></div>
		<div class="table-responsive" style="border-top: 1px solid #999;">
	        <table class="table table-style table-bordered" style="border-top: 0;">
	        	<colgroup>
	        		<col width="25%">
	        		<col width="25%">
	        		<col width="25%">
	        		<col width="25%">
	        	</colgroup>
				<thead>
					<tr>
						<th scope="col">연도</th>
						<th scope="col">입금액</th>
						<th scope="col">출금액</th>
						<th scope="col">잔액</th>
					</tr>
				</thead>
	            <tbody>
	            	<c:forEach items="${bankStatusList}" var="rowItem">
	            	<tr <c:if test="${rowItem.year == 'All'}">style="background-color: #FFFCCC; font-weight: bold;"</c:if>>
	            		<td>
	            			<c:choose>
	            				<c:when test="${rowItem.year == 'All'}">합계</c:when>
	            				<c:otherwise>${rowItem.year}</c:otherwise>
	            			</c:choose>
	            		</td>
	            		<td align="right">${cutil:getThousandSeperatorFormatString(rowItem.deposit_amount)}</td>
	            		<td align="right">${cutil:getThousandSeperatorFormatString(rowItem.withdrawal_amount)}</td>
	            		<td align="right">${cutil:getThousandSeperatorFormatString(rowItem.deposit_amount - rowItem.withdrawal_amount)}</td>
	            	</tr>
	            	</c:forEach>
	            </tbody>
	        </table>
	    </div>
	
		<!-- 검색 -->
		<div class="pull-left"><h3 style="margin-top: 0; margin-top: 20px;">상세 조회</h3></div>
    	<div class="clearfix"></div>
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
	            			<select id="selPaymentDivision" class="form-control" style="width: 225px;">
	            				<option value="">전체</option>
	            				<option value="<%=CalvaryConstants.PAYMENT_DIVISION_DEPOSIT%>">입금</option>
	            				<option value="<%=CalvaryConstants.PAYMENT_DIVISION_WITHDRAWAL %>">출금</option>
	            			</select>
	            		</td>
	            		<th style="background-color: #f5f5f5;"><p class="form-control-static">입출유형</p></th>
	            		<td>
	            			<select id="selPaymentType" class="form-control" style="width: 225px;">
	            				
	            			</select>
	            		</td>
	            	</tr>
	            	<tr>
	            		<th style="background-color: #f5f5f5;"><p class="form-control-static">입출금기간</p></th>
	            		<td>
	            			
<!-- 	            			<input id="tiPaymentStartDate" type="text" class="form-control" style="width: 100px; display: inline-block;"> -->
<!-- 	            			<span style="margin-left: 5px; margin-right: 5px;">~</span> -->
<!-- 	            			<input id="tiPaymentEndDate" type="text" class="form-control" style="width: 100px; display: inline-block;"> -->
							<div class="input-group date" data-provide="datepicker" style="width: 133px; float: left;">
							    <input id="tiPaymentStartDate" type="text" class="form-control" style="display: inline-block;">
							    <div class="input-group-addon" style="cursor: pointer;">
							        <span class="glyphicon glyphicon-calendar"></span>
							    </div>
							</div>
							<div style="float: left; margin-top: 8px;"><span style="margin-left: 5px; margin-right: 5px;">~</span></div>
							<div class="input-group date" data-provide="datepicker" style="width: 133px; float: left;">
							    <input id="tiPaymentEndDate" type="text" class="form-control">
							    <div class="input-group-addon"  style="cursor: pointer;">
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
			<button class="btn btn-success" type="button" style="width: 70px;" onclick="_downloadExcel()">Excel</button>
	    </div>
	    
		<!-- 테이블 -->
		<div class="table-responsive" style="margin-top: 10px;">
			<table id="tblApplyList" class="table table-style table-bordered">
				<colgroup>
	        		<col width="13%">
	        		<col width="10%">
	        		<col width="10%">
	        		<col width="10%">
	        		<col width="10%">
	        		<col width="10%">
	        		<col width="22%">
	        	</colgroup>
				<thead>
					<tr>
						<th scope="col">입출일자</th>
						<th scope="col">입출금액</th>
						<th scope="col">입출구분</th>
						<th scope="col">입출유형</th>
						<th scope="col">계약번호</th>
						<th scope="col">입금자</th>
						<th scope="col">비고</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${depositWithDrawlList}" var="rowItem">
					<tr bunyangSeq="${rowItem.bunyang_seq}">
						<td>${rowItem.payment_date}</td>
						<td align="right">${cutil:getThousandSeperatorFormatString(rowItem.payment_amount)}</td>
						<td>${rowItem.payment_division_name}</td>
						<td>${rowItem.payment_type_name}</td>
						<td><a href="javascript:void(0);" class="tbllink" style="color: #337ab7;" onclick="_showBunyangInfo(this)">${rowItem.bunyang_no}</a></td>
						<td>${rowItem.payment_user}</td>
						<td align="left">${rowItem.remarks}</td>
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
	<li code_seq="${typeItem.code_seq}" code_name="${typeItem.code_name}" parent_code_seq="${typeItem.parent_code_seq}" parent_code_name="입금"></li>
	</c:forEach>
</ul>
<ul id="WITHDRAWALList" style="display: none;">
	<c:forEach items="${withdrawalTypeList}" var="typeItem">
	<li code_seq="${typeItem.code_seq}" code_name="${typeItem.code_name}" parent_code_seq="${typeItem.parent_code_seq}" parent_code_name="출금"></li>
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
	
	common.datePicker($("#tiPaymentStartDate"), {startDate:fromDt});
	common.datePicker($("#tiPaymentEndDate"),{startDate:toDt});
	
	$('#tiPaymentStartDate, #tiPaymentEndDate').next().click(function() {
		$(this).prev().focus();
	});
	
	$('#selPaymentDivision').change(function(e) {
		filterPaymentType();
	});
	
	$('#selPaymentDivision option[value="${paymentDivision}"]').attr('selected', 'selected');
	
	filterPaymentType('${parentCodeSeq}', '${paymentType}');
	
})();

/**
 * 입출구분에 따라 입출유형 filter
 */
function filterPaymentType(parent_code_seq, code_seq) {
	var selected = $('#selPaymentDivision').find('option:selected').val();
	var paymentType = $('#selPaymentType');
	paymentType.html('');
	paymentType.append($('<option value="">전체</option>'));
	var option;
	if(selected) {
		$('#'+selected+'List li').each(function(idx) {
			option = getPaymentTypeOption($(this),false);
			if(option.val() == code_seq && option.attr('parent_code_seq') == parent_code_seq) {
				option.attr('selected', 'selected');
			}
			paymentType.append(option);
		});
	}else {
		$('#DEPOSITList li').each(function(idx) {
			option = getPaymentTypeOption($(this),true);
			if(option.val() == code_seq && option.attr('parent_code_seq') == parent_code_seq) {
				option.attr('selected', 'selected');
			}
			paymentType.append(option);
		});
		$('#WITHDRAWALList li').each(function(idx) {
			option = getPaymentTypeOption($(this),true);
			if(option.val() == code_seq && option.attr('parent_code_seq') == parent_code_seq) {
				option.attr('selected', 'selected');
			}
			paymentType.append(option);
		});
	}
}

/**
 * 입출유형 option 반환
 */
function getPaymentTypeOption(el, addprefix) {
	var code_seq = $(el).attr('code_seq');
	var code_name = $(el).attr('code_name');
	var parent_code_seq = $(el).attr('parent_code_seq');
	var parent_code_name = $(el).attr('parent_code_name');
	var option = $('<option/>');
	var text = code_name;
	if(addprefix) {
		text = '(' + parent_code_name + ') - ' + text;
	}
	option.val(code_seq);
	option.text(text);
	option.attr('parent_code_seq', parent_code_seq);
	return option;
}

/**
 * 조회
 */
function _search(pageIndex) {
	var fromData = $('#tiPaymentStartDate').data('daterangepicker');
	var toData = $('#tiPaymentEndDate').data('daterangepicker');
	var fromDt = '', toDt = '', paymentDivision = '', paymentType = '', parentCodeSeq = '';
	
	if(fromData && fromData.startDate) {
		fromDt = fromData.startDate.format('YYYYMMDD');
	}
	if(toData && toData.startDate) {
		toDt = toData.startDate.format('YYYYMMDD');
	}
	if(fromDt > toDt) {
		common.showAlert("입출금기간의 시작일이 종료일보다 큽니다.");
		$('#tiPaymentStartDate').focus();
		return;
	}
	
	paymentDivision = $('#selPaymentDivision option:selected').val();
	paymentType = $('#selPaymentType option:selected').val();
	parentCodeSeq = $('#selPaymentType option:selected').attr('parent_code_seq');
	$("#pageIndex").val(pageIndex ? pageIndex : 1);
	$("#fromDt").val(fromDt);
	$("#toDt").val(toDt);
	$("#paymentDivision").val(paymentDivision);
	$("#paymentType").val(paymentType);
	$("#parentCodeSeq").val(parentCodeSeq);
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/bankStatus";
	frm.submit();
}

/**
 * Excel 다운로드
 */
function _downloadExcel() {
	var excelHeaders = ["입출일자","입출금액","입출구분","입출유형","계약번호","입금자","비고"];
	var excelFields = ["payment_date","payment_amount","payment_division_name","payment_type_name","bunyang_no","payment_user","remarks"];
	var searchKeys = ["bunyangNo", "paymentType", "paymentDivision", "fromDt", "toDt"];
	var searchValues = ["${searchVo.searchVal}", "${paymentType}", "${parentCodeSeq}", "${searchVo.fromDt}", "${searchVo.toDt}"];
	var queryId = "payment.getPaymentList";
	var title = "갈보리추모동산 입출금현황";
	var fileName = title + ".xlsx";
	var sheetName = title;
	common.exportExcel(excelHeaders, excelFields, searchKeys, searchValues, queryId, fileName, title, sheetName);
}

/**
 * 분양 상세정보를 팝업으로 표시
 */
function _showBunyangInfo(el) {
	var bunyangSeq = $(el).parent('td').parent('tr').attr('bunyangSeq');
	var winoption = {width:1120, height:750};
	common.openWindow("${contextPath}/popup/bunyanginfo", "popBunyangInfo", winoption, {bunyangSeq:bunyangSeq});
}

</script>