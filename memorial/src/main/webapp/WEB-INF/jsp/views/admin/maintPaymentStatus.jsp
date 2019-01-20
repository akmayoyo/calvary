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
		<div class="table-responsive" style="border-top: 1px solid #999;">
	        <table class="table table-style table-bordered" style="border-top: 0;">
	        	<colgroup>
	        		<col width="20%">
	        		<col width="20%">
	        		<col width="20%">
	        		<col width="20%">
	        		<col width="20%">
	        	</colgroup>
	            <tbody>
	            	<tr>
	            		<th style="background-color: #f5f5f5;"><p class="form-control-static">관리비납부</p></th>
	            		<td>₩${cutil:getThousandSeperatorFormatString(maintPaymentStatus.transfer_amount)}원</td>
	            		<th style="background-color: #f5f5f5;"><p class="form-control-static">관리비납부인원</p></th>
	            		<td>${maintPaymentStatus.transfer_cnt}명</td>
	            		<td rowspan="2">총액 ₩${cutil:getThousandSeperatorFormatString(maintPaymentStatus.transfer_amount + maintPaymentStatus.cash_amount)}원</td>
	            	</tr>
	            	<tr>
	            		<th style="background-color: #f5f5f5;"><p class="form-control-static">헌금</p></th>
	            		<td>₩${cutil:getThousandSeperatorFormatString(maintPaymentStatus.cash_amount)}원</td>
	            		<th style="background-color: #f5f5f5;"><p class="form-control-static">헌금인원</p></th>
	            		<td>${maintPaymentStatus.cash_cnt}명</td>
	            	</tr>
	            </tbody>
	        </table>
	    </div>
	
	
		<!-- 검색 -->
		<div class="bx-border p-20 mb-20" style="margin-top: 20px;">
			<div class="row">
				<div class="col-xs-4 col-md-3 pr-10">
					<select name="searchKey" class="form-control">
						<option value="apply_user_name" <c:if test="${searchVo.searchKey == 'apply_user_name'}">selected</c:if>>신청자</option>
						<option value="bunyang_seq" <c:if test="${searchVo.searchKey == 'bunyang_seq'}">selected</c:if>>번호</option>
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
			<table id="tblList" class="table table-style table-bordered">
				<thead>
					<tr>
						<th scope="col" colspan="2">계약정보</th>
						<th scope="col" colspan="5">납부정보</th>
					</tr>
					<tr>
						<th scope="col">계약번호</th>
						<th scope="col">계약자명</th>
						<th scope="col">납부자명</th>
						<th scope="col">납부일자</th>
						<th scope="col">금액</th>
						<th scope="col">납부유형</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${maintPaymentList}" var="paymentItem">
						<tr bunyangSeq="${paymentItem.bunyang_seq}">
							<td><a href="#" class="tbllink" onclick="_showBunyangInfo(this)">${paymentItem.bunyang_seq}</a></td>
							<td><a href="#" class="tbllink" onclick="_showBunyangInfo(this)">${paymentItem.apply_user_name}</a></td>
							<td>${paymentItem.payment_user_name}</td>
							<td>${paymentItem.payment_date}</td>
							<td>₩${cutil:getThousandSeperatorFormatString(paymentItem.payment_amount)}원</td>
							<td>
								<c:choose>
									<c:when test="${paymentItem.payment_method == 'TRANSFER'}">관리비</c:when>
									<c:when test="${paymentItem.payment_method == 'CASH'}">헌금</c:when>
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
	var excelHeaders = ["계약번호", "계약자명", "납부자명", "납부일자", "금액", "납부유형"];
	var excelFields = ["bunyang_seq","apply_user_name","payment_user_name","payment_date","payment_amount","payment_method_name"];
	var searchKeys = [""];
	var searchValues = [""];
	var queryId = "bunyangstatus.getMaintPaymentList";
	var fileName = "관리비납부현황.xlsx";
	common.exportExcel(excelHeaders, excelFields, searchKeys, searchValues, queryId, fileName);
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