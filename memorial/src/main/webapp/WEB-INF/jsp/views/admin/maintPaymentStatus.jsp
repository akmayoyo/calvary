<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@page import="com.calvary.admin.controller.AdminController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<form id="frm" method="post">
	<input type="hidden" id="pageIndex" name="pageIndex" value="${searchVo.pageIndex}">
	<input type="hidden" id="bunyangSeq" name="bunyangSeq">
	<!-- 그리드 샘플 -->
	<div class="col-md-9">
	
		<div class="pull-left"><h3 style="margin-top: 0;">관리비납부현황</h3></div>
    	<div class="clearfix"></div>
		<div style="border-top: 1px solid #999;">
	        <table class="table table-style table-bordered" style="border-top: 0;">
	        	<colgroup>
	        		<col width="14%">
	        		<col width="14%">
	        		<col width="14%">
	        		<col width="14%">
	        		<col width="14%">
	        		<col width="14%">
	        		<col width="15%">
	        	</colgroup>
	            <tbody>
	            	<tr>
	            		<th style="background-color: #f5f5f5;"><p class="form-control-static">납부연도</p></th>
	            		<td>
	            		<c:choose>
	            			<c:when test="${searchVo.maintYear > 0}">${searchVo.maintYear}년</c:when>
	            			<c:otherwise>전체</c:otherwise>
	            		</c:choose>
	            		</td>
	            		<th style="background-color: #f5f5f5;"><p class="form-control-static">총관리비</p></th>
	            		<td>₩ ${cutil:getThousandSeperatorFormatString(maintPaymentStatus.total_price)}원</td>
	            		<th style="background-color: #f5f5f5;"><p class="form-control-static">총납부금액</p></th>
	            		<td>₩ ${cutil:getThousandSeperatorFormatString(maintPaymentStatus.total_payment)}원</td>
	            		<td align="left">납부완료 : ${maintPaymentStatus.full_payment_cnt}<br>미납 : ${maintPaymentStatus.non_payment_cnt}<br>부분납부 : ${maintPaymentStatus.partial_payment_cnt}</td>
	            	</tr>
	            </tbody>
	        </table>
	    </div>
	
		<!-- 검색 -->
		<div class="bx-border p-20 mb-20" style="margin-top: 20px;">
			<div class="row">
				<div class="col-xs-2 col-md-2 pr-10">
					<select name="maintYear" class="form-control">
						<option value="0">납부연도 : 전체</option>
						<c:forEach items="${maintYearList}" var="maintYearItem">
						<option value="${maintYearItem.yearval}" <c:if test="${searchVo.maintYear == maintYearItem.yearval}">selected</c:if>>납부연도 : ${maintYearItem.yearval}</option>
						</c:forEach>
					</select>
				</div>
				<div class="col-xs-2 col-md-2 pr-10 pl-0">
					<select name="maintStatus" class="form-control">
						<option value="ALL" <c:if test="${searchVo.maintStatus == 'ALL'}">selected</c:if>>전체</option>
						<option value="1" <c:if test="${searchVo.maintStatus == '1'}">selected</c:if>>납부완료</option>
						<option value="2" <c:if test="${searchVo.maintStatus == '2'}">selected</c:if>>미납</option>
						<option value="3" <c:if test="${searchVo.maintStatus == '3'}">selected</c:if>>부분납부</option>
					</select>
				</div>
				<div class="col-xs-8 col-md-8 pl-0">
					<div class="input-group">
						<input type="text" name="searchVal" class="form-control" value="${searchVo.searchVal}">
						<span class="input-group-btn pl-10">
							<button class="btn btn-primary" type="button" onclick="_search()" style="width: 70px;">조회</button>
							<button class="btn btn-primary" type="button" style="margin-left: 4px; padding: 6px 8px 6px 12px;" onclick="_showPaymentClaim()">납부대상</button>
							<button class="btn btn-success" type="button" style="margin-left: 4px; width: 70px;" onclick="_downloadExcel()">Excel</button>
						</span>
					</div>
				</div>
			</div>
		</div>
	
		<!-- 테이블 -->
		<div class="table-responsive">
			<table id="tblList" class="table table-style table-bordered">
				<thead>
					<tr>
						<th scope="col" class="col-xs-1">계약번호</th>
						<th scope="col" class="col-xs-1">계약자</th>
						<th scope="col" class="col-xs-2">사용자</th>
						<th scope="col" class="col-xs-1">사용승인일</th>
						<th scope="col" class="col-xs-1">총관리비</th>
						<th scope="col" class="col-xs-1">납부금액</th>
						<th scope="col" class="col-xs-1">납부건수</th>
						<th scope="col" class="col-xs-1">미납건수</th>
						<th scope="col" class="col-xs-2">납부상태</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${maintPaymentList}" var="maintPaymentItem">
					<tr bunyangSeq="${maintPaymentItem.bunyang_seq}">
						<td><a href="javascript:void(0);" class="tbllink" style="color: #337ab7;" onclick="_showBunyangInfo(this)">${maintPaymentItem.bunyang_no}</a></td>
						<td>${maintPaymentItem.apply_user_name}</td>
						<td>${maintPaymentItem.use_user_exp}</td>
						<td>${maintPaymentItem.use_approval_date}</td>
						<td align="right">${cutil:getThousandSeperatorFormatString(maintPaymentItem.total_price)}</td>
						<td align="right">${cutil:getThousandSeperatorFormatString(maintPaymentItem.total_payment)}</td>
						<td align="right">${maintPaymentItem.payment_cnt}
<%-- 						<c:choose> --%>
<%-- 							<c:when test="${maintPaymentItem.payment_cnt > 0}"><a href="javascript:void(0);" class="tbllink" style="color: #337ab7;" onclick="_showPaymentDetail(this,'Y')">${maintPaymentItem.payment_cnt}</a></c:when> --%>
<%-- 							<c:otherwise>${maintPaymentItem.payment_cnt}</c:otherwise> --%>
<%-- 						</c:choose> --%>
						</td>
						<td align="right">${maintPaymentItem.not_payment_cnt}
<%-- 						<c:choose> --%>
<%-- 							<c:when test="${maintPaymentItem.not_payment_cnt > 0}"><a href="javascript:void(0);" class="tbllink" style="color: #337ab7;" onclick="_showPaymentDetail(this,'N')">${maintPaymentItem.not_payment_cnt}</a></c:when> --%>
<%-- 							<c:otherwise>${maintPaymentItem.not_payment_cnt}</c:otherwise> --%>
<%-- 						</c:choose> --%>
						</td>
						<td>${maintPaymentItem.maint_status_exp}</td>
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
	
})();

/**
 * 조회
 */
function _search(pageIndex) {
	$("#pageIndex").val(pageIndex ? pageIndex : 1);
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/admin/maintPaymentStatus";
	frm.submit();
}

/**
 * Excel 다운로드
 */
function _downloadExcel() {
	var excelHeaders = ["계약번호","계약자","연락처","사용자","사용승인일","총관리비","납부금액","납부건수","미납건수","납부상태"];
	var excelFields = ["bunyang_no","apply_user_name","apply_user_mobile","use_user_exp","use_approval_date","total_price","total_payment","payment_cnt","not_payment_cnt","maint_status_exp"];
	var searchKeys = ["apply_user_name", "maintYear", "maintStatus"];
	var searchValues = ["${searchVo.searchVal}", "${searchVo.maintYear}", "${searchVo.maintStatus}"];
	var queryId = "bunyangstatus.getMaintPaymentList";
	var title = "갈보리추모동산 관리비납부현황";
	var fileName = title + ".xlsx";
	var sheetName = title;
	if(${searchVo.maintYear} > 0) {
		title += '(' + ${searchVo.maintYear} + '년)';
	}
	common.exportExcel(excelHeaders, excelFields, searchKeys, searchValues, queryId, fileName, title, sheetName);
}

/**
 * 관리비 청구 대상 상세정보를 팝업으로 표시
 */
function _showPaymentClaim() {
	var maintYear = ${searchVo.maintYear};
	var winoption = {width:1180, height:750};
	var param = {};
	param['maintYear'] = maintYear;
	common.openWindow("${contextPath}/popup/maintPaymentClaim", "popMaintPaymentClaim", winoption, param);
}

/**
 * 납부/미납 상세정보를 팝업으로 표시
 */
function _showPaymentDetail(el,paymentYn) {
	var bunyangSeq = $(el).parent('td').parent('tr').attr('bunyangSeq');
	var maintYear = ${searchVo.maintYear};
	var winoption = {width:1180, height:750};
	var param = {};
	param['bunyangSeq'] = bunyangSeq;
	param['maintYear'] = maintYear;
	param['paymentYn'] = paymentYn;// Y:납부,N:미납
	param['popupTitle'] = '관리비 납부 상세 정보';
	param['selectable'] = '0';
	common.openWindow("${contextPath}/popup/maintPaymentDetailInfo", "popMaintPaymentDetailInfo", winoption, param);
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