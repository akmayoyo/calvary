<%@page import="com.calvary.admin.controller.AdminController"%>
<%@page import="com.calvary.common.constant.CalvaryConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<form id="frm" method="post">
	<input type="hidden" id="pageIndex" name="pageIndex" value="${searchVo.pageIndex}">
	<input type="hidden" id="maintYear" name="maintYear" value="${searchVo.maintYear}">
	<input type="hidden" id="bunyangSeq" name="bunyangSeq" value="${bunyangSeq}">
	<input type="hidden" id="paymentYn" name="paymentYn" value="${paymentYn}">
</form>

<div class="poptitle">
	<strong>관리비 납부 대상자</strong>
	<button type="button" class="close btnClose" aria-label="Close">
		<span aria-hidden="true">&times;</span>
	</button>
</div>

<div class="content" style="padding: 15px 15px;">
    <!-- 신청자 -->
    <div>
    	<div class="pull-left">
	    	<h4>관리비 납부 대상 리스트
<%-- 	    	<c:if test="${searchVo.maintYear > 0}">(${searchVo.maintYear}년)</c:if> --%>
	    	</h4>
    	</div>
    	<div class="pull-right">
	    	<button class="btn btn-success" type="button" onclick="_downloadExcel()">Excel</button>
    	</div>
    </div>
    <div class="clearfix"></div>
    <div>
        <table class="table table-style table-bordered">
            <thead>
                <tr>
                    <th scope="col" colspan="3">계약정보</th>
                    <th scope="col" rowspan="2">납부자성명</th>
                    <th scope="col" rowspan="2">납부자연락처</th>
                    <th scope="col" rowspan="2">납부자주소</th>
                    <th scope="col" rowspan="2">미납건수</th>
                    <th scope="col" rowspan="2">미납총액</th>
                </tr>
                <tr>
                    <th scope="col">계약번호</th>
                    <th scope="col">계약자명</th>
                    <th scope="col">관리비납부유형</th>
				</tr>
            </thead>
            <tbody>
            	<c:forEach items="${maintPaymentDetailList}" var="rowItem">
            	<tr>
            		<td class="tdBunyangNo">${rowItem.bunyang_no}</td>
            		<td class="tdApplyUser">${rowItem.apply_user_name}</td>
            		<td class="tdChargeType">${rowItem.service_charge_type_name}</td>
            		<td>${rowItem.charger_name}</td>
            		<td>${rowItem.charger_phone}</td>
            		<td align="left">${rowItem.charger_address}</td>
            		<td align="right">${rowItem.total_unpaid_cnt}</td>
            		<td align="right">${cutil:getThousandSeperatorFormatString(rowItem.total_unpaid_price)}</td>
            	</tr>
            	</c:forEach>
            </tbody>
        </table>
    </div>
    
    <!-- 페이징 -->
	<div id="divPagination" class="text-center">
	</div>

</div>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/moment.min.js"></script>
<script type="text/javascript">
// init 함수
(function(){
	
	// 페이징 표시 설정
	$('#divPagination').bootpag({
	   total: Math.ceil(${searchVo.totalCount/searchVo.countPerPage}),
	   page: ${searchVo.pageIndex},
	   maxVisible: 5
	}).on('page', function(event, num){
		_search(num);
	});
	
	// 닫기 클릭
    $("button.btnClose").click(function(e) {
        common.closeWindow();
    });
	
	// 행병합
    rowSpan();
	
})();

/**
 * 조회
 */
function _search(pageIndex) {
	$("#pageIndex").val(pageIndex ? pageIndex : 1);
	var frm = document.getElementById("frm");
	frm.action = "${contextPath}/popup/maintPaymentClaim";
	frm.submit();
}

/**
 * Excel 다운로드
 */
function _downloadExcel() {
	var excelHeaders = ["계약번호","계약자","관리비납부유형","납부자성명","납부자연락처","납부자주소","미납건수","미납총액"];
	var excelFields = ["bunyang_no","apply_user_name","service_charge_type_name","charger_name","charger_phone","charger_address","total_unpaid_cnt","total_unpaid_price"];
	var searchKeys = ["maintYear", "paymentYn"];
	var searchValues = [${searchVo.maintYear}, "N"];
	var queryId = "bunyangstatus.getUnpaidMaintPaymentList";
	var title = "갈보리부활동산 관리비 납부 대상자";
	var fileName = title + ".xlsx";
	var sheetName = title;
// 	if(${searchVo.maintYear} > 0) {
// 		title += '(' + ${searchVo.maintYear} + '년)';
// 	}
	common.exportExcel(excelHeaders, excelFields, searchKeys, searchValues, queryId, fileName, title, sheetName);
}

function rowSpan(){
    $(".tdBunyangNo").each(function() {
        var rows = $(".tdBunyangNo" + ":contains('" + $(this).text() + "')");
        if (rows.length > 1) {
        	var row = rows.eq(0); 
        	var tr = row.parent('tr');
        	row.attr("rowspan", rows.length);
        	$(tr).find('.tdApplyUser').attr("rowspan", rows.length);
        	$(tr).find('.tdChargeType').attr("rowspan", rows.length);
        	for(var i = 1; i < rows.length; i++) {
        		row = rows.eq(i);
        		tr = row.parent('tr');
        		row.remove();
        		$(tr).find('.tdApplyUser').remove();
        		$(tr).find('.tdChargeType').remove();
        	}
        }
    });
}

</script>